// SPDX-License-Identifier:	AGPL-3.0
pragma solidity ^0.8.10;

contract TestContractA {
    string name;

    constructor(string memory _name) {
        name = _name;
    }

    function whatContractA() public view returns (string memory) {
        return name;
    }
}
