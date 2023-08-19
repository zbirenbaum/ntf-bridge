# Instructions
## Install Dependencies:
 - clone this repo, zbirenbaum/cw-nft and sei-protocol/sei-chain
 - `cd ./nft-bridge && yarn`

## Start Development Chains:
 - In two seperate terminals run the following
 - `cd ./sei-chain && git checkout 3.0.8 && ./scripts/initialize_local_chain.sh`
 - `cd ./nft-bridge && npx hardhat node`

## Build SEI Contracts:

```
cd ./cw-nfts

cargo wasm

docker run --rm -v "$(pwd)":/code \
  --mount type=volume,source="$(basename "$(pwd)")_cache",target=/code/target \
  --mount type=volume,source=registry_cache,target=/usr/local/cargo/registry \
  cosmwasm/rust-optimizer:0.14.0
```

## Deploy the EVM contracts:
 - `cd ./nft-bridge && npx hardhat run scripts/deploy.ts --network localhost`

## Instantiate the Executor In a New Terminal:
 - `cd ./nft-bridge && npx hardhat run scripts/executor.ts --network localhost`

## Run a Mint and Trigger a Mint on SEI:
 - `cd ./nft-bridge && npx hardhat run scripts/mintAndBridge.ts --network localhost`
