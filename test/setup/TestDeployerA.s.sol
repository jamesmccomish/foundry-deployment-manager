// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {TestContractA} from "./TestContractA.t.sol";
import {Deployer} from "../../src/Deployer.sol";

contract TestDeployerA is Deployer {
    TestContractA public contractA;

    function run() public {
        innerRun();
        outputDeployment();
    }

    function innerRun() public {
        broadcast();

        contractA = new TestContractA("A");

        fork.set("TestContractA", address(contractA));
    }
}
