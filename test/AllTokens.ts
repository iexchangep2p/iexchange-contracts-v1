// import {
//   time,
//   loadFixture,
// } from "@nomicfoundation/hardhat-toolbox/network-helpers";
// import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
// import { expect } from "chai";
// import { ethers } from "hardhat";

// export async function deployAllTokens() {
//   const [owner, merchant, trader1, trader2] = await ethers.getSigners();

//   const Ramp = await ethers.getContractFactory("Ramp");

//   const ramp = await Ramp.deploy();

//   const one_million = BigInt(1e6 * 1e18);

//   await ramp.transfer(await merchant.getAddress(), one_million);
//   await ramp.transfer(await trader1.getAddress(), one_million);
//   await ramp.transfer(await trader2.getAddress(), one_million);

//   const Cedih = await ethers.getContractFactory("Cedih");

//   const cedih = await Cedih.deploy();

//   await cedih.transfer(await merchant.getAddress(), one_million);
//   await cedih.transfer(await trader1.getAddress(), one_million);
//   await cedih.transfer(await trader2.getAddress(), one_million);

//   const Troken = await ethers.getContractFactory("Cedih");

//   const troken = await Troken.deploy();

//   await troken.transfer(await merchant.getAddress(), one_million);
//   await troken.transfer(await trader1.getAddress(), one_million);
//   await troken.transfer(await trader2.getAddress(), one_million);

//   return { ramp, troken, cedih, owner, merchant, trader1, trader2 };
// }

// describe("Ramp", function () {
//   describe("Deployment", function () {
//     it("Should Deploy", async function () {
//       await loadFixture(deployAllTokens);
//     });
//   });
// });
