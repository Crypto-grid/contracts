// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Account {
	struct Acccount {
		uint256 rebirths;
		uint256 sacrifices;
		uint256 pcSpeed;
		uint256 claimTime;
	}

	mapping(address => Acccount) public accounts;
	// string constant PC_SPEED_INCREMENT = 1;
	uint256 constant CLAIM_TIME_DECREMENT = 5;
	uint256 constant FIRST_REBIRTH = 12;
	uint256 constant MAXIMUM_REBIRTH = 8638;

	modifier rebirthLimit(address _address) {
		require(accounts[_address] <= MAXIMUM_REBIRTH, "The maximum number of rebirth is " + MAXIMUM_REBIRTH);
		_;
   }

	function signUp(address _address) public {
		accounts[_address] = Acccount(0, 0);
	}

	// rebirth should be called after 12 hours?
	function rebirth(address _address) public rebirthLimit(address _address){
		accounts[_address].rebirths++;

		// Increase PC speed, rate of earning from their equipment. 1.01x faster each rebirth.
		// accounts[_address].pcSpeed *= PC_SPEED_INCREMENT;

		// Decrease minimum claim time by 5 seconds. First rebirth will start from 12 hours. (8638 rebirth will be the maximum) claim times are separate from each other.
		accounts[_address].claimTime -= CLAIM_TIME_DECREMENT;
	}

	function sacrifice(address _address) public {
		accounts[_address].sacrifices++;
		accounts[_address].rebirths = 0;
	}
}
