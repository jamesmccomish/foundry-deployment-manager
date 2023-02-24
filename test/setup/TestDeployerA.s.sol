// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {DeploymentSelector} from "../../src/DeploymentSelector.sol";

import {TestContractA} from "./TestContractA.sol";

import "forge-std/console.sol";

contract TestDeployerA is DeploymentSelector {
    TestContractA public contractA;

    function run() public {
        innerRun();
        outputDeployment();
    }

    function innerRun() public {
        startBroadcast();

        // Build initialization data
        bytes memory initData = abi.encode("A");

        // Get the contract address and deployment bytecode based on deployment type
        (address contractAddress, bytes memory deploymentBytecode) = SelectDeployment("TestContractA", initData);

        // Set the contract details to be written when outputted
        fork.set("TestContractA", contractAddress, deploymentBytecode);

        stopBroadcast();
    }
}
