// import {
//   time,
//   loadFixture,
// } from "@nomicfoundation/hardhat-toolbox/network-helpers";
// import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
// import { expect } from "chai";
// import { ethers } from "hardhat";

// export async function deployGaara() {
//   const [owner, merchant, trader1, trader2, amlAgent, kycAgent] = await ethers.getSigners();

//   const AML = await ethers.getContractFactory("AMLBlacklist");

//   const aml = await AML.deploy();

//   await aml.addAgent(await amlAgent.getAddress());

//   const KYC = await ethers.getContractFactory("KYCWhitelist");

//   const kyc = await KYC.deploy();

//   await kyc.addAgent(await kycAgent.getAddress());

//   return { owner, merchant, trader1, trader2, amlAgent, kycAgent };
// }

// describe("Ramp", function () {
//   describe("Deployment", function () {
//     it("Should Deploy", async function () {
//       await loadFixture(deployGaara);
//     });
//   });
// });
