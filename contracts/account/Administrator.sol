// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Administrators {
	// administrators that can handle grid token allocations, treasury, etc
	// future: implement voting triad (or other governance option)
	address public admin1;
	address public admin2;
	address public admin3;

	/// @notice define token contract administrators
	/// @dev setup administrator in a way that only one of the 3 admins can perform token actions
	/// @param _admin1 1st administrator
	/// @param _admin2 2nd administrator
	/// @param _admin3 3rd administrator
	function setAdminstrators(
		address _admin1,
		address _admin2,
		address _admin3
	) public {
		require(_admin1 != _admin2 && _admin1 != _admin3 && _admin2 != _admin3, "Admins must be different addresses");
		admin1 = _admin1;
		admin2 = _admin2;
		admin3 = _admin3;
	}

	/// @notice Inform if administrators are already defined
	/// @dev Valid if all 3 admins are set with non-zero addresses
	/// @return true if all admins are set, if not... false
	function adminsAreDefined() public view returns (bool) {
		if (admin1 != address(0) && admin2 != address(0) && admin3 != address(0)) {
			return true;
		}
		return false;
	}

	/// @notice Check if the function caller is an admin
	/// @dev Valid if any of the callers is admin
	/// @return true if any caller is admin
	function isAdminCaller(address _caller) public view returns (bool) {
		if ((admin1 == _caller) || (admin2 == _caller) || (admin3 == _caller)) {
			return true;
		}
		return false;
	}
}
