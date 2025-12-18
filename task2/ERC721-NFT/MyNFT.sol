// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyNFT is ERC721{

    uint public MAX_APES = 10000;

    //uint public MAX_APES = 10000;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 tokenId => string) private _tokenURIs;

    constructor(string memory name_, string memory symbol_) ERC721 (name_, symbol_){
    }

    function _baseURI() internal pure override returns (string memory) {
        return "";
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        _tokenURIs[tokenId] = _tokenURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(ownerOf(tokenId) != address(0), "token not exist!!");

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        if (bytes(base).length == 0) {
            return _tokenURI;
        }

        if (bytes(_tokenURI).length > 0) {
            return string.concat(base, _tokenURI);
        }

        return super.tokenURI(tokenId);
    }

    function mint(address to, string memory tokenUrl) external {
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        require(tokenId >=0 && tokenId< MAX_APES, "token out of range");

        _setTokenURI(tokenId, tokenUrl);
        _mint(to, tokenId);
    }

}