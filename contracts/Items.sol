// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import { main } from "./Library.sol";

contract Items {
  using main for main.ItemKey;
  using main for main.ItemType;
  using main for main.MaterialType;
  using main for main.Item;
  using main for main.CombatPower;

  mapping(main.ItemType => mapping(main.MaterialType => main.Item)) private items;

  function _isValidItemKey(main.ItemKey memory key) private pure {
    require(key.itemType >= main.ItemType.Helmet && key.itemType <= main.ItemType.Boots, "Invalid item type");
    require(key.materialType >= main.MaterialType.None && key.materialType <= main.MaterialType.Diamond,
    "Invalid material type");
  }

  modifier isValidItemKey(main.ItemKey memory key) {
    _isValidItemKey(key);
    _;
  }

  constructor() {
    initializeItem(main.ItemType.Helmet, main.MaterialType.Wood, 10, 0, 1);
    initializeItem(main.ItemType.Helmet, main.MaterialType.Iron, 20, 0, 2);
    initializeItem(main.ItemType.Helmet, main.MaterialType.Steel, 30, 0, 3);
    initializeItem(main.ItemType.Helmet, main.MaterialType.Diamond, 40, 0, 4);

    initializeItem(main.ItemType.Armor, main.MaterialType.None, 0, 0, 0);
    initializeItem(main.ItemType.Armor, main.MaterialType.Wood, 10, 0, 1);
    initializeItem(main.ItemType.Armor, main.MaterialType.Iron, 20, 0, 2);
    initializeItem(main.ItemType.Armor, main.MaterialType.Steel, 30, 0, 3);
    initializeItem(main.ItemType.Armor, main.MaterialType.Diamond, 40, 0, 4);

    initializeItem(main.ItemType.Weapon, main.MaterialType.None, 0, 0, 0);
    initializeItem(main.ItemType.Weapon, main.MaterialType.Wood, 10, 1, 0);
    initializeItem(main.ItemType.Weapon, main.MaterialType.Iron, 20, 2, 0);
    initializeItem(main.ItemType.Weapon, main.MaterialType.Steel, 30, 3, 0);
    initializeItem(main.ItemType.Weapon, main.MaterialType.Diamond, 40, 4, 0);

    initializeItem(main.ItemType.Boots, main.MaterialType.None, 0, 0, 0);
    initializeItem(main.ItemType.Boots, main.MaterialType.Wood, 10, 0, 1);
    initializeItem(main.ItemType.Boots, main.MaterialType.Iron, 20, 0, 2);
    initializeItem(main.ItemType.Boots, main.MaterialType.Steel, 30, 0, 3);
    initializeItem(main.ItemType.Boots, main.MaterialType.Diamond, 40, 0, 4);
  }

  function getItem(main.ItemKey memory key) public view isValidItemKey(key) returns (main.Item memory) {
    return items[key.itemType][key.materialType];
  }

  function getItemPrice(main.ItemKey memory key) public view isValidItemKey(key) returns (uint16) {
    return items[key.itemType][key.materialType].price;
  }

  function getItemPower(main.ItemKey memory key) public view isValidItemKey(key) returns (main.CombatPower memory) {
    return items[key.itemType][key.materialType].power;
  }

  function initializeItem(main.ItemType itemType, main.MaterialType materialType,
  uint16 price, uint16 attack, uint16 defense) private {
    items[itemType][materialType] = main.Item(itemType, materialType, main.CombatPower(attack, defense), price);
  }
}
