// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract Upgrades is ERC20Burnable {
	constructor() ERC20("Upgrades", "UPGRADES") {}

	address[] public allowedAddresses_;

	// prevent transfer of tokens to prevent users from transfering to themselves
	// and transfering to other players to progress faster.
	function _beforeTokenTransfer (
		address from,
		address to,
		uint256 amount
	) internal virtual override {
		bool allowed = false;
		for (uint256 i = 0; i < allowedAddresses_.length; i++) {
			if (allowedAddresses_[i] == to) {
				allowed = true;
				return;
			}
		}

		require(allowed, "Transfer to unwhitelisted address is not allowed");
	}
}
