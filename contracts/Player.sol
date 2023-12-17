// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import { Character, Equipment } from "./Character.sol";
import { ItemKey, ItemType, MaterialType } from "./Items.sol";

contract Player is Character {
  address public immutable player;
  address public activeRoom;  
  address public immutable game;
  uint16 highestCompletedRoomLevel = 0;
  ItemKey[20] public inventory;
  uint32 public gold;

  modifier onlyPlayer() {
    require(msg.sender == player, "Only player can call this function");
    _;
  }

  modifier onlyGame() {
    require(msg.sender == game, "Only game can call this function");
    _;
  }

  modifier onlyActiveRoom() {
    require(msg.sender == address(activeRoom), "Only active room can call this function");
    _;
  }

  constructor(uint8 _level, address _items, Equipment memory _equippedItems) Character(_level, _items, _equippedItems) {
    player = tx.origin; // assume that tx.origin is the player
    game = msg.sender; // assume that msg.sender is the game contract
    inventory[0] = _equippedItems.helmet;
    inventory[1] = _equippedItems.armor;
    inventory[2] = _equippedItems.weapon;
    inventory[3] = _equippedItems.boots;
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

  function getInventoryLength() public view returns (uint256) {
    return inventory.length;
  }

  function equipItem(uint256 _index) public onlyPlayer {
    require(activeRoom == address(0), "Player is already in a room");
    require(_index < inventory.length, "Index out of bounds");
    ItemKey memory item = inventory[_index];

    if (item.itemType == ItemType.Helmet) {
      _equipItemHelper(equippedItems.helmet, _index);
    } else if (item.itemType == ItemType.Armor) {
      _equipItemHelper(equippedItems.armor, _index);
    } else if (item.itemType == ItemType.Boots) {
      _equipItemHelper(equippedItems.boots, _index);
    } else if (item.itemType == ItemType.Weapon) {
      _equipItemHelper(equippedItems.weapon, _index);
    }
  
    _updateStats();
  }

  function _equipItemHelper(ItemKey storage equippedItem, uint256 _index) private {
    if (equippedItem.materialType != MaterialType.None) {
      (inventory[_index], equippedItem) = (equippedItem, inventory[_index]);
    } else {
      inventory[_index] = inventory[inventory.length - 1];
      inventory[inventory.length - 1] = ItemKey(ItemType.Helmet, MaterialType.None);
    }
  }

  function unequipItem(ItemType _itemType) public onlyPlayer {
    require(activeRoom == address(0), "Player is already in a room");
    for (uint256 i = 0; i < inventory.length; i++) {
      if (inventory[i].materialType == MaterialType.None) {
        if (_itemType == ItemType.Helmet) {
          inventory[i] = equippedItems.helmet;
          equippedItems.helmet = ItemKey(ItemType.Helmet, MaterialType.None);
        } else if (_itemType == ItemType.Armor) {
          inventory[i] = equippedItems.armor;
          equippedItems.helmet = ItemKey(ItemType.Armor, MaterialType.None);
        } else if (_itemType == ItemType.Boots) {
          inventory[i] = equippedItems.boots;
          equippedItems.helmet = ItemKey(ItemType.Boots, MaterialType.None);
        } else if (_itemType == ItemType.Weapon) {
          inventory[i] = equippedItems.weapon;
          equippedItems.helmet = ItemKey(ItemType.Weapon, MaterialType.None);
        }
      }
    }

    _updateStats();
  }

  function addXp(uint32 _xp) external onlyActiveRoom {
    _addXp(_xp);
  }

  function addGold(uint32 _gold) external onlyActiveRoom {
    gold += _gold;
  }

  function reset() external onlyActiveRoom {
    hp.current = hp.max;
    sp.current = sp.max;
  }

  function decreaseHealth(uint16 _damage) external onlyActiveRoom {
    if (hp.current > _damage) {
      hp.current -= _damage;
    } else {
      hp.current = 0;
    }
  }

  function decreaseShield(uint16 _damage) external onlyActiveRoom {
    if (sp.current > _damage) {
      sp.current -= _damage;
    } else {
      sp.current = 0;
    }
  }

  function increaseShield(uint16 _value) external onlyActiveRoom {
    if (sp.current + _value > sp.max) {
      sp.current = sp.max;
    } else {
      sp.current += _value;
    }
  }

  function setGold(uint32 _gold) external onlyGame {
    gold = _gold;
  }

  function setHighestCompletedRoomLevel(uint16 _highestCompletedRoomLevel) external onlyGame {
    highestCompletedRoomLevel = _highestCompletedRoomLevel;
  }

  function addInventoryItem(ItemKey memory _item) external onlyGame {
    for (uint256 i = 0; i < inventory.length; i++) {
      if (inventory[i].materialType == MaterialType.None) {
        inventory[i] = _item;
        return;
      }
    }
  }

  function removeInventoryItem(uint256 _index) external onlyGame {
    require(_index < inventory.length, "Index out of bounds");
    inventory[_index] = inventory[inventory.length - 1];
    inventory[inventory.length - 1] = ItemKey(ItemType.Helmet, MaterialType.None);
  }
}
