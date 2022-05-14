// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../account/Administrator.sol";

contract Treasury {

  address immutable gridTokeAddress;

	// administrators that can handle treasury spend allowances
	// future: implement voting triad (or other governance option)
	Administrators treasuryAdmin;

  constructor(address _gridTokeAddress, address[3] memory _admin) {
    require(_gridTokeAddress != address(0), "Treasury: need a valid token address");
    gridTokeAddress = _gridTokeAddress;
    treasuryAdmin = new Administrators(_admin);
  }

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
		require(treasuryAdmin.adminsAreDefined(), "Treasury: administrators must be defined");
		_;
	}

	/// @notice Only token administrators
	/// @dev Only token admins can proceed to the next step
	modifier onlyAdmin() {
		require(treasuryAdmin.isAdminCaller(msg.sender), "Treasury: must be token administrator");
		_;
	}

	function depositToken(uint256 _amount) public definedAdmins {
		require(_amount > 0, "Treasury: cannon deposit zero amount");
		IERC20 tokenContract = IERC20(gridTokeAddress);
		require(tokenContract.transferFrom(msg.sender, address(this), _amount), "Treasury: insufficient allowance");
		emit TokenDepositEvent(msg.sender, gridTokeAddress, _amount);
	}

	function depositEther() public payable definedAdmins {
		require(msg.value > 0, "Treasury: invalid parameters");
	}

	function getTokenBalance() public view returns (uint256) {
		IERC20 tokenContract = IERC20(gridTokeAddress);
		return tokenContract.balanceOf(address(this));
	}

	function withdrawTokens(uint256 amount) public definedAdmins onlyAdmin {
		IERC20 tokenContract = IERC20(gridTokeAddress);
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
