// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Upgrades is ERC20BurnableUpgradeable, OwnableUpgradeable {
	address[] public allowedAddresses_;

	function initialize() external initializer {
		__ERC20_init("Upgrades", "UPGRADES");
		__Ownable_init();
		allowedAddresses_ = [msg.sender];
	}

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

		require(allowed, "Not in transfer whitelist");
	}

	// Allows UPGRADES token to be sent to our other contacts but not to other players
	function addAllowedAddress(address _address) public onlyOwner {
		allowedAddresses_.push(_address);
	}
}
