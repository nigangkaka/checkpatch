#!/bin/bash
#
# install_check_patch.sh
#
# Use this script to fetch the latest checkpatch.pl from GitHub

TEMP="/tmp/install_check_patch/"

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
	sudo cp ${download##*:} /usr/local/bin/
done

popd
rm -rf ${TEMP}
