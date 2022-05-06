// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract aCPU is ERC721 {
    
    function mint(address to, uint256 tokenId) public virtual {
        _safeMint(to, tokenId);
    }
}