// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "../tokens/Upgrades.sol";

contract Account {
	struct Acccount {
		uint256 rebirths;
		uint256 sacrifices;
		// uint256 pcSpeed;
		// uint256 claimTime;
	}

	mapping(address => Acccount) public accounts;
	address public upgradeToken;
	// string constant PC_SPEED_INCREMENT = 1;
	uint256 constant CLAIM_TIME_DECREMENT = 5;
	uint256 constant FIRST_REBIRTH = 12;
	uint256 constant MAXIMUM_REBIRTH = 8638;
	uint256 constant A = 10;
	uint256 constant H = 10;
	uint256 constant K = 10;

	constructor (address _upgradeToken){
		upgradeToken = _upgradeToken;
	}


	modifier rebirthLimit(address _address) {
		require(accounts[_address].rebirths <= MAXIMUM_REBIRTH, "Exceed maximum rebirth");
		_;
   }

   modifier enoughUpgradeToken(address _address){
	   IERC20 token = IERC20(upgradeToken);
		require(token.balanceOf(_address) < determineUpgradeTokenRequired(_address), "Not enough tokens");
		_;
   }

	function signUp(address _address) public {
		// what is the initial pc speed and claim time for the miner?
		// ^ will be added
		accounts[_address] = Acccount(0, 0);
	}

	function determineUpgradeTokenRequired(address _address) private view returns (uint256 upgradeTokenRequired){
		// rebirth mechanism
		// btw the algorithm is not confirmed for now since it takes quite less tokens.
		// y = a(x-h)^2 + k
		// y = no of upgrades token required
		// x = no of rebirth

		upgradeTokenRequired = A * ((accounts[_address].rebirths - H)*(accounts[_address].rebirths - H)) + K;
	}

	// rebirth should be called when the player rebirths, this will require an amount of upgrade tokens x, however ALL the upgrade token will be REMOVED!!!
	// x can be an amount for example 5000 on the first rebirth, second could be 7500, third could be 12000 etc.
	// whats the logic to determine the number of upgrade tokens? 
	function rebirth(address _address) public rebirthLimit(_address) enoughUpgradeToken(_address){
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
}
