import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { Web3 } from "web3";
export async function deployZk() {
  const [owner, kwame] = await ethers.getSigners();

  const iExAttestation = await ethers.getContractFactory("iExAttestation");
  const iex = await iExAttestation.deploy([]);

  const proof = {
    taskId: Web3.utils.asciiToHex("b16f527b8891454abe684c6a5f06dfb2"),
    schemaId: Web3.utils.asciiToHex("c7eab8b7d7e44b05b41b613fe548edf5"),
    uHash: "0xa3a5c8c3dd7dfe4abc91433fb9ad3de08344578713070983c905123b7ea91dda",
    publicFieldsHash:
      "0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6",
    recipient: "0xeCD12972E428a8256c9805b708E007882568d7D6",
    validator: "0xb1C4C1E1Cdd5Cf69E27A3A08C8f51145c2E12C6a",
    allocatorSignature:
      "0x8e789c4c4805d256ec9d332e734888d83dee9126030bd00a52a0d3342c3cc40613f88f8d3145360e5464b908fd82e94814a2f0549a459ac26489e76e1a89bd261b",
    validatorSignature:
      "0x5e47b2237c7208317f36a10039a37f637f33564138458770f87cd1880a45a2580052763accdd97f33a090523fd9220ed31f6ebabbfd51b263635e16fb0a0399a1b",
  };

  return {
    owner,
    kwame,
    iex,
    proof,
  };
}

// describe("ZK", function () {
//   describe("Deployment", function () {
//     it("Should Deploy and test ZK", async function () {
//       const { iex, proof } = await loadFixture(deployZk);
//       const uid =
//         "0x67c01a3e12ab8d66a38f66ca936b56cf53819fb269b6a41d9cb338f9b7aa763d";
//       await iex.addSchema(proof.schemaId);
//       await iex.attest(proof);
//       const res = await iex.getAttestation(uid);
//       const res2 = await iex.getiExAttestation(proof.recipient);
//       expect(res).to.deep.equal(res2);
//     });
//     it("Get Ix Attestation should be empty", async function () {
//       const { iex, proof } = await loadFixture(deployZk);
//       const uid =
//         "0x67c01a3e12ab8d66a38f66ca936b56cf53819fb269b6a41d9cb338f9b7aa763d";

//       await iex.attest(proof);
//       const res2 = await iex.getiExAttestation(proof.recipient);
//       expect(res2[4]).to.equal(
//         "0x0000000000000000000000000000000000000000000000000000000000000000"
//       );
//     });
//   });
// });
