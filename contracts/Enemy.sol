// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Character, Equipment } from "./Character.sol";

contract Enemy is Character {
  uint16 constant private ATTACK_DAMAGE_REDUCTION = 30;

  constructor(uint8 _level, address _items, Equipment memory _equippedItems) Character(_level, _items, _equippedItems) {}

  function standartAttackDamage() public view returns (uint16) {
    return _standartAttackDamage() * (100 - ATTACK_DAMAGE_REDUCTION) / 100;
  }

  function specialAttackDamage() public view returns (uint16) {
    return _specialAttackDamage() * (100 - ATTACK_DAMAGE_REDUCTION) / 100;
  }

  function shieldUpValue() public view returns (uint16) {
    return _shieldUpValue() * (100 - ATTACK_DAMAGE_REDUCTION) / 100;
  }
}
