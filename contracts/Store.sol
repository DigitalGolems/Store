// SPDX-License-Identifier: GPL-3.0

pragma experimental ABIEncoderV2;
pragma solidity 0.8.10;

import "./Things.sol";

contract Store is StoreThings {

    function changeAllPricesWithPercentMinus(uint256 percent) external isOwner {
        for (uint16 i = 0; i < inventory.getThingsAmount(); i++) {
            thingsPrices[i] = thingsPrices[i] - (thingsPrices[i] * percent / 100);
        }
        for (uint16 i = 0; i < inventory.getResourcesAmount(); i++) {
            resourcesPrices[i] = resourcesPrices[i] - (resourcesPrices[i] * percent / 100);
        }
        for (uint16 i = 0; i < inventory.getAugmentationsAmount(); i++) {
            augmentationsPrices[i] = augmentationsPrices[i] - (augmentationsPrices[i] * percent/ 100);
        }
    }

    function changeAllPricesWithPercentPlus(uint256 percent) external isOwner {
        for (uint16 i = 0; i < inventory.getThingsAmount(); i++) {
            thingsPrices[i] = thingsPrices[i] + (thingsPrices[i] * percent / 100);
        }
        for (uint16 i = 0; i < inventory.getResourcesAmount(); i++) {
            resourcesPrices[i] = resourcesPrices[i] + (resourcesPrices[i] * percent / 100);
        }
        for (uint16 i = 0; i < inventory.getAugmentationsAmount(); i++) {
            augmentationsPrices[i] = augmentationsPrices[i] + (augmentationsPrices[i] * percent/ 100);
        }
    }

}
