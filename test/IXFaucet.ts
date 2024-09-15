import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

export async function deployTokensFaucet() {
  const [owner, otherAccount] = await ethers.getSigners();

  const Ramp = await ethers.getContractFactory("Ramp");

  const ramp = await Ramp.deploy();

  const ten_million = BigInt(1e7 * 1e18);

  const Cedih = await ethers.getContractFactory("Cedih");

  const cedih = await Cedih.deploy();

  const Troken = await ethers.getContractFactory("Cedih");

  const troken = await Troken.deploy();


  const IXFaucet = await ethers.getContractFactory("IXFaucet");
  const faucet = await IXFaucet.deploy([ramp, cedih, troken]);

  await ramp.transfer(await faucet.getAddress(), ten_million);
  await cedih.transfer(await faucet.getAddress(), ten_million);
  await troken.transfer(await faucet.getAddress(), ten_million);

  return { owner, otherAccount, faucet };
}

describe("IXFaucet", function () {
  describe("Deployment", function () {
    it("Should Deploy", async function () {
      await loadFixture(deployTokensFaucet);
    });
  });

  describe("Claim IXTokens", function () {
    it("Should Claim IXTokens", async function () {
      const { faucet, otherAccount } = await loadFixture(deployTokensFaucet);
      await expect(faucet.connect(otherAccount).claim())
        .emit(faucet, "Claimed")
        .withArgs(await otherAccount.getAddress(), await faucet.dailyClaim());

      await expect(
        faucet.connect(otherAccount).claim()
      ).revertedWithCustomError(faucet, "AlreadyClaimed");

    });
  });
});
