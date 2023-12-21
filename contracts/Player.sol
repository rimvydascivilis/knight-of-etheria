// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import { Character } from "./Character.sol";
import { main } from "./Library.sol";

contract Player is Character {
  using main for main.ItemKey;
  using main for main.ItemType;
  using main for main.MaterialType;
  using main for main.Equipment;

  address private immutable player;
  address public activeRoom;
  address private immutable game;
  uint16 public highestCompletedRoomLevel = 0;
  main.ItemKey[20] public inventory;
  uint32 public gold;

  function _onlyPlayer() private view {
    require(msg.sender == player, "Only player can call this function");
  }

  modifier onlyPlayer() {
    _onlyPlayer();
    _;
  }

  function _onlyGame() private view {
    require(msg.sender == game, "Only game can call this function");
  }

  modifier onlyGame() {
    _onlyGame();
    _;
  }

  // function _onlyActiveRoom() private view {
  //   require(msg.sender == activeRoom, "Only active room can call this function");
  // }

  // modifier onlyActiveRoom() {
  //   _onlyActiveRoom();
  //   _;
  // }

  constructor(uint8 _level, address _items, main.Equipment memory _equippedItems)
  Character(_level, _items, _equippedItems) {
    player = tx.origin; // assume that tx.origin is the player
    game = msg.sender; // assume that msg.sender is the game contract
  }

  // function standartAttackDamage() public view returns (uint16) {
  //   return _standartAttackDamage();
  // }

  // function specialAttackDamage() public view returns (uint16) {
  //   return _specialAttackDamage();
  // }

  // function shieldUpValue() public view returns (uint16) {
  //   return _shieldUpValue();
  // }

  function getItemsAddress() public view returns (address) {
    return address(items);
  }

  function equipItem(uint256 _index) public onlyPlayer {
    require(activeRoom == address(0), "Player is already in a room");
    require(_index < inventory.length, "Index out of bounds");
    main.ItemKey memory item = inventory[_index];
    require(item.materialType != main.MaterialType.None, "Item is not valid");

    if (item.itemType == main.ItemType.Helmet) {
      _addInventoryItem(equippedItems.helmet);
      equippedItems.helmet = main.ItemKey(item.itemType, item.materialType);
    } else if (item.itemType == main.ItemType.Armor) {
      _addInventoryItem(equippedItems.armor);
      equippedItems.armor = main.ItemKey(item.itemType, item.materialType);
    } else if (item.itemType == main.ItemType.Boots) {
      _addInventoryItem(equippedItems.boots);
      equippedItems.boots = main.ItemKey(item.itemType, item.materialType);
    } else if (item.itemType == main.ItemType.Weapon) {
      _addInventoryItem(equippedItems.weapon);
      equippedItems.weapon = main.ItemKey(item.itemType, item.materialType);
    }

    _removeInventoryItem(_index);
    _updateStats();
  }

  function unequipItem(main.ItemType _itemType) public onlyPlayer {
    require(activeRoom == address(0), "Player is already in a room");
  
    if (_itemType == main.ItemType.Helmet) {
      if (equippedItems.helmet.materialType != main.MaterialType.None) {
        _addInventoryItem(equippedItems.helmet);
        equippedItems.helmet = main.ItemKey(main.ItemType.Helmet, main.MaterialType.None);
      }
    } else if (_itemType == main.ItemType.Armor) {
      if (equippedItems.armor.materialType != main.MaterialType.None) {
        _addInventoryItem(equippedItems.armor);
        equippedItems.armor = main.ItemKey(main.ItemType.Armor, main.MaterialType.None);
      }
    } else if (_itemType == main.ItemType.Boots) {
      if (equippedItems.boots.materialType != main.MaterialType.None) {
        _addInventoryItem(equippedItems.boots);
        equippedItems.boots = main.ItemKey(main.ItemType.Boots, main.MaterialType.None);
      }
    } else if (_itemType == main.ItemType.Weapon) {
      if (equippedItems.weapon.materialType != main.MaterialType.None) {
        _addInventoryItem(equippedItems.weapon);
        equippedItems.weapon = main.ItemKey(main.ItemType.Weapon, main.MaterialType.None);
      }
    }

    _updateStats();
  }

  function _addInventoryItem(main.ItemKey memory _item) private {
    for (uint256 i = 0; i < inventory.length; i++) {
      if (inventory[i].materialType == main.MaterialType.None) {
        inventory[i] = main.ItemKey(_item.itemType, _item.materialType);
        return;
      }
    }
  }

  function _removeInventoryItem(uint256 _index) private {
    require(_index < inventory.length, "Index out of bounds");
    uint256 lastIndex = 0;
    for (uint256 i = 0; i < inventory.length; i++) {
      if (inventory[i].materialType == main.MaterialType.None) {
        lastIndex = i;
      }
    }

    inventory[_index] = inventory[lastIndex];
    inventory[lastIndex] = main.ItemKey(main.ItemType.Helmet, main.MaterialType.None);
  }

  // function addXp(uint32 _xp) external onlyActiveRoom {
  //   _addXp(_xp);
  // }

  // function addGold(uint32 _gold) external onlyActiveRoom {
  //   gold += _gold;
  // }

  // function decreaseHealth(uint16 _damage) external onlyActiveRoom {
  //   if (hp.current > _damage) {
  //     hp.current -= _damage;
  //   } else {
  //     hp.current = 0;
  //   }
  // }

  // function decreaseShield(uint16 _damage) external onlyActiveRoom {
  //   if (sp.current > _damage) {
  //     sp.current -= _damage;
  //   } else {
  //     sp.current = 0;
  //   }
  // }

  // function increaseShield(uint16 _value) external onlyActiveRoom {
  //   if (sp.current + _value > sp.max) {
  //     sp.current = sp.max;
  //   } else {
  //     sp.current += _value;
  //   }
  // }

  function setGold(uint32 _gold) external onlyGame {
    gold = _gold;
  }

  // function setHighestCompletedRoomLevel(uint16 _highestCompletedRoomLevel) external onlyGame {
  //   highestCompletedRoomLevel = _highestCompletedRoomLevel;
  // }

  function addInventoryItem(main.ItemKey memory _item) external onlyGame {
    _addInventoryItem(_item);
  }

  function removeInventoryItem(uint256 _index) external onlyGame {
    _removeInventoryItem(_index);
  }
}
