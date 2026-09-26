#!/bin/env bash

USER="allseenn"
GROUP=""
REPO=""
PROVIDER="github"
DISK=sdcard
usage() {
    echo "Usage: $0 -r REPO [-u USER] [-g GROUP] [-p PROVIDER]"
    echo ""
    echo "Options:"
    echo "  -u USER       GitHub/GitLab username (default: allseenn)"
    echo "  -g GROUP      GitLab group name (optional)"
    echo "  -r REPO       Repository name (required)"
    echo "  -p PROVIDER   Git provider: github or gitlab (default: github)"
    echo "  -h            Show this help"
}

while getopts ":u:g:r:p:h" opt; do
    case "$opt" in
        u)
            USER="$OPTARG"
            ;;
        g)
            GROUP="$OPTARG"
            ;;
        r)
            REPO="$OPTARG"
            ;;
        p)
            PROVIDER="$OPTARG"
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

case "$PROVIDER" in
    github)
        URL="https://github.com/${USER}/${REPO}.git"
        TARGET_DIR="/mnt/$DISK/github/${REPO}"
        ;;
    gitlab)
        if [[ -n "$GROUP" ]]; then
            URL="https://gitlab.com/${GROUP}/${REPO}.git"
            TARGET_DIR="/mnt/$DISK/gitlab/${GROUP}/${REPO}"
        else
            URL="https://gitlab.com/${USER}/${REPO}.git"
            TARGET_DIR="/mnt/$DISK/gitlab/${REPO}"
        fi
        ;;
    *)
        echo "Error: unsupported provider '$PROVIDER'. Use github or gitlab." >&2
        usage >&2
        exit 1
        ;;
esac

mkdir -p "$(dirname "$TARGET_DIR")"
git clone "$URL" "$TARGET_DIR"

echo "alias ${REPO}='cd ${TARGET_DIR}' # переходим в папку ${REPO}" >> /usr/local/sbin/.bashrc.d/dirs.sh
. /usr/local/sbin/.bashrc.d/dirs.sh
. /usr/local/sbin/.bashrc.d/apps.sh

