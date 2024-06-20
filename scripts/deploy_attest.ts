import { ethers } from "hardhat";
import "dotenv/config";
import { Web3 } from 'web3';


async function main() {
    const schemas = [
      Web3.utils.asciiToHex('bb0841c23af949fb81641c49ffa1e189'),
      Web3.utils.asciiToHex('b3bd0822034641b2aee2deb631550c75')
    ]
    console.log(schemas);
    
  const shadow = await ethers.deployContract("iExAttestation", [schemas]);

  await shadow.waitForDeployment();

  const { ...tx } = shadow.deploymentTransaction()?.toJSON();
  tx.data = await shadow.getAddress();

  console.log(`deployed to ${JSON.stringify(tx, null, 2)}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
