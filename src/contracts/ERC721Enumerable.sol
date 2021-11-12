// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./interfaces/IERC721Enumerable.sol";

contract ERC721Enumerable is ERC721, IERC721Enumerable {
    uint256[] private _allTokens;

    //mapping from tokenId to position in _allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    // mapping of owner to listing all owner token ids
    mapping(address => uint256[]) private _ownedTokens;

    // mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    constructor() {
        _registerInterface(
            bytes4(keccak256("tokenByIndex(bytes4)"))^
                bytes4(keccak256("tokenOfOwnerByIndex(bytes4)"))^
                bytes4(keccak256("totalSupply(bytes4)"))
        );
    }

    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);

        //A. add tokens to the owner and B. add tokens to total supply
        _addTokensToAllTokensEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);
    }

    // add tokes to the _allTokens array and set hte position if the indexes
    function _addTokensToAllTokensEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    /* @notice Count NFTs tracked by this contract
    @return A count of valid NFTs tracked by this contract, where each one of
    them has an assigned and queryable owner not equal to the zero address */

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
        //add address and tokenId to the _ownedTokens
        //2. ownedTokensIndex tokenzId set to address of ownedTokens position
        //3. Execute this function with minting
        _ownedTokens[to].push(tokenId);
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length - 1;
    }

    //two functions -- one that returns tokenByIndex
    function tokenByIndex(uint256 index)
        public
        view
        override
        returns (uint256)
    {
        //requre index is not out of bounds
        require(index < totalSupply(), "global index is out of bounds");
        return _allTokens[index];
    }

    //another that returns tokenByOwnerIndex
    function tokenOfOwnerByIndex(address owner, uint256 index)
        public
        view
        override
        returns (uint256)
    {
        require(index < balanceOf(owner), "owner index is out of bounds");
        return _ownedTokens[owner][index];
    }

    //return the total supoly od the _allTokens array
    function totalSupply() public view override returns (uint256) {
        return _allTokens.length;
    }
}
