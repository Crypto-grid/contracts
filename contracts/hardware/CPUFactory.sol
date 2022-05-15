// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./cpu/CPU.sol";

contract CPUFactory is Ownable {
	// This array is used to store all available CPUs that can be sold
	CPU[] public availableCPUs_;

	address public aggregatorAddress_;
	address public upgradeTokenAddress_;

	constructor(address _aggregatorAddress, address _upgradeTokenAddress) {
		require(address(_aggregatorAddress) != address(0) && address(_upgradeTokenAddress) != address(0), "Addresses cannot be 0");
		aggregatorAddress_ = _aggregatorAddress;
		upgradeTokenAddress_ = _upgradeTokenAddress;
		createNewCPU("Int3l", "i5", "4790k", 0, "");
	}

	// createNewCPU creates a new NFT based CPU which can be classified as a brand of CPU, series and name of the CPU
	function createNewCPU(
		string memory _brand,
		string memory _series,
		string memory _name,
		uint256 _basePrice,
		string memory _imageURI
	) public onlyOwner {
		CPU cpu = new CPU(_brand, _series, _name, _basePrice, upgradeTokenAddress_, aggregatorAddress_, _imageURI);
		availableCPUs_.push(cpu);
	}
}
