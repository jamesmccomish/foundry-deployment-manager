// SPDX-License-Identifier:	AGPL-3.0
pragma solidity ^0.8.10;

import {Deployer} from "../src/Deployer.sol";
import {GenericFork, Parser, Record} from "../src/forks/Generic.sol";

import {TestDeployerA} from "./setup/TestDeployerA.s.sol";

import {TestContractA} from "./setup/TestContractA.t.sol";
import {TestContractB} from "./setup/TestContractB.t.sol";

import {Test2, Test} from "../src/utils/Test2.sol";

import "forge-std/console.sol";

contract ContractDeployerTest is Deployer, Test2 {
    Parser parser;
    TestDeployerA deployerA;

    address broadcasterAddress = envAddressOrName("BROADCASTER");

    function setUp() public {
        deployerA = new TestDeployerA();
        parser = new Parser();

        // Dont check deployments to deploy new contract for each test
        vm.setEnv("CHECK_DEPLOYMENT", "false");

        // Run the deployer script
        deployerA.run();
    }

    function testToyEnsHasAddresses() public {
        // Check that the ToyENS is setup
        assertEq(fork.get("TestContractA"), address(deployerA.contractA()));
    }

    function testContractsInstantiatedCorrectly() public {
        // Read the deploy file and parse
        string memory jsonAddressRecord = vm.readFile("addresses/deployed/local.json");
        Record[] memory record = parser.parseJsonBytes(vm.parseJson(jsonAddressRecord));

        assertEq(TestContractA(record[0].addr).whatContractA(), "A");
    }

    function testDontRedeploySameBytecode() public {
        // Dont check deployments to deploy new contract for each test
        vm.setEnv("CHECK_DEPLOYMENT", "true");

        uint nonceBefore = vm.getNonce(broadcasterAddress);

        // Run the deployer script
        deployerA.run();

        uint nonceAfter = vm.getNonce(broadcasterAddress);

        // Check that the nonce has not incremented
        assertEq(nonceBefore, nonceAfter);
    }
}
