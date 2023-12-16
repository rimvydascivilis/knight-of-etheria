// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import { VitalityPower } from "./VitalityPower.sol";
import { CombatPower } from "./CombatPower.sol";
import { ItemKey, Items } from "./Items.sol";

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

contract Character {
  Items public immutable items;
  Equipment public equippedItems;
  uint8 public level;
  uint32 public xp;
  VitalityPower public hp;
  VitalityPower public sp;
  CombatPower public cp;

  uint8 public constant MAX_LEVEL = 5;
  uint16[MAX_LEVEL] public xpLevels = [0, 100, 250, 500, 1000];
  uint16[MAX_LEVEL] public baseHpLevels = [100, 150, 200, 250, 300];
  uint16[MAX_LEVEL] public baseSpLevels = [40, 60, 80, 100, 120];
  uint16[MAX_LEVEL] public baseAttackLevels = [10, 15, 20, 25, 30];
  uint16[MAX_LEVEL] public baseDefenseLevels = [10, 15, 20, 25, 30];

  constructor(uint8 _level, address _items, Equipment memory _equippedItems) {
    items = Items(_items);
    level = _level;
    xp = 0;
    equippedItems = _equippedItems;
    _updateStats();
  }

  function getStats() external view
  returns (uint8, uint32, VitalityPower memory, VitalityPower memory, CombatPower memory) {
    return (level, xp, hp, sp, cp);
  }

  function getDamage(uint16 _damage) public view returns (uint16, uint16) {
    uint16 hpDamage = 0;
    uint16 spDamage = 0;
    if (sp.current > 0) {
      if (_damage > sp.current) {
        hpDamage = _damage - sp.current;
        spDamage = sp.current;
      } else {
        spDamage = _damage;
      }
    } else {
      hpDamage = _damage;
    }
    return (hpDamage, spDamage);
  }

  function _standartAttackDamage() internal view returns (uint16) {
    return cp.attack;
  }

  function _specialAttackDamage() internal view returns (uint16) {
    return cp.attack * _random(0, 2); // 0 to 2 times attack
  }

  function _shieldUpValue() internal view returns (uint16) {
    uint16 value = _random(3, 10);
    return sp.max / value; // 10% to 33%
  }

  function _random(uint16 min, uint16 max) internal view returns (uint16) {
    return uint16(uint256(keccak256(abi.encodePacked(block.timestamp, block.gaslimit))) % (max - min + 1) + min);
  }

  function levelUp() external {
    require(level < MAX_LEVEL, "Max level reached");
    require(xp >= xpLevels[level], "Not enough XP to level up");
    xp -= xpLevels[level];
    level++;
    _updateStats();
  }

  function _addXp(uint32 _xp) internal {
    xp += _xp;
  }

  function _updateStats() internal {
    uint16 baseHp = baseHpLevels[level];
    uint16 baseSp = baseSpLevels[level];
    uint16 baseAttack = baseAttackLevels[level];
    uint16 baseDefense = baseDefenseLevels[level];
    hp = VitalityPower(baseHp, baseHp);
    sp = VitalityPower(baseSp, baseSp);
    cp = _calculateCP(baseAttack, baseDefense);
  }

  function _calculateCP(uint16 baseAttack, uint16 baseDefense) private view returns (CombatPower memory) {
    CombatPower memory totalCP = CombatPower(baseAttack, baseDefense);
    totalCP.attack += items.getItemPower(equippedItems.helmet).attack;
    totalCP.defense += items.getItemPower(equippedItems.helmet).defense;
    totalCP.attack += items.getItemPower(equippedItems.armor).attack;
    totalCP.defense += items.getItemPower(equippedItems.armor).defense;
    totalCP.attack += items.getItemPower(equippedItems.weapon).attack;
    totalCP.defense += items.getItemPower(equippedItems.weapon).defense;
    totalCP.attack += items.getItemPower(equippedItems.boots).attack;
    totalCP.defense += items.getItemPower(equippedItems.boots).defense;
    return totalCP;
  }
}
