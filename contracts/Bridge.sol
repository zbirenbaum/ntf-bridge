// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import {Ownable} from 'oz/access/Ownable.sol';
import {IERC721Receiver} from 'oz/interfaces/IERC721Receiver.sol';
import {IERC721Metadata} from 'oz/interfaces/IERC721Metadata.sol';
import {TestNFT} from './TestNFT.sol';
// Uncomment this line to use console.log
// import "hardhat/console.sol";

struct BridgeInfo {
  address owner;
  address token;
  uint256 tokenId;
  address receiver;
  uint256 chainId;
  string tokenURI;
}
contract Bridge is Ownable, IERC721Receiver {
  address token;
  mapping(address => uint) public tokenIds;
  mapping(address => BridgeInfo) public owners;
  event Deposit(
    address owner,
    address nftAddress,
    string name,
    string symbol,
    uint tokenId,
    string tokenURI,
    address to,
    uint chainId
  );

  constructor() payable {}

  function transfer(address to, uint256 tokenId) public {
    IERC721Metadata(token).safeTransferFrom(address(this), to, tokenId);
  }

  function onERC721Received(
    address operator,
    address from,
    uint256 tokenId,
    bytes calldata data
  ) public override returns (bytes4) {
    tokenIds[from] = tokenId;
    return IERC721Receiver.onERC721Received.selector;
  }

  function BridgeNFT(address nftAddress, address receiver, uint chainId) public onlyOwner {
    IERC721Metadata nft = IERC721Metadata(nftAddress);
    BridgeInfo memory info;
    uint tokenId = tokenIds[msg.sender];
    string memory uri = nft.tokenURI(tokenId);
    info.owner = msg.sender;
    info.token = nftAddress;
    info.tokenId = tokenId;
    info.receiver = receiver;
    info.chainId = chainId;
    info.tokenURI = uri;
    owners[msg.sender] = info;
    emit Deposit(
      info.owner,
      info.token,
      nft.name(),
      nft.symbol(),
      info.tokenId,
      info.tokenURI,
      info.receiver,
      info.chainId
    );
  }
}
