```bash
bbup -v 0.78.0

cd first
CIRCUIT_NAME="first"
mkdir proof

bb prove -v -b "./target/$CIRCUIT_NAME.json" -w "./target/$CIRCUIT_NAME.gz" -o ./proof
bb write_vk -b "./target/$CIRCUIT_NAME.json" -o ./proof
bb verify -k ./proof/vk -p ./proof/proof
```

as fields

```bash
# bb OLD_API write_recursion_inputs_ultra_honk -b "./target/first.json" -o ./proof --recursive
bb prove -v -b "./target/$CIRCUIT_NAME.json" -w "./target/$CIRCUIT_NAME.gz" -o ./proof --output_format bytes_and_fields --honk_recursion 1 --recursive --init_kzg_accumulator
bb write_vk -v -b "./target/$CIRCUIT_NAME.json" -o ./proof --output_format bytes_and_fields --honk_recursion 1 --init_kzg_accumulator
bb verify -k ./proof/vk -p ./proof/proof
```

- remove first value (public input) from proof_fields.json
- copy values to recurse/Prover.toml

```bash
CIRCUIT_NAME="recurse"
mkdir proof

bb prove -v -b "./target/$CIRCUIT_NAME.json" -w "./target/$CIRCUIT_NAME.gz" -o ./proof --recursive
bb write_vk -v -b "./target/$CIRCUIT_NAME.json" -o ./proof --honk_recursion 1
bb verify -k ./proof/vk -p ./proof/proof
```
