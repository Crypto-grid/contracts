// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Account {
	struct Acccount {
		uint256 rebirths;
		uint256 sacrifices;
	}

	mapping(address => Acccount) public accounts;

	function signUp(address _address) public {
		accounts[_address] = Acccount(0, 0);
	}

	function rebirth(address _address) public {
		accounts[_address].rebirths++;
	}

	function sacrifice(address _address) public {
		accounts[_address].sacrifices++;
		accounts[_address].rebirths = 0;
	}
}
