#!/bin/bash
export CARGO_INCREMENTAL=0
export RUSTFLAGS="-Zprofile -Ccodegen-units=1 -Cinline-threshold=0 -Clink-dead-code -Coverflow-checks=off -Zno-landing-pads"

cargo test --no-run
cargo test

zip -0 ccov.zip `find . \( -name "swc*.gc*" -o -name 'ast_node*.gc*' -o -name 'enum_kind*.gc*' -o -name 'string-enum*.gc*' -o -name 'from_variant*.gc*' \) -print`;

grcov ccov.zip -s . -t lcov --llvm --branch --ignore-not-existing --ignore "/*" -o lcov.info;

bash <(curl -s https://codecov.io/bash) -f lcov.info