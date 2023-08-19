import { ethers } from 'hardhat'
import deployments from '../deployments.json';
import {spawn} from 'child_process';
import {EventEmitter} from 'events';
const CW_PATH = __dirname + "/../../cw-nfts/"

function mint(args: any, emitter: EventEmitter)  {
  const deploy = spawn(CW_PATH + 'mint.sh', args);
  let output = { stdout: "", stderr: undefined, done: false }
  deploy.stdout.on('data', (data) => {
    console.log(data.toString().trim())
    output.stdout = data.toString().trim();
  })
  deploy.stderr.on('data', (data) => {
    console.log(data.toString().trim())
    emitter.emit('failed with error:', data);
  });
  deploy.on('close', (code) => {
    emitter.emit('done', code);
  });
}

function deploy(name: string, symbol: string, emitter: EventEmitter)  {
  const args = [name, symbol];
  const deploy = spawn(CW_PATH + 'deploy.sh', args);
  let output = { stdout: "", stderr: undefined, done: false }
  deploy.stdout.on('data', (data) => {
    emitter.emit('result', [data.toString().trim()]);
    output.stdout = data.toString().trim();
  })
  deploy.stderr.on('data', (data) => {
    emitter.emit('error', data);
    output.stderr = data.toString().trim();
  });
  deploy.on('close', (code) => {
    emitter.emit('close', code);
  });
}
type ContractMap = { [key: string]: string}

async function main() {
  let cmap: ContractMap = {}
  const contract = await ethers.getContractAt("Bridge", deployments.bridge);

  contract.on("Deposit", (owner, nftAddress, nftName, nftSymbol, tokenId, tokenURI, to, chainId) => {
    to = "sei1jkq4ky6ad8gmr73pvuvts443quzwxjjufdedsp";
    console.log({owner, nftAddress, nftName, nftSymbol, tokenId, tokenURI, to, chainId})
    console.log(to)

    const deploy_emitter = new EventEmitter();
    const mint_emitter = new EventEmitter();
    const addr = cmap[nftAddress];

    mint_emitter.on('done', (code) => {
      console.log("mint done", code);
    });

    if (addr == undefined) {
      deploy(nftName, nftSymbol, deploy_emitter);
      deploy_emitter.on('result', (address) => {
        cmap[nftAddress] = address;
        console.log(address)
        mint([address[0], to, tokenId, tokenURI], mint_emitter)
      })
    }
    else {
      console.log(addr)
      mint([addr, to, tokenId, tokenURI], mint_emitter)
    }
  });
}

main()
