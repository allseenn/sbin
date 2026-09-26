#!/usr/bin/env bash
# .gitignore atomatic creator script
usage() {
    cat << EOF
Использование: $0 [КЛЮЧИ]

Ключи:
  -h  Вывести эту справку
  -p  Python (uv, poetry, venv, pycache, FastAPI, Flask)
  -o  Obsidian (интерфейсный мусор, кэш, логи)
  -j  JavaScript (node_modules, dist, logs)
  -x  Разметка / Markup (HTML, XML, Markdown)
  -c  CSS (sass-cache, css.map)
  -w  Web-стек (включает -j, -x, -c)
  -d  Docker (контейнеры, дампы, локальные оверрайды)

Пример: $0 -p -o -d
EOF
    exit 0
}

if [ $# -eq 0 ]; then
    usage
fi

KEYS=()
USE_P=0
USE_O=0
USE_J=0
USE_X=0
USE_C=0
USE_D=0

while getopts "hpojxcwd" opt; do
    case ${opt} in
        h) usage ;;
        p) USE_P=1; KEYS+=("-p") ;;
        o) USE_O=1; KEYS+=("-o") ;;
        j) USE_J=1; KEYS+=("-j") ;;
        x) USE_X=1; KEYS+=("-x") ;;
        c) USE_C=1; KEYS+=("-c") ;;
        w) 
           USE_J=1
           USE_X=1
           USE_C=1
           KEYS+=("-w")
           ;;
        d) USE_D=1; KEYS+=("-d") ;;
        *) usage ;;
    esac
done

GITIGNORE_FILE=".gitignore"

# --- Блок по умолчанию (ОС, IDE, Vim, MS Office, Корзины, Tmp) ---
cat << 'EOF' > "$GITIGNORE_FILE"
# General & OS System Files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
Desktop.ini
$RECYCLE.BIN/
.Trash-*

# Temporary & Swap Files (Vim, Editors, OS)
*.tmp
*.temp
*.bak
*.swp
*.swo
*~
.netrwhist

# MS Office Temporary Files
~$*
.~lock.*#

# IDEs, Editors & AI tools (VS Code, JetBrains, Codex, Cursor)
.vscode/
.idea/
.codex/
.cursor/
*.suo
*.user
*.userosv
*.sln
*.sw?
EOF

# --- Дополнительные блоки по ключам ---

if [ $USE_P -eq 1 ]; then
    cat << 'EOF' >> "$GITIGNORE_FILE"

# Python & Frameworks
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
.venv/
ENV/
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Caches & Secrets
instance/
.webassets-cache
.pytest_cache/
.mypy_cache/
.ruff_cache/
.env
*.db
*.sqlite3
EOF
fi

if [ $USE_O -eq 1 ]; then
    cat << 'EOF' >> "$GITIGNORE_FILE"

# Obsidian
.obsidian/workspace.json
.obsidian/workspace-mobile.json
.obsidian/cache/
.obsidian/backups/
.obsidian/plugins/
EOF
fi

if [ $USE_J -eq 1 ]; then
    cat << 'EOF' >> "$GITIGNORE_FILE"

# JavaScript / Node.js
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.pnpm-debug.log*
dist/
build/
.next/
.nuxt/
EOF
fi

if [ $USE_X -eq 1 ]; then
    cat << 'EOF' >> "$GITIGNORE_FILE"

# Markup Languages (HTML, XML, Markdown)
*.html.tmp
*.xml.tmp
.cache/
.jekyll-cache/
.pandoc/
resources/_gen/
EOF
fi

if [ $USE_C -eq 1 ]; then
    cat << 'EOF' >> "$GITIGNORE_FILE"

# CSS / Sass
.sass-cache/
*.css.map
*.sass.map
*.scss.map
EOF
fi

if [ $USE_D -eq 1 ]; then
    cat << 'EOF' >> "$GITIGNORE_FILE"

# Docker
.docker/
*.tar
*.tar.gz
docker-compose.override.yml
EOF
fi

KEYS_STR="${KEYS[*]}"

echo "Создан $GITIGNORE_FILE с базовым блоком и ключами: $KEYS_STR"

git add .
git commit -m "feat: add .gitignore with key ${KEYS_STR}"
git push

