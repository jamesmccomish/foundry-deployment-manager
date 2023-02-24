// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// Import deployment selector to handle deployments
import {DeploymentSelector} from "../../src/DeploymentSelector.sol";

// Import any contracts to be deployed
import {TestContractA} from "./TestContractA.sol";

/**
 * @dev Deploy script for contractB which has dependencies
 * ! TODO - Add support for dependencies
 */

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
