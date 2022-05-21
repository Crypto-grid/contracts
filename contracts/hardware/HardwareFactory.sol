// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Hardware.sol";

contract HardwareFactory is Ownable {
	// These mappings are used to store all available hardware that can be sold
	mapping(address => Hardware) public availableCPUs;
	mapping(address => Hardware) public availableGPUs;
	mapping(address => Hardware) public availableASICs;

	address public aggregatorAddress_;
	address public upgradeTokenAddress_;

	enum HardwareType {
		CPU,
		GPU,
		ASICS
	}

	constructor(address _aggregatorAddress, address _upgradeTokenAddress) {
		require(address(_aggregatorAddress) != address(0) && address(_upgradeTokenAddress) != address(0), "Addresses cannot be 0");
		aggregatorAddress_ = _aggregatorAddress;
		upgradeTokenAddress_ = _upgradeTokenAddress;
	}

	// createNewCPU creates a new NFT based CPU which can be classified as a brand of CPU, series and name of the CPU
	function createNewHardware(
		string memory _brand,
		string memory _series,
		string memory _name,
		uint256 _basePrice,
		string[5] memory _imageURI,
		HardwareType type_
	) public onlyOwner {
		Hardware hw = new Hardware(_brand, _series, _name, _basePrice, upgradeTokenAddress_, aggregatorAddress_, _imageURI);
		// It'll be so nice if there was generics or switch lol
		if (type_ == HardwareType.CPU) {
			availableCPUs[address(hw)] = hw;
		}else if (type_ == HardwareType.GPU) {
			availableGPUs[address(hw)] = hw;
		}else if (type_ == HardwareType.ASICS) {
			availableCPUs[address(hw)] = hw;
		}else {
			revert("Invalid hardware type");
		}
	}

	function getInstance(HardwareType _type, address _hwAddress) public view returns (Hardware) {
		if (_type == HardwareType.CPU) {
			return availableCPUs[_hwAddress];
		}else if (_type == HardwareType.GPU) {
			return availableGPUs[_hwAddress];
		}else if (_type == HardwareType.ASICS) {
			return availableASICs[_hwAddress];
		}else {
			revert("Invalid hardware type");
		}
	}
}
