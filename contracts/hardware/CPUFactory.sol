// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CPUFactory is Ownable {
    
    constructor() public {

    }

    // createNewCPU creates a new NFT based CPU which can be classified as a brand of CPU, series and name of the CPU
    function createNewCPU(string memory _brand, string memory series, string memory name) public onlyOwner {
        
    }
}