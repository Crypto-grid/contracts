// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Treasury is Ownable {

  event TokenDepositEvent(
    address indexed depositorAddress, 
    address indexed tokenContractAddress, 
    uint256 amount
  );

  function initialDepositToken(address token, uint256 _amount) public payable {
    require(token != address(0x0), "token contract address cannot be null");
    require(address(token) != address(0), "token contract address cannot be 0");

    IERC20 tokenContract = IERC20(token);

    require(_amount != 0, "Cannot deposit nothing into the treasury");

    tokenContract.transferFrom(msg.sender, address(this), _amount);
    emit TokenDepositEvent(msg.sender, token, _amount);
  }

  function depositToken(address token) public payable {
    require(token != address(0x0), "token contract address cannot be null");
    require(address(token) != address(0), "token contract address cannot be 0");

    IERC20 tokenContract = IERC20(token);
    uint256 amountToDeposit = tokenContract.allowance(msg.sender, address(this));

    require(amountToDeposit != 0, "Cannot deposit nothing into the treasury");

    tokenContract.transferFrom(msg.sender, address(this), amountToDeposit);
    emit TokenDepositEvent(msg.sender, token, amountToDeposit);
  }

  function getTokenBalance(address token) public view returns (uint256) {
    IERC20 tokenContract = IERC20(token);
    return tokenContract.balanceOf(address(this));
  }

  function withdrawTokens(address tokenAddress, uint256 amount) external onlyOwner{
    IERC20 tokenContract = IERC20(tokenAddress);
    uint256 tokenBalance = tokenContract.balanceOf(address(this));
    require(tokenBalance >= amount, "Insufficient token balance");
    tokenContract.transfer(owner(), amount);
  }

  mapping(address => uint256) claimRequest;

  event ClaimTreasuryEvent(
    address indexed claimer, 
    uint256 amount
  );

  function claim(uint256 _amount) public {
    require(_amount <= getTokenBalance(address(this)),'Cannot claim more than treasury amount');
    claimRequest[msg.sender] = _amount;
    emit ClaimTreasuryEvent(msg.sender, _amount);
  }

  event TokenWithdrawEvent(
    address indexed destinationAddress, 
    uint256 amount
  );

  function approveClaim(address tokenAddress, address claimer, uint256 approvedAmount) external onlyOwner {
    IERC20 tokenContract = IERC20(tokenAddress);
    uint256 tokenBalance = tokenContract.balanceOf(address(this));
    require(tokenBalance >= approvedAmount, "Insufficient token balance");
    tokenContract.transfer(claimer, approvedAmount);
    
  }

}
