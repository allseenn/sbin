# скачиваем с оригинальным именем файла, без проверки сертификата, в фоне, с поддержкой докачивания
alias get='wget --content-disposition --no-check-certificate --continue --background'
alias tor='~/tor-browser/Browser/firefox'
alias apps='vim ~/.bashrc.d/apps.sh'
alias dirs='vim ~/.bashrc.d/dirs.sh'
alias exports='vim ~/.bashrc.d/exports.sh'
alias p='/usr/bin/python'
alias wsgi='flask run --debug --host 0.0.0.0 --port 5500'
alias venv='source venv/bin/activate'
alias git='LANG=en_US.UTF-8 git'
function sources() {
    . /usr/local/sbin/.bashrc.d/dirs.sh
    . /usr/local/sbin/.bashrc.d/apps.sh
}
