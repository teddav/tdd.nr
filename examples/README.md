```bash
mkdir proof

CIRCUIT_NAME="tdd_id"

bb prove -b "./target/$CIRCUIT_NAME.json" -w "./target/$CIRCUIT_NAME.gz" -o ./proof
bb write_vk -b "./target/$CIRCUIT_NAME.json" -o ./proof
bb verify -k ./proof/vk -p ./proof/proof
```
