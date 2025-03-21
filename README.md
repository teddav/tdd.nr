# 2D-Doc

This library allows you to verify [2D-Doc](https://ants.gouv.fr/nos-missions/les-solutions-numeriques/2d-doc) in Noir

## Installation

In Nargo.toml file, add the following dependency:

```
[dependencies]
tdd = { git = "https://github.com/teddav/tdd.nr", tag = "main" }
```

### Import the library

Add this line:

```rust
use tdd::*;
```

## Usage

You can find an example in [./examples/tdd1](./examples/tdd1)

## Gates

Use `bb` to get the number of gates in the circuit:

```bash
bb gates -b circuit.json | jq ".functions[0].circuit_size"
```
