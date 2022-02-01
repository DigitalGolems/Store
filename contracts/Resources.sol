// SPDX-License-Identifier: GPL-3.0

pragma experimental ABIEncoderV2;
pragma solidity 0.8.10;

import "./Augmentations.sol";

contract StoreResources is StoreAugmentations {

    using SafeMath for uint;
    using SafeMath16 for uint16;
    using SafeMath32 for uint32;

    mapping(uint16 => uint256) resourcesPrices;

    event BuyResources(uint16 _ID, uint16 _amount, address _buyer);
    event ChangeResourcesPrice(uint16 _ID, uint256 _price);

    //onlyOWner
    function addResourcesPrice(uint16 _ID, uint256 _price) public isOwner {
        require(_ID < inventory.getResourcesAmount(), "ID more than Resources amount");
        resourcesPrices[_ID] = _price;
        emit ChangeResourcesPrice(_ID, _price);
    }

    function getResourcesPrice(uint16 _ID) public view returns(uint256) {
        return resourcesPrices[_ID];
    }

    function buyResources(uint16 _ID, uint16 _amount) external {
        require(resourcesPrices[_ID] != 0, "Prices a not added");
        require(DBT.balanceOf(msg.sender) >= _amount * resourcesPrices[_ID], "Balance too small");
        require(DBT.allowance(msg.sender, address(this)) >= _amount * resourcesPrices[_ID], "Contract cant do transfer from your account");
        _buyResources(_ID, _amount, msg.sender);
        DBT.transferFrom(msg.sender, address(this), _amount * resourcesPrices[_ID]);
        emit BuyResources(_ID, _amount, msg.sender);
    }

    function _buyResources(uint16 _ID, uint16 _amount, address _buyer) private {
        inventory.addAmountOfOneResource(_ID, _amount, _buyer);
    }

}