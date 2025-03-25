const { UltraHonkBackend, UltraPlonkBackend } = require("@aztec/bb.js");
const { Noir } = require("@noir-lang/noir_js");
const { assert } = require("console");
const fs = require("fs");
const os = require("os");

async function prove() {
  const circuit1 = JSON.parse(fs.readFileSync("./first/target/first.json"));

  const noir = new Noir(circuit1);
  const backend = new UltraPlonkBackend(circuit1.bytecode, { threads: os.cpus() });

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

  //   RECURSIVE
  const circuit_recursive = JSON.parse(fs.readFileSync("./recurse/target/recurse.json"));
  const noir_recursive = new Noir(circuit_recursive);
  const backend_recursive = new UltraPlonkBackend(circuit_recursive.bytecode, { threads: os.cpus() });

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

prove();
