// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract Upgrades is ERC20Burnable{
    constructor() ERC20("Upgrades", "UPGRADES") {}
}
