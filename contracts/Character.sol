// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { VitalityPower} from "./VitalityPower.sol";
import { CombatPower } from "./CombatPower.sol";
import { ItemKey, Items } from "./Items.sol";

struct Equipment {
  ItemKey helmet;
  ItemKey armor;
  ItemKey weapon;
  ItemKey boots;
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
    updateStats();
  }

  function standartAttackDamage() internal view returns (uint16) {
    return cp.attack;
  }

  function specialAttackDamage() internal view returns (uint16) {
    return cp.attack * random(0, 2); // 0 to 2 times attack
  }

  function shieldUpValue() internal view returns (uint16) {
    uint16 value = random(3, 10);
    return sp.max / value; // 10% to 33%
  }

  function random(uint16 min, uint16 max) internal view returns (uint16) {
    return uint16(uint256(keccak256(abi.encodePacked(block.timestamp, block.gaslimit))) % (max - min + 1) + min);
  }

  function updateStats() internal {
    uint16 baseHp = baseHpLevels[level];
    uint16 baseSp = baseSpLevels[level];
    uint16 baseAttack = baseAttackLevels[level];
    uint16 baseDefense = baseDefenseLevels[level];
    hp = VitalityPower(baseHp, baseHp);
    sp = VitalityPower(baseSp, baseSp);
    cp = calculateCP(baseAttack, baseDefense);
  }

  function calculateCP(uint16 baseAttack, uint16 baseDefense) internal view returns (CombatPower memory) {
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
