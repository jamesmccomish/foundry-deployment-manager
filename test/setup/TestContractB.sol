// SPDX-License-Identifier:	AGPL-3.0
pragma solidity ^0.8.10;

contract TestContractB {
    string name;

    constructor(string memory _name) {
        name = _name;
    }

    function whatContractB() public view returns (string memory) {
        return name;
    }
}
