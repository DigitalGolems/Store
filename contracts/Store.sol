// SPDX-License-Identifier: GPL-3.0

pragma experimental ABIEncoderV2;
pragma solidity 0.8.10;

import "./Things.sol";

contract Store is StoreThings {

    function changeAllPricesWithPercent(uint256 percent) external isOwner {
        for (uint16 i = 0; i < inventory.getThingsAmount(); i++) {
            thingsPrices[i] = uint16(uint256(thingsPrices[i]) * percent / 100);
        }
        for (uint16 i = 0; i < inventory.getResourcesAmount(); i++) {
            resourcesPrices[i] = uint16(uint256(resourcesPrices[i]) * percent / 100);
        }
        for (uint16 i = 0; i < inventory.getAugmentationsAmount(); i++) {
            augmentationsPrices[i] = uint16(uint256(augmentationsPrices[i]) * percent / 100);
        }
    }

}