// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {

    uint256 private constant INITIAL_BALANCE = 100e18;

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe", 
            block.chainid);
        FundMe(payable(mostRecentlyDeployed)).fund{value: INITIAL_BALANCE}();
        console.log("Funded Fund me with %s", INITIAL_BALANCE);
        
    }
    
    function fundFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value: INITIAL_BALANCE}();
        vm.stopBroadcast();
        console.log("Funded Fund me with %s", INITIAL_BALANCE);
    }


}

contract WithdrawFundMe is Script {

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe", 
            block.chainid);

        withdrawFundMe(mostRecentlyDeployed);
    }

    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
        
    }


}