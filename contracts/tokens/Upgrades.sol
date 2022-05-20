// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Upgrades is Initializable, ERC20Upgradeable, ERC20BurnableUpgradeable, OwnableUpgradeable {
	// map address for token transfer allowance (default is false)
	mapping(address => bool) isAllowed;

	function initialize() external initializer {
		__ERC20_init("Upgrades", "UPGRADES");
		__Ownable_init();
		isAllowed[msg.sender] = true;
	}

	// prevent transfer of tokens to prevent users from transfering to themselves
	// and transfering to other players to progress faster.
	function _beforeTokenTransfer(
		address _from,
		address _to,
		uint256 _amount
	) internal virtual override {
		require(isAllowed[msg.sender], "Not in transfer whitelist");
		super._beforeTokenTransfer(_from, _to, _amount);
	}

	// Allows UPGRADES token to be sent to our other contacts but not to other players
	function addAllowedAddress(address _address) public onlyOwner {
		isAllowed[_address] = true;
	}
}
