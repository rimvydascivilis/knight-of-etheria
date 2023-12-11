// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import { Character, Equipment } from "./Character.sol";

contract Enemy is Character {
  address public room;
  uint32 public goldReward;
  uint32 public xpReward;

  uint16 constant private ATTACK_DAMAGE_REDUCTION = 30;

  modifier onlyRoom() {
    require(msg.sender == address(room), "Only room can call this function");
    _;
  }

  constructor(uint8 _level, address _items, Equipment memory _equippedItems, uint32 _goldReward,
  uint32 _xpReward, address _room) Character(_level, _items, _equippedItems) {
    room = _room;
    xpReward = _xpReward;
    goldReward = _goldReward;
  }

  function decreaseHealth(uint16 _damage) external onlyRoom {
    hp.current -= _damage;
  }

  function decreaseShield(uint16 _damage) external onlyRoom {
    sp.current -= _damage;
  }

  function isDead() public view returns (bool) {
    return hp.current == 0;
  }

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
