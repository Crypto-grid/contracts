// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Administrators {
	// administrators that can handle grid token allocations, treasury, etc
	// future: implement voting triad (or other governance option)
	address[3] public admin;

  // set administrators on contract setup
  constructor(address[3] memory _admin) {
    setAdminstrators(_admin);
  }

	/// @notice define token contract administrators
	/// @dev setup administrator in a way that only one of the 3 admins can perform token actions
	/// @param _admin array of administators
	function setAdminstrators(address[3] memory _admin) public {
		require(_admin[0] != _admin[1] && _admin[0] != _admin[2] && _admin[1] != _admin[2], "Contract adminstrators must have different addresses");
		admin[0] = _admin[0];
		admin[1] = _admin[1];
		admin[2] = _admin[2];
	}

	/// @notice Inform if administrators are already defined
	/// @dev Valid if all 3 admins are set with non-zero addresses
	/// @return true if all admins are set, if not... false
	function adminsAreDefined() public view returns (bool) {
		if (admin[0] != address(0) && admin[1] != address(0) && admin[2] != address(0)) {
			return true;
		}
		return false;
	}

	/// @notice Check if the function caller is an admin
	/// @dev Valid if any of the callers is admin
	/// @param _caller function caller address
	/// @return true if any caller is admin
	function isAdminCaller(address _caller) public view returns (bool) {
		if ((admin[0] == _caller) || (admin[1] == _caller) || (admin[2] == _caller)) {
			return true;
		}
		return false;
	}
}
