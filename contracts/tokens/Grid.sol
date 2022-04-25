// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract Grid is ERC20Capped {
    uint256 public immutable MAX_SUPPLY = 750000000;

    constructor(uint256 initialSupply, address marketing, address treasury, address liquidityPool) ERC20("CryptoGrid", "GRID") ERC20Capped(MAX_SUPPLY) {
        _mint(msg.sender, initialSupply/4);
        // TODO: Allocate funds properly
        _mint(marketing, initialSupply/10);
        _mint(treasury, initialSupply/10);
        _mint(liquidityPool, initialSupply - (initialSupply/4 + initialSupply/10 + initialSupply/10));
    }
}