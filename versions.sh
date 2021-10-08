#!/bin/bash
set -Eeuo pipefail

defaultDebianSuite='buster'
declare -A debianSuites=(
	[11]='bullseye' # https://github.com/docker-library/gcc/pull/74#issuecomment-828768704
)

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
	json='{}'
else
	json="$(< versions.json)"
fi
versions=( "${versions[@]%/}" )

#packagesUrl='https://ftpmirror.gnu.org/gcc/'
packagesUrl='https://mirrors.kernel.org/gnu/gcc/' # the actual HTML of the page changes based on which mirror we end up hitting, so let's hit a specific one for now... :'(
packages="$(wget -qO- "$packagesUrl")"

# our own "supported" window is 18 months from the most recent release because upstream doesn't have a good guideline, but appears to only release maintenance updates for 2-3 years after the initial release
# in addition, maintenance releases are _usually_ less than a year apart; from 4.7+ there's a handful of outliers, like 4.7.3->4.7.4 at ~14 months, 6.4->6.5 at ~15 months, etc
export TZ=UTC
eolPeriod='18 months'
today="$(date +'%s')"
eolAgo="$(date +'%s' -d "$(date -d "@$today") - $eolPeriod")"
eolAge="$(( $today - $eolAgo ))"
eols=()

dateFormat='%Y-%m-%d'

for version in "${versions[@]}"; do
	fullVersion="$(grep -E '<a href="(gcc-)?'"$version." <<<"$packages" | sed -r 's!.*<a href="(gcc-)?([^"/]+)/?".*!\2!' | sort -V | tail -1)"
	lastModified="$(grep -Em1 '<a href="(gcc-)?'"$fullVersion"'/"' <<<"$packages" | awk -F '  +' '{ print $2 }')"
	lastModified="$(date -d "$lastModified" +"$dateFormat")"

	lastModifiedTime="$(date +'%s' -d "$lastModified")"
	releaseAge="$(( today - lastModifiedTime ))"
	if [ "$releaseAge" -gt "$eolAge" ]; then
		eols+=( "$version ($fullVersion)" )
	fi
	eolDate="$(date -d "$lastModified + $eolPeriod" +"$dateFormat")"

	debianSuite="${debianSuites[$version]:-$defaultDebianSuite}"

	compression=
	# for tryCompression in xz bz2 gz; do
	for tryCompression in gz; do
		if \
			wget --quiet --spider "$packagesUrl/gcc-$fullVersion/gcc-$fullVersion.tar.$tryCompression" \
			|| wget --quiet --spider "$packagesUrl/$fullVersion/gcc-$fullVersion.tar.$tryCompression" \
		; then
			compression="$tryCompression"
			break
		fi
	done
	if [ -z "$compression" ]; then
		echo >&2 "error: $fullVersion does not seem to even really exist"
		exit 1
	fi

	echo "$version: $fullVersion ($lastModified vs $eolDate); $debianSuite, $compression"

	export version fullVersion lastModified eolDate debianSuite compression
	json="$(jq <<<"$json" -c '
		.[env.version] = {
			version: env.fullVersion,
			lastModified: env.lastModified,
			eol: env.eolDate,
			debian: env.debianSuite,
			compression: env.compression,
		}
	')"
done

if [ ${#eols[@]} -gt 0 ]; then
	{
		echo
		echo
		echo
		echo " WARNING: the following releases are older than $eolPeriod:"
		echo
		for eol in "${eols[@]}"; do
			echo "   - $eol"
		done
		echo
		echo
		echo
	} >&2
fi

jq <<<"$json" -S . > versions.json
