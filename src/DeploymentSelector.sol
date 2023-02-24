// SPDX-License-Identifier:	AGPL-3.0
pragma solidity ^0.8.13;

import {Deployer} from "./Deployer.sol";

import "forge-std/console.sol";

contract DeploymentSelector is Deployer {
    error DeployerError();

    /** TODO:
     *  ! Consider salt in create2 deployment
     *  ! improve formatting of getCode input (contract file and contract declaration must be the same for now)
     */

    /**
     * @notice Selects how the contract should be deployed, or returns the address of a previous deployment
     * @param check The name of the contract to check
     * @param initData The initialization data for the contract
     * @return contractAddress The address of the deployed contract, or that of a previous deployment
     * @return deploymentBytecode The bytecode of the deployed contract (empty bytes if previous deployment used)
     */
    function SelectDeployment(
        string memory check,
        bytes memory initData
    ) public returns (address contractAddress, bytes memory deploymentBytecode) {
        // Construct bytecode based off contract and initialization data
        deploymentBytecode = abi.encodePacked(vm.getCode(string.concat(check, ".sol:", check)), initData);

        // If deterministic deployment is enabled, we will use the create2 opcode to deploy the contract
        if (vm.envBool("DETERMINISTIC_DEPLOYMENT")) {
            assembly {
                contractAddress := create2(0, add(deploymentBytecode, 0x20), mload(deploymentBytecode), 0)
            }

            if (contractAddress == address(0)) revert DeployerError();

            return (contractAddress, deploymentBytecode);
        }

        contractAddress = checkPreviousDeployment(check, initData);

        // If we should check for previous deployments, and there is one, return it
        if (vm.envBool("CHECK_DEPLOYMENT") && contractAddress != address(0))
            return (contractAddress, deploymentBytecode);
        else {
            // deploy contract
            assembly {
                contractAddress := create(0, add(deploymentBytecode, 0x20), mload(deploymentBytecode))
            }

            if (contractAddress == address(0)) revert DeployerError();

            return (contractAddress, deploymentBytecode);
        }
    }

    // consider a way to check all existing deployments?
    /**
     * @notice Checks if the contract has already been deployed in our address archive
     * @param check The name of the contract to check
     * @param initData The initialization data for the contract
     * @dev Must match full bytecode of previous deployment
     */
    function checkPreviousDeployment(string memory check, bytes memory initData) internal view returns (address) {
        try fork.getWithBytecode(check) returns (address payable deployed, bytes memory bytecode) {
            return
                keccak256(bytecode) ==
                    keccak256(abi.encodePacked(vm.getCode(string.concat(check, ".sol:", check)), initData))
                    ? deployed
                    : address(0);
        } catch {
            return address(0);
        }
    }
}
