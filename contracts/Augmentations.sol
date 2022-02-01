// SPDX-License-Identifier: GPL-3.0

pragma experimental ABIEncoderV2;
pragma solidity 0.8.10;

import "../../Utils/Owner.sol";
import "../Inventory/Inventory.sol";
import "../../Digibytes/Digibytes.sol";

contract StoreAugmentations is Owner {

    using SafeMath for uint;
    using SafeMath16 for uint16;
    using SafeMath32 for uint32;

    Inventory public inventory;
    Digibytes public DBT;
    mapping(uint16 => uint256) augmentationsPrices;

    function setDBT(address _DBT) public isOwner {
        DBT = Digibytes(_DBT);
    }

    function setInventory(address _inventory) public isOwner {
        inventory = Inventory(_inventory);
    }

    event BuyAugmentations(uint16 _ID, uint16 _amount, address _buyer);
    event ChangeAumentationsPrice(uint16 _ID, uint256 _price);
    //onlyOWner
    function addAugmentationPrice(uint16 _ID, uint256 _price) public isOwner {
        require(_ID < inventory.getAugmentationsAmount(), "ID more than Augment amount");
        augmentationsPrices[_ID] = _price;
        emit ChangeAumentationsPrice(_ID, _price);
    }

    function getAugmentationPrice(uint16 _ID) public view returns(uint256) {
        return augmentationsPrices[_ID];
    }

    function buyAugmentations(uint16 _ID, uint16 _amount) external {
        require(augmentationsPrices[_ID] != 0, "Prices a not added");
        require(DBT.balanceOf(msg.sender) >= _amount * augmentationsPrices[_ID], "Balance too small");
        require(DBT.allowance(msg.sender, address(this)) >= _amount * augmentationsPrices[_ID], "Contract cant do transfer from your account");
        _buyAugmentations(_ID, _amount, msg.sender);
        DBT.transferFrom(msg.sender, address(this), _amount * augmentationsPrices[_ID]);
        emit BuyAugmentations(_ID, _amount, msg.sender);
    }

    function _buyAugmentations(uint16 _ID, uint16 _amount, address _buyer) private {
        inventory.addAmountOfOneAugmentation(_ID, _amount, _buyer);
    }

}