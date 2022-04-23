// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Grid is ERC20 {
    constructor(uint256 initialSupply) ERC20("CryptoGrid", "GRID") {
        _mint(msg.sender, initialSupply);
    }
}