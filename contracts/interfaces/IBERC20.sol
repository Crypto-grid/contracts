// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// IBERC20 is an interface that defines the basic functions of a token that can be burned.
// It is inherited from ERC20Burnable.
interface IBERC20 is IERC20 {
	function burn(uint256 amount) external;
	function burnFrom(address account, uint256 amount) external;
}
