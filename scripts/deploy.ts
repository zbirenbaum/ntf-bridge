import {ethers} from "hardhat";
import fs from 'fs';

async function main() {
  const [signer] = await ethers.getSigners();
  const bridge = await ethers.deployContract("Bridge", [], signer);
  await bridge.deployed();

  const nft = await ethers.deployContract("TestNFT", [], signer);
  await nft.deployed();

  console.log('Bridge Address: ', bridge.address)
  console.log('Test NFT Address: ', nft.address)

  let deployments = {
    bridge: bridge.address,
    nft: nft.address,
  };

  fs.writeFileSync('deployments.json', JSON.stringify(deployments));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
