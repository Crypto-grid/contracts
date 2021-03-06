// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.9;

import "../hardware/Hardware.sol";
import "../hardware/HardwareFactory.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

// Rewards is a system to reward players for mining the tokens
contract Rewards {
    // This uses a lot of gas due to it mapping to a contract!!!!
    // TODO: Improve this code. What I'm thinking of is address of the hardware mapped to the token ids mapped to timestamp but that won't work with solidity :()
    // Player address mapped to hardware type which is mapped to the tokenID which stores the last claimed timestamp
	mapping(address => mapping(Hardware => mapping(HardwareFactory.HardwareType => uint256))) public lastClaimedMapping;
    // Player address mapped to hardware type mapped to the tokenID.
	mapping(address => mapping(Hardware => HardwareFactory.HardwareType)) public depositsMapping;
    
	address public hw;
	address public hwf;

	constructor(address hardware, address hardwareFactory) {
		hw = hardware;
		hwf = hardwareFactory;
	}

	// The claim function will be ran when someone claims the token
	function claim(address _address, address _token) public {}

	function claimAll() public {}

    // rewardsBalance provides information about unclaimed rewards.
    function rewardsBalance(address _address, HardwareFactory.HardwareType _type, uint256 _tokenID) public view returns (uint256) {
        if (lastClaimedMapping[_address][Hardware(_address)][_type] == 0) {
            return 0;
        }

        // TODO: Implement mechanism to reduce time to claim with sacrifice
        uint256 sacrifice = 0;
        if (lastClaimedMapping[_address][Hardware(_address)][_type] <= (block.timestamp + 3 days - sacrifice)) {
            return 0;
        }

        return (block.timestamp - lastClaimedMapping[_address][Hardware(_address)][_type]) * 1 / 10000;
    }

	function deposit(
		uint256 _tokenID,
		address _token,
		HardwareFactory.HardwareType _type
	) public {
		lastClaimedMapping[address(msg.sender)][Hardware(_token)][_type] = block.timestamp;
        depositsMapping[address(msg.sender)][Hardware(_token)] = _type;
		require(checkFactory(_tokenID, _token, _type), "You can't deposit this token");
		Hardware token = Hardware(_token);
		token.safeTransferFrom(address(msg.sender), address(this), _tokenID);
	}

	function checkFactory(
		uint256 _tokenID,
		address _token,
		HardwareFactory.HardwareType _type
	) internal view returns (bool) {
		HardwareFactory hardwares = HardwareFactory(hwf);
		if (_type == HardwareFactory.HardwareType.CPU) {
			Hardware hw2 = hardwares.getInstance(HardwareFactory.HardwareType.CPU, _token);
			require(
				hw2.getApproved(_tokenID) == address(msg.sender) || hw2.ownerOf(_tokenID) == address(msg.sender),
				"You don't have permission to deposit this token"
			);
		} else if (_type == HardwareFactory.HardwareType.GPU) {
			Hardware hw2 = hardwares.getInstance(HardwareFactory.HardwareType.GPU, _token);
			require(
				hw2.getApproved(_tokenID) == address(msg.sender) || hw2.ownerOf(_tokenID) == address(msg.sender),
				"You don't have permission to deposit this token"
			);
		} else if (_type == HardwareFactory.HardwareType.ASICS) {
			Hardware hw2 = hardwares.getInstance(HardwareFactory.HardwareType.ASICS, _token);
			require(
				hw2.getApproved(_tokenID) == address(msg.sender) || hw2.ownerOf(_tokenID) == address(msg.sender),
				"You don't have permission to deposit this token"
			);
		} else {
			return false;
		}
		return true;
	}

	// this will be used for the rebirth functionality to remove all non rare tokens
	// function wipeDeposits() internal {
	// 	for (uint256 i = 0; i < depositsMapping[msg.sender].length; i++) {
	// 		remove(i);
	// 	}
	// }

	// TODO: Check for rare tokens
	// function remove(uint256 index) public {
	// 	if (index >= depositsMapping[msg.sender].length) return;

	// 	for (uint256 i = index; i < depositsMapping[msg.sender].length - 1; i++) {
	// 		depositsMapping[msg.sender][i] = depositsMapping[msg.sender][i + 1];
	// 	}
	// 	depositsMapping[msg.sender].pop();
	// }
}
