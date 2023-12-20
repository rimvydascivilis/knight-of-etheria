// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

library main {
  enum ItemType { Helmet, Armor, Weapon, Boots }
  enum MaterialType { None, Wood, Iron, Steel, Diamond }

  struct VitalityPower {
    uint16 current;
    uint16 max;
  }

  struct CombatPower {
    uint16 attack;
    uint16 defense;
  }

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

  struct Equipment {
    ItemKey helmet;
    ItemKey armor;
    ItemKey weapon;
    ItemKey boots;
  }

  enum Moves {
    StandartAttack,
    SpecialAttack,
    ShieldUp
  }

  
  function random(uint16 min, uint16 max) internal view returns (uint16) {
    return uint16(uint256(keccak256(abi.encodePacked(block.timestamp, block.gaslimit))) % (max - min + 1) + min);
  }
}
