// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {

    NetworkConfig public activeNetworkconfig;

    uint8 private constant DECIMALS = 8;
    int256 private constant INITIAL_USD = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkconfig = getSepoliaEthConfig();
        }
        else if (block.chainid == 1) {
            activeNetworkconfig = getMainnetEthConfig();
        }
        else {
            activeNetworkconfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetConfig = NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return mainnetConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if(activeNetworkconfig.priceFeed != address(0)) {
            return activeNetworkconfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mock = new MockV3Aggregator(DECIMALS, INITIAL_USD);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mock)});

        return anvilConfig;

    }

}