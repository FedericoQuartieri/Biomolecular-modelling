#!/usr/bin/env bash

# Usage: run_namd_recursive.sh ROOT_DIR NPROCS
# Example: ./run_namd_recursive.sh /path/to/runs 4

# Check arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 ROOT_DIR NPROCS"
    exit 1
fi

ROOT_DIR="$1"
NPROCS="$2"

# Check ROOT_DIR
if [ ! -d "$ROOT_DIR" ]; then
    echo "Error: '$ROOT_DIR' is not a directory."
    exit 1
fi

# Check NPROCS is a positive integer
case "$NPROCS" in
    ''|*[!0-9]*)
        echo "Error: NPROCS must be a positive integer."
        exit 1
        ;;
esac

# Find all .conf files and run NAMD on each
find "$ROOT_DIR" -type f -name '*.conf' -print0 | while IFS= read -r -d '' conf_file; do
    conf_dir="$(dirname "$conf_file")"
    conf_name="$(basename "$conf_file")"
    conf_base="${conf_name%.conf}"
    log_name="run_${conf_base}.log"

    echo "============================================================"
    echo "Running NAMD in directory:"
    echo "  $conf_dir"
    echo "Config file: $conf_name"
    echo "Log file:    $log_name"
    echo "Cores:       $NPROCS"
    echo "============================================================"

    (
        cd "$conf_dir" || exit 1
        # Run NAMD, show output on screen and save to log file
        namd2 +p"$NPROCS" "$conf_name" 2>&1 | tee "$log_name"
    )

    echo
done
