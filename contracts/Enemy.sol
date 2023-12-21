// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

// import { Character } from "./Character.sol";
// import { main } from "./Library.sol";

// contract Enemy is Character {
//   using main for main.Equipment;

//   address public room;
//   uint32 public goldReward;
//   uint32 public xpReward;

//   uint16 constant private ATTACK_DAMAGE_REDUCTION = 30;

//   function _onlyRoom() private view {
//     require(msg.sender == address(room), "Only room can call this function");
//   }

//   modifier onlyRoom() {
//     _onlyRoom();
//     _;
//   }

//   constructor(uint8 _level, address _items, main.Equipment memory _equippedItems, uint32 _goldReward,
//   uint32 _xpReward, address _room) Character(_level, _items, _equippedItems) {
//     room = _room;
//     xpReward = _xpReward;
//     goldReward = _goldReward;
//   }

//   function decreaseHealth(uint16 _damage) external onlyRoom {
//     if (hp.current > _damage) {
//       hp.current -= _damage;
//     } else {
//       hp.current = 0;
//     }
//   }

//   function decreaseShield(uint16 _damage) external onlyRoom {
//     if (sp.current > _damage) {
//       sp.current -= _damage;
//     } else {
//       sp.current = 0;
//     }
//   }

//   function increaseShield(uint16 _value) external onlyRoom {
//     if (sp.current + _value > sp.max) {
//       sp.current = sp.max;
//     } else {
//       sp.current += _value;
//     }
//   }

//   function isDead() public view returns (bool) {
//     return hp.current == 0;
//   }

//   function standartAttackDamage() public view returns (uint16) {
//     return _standartAttackDamage() * (100 - ATTACK_DAMAGE_REDUCTION) / 100;
//   }

//   function specialAttackDamage() public view returns (uint16) {
//     return _specialAttackDamage() * (100 - ATTACK_DAMAGE_REDUCTION) / 100;
//   }

//   function shieldUpValue() public view returns (uint16) {
//     return _shieldUpValue() * (100 - ATTACK_DAMAGE_REDUCTION) / 100;
//   }
// }
