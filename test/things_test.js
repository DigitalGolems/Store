const { assert } = require("chai");

const Inventory = artifacts.require("Inventory.sol");
const Digibytes = artifacts.require("Digibytes.sol");
const Store = artifacts.require("Store.sol")
const Game = artifacts.require("Game.sol")
// const { assert } = require('chai')
// const chai = require('chai')

contract('Game Store Things', async (accounts)=>{
    let inventory;
    let DBT;
    let store;
    let game;
    let user = accounts[9];
    let owner = accounts[0];
    before(async () => {
        inventory = await Inventory.new()
        DBT = await Digibytes.new()
        store = await Store.new()
        game = await Game.deployed()
        await inventory.setStoreContract(store.address)
        await inventory.setGameContract(game.address)
        await store.setDBT(DBT.address)
        await store.setInventory(inventory.address)
        for (let i = 0;i < parseInt((await inventory.getThingsAmount()).toString());i++){
            await store.addThingPrice(
                i,
                web3.utils.toWei("10"),
                {from: owner}
            )
        }
        await DBT.transfer(user, web3.utils.toWei("100"), {from: owner})
    })
    // in order to send money to the contract, we will approve the money in gigabytes to it
    // which is equal to the price * amount (the thing we want to buy)
    // then we will buy it and check
    // if your items are added to the inventory
    // and the game balance increases price*amount
   it("Should buy each thing", async () => {
        await DBT.approve(store.address, web3.utils.toWei("100"), {from: user})
        for (let i = 0;i < parseInt((await inventory.getThingsAmount()).toString());i++){
            await store.buyThings(i, 1, {from: user})
        }
        let things = await inventory.getThings(user,{from: user})
        let balance = await DBT.balanceOf(store.address)
        assert.equal(balance, web3.utils.toWei("10") * parseInt((await inventory.getThingsAmount())), "Balances equal")
        for (let i = 0;i < parseInt((await inventory.getThingsAmount()).toString());i++){
            assert.equal(things[i].toString(), 1, "Things equal")
        }
    })

})