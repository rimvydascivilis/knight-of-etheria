// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import { CombatPower } from "./CombatPower.sol";

enum ItemType { Helmet, Armor, Weapon, Boots }
enum MaterialType { None, Wood, Iron, Steel, Diamond }

struct Item {
  ItemType itemType;
  MaterialType materialType;
  CombatPower power;
  uint16 price;
}

struct ItemKey {
  ItemType itemType;
  MaterialType materialType;
}

contract Items {
  mapping(ItemType => mapping(MaterialType => Item)) private items;

  modifier isValidItemKey(ItemKey memory key) {
    require(key.itemType >= ItemType.Helmet && key.itemType <= ItemType.Boots, "Invalid item type");
    require(key.materialType >= MaterialType.None && key.materialType <= MaterialType.Diamond, "Invalid material type");
    _;
  }

  constructor() {
    initializeItem(ItemType.Helmet, MaterialType.Wood, 10, 0, 1);
    initializeItem(ItemType.Helmet, MaterialType.Iron, 20, 0, 2);
    initializeItem(ItemType.Helmet, MaterialType.Steel, 30, 0, 3);
    initializeItem(ItemType.Helmet, MaterialType.Diamond, 40, 0, 4);

    initializeItem(ItemType.Armor, MaterialType.None, 0, 0, 0);
    initializeItem(ItemType.Armor, MaterialType.Wood, 10, 0, 1);
    initializeItem(ItemType.Armor, MaterialType.Iron, 20, 0, 2);
    initializeItem(ItemType.Armor, MaterialType.Steel, 30, 0, 3);
    initializeItem(ItemType.Armor, MaterialType.Diamond, 40, 0, 4);

    initializeItem(ItemType.Weapon, MaterialType.None, 0, 0, 0);
    initializeItem(ItemType.Weapon, MaterialType.Wood, 10, 1, 0);
    initializeItem(ItemType.Weapon, MaterialType.Iron, 20, 2, 0);
    initializeItem(ItemType.Weapon, MaterialType.Steel, 30, 3, 0);
    initializeItem(ItemType.Weapon, MaterialType.Diamond, 40, 4, 0);

    initializeItem(ItemType.Boots, MaterialType.None, 0, 0, 0);
    initializeItem(ItemType.Boots, MaterialType.Wood, 10, 0, 1);
    initializeItem(ItemType.Boots, MaterialType.Iron, 20, 0, 2);
    initializeItem(ItemType.Boots, MaterialType.Steel, 30, 0, 3);
    initializeItem(ItemType.Boots, MaterialType.Diamond, 40, 0, 4);
  }

  function getItem(ItemKey memory key) public view isValidItemKey(key) returns (Item memory) {
    return items[key.itemType][key.materialType];
  }

  function getItemPrice(ItemKey memory key) public view isValidItemKey(key) returns (uint16) {
    return items[key.itemType][key.materialType].price;
  }

  function getItemPower(ItemKey memory key) public view isValidItemKey(key) returns (CombatPower memory) {
    return items[key.itemType][key.materialType].power;
  }

  function initializeItem(ItemType itemType, MaterialType materialType,
  uint16 price, uint16 attack, uint16 defense) private {
    items[itemType][materialType] = Item(itemType, materialType, CombatPower(attack, defense), price);
  }
}
