// SPDX-License-Identifier:	AGPL-3.0
pragma solidity ^0.8.15;

contract TestContractA {
    string name;

    uint public num = 2;

    constructor(string memory _name) {
        name = _name;
    }

    function whatContractA() public view returns (string memory) {
        return name;
    }
}
