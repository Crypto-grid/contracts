// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Mine is a factory that allows users to mine with their hardware.
// there will be 3 coins at the start, gridBTC, gridETH and gridXMR all of them will have the same price to the real world data from
// chainlinks agregatorv3interface. This contract does not need to be upgraded.
contract MineFactory {
	ERC20[] public tokens;
}
