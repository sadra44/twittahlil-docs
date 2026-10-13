#!/usr/bin/env bash
# ==============================================================================
# اسکریپت نصب و راه‌اندازی خودکار سامانه توییت‌تحلیل (Twittahlil)
# Root Wrapper & Direct Launcher
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# اگر دایرکتوری /app وجود دارد و install.sh داخل آن است، به آنجا هدایت شود
if [ -d "$SCRIPT_DIR/app" ] && [ -f "$SCRIPT_DIR/app/install.sh" ]; then
    cd "$SCRIPT_DIR/app"
    bash install.sh "$@"
    exit $?
fi

# در غیر این صورت مستقیماً در همین مسیر اجرا گردد
if [ -f "$SCRIPT_DIR/schema.sql" ] && [ ! -f "$SCRIPT_DIR/app/schema.sql" ]; then
    mkdir -p "$SCRIPT_DIR/app"
    cp "$SCRIPT_DIR/schema.sql" "$SCRIPT_DIR/app/schema.sql"
fi

cd "$SCRIPT_DIR"
if [ -f "app/install.sh" ]; then
    bash app/install.sh "$@"
else
    echo "Error: install.sh not found."
    exit 1
fi
