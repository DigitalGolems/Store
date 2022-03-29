// SPDX-License-Identifier: GPL-3.0

pragma experimental ABIEncoderV2;
pragma solidity 0.8.10;

import "./Resources.sol";

contract StoreThings is StoreResources {

    mapping(uint16 => uint256) thingsPrices;

    event BuyThings(uint16 _ID, uint16 _amount, address _buyer);
    event ChangeThingsPrice(uint16 _ID, uint256 _price);

    //onlyOWner
    function addThingPrice(uint16 _ID, uint256 _price) public isOwner {
        require(_ID < inventory.getThingsAmount(), "ID more than Things amount");
        thingsPrices[_ID] = _price;
        emit ChangeThingsPrice(_ID, _price);
    }

    function getThingPrice(uint16 _ID) public view returns(uint256) {
        return thingsPrices[_ID];
    }

    function buyThings(uint16 _ID, uint16 _amount) external {
        require(thingsPrices[_ID] != 0, "Prices a not added");
        require(DBT.balanceOf(msg.sender) >= _amount * thingsPrices[_ID], "Balance too small");
        require(DBT.allowance(msg.sender, address(this)) >= _amount * thingsPrices[_ID], "Contract cant do transfer from your account");
        _buyThings(_ID, _amount, msg.sender);
        DBT.transferFrom(msg.sender, address(this), _amount * thingsPrices[_ID]);
        emit BuyThings(_ID, _amount, msg.sender);
    }

    function _buyThings(uint16 _ID, uint16 _amount, address _buyer) private {
        inventory.addAmountOfOneThing(_ID, _amount, _buyer);
    }


}
