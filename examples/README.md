# Profiler

```bash
noirup -v nightly-2025-04-01

cd $(mktemp -d)
curl -LO https://github.com/noir-lang/noir/releases/download/nightly-2025-03-31/noir-aarch64-unknown-linux-gnu.tar.gz
tar -xvzf noir-aarch64-unknown-linux-gnu.tar.gz
mv noir-profiler ~/.nargo/bin/

cd /app
rm -rf target

nargo compile --package tdd_multiple
nargo execute --package tdd_multiple

noir-profiler opcodes --artifact-path ./target/tdd_multiple.json --output ./target/
```
