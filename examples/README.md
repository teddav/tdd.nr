```bash
mkdir proof

CIRCUIT_NAME="tdd_id"

bb prove -b "./target/$CIRCUIT_NAME.json" -w "./target/$CIRCUIT_NAME.gz" -o ./proof
bb write_vk -b "./target/$CIRCUIT_NAME.json" -o ./proof
bb verify -k ./proof/vk -p ./proof/proof

# bb OLD_API write_recursion_inputs_ultra_honk -b "./target/first.json" -o ./proof --recursive

# as fields
bb prove -b "./target/$CIRCUIT_NAME.json" -w "./target/$CIRCUIT_NAME.gz" -o ./proof --output_format fields
bb write_vk -b "./target/$CIRCUIT_NAME.json" -o ./proof --output_format fields
```
