import {
    time,
    loadFixture,
  } from "@nomicfoundation/hardhat-toolbox/network-helpers";
  import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
  import { expect } from "chai";
  import { ethers } from "hardhat";
  
  export async function deployP2P() {
    const [owner, kojo, kofi, kwame] = await ethers.getSigners();
  
    const OptimisticP2P = await ethers.getContractFactory("OptimisticP2P");
    const p2p = await OptimisticP2P.deploy();
  
    return { p2p, owner, kojo, kofi, kwame };
  }
  
  describe("Optimistic P2P", function () {

    describe("Deployment", function () {
      it("Should Deploy", async function () {
        await loadFixture(deployP2P);
      });
    });
  });
  