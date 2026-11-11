#!/bin/sh
# Offline checks: unit tests (lib/Parsers.js) + QML syntax. Usage: tests/run.sh
cd "$(dirname "$0")/.." || exit 1

decl=$(dirname "$(dirname "$(readlink -f "$(command -v qmllint 2>/dev/null || ls -d /nix/store/*qtdeclarative-6*/bin/qmllint | head -n1)")")")
fail=0

echo "== unit tests"
QT_QPA_PLATFORM=offscreen "$decl/bin/qmltestrunner" -import "$decl/lib/qt-6/qml" -input tests 2>&1 \
    | grep -E '^(PASS|FAIL|Totals)' || fail=1
QT_QPA_PLATFORM=offscreen "$decl/bin/qmltestrunner" -import "$decl/lib/qt-6/qml" -input tests >/dev/null 2>&1 || fail=1

echo "== syntax"
errors=$(find . -name '*.qml' -not -path './tests/*' -exec "$decl/bin/qmllint" --bare {} + 2>&1 | grep '\[syntax\]')
if [ -n "$errors" ]; then echo "$errors"; fail=1; else echo "ok"; fi

[ $fail -eq 0 ] && echo "== all good" || echo "== FAILED"
exit $fail
