#!/bin/bash
#
# install_check_patch.sh
#
# Use this script to fetch the latest checkpatch.pl from GitHub

get_system(){
	local linux=$(uname -a |grep "^Linux" -o)
	if [[ -n "${linux}" ]]; then
		echo ${linux}
	fi

	local cygwin=$(uname -a| grep "^CYGWIN" -o)
	if [[ -n "${cygwin}" ]]; then
		echo ${cygwin}
	fi

	local MINGW=$(uname -a| grep "^MINGW" -o)
	if [[ -n "${MINGW}" ]]; then
		echo ${MINGW}
	fi
}


TEMP="/tmp/install_check_patch/"

SYSTEM=$(get_system)

echo ${SYSTEM}

readonly CHECKPATCH_SCRIPT="checkpatch.pl"
readonly SPELLING_TXT="spelling.txt"
readonly CONST_STRUCTS="const_structs.checkpatch"
readonly LINDENT="Lindent"

readonly KERNEL_RAW_URL="https://raw.githubusercontent.com/torvalds/linux/master"
readonly CHECKPATCH_URL="${KERNEL_RAW_URL}/scripts/${CHECKPATCH_SCRIPT}"
readonly SPELLING_URL="${KERNEL_RAW_URL}/scripts/${SPELLING_TXT}"
readonly CONST_STRUCTS_URL="${KERNEL_RAW_URL}/scripts/${CONST_STRUCTS}"
readonly LINDENT_URL="${KERNEL_RAW_URL}/scripts/${LINDENT}"

readonly GIT_CHECKPATCH="git-checkpatch"
readonly GIT_CHECKPATCH_URL="https://raw.githubusercontent.com/nigangkaka/checkpatch/master/git-checkpatch"

rm -rf ${TEMP}
mkdir ${TEMP}
pushd ${TEMP}

for download in "${CHECKPATCH_URL}:${CHECKPATCH_SCRIPT}"\
		"${SPELLING_URL}:${SPELLING_TXT}"\
		"${GIT_CHECKPATCH_URL}:${GIT_CHECKPATCH}"\
		"${CONST_STRUCTS_URL}:${CONST_STRUCTS}"\
		"${LINDENT_URL}:${LINDENT}"; do
	echo "Downloading '${download##*:}'..."
	curl -f "${download%:*}" -s -S -O || \
		exit 1
	chmod 755 ${download##*:}

	if [[ "${SYSTEM}" == "CYGWIN" ]]; then
		cp ${download##*:} /usr/local/bin/
	elif [[ "${SYSTEM}" == "MINGW" ]]; then
		cp ${download##*:} ${HOME}/bin
	else
		sudo cp ${download##*:} /usr/local/bin/
	fi

done

popd
rm -rf ${TEMP}
