// SPDX-License-Identifier:	AGPL-3.0
pragma solidity ^0.8.10;

import {Deployer} from "../src/Deployer.sol";
import {TestDeployerA} from "./setup/TestDeployerA.s.sol";

import {TestContractA} from "./setup/TestContractA.t.sol";
import {TestContractB} from "./setup/TestContractB.t.sol";

import {Test2, Test} from "../src/utils/Test2.sol";

contract ContractDeployerTest is Deployer, Test2 {
    TestDeployerA deployerA;

    function setUp() public {
        deployerA = new TestDeployerA();

        deployerA.innerRun();
    }

    function testToyEnsHasAddresses() public {
        assertEq(fork.get("TestContractA"), address(deployerA.contractA()));
    }

    function testContractsInstantiatedCorrectly() public {
        TestContractA contractA = deployerA.contractA();

        assertEq(contractA.whatContractA(), "A");
    }
}
