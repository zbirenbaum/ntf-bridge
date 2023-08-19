// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import {IERC721Metadata} from 'oz/interfaces/IERC721Metadata.sol';

import {Ownable} from 'oz/access/Ownable.sol';
import {IERC165} from 'oz/interfaces/IERC165.sol';
import {ERC721} from 'oz/token/ERC721/ERC721.sol';
import {ERC721URIStorage} from 'oz/token/ERC721/extensions/ERC721URIStorage.sol';
import {ERC721Burnable} from 'oz/token/ERC721/extensions/ERC721Burnable.sol';
import {Ownable} from 'oz/access/Ownable.sol';
import {Counters} from 'oz/utils/Counters.sol';
import "hardhat/console.sol";

contract TestNFT is IERC721Metadata, ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIdCounter;
  constructor() ERC721("TestNFT", "TNFT") {}

  function safeMint(address to, string memory uri) public onlyOwner {
    uint256 tokenId = _tokenIdCounter.current();
    _tokenIdCounter.increment();
    _safeMint(to, tokenId);
    _setTokenURI(tokenId, uri);
    console.log(this.tokenURI(tokenId));

  }
  // The following functions are overrides required by Solidity.

  function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
    super._burn(tokenId);
  }

  function tokenURI(uint256 tokenId)
  public
  view
  override(ERC721, ERC721URIStorage, IERC721Metadata)
  returns (string memory)
  {
    return super.tokenURI(tokenId);
  }

  function supportsInterface(bytes4 interfaceId)
  public
  view
  override(ERC721, ERC721URIStorage, IERC165)
  returns (bool)
  {
    return super.supportsInterface(interfaceId);
  }
}
