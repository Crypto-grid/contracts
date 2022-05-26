// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "../tokens/Upgrades.sol";
import "../hardware/Hardware.sol";

contract Account {
	struct Acccount {
		uint256 rebirths;
		uint256 sacrifices;
	}

	mapping(address => Acccount) public accounts;
	address public upgradeToken;
	address public defaultHardware;
	// string constant PC_SPEED_INCREMENT = 1;
	// NOTE: _defaultHardware has to be owner before it's able to signup correctly
	constructor (address _upgradeToken, address _defaultHardware){
		upgradeToken = _upgradeToken;
		defaultHardware = _defaultHardware;
	}

   modifier enoughUpgradeToken(address _address){
	   IERC20 token = IERC20(upgradeToken);
		require(token.balanceOf(_address) < determineUpgradeTokenRequired(_address), "Not enough tokens");
		_;
   }

	function signUp(address _address) public {
		accounts[_address] = Acccount(0, 0);
		Hardware hw = Hardware(defaultHardware);
		hw.mint(_address);
	}

	function determineUpgradeTokenRequired(address _address) private view returns (uint256 upgradeTokenRequired){
		// rebirth mechanism
		// btw the algorithm is not confirmed for now since it takes quite less tokens.
		// y = a(x-h)^2 + k
		// y = no of upgrades token required
		// x = no of rebirth

		// upgradeTokenRequired = A * ((accounts[_address].rebirths - H)*(accounts[_address].rebirths - H)) + K;
	}

	// rebirth should be called when the player rebirths, this will require an amount of upgrade tokens x, however ALL the upgrade token will be REMOVED!!!
	// x can be an amount for example 5000 on the first rebirth, second could be 7500, third could be 12000 etc.
	// whats the logic to determine the number of upgrade tokens? 
	function rebirth(address _address) public {
		accounts[_address].rebirths++;

		// Increase PC speed, rate of earning from their equipment. 1.01x faster each rebirth.
		// accounts[_address].pcSpeed *= PC_SPEED_INCREMENT;

		// Decrease minimum claim time by 5 seconds. First rebirth will start from 12 hours. (8638 rebirth will be the maximum) claim times are separate from each other.
		// accounts[_address].claimTime -= CLAIM_TIME_DECREMENT;
	}

	function sacrifice(address _address) public {
		accounts[_address].sacrifices++;
		accounts[_address].rebirths = 0;
	}

	function getAccount(address _address) public view returns(Acccount memory){
		return accounts[_address];
	}
}
