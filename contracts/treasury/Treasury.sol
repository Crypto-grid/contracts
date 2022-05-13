// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../account/Administrator.sol";

contract Treasury {
	// administrators that can handle treasury spend allowances
	// future: implement voting triad (or other governance option)
	Administrators treasuryAdmin = new Administrators();

	event TokenDepositEvent(address indexed depositorAddress, address indexed tokenContractAddress, uint256 amount);

	/// @notice define tresury contract administrators
	/// @dev setup administrator in a way that only one of the 3 admins can perform treasury actions
	/// @param _admin1 1st administrator
	/// @param _admin2 2nd administrator
	/// @param _admin3 3rd administrator
	function setTreasuryAdminstrators(
		address _admin1,
		address _admin2,
		address _admin3
	) internal {
    address[3] memory _admin;
    _admin[0] = _admin1;
    _admin[1] = _admin2;
    _admin[2] = _admin3;
		treasuryAdmin.setAdminstrators(_admin);
	}

	/// @notice Ensure that administrators are set
	/// @dev Only allow function call if administrators are defined
	modifier definedAdmins() {
		require(treasuryAdmin.adminsAreDefined(), "Treasury: admins must be defined");
		_;
	}

	/// @notice Only token administrators
	/// @dev Only token admins can proceed to the next step
	modifier onlyAdmin() {
		require(treasuryAdmin.isAdminCaller(msg.sender), "Treasury: must be token admin");
		_;
	}

	function depositToken(address _token, uint256 _amount) public definedAdmins {
		require(_token != address(0) && _amount <= 0, "Treasury: invalid parameters");
		IERC20 tokenContract = IERC20(_token);
		require(tokenContract.transferFrom(msg.sender, address(this), _amount), "Treasury: insufficient allowance");

		emit TokenDepositEvent(msg.sender, _token, _amount);
	}

	function depositEther() public payable definedAdmins {
		require(msg.value > 0, "Treasury: invalid parameters");
	}

	function getTokenBalance(address _token) public view returns (uint256) {
		IERC20 tokenContract = IERC20(_token);
		return tokenContract.balanceOf(address(this));
	}

	function withdrawTokens(address _token, uint256 amount) public definedAdmins onlyAdmin {
		require(address(_token) != address(0), "Treasury: Invalid address");
		IERC20 tokenContract = IERC20(_token);
		uint256 tokenBalance = tokenContract.balanceOf(address(this));
		require(tokenBalance >= amount, "Treasury: Insufficient token balance");
		require(tokenContract.transfer(msg.sender, amount), "Treasury: unable to withdraw");
	}

	function withdrawEther(uint256 _amount) public definedAdmins onlyAdmin {
		require(address(this).balance >= _amount, "Treasury: Insufficient ether balance");
		require(address(msg.sender) != address(0), "Treasury: Invalid address");
		payable(address(msg.sender)).transfer(_amount);
	}
}
