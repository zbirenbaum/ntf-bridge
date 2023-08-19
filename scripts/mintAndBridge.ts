import {ethers} from 'hardhat';
import * as deployments from '../deployments.json';

async function main() {
  const [signer] = await ethers.getSigners();
  const nft = await ethers.getContractAt("TestNFT", deployments.nft, signer);
  const bridge = await ethers.getContractAt("Bridge", deployments.bridge, signer);

  await nft.safeMint(signer.address, "https://someurihere.lol");
  await nft.setApprovalForAll(bridge.address, true);
  await bridge.BridgeNFT(nft.address, signer.address, 0);
  console.log(nft.address)
}

main();
