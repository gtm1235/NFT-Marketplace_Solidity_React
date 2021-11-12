// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC165.sol";
import "./interfaces/IERC721.sol";

 contract ERC721 is ERC165, IERC721 {
//    contract ERC721 is IERC721 {
    /*
    Building minting funciion
    a. NFT to point to an address
    b. Keep track of the token ids
    c. Keep track of the token owners address to token ids
    d. Keep track of how many tokens an address has
    e. Create an event that transmits a transfer log
        contract address, where it is being minted to, id
    */

    //Mapping from token id to the owner
    mapping(uint256 => address) private _tokenOwner;

    //Mapping frm owner to number of owned tokens
    mapping(address => uint256) private _ownedTokensCount;

    //mapping from tokenId to approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    constructor() {
        _registerInterface(
            bytes4(
                keccak256("balanceOf(bytes4)") ^
                    keccak256("ownerOf(bytes4)") ^
                    keccak256("transferFrom(bytes4)")
            )
        );
    }

    function balanceOf(address _owner) public view override returns (uint256) {
        require(_owner != address(0), "Address cannot be zero address");
        uint256 _balance = _ownedTokensCount[_owner];
        return _balance;
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT

    function ownerOf(uint256 _tokenId) public view override returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), "ERC721: Mining address invalid");
        return owner;
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        //setting the address to the nft owner
        address owner = _tokenOwner[tokenId];
        //returnd truthiness that address is not zero
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        //requires address is not zero
        require(to != address(0), "ERC721: Mining address invalid");
        //requires that the token does not already exist
        require(!_exists(tokenId), "ERC721: Token already minted");

        // adding new address for minting with token id
        _tokenOwner[tokenId] = to;
        //increasing total token counts to minting address
        _ownedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    function _transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal {
        require(_to != address(0), "Error -- ERC721 Transfer to zero address");
        require(
            ownerOf(_tokenId) == _from,
            "Trying to transfer a token from address that is not owners"
        );

        _ownedTokensCount[_from] -= 1;
        _ownedTokensCount[_to] += 1;

        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public override {
        //require(isApprovedOrOwner(msg.sender, tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    //require person appproving is the owner
    // 2. We are approving an address ro a  token (tokenId)
    // 3. require that we cant appeove sending tokens od the
    //      owner to the owner
    // 4. Update the map od the approval addresses
    function approve(address _to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(_to != owner, "Error -- approval to current owner");
        require(
            msg.sender == owner,
            "Cuurent caller is not the owner of the token"
        );
        _tokenApprovals[tokenId] = _to;

        emit Approval(owner, _to, tokenId);
    }

    // function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool) {
    //     require(_exists(tokenId), 'token does not exist');
    //     address owner = ownerOf(tokenId);
    //     return(spender == owner || getApproved(tokenId) == spender);
    // }
}
