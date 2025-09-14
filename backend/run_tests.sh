#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if ! command -v pytest >/dev/null 2>&1; then
	echo "pytest not installed. Create venv and install requirements?" >&2
	exit 1
fi

# Run tests with coverage if available
if python -c "import importlib,sys; sys.exit(0 if importlib.util.find_spec('coverage') else 1)"; then
	pytest -q --maxfail=1 --disable-warnings --cov=app --cov-report=term-missing
else
	pytest -q --maxfail=1 --disable-warnings
fi 