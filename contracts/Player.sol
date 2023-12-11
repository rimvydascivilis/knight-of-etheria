// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Character, Equipment } from "./Character.sol";
import { ItemKey, ItemType, MaterialType } from "./Items.sol";

contract Player is Character {
  address public activeRoom;  
  address public immutable game;
  uint16 highestCompletedRoomLevel = 0;
  ItemKey[] public inventory;
  uint32 public gold;

  modifier onlyGame() {
    require(msg.sender == game, "Only game can call this function");
    _;
  }

  modifier onlyActiveRoom() {
    require(msg.sender == address(activeRoom), "Only active room can call this function");
    _;
  }

  constructor(uint8 _level, address _items, Equipment memory _equippedItems) Character(_level, _items, _equippedItems) {
    game = msg.sender; // assume that msg.sender is the game contract
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

  function addXp(uint32 _xp) external onlyActiveRoom {
    _addXp(_xp);
  }

  function addGold(uint32 _gold) external onlyActiveRoom {
    gold += _gold;
  }

  function setGold(uint32 _gold) external onlyGame {
    gold = _gold;
  }

  function decreaseHealth(uint16 _damage) external onlyActiveRoom {
    hp.current -= _damage;
  }

  function decreaseShield(uint16 _damage) external onlyActiveRoom {
    sp.current -= _damage;
  }

  function setHighestCompletedRoomLevel(uint16 _highestCompletedRoomLevel) external onlyGame {
    highestCompletedRoomLevel = _highestCompletedRoomLevel;
  }

  function addInventoryItem(ItemKey memory _item) external onlyGame {
    inventory.push(_item);
  }

  function removeInventoryItem(uint256 _index) external onlyGame {
    require(_index < inventory.length, "Index out of bounds");
    inventory[_index] = inventory[inventory.length - 1];
    inventory.pop();
  }
}
