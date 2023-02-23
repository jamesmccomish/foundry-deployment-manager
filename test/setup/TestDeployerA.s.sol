// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {DeploymentSelector} from "../../src/DeploymentSelector.sol";

import {TestContractA} from "./TestContractA.t.sol";

import "forge-std/console.sol";

contract TestDeployerA is DeploymentSelector {
    TestContractA public contractA;

    function run() public {
        innerRun();
        outputDeployment();
    }

    function innerRun() public {
        startBroadcast();

        bytes memory initData = abi.encode("A");

        (address contractAddress, bytes memory deploymentBytecode) = SelectDeployment("TestContractA", initData);

        fork.set("TestContractA", contractAddress, deploymentBytecode);
    }
}
