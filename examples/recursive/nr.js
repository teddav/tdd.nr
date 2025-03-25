const { UltraHonkBackend, UltraPlonkBackend } = require("@aztec/bb.js");
const { Noir } = require("@noir-lang/noir_js");
const { assert } = require("console");
const fs = require("fs");
const os = require("os");
const { execSync } = require("child_process");

const CIRCUITS = {
  first: JSON.parse(fs.readFileSync("./first/target/first.json")),
  recurse: JSON.parse(fs.readFileSync("./recurse/target/recurse.json")),
};

async function prove_UltraPlonk() {
  const noir = new Noir(CIRCUITS.first);
  const backend = new UltraPlonkBackend(CIRCUITS.first.bytecode, { threads: os.cpus() });

  const data = {
    a: 3,
    b: 4,
  };

  const { witness } = await noir.execute(data);

  //   PROOF
  console.time("prove");
  const proof = await backend.generateProof(witness);
  console.timeEnd("prove");
  console.log("proof", proof);

  // VK
  const publicInputsCount = 1;
  const { proofAsFields, vkAsFields, vkHash } = await backend.generateRecursiveProofArtifacts(proof, publicInputsCount);
  //   console.log("proofAsFields", proofAsFields.length);
  //   console.log(JSON.stringify(proofAsFields));
  //   console.log("vkAsFields", vkAsFields.length);
  //   console.log(JSON.stringify(vkAsFields));
  //   console.log("vkHash", vkHash);

  // VERIFY proof1
  const isValid = await backend.verifyProof(proof);
  assert(isValid);

  // RECURSIVE
  const noir_recursive = new Noir(CIRCUITS.recurse);
  const backend_recursive = new UltraPlonkBackend(CIRCUITS.recurse.bytecode, { threads: os.cpus() });

  const recursiveInputs = {
    verification_key: vkAsFields,
    proof: proofAsFields,
    public_inputs: proof.publicInputs,
    key_hash: vkHash,
  };

  console.log("recursing...", recursiveInputs);
  const { witness: witness_recursive } = await noir_recursive.execute(recursiveInputs);
  const proof_recursive = await backend_recursive.generateProof(witness_recursive);
  const verified = await backend_recursive.verifyProof(proof_recursive);
  assert(verified);
}

async function prove_UltraHonk() {
  // execSync("nargo execute --package first");
  // execSync("nargo compile --package recurse");
  execSync(
    "bb prove -b ./first/target/first.json -w ./first/target/first.gz -o ./first/proof --init_kzg_accumulator --honk_recursion 1 --output_format fields"
  );
  execSync("bb write_vk -b ./first/target/first.json -o ./first/proof --init_kzg_accumulator --honk_recursion 1 --output_format fields");

  const noir = new Noir(CIRCUITS.first);
  const backend = new UltraHonkBackend(CIRCUITS.first.bytecode, { threads: os.cpus() });

  const data = {
    a: 3,
    b: 4,
  };

  const { witness } = await noir.execute(data);

  //   PROOF
  console.time("prove");
  const proof = await backend.generateProof(witness);
  console.timeEnd("prove");
  console.log("proof", proof);

  // // VK
  // const publicInputsCount = 1;
  const proofAsFields = JSON.parse(fs.readFileSync("./first/proof/proof_fields.json"));
  const vkAsFields = JSON.parse(fs.readFileSync("./first/proof/vk_fields.json"));
  const vkHash = "0x" + "0".repeat(64);

  // VERIFY proof1
  const isValid = await backend.verifyProof(proof);
  assert(isValid);

  // RECURSIVE
  const noir_recursive = new Noir(CIRCUITS.recurse);
  const backend_recursive = new UltraHonkBackend(CIRCUITS.recurse.bytecode, { threads: os.cpus() });

  const recursiveInputs = {
    verification_key: vkAsFields,
    proof: proofAsFields,
    public_inputs: proof.publicInputs,
    key_hash: vkHash,
  };

  console.log("recursing...", recursiveInputs);
  const { witness: witness_recursive } = await noir_recursive.execute(recursiveInputs);
  const proof_recursive = await backend_recursive.generateProof(witness_recursive);
  const verified = await backend_recursive.verifyProof(proof_recursive);
  assert(verified);
}

prove_UltraHonk();
