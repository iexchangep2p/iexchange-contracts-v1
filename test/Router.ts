// import {
//   time,
//   loadFixture,
// } from "@nomicfoundation/hardhat-toolbox/network-helpers";
// import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
// import { expect } from "chai";
// import { ethers } from "hardhat";

// export async function deployRouter() {
//   const [owner, kwame] = await ethers.getSigners();

//   const Ramp = await ethers.getContractFactory("Ramp");

//   const ramp = await Ramp.deploy();

//   const one_million = BigInt(1e6 * 1e18);

//   const Cedih = await ethers.getContractFactory("Cedih");

//   const cedih = await Cedih.deploy();

//   const Troken = await ethers.getContractFactory("Cedih");

//   const troken = await Troken.deploy();

//   const WETH = await ethers.getContractFactory("WETH");

//   const weth = await WETH.deploy();

//   return {
//     owner,
//     ramp,
//     cedih,
//     troken,
//   };
// }

// describe("Optimistic P2P", function () {
//   describe("Deployment", function () {
//     it("Should Deploy and test P2p", async function () {
//       const { owner, ramp, cedih, troken } = await loadFixture(deployRouter);
//     });
//   });
// });
