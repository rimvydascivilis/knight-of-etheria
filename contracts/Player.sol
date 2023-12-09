// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Character, Equipment } from "./Character.sol";
import { ItemKey, ItemType, MaterialType } from "./Items.sol";

contract Player is Character {
  address public immutable owner;
  ItemKey[] public inventory;
  uint32 public gold;

  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }

  constructor(uint8 _level, address _items, Equipment memory _equippedItems) Character(_level, _items, _equippedItems) {
    owner = msg.sender;
    inventory.push(_equippedItems.helmet);
    inventory.push(_equippedItems.armor);
    inventory.push(_equippedItems.weapon);
    inventory.push(_equippedItems.boots);
  }

  function standartAttackDamage() public view returns (uint16) {
    return _standartAttackDamage();
  }

  function specialAttackDamage() public view returns (uint16) {
    return _specialAttackDamage();
  }

  function shieldUpValue() public view returns (uint16) {
    return _shieldUpValue();
  }

  function addXp(uint32 _xp) external onlyOwner {
    _addXp(_xp);
  }

  function setGold(uint32 _gold) external onlyOwner {
    gold = _gold;
  }

  function addInventoryItem(ItemKey memory _item) external onlyOwner {
    inventory.push(_item);
  }

  function removeInventoryItem(uint256 _index) external onlyOwner {
    require(_index < inventory.length, "Index out of bounds");
    inventory[_index] = inventory[inventory.length - 1];
    inventory.pop();
  }
}
