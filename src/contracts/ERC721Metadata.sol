// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './interfaces/IERC721Metadata.sol';
import './ERC165.sol';

contract ERC721Metadata is  ERC165, IERC721Metadata {
    string private _name;
    string private _symbol;

    constructor(string memory named, string memory symbolified) {
        _name = named;
        _symbol = symbolified;

        _registerInterface(
            bytes4(keccak256("name(bytes4)")) ^
                bytes4(keccak256("symbol(bytes4)"))
        );
    }

    function name() external view override returns (string memory) {
        return _name;
    }

    function symbol() external view override returns (string memory) {
        return _symbol;
    }
}
