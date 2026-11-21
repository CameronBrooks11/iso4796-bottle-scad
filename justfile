default:
    @just --list

# Check the tables against docs/references.md and the capacities against its Findings, render the bottles and examples, check the refusals
test:
    scadman sync
    OPENSCADPATH="$(scadman env)" python3 tests/test_iso4796.py

# Everything CI runs, bar the tests
check: fmt-check

# Format the .scad sources with topiary (.topiary/languages.ncl)
fmt:
    git ls-files -z '*.scad' | xargs -0 -r topiary format

# Check the .scad sources are formatted, without changing them
fmt-check:
    git ls-files -z '*.scad' | xargs -0 -r -n1 topiary format --check

# Render the README picture into docs/img/
images:
    @mkdir -p docs/img
    scadman sync
    OPENSCADPATH="$(scadman env)" openscad --camera=0,0,88,70,0,30,560 --imgsize=800,480 --colorscheme=Tomorrow -D thread=true -o docs/img/500ml-section.png examples/500ml_section.scad
