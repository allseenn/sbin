#!/bin/bash

USER="allseenn"
REPO=""
DISK=sdcard
usage() {
    echo "Usage: $0 -r REPO [-u USER]"
    echo ""
    echo "Options:"
    echo "  -u USER   GitHub username (default: allseenn)"
    echo "  -r REPO   Repository name (required)"
    echo "  -h        Show this help"
}

while getopts ":u:r:h" opt; do
    case "$opt" in
        u)
            USER="$OPTARG"
            ;;
        r)
            REPO="$OPTARG"
            ;;
        h)
            usage
            exit 0
            ;;
        :)
            echo "Error: option -$OPTARG requires an argument." >&2
            usage >&2
            exit 1
            ;;
        ?)
            echo "Error: invalid option -$OPTARG" >&2
            usage >&2
            exit 1
            ;;
    esac
done

if [[ -z "$REPO" ]]; then
    echo "Error: repository is required." >&2
    usage >&2
    exit 1
fi

git clone "https://github.com/${USER}/${REPO}.git" "/mnt/$DISK/github/${REPO}"
echo "alias ${REPO}='cd /mnt/$DISK/github/${REPO}' # переходим в папку ${REPO}" >> /usr/local/sbin/.bashrc.d/dirs.sh
. /usr/local/sbin/.bashrc.d/dirs.sh
. /usr/local/sbin/.bashrc.d/apps.sh

