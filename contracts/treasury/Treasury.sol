// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Treasury is Ownable {
	event TokenDepositEvent(address indexed depositorAddress, address indexed tokenContractAddress, uint256 amount);

	function depositToken(address _token, uint256 _amount) public {
		require(_token != address(0) && _amount <= 0, "Treasury: invalid parameters");
		IERC20 token_ = IERC20(_token);
		require(token_.transferFrom(msg.sender, address(this), _amount), "Treasury: insufficient allowance");

		emit TokenDepositEvent(msg.sender, _token, _amount);
	}

	function depositEther() public payable {
		require(msg.value > 0, "Treasury: invalid parameters");
	}

	function getTokenBalance(address token) public view returns (uint256) {
		IERC20 tokenContract = IERC20(token);
		return tokenContract.balanceOf(address(this));
	}

	function withdrawTokens(address tokenAddress, uint256 amount) public onlyOwner {
		IERC20 tokenContract = IERC20(tokenAddress);
		uint256 tokenBalance = tokenContract.balanceOf(address(this));
		require(tokenBalance >= amount, "Insufficient token balance");
		tokenContract.transfer(owner(), amount);
	}

	function withdrawEther(uint256 _amount) public onlyOwner {
		require(address(this).balance >= _amount, "Insufficient ether balance");
		require(address(msg.sender) != address(0), "Invalid address");
		payable(address(msg.sender)).transfer(_amount);
	}
}
