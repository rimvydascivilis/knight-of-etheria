// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import { Player } from "./Player.sol";
import { Enemy } from "./Enemy.sol";
import { Moves } from "./Character.sol";

contract Room {
  address public immutable game;
  Enemy[] public enemies;
  uint16 public level;
  uint32 public goldReward;
  uint32 public xpReward;
  Player public player;

  modifier onlyPlayer() {
    require(msg.sender == address(player), "Only player can call this function");
    _;
  }

  modifier onlyGame() {
    require(msg.sender == game, "Only game can call this function");
    _;
  }

  modifier validEnemyIndex(uint256 _index) {
    require(_index < enemies.length, "Index out of bounds");
    _;
  }

  modifier aliveEnemy(uint256 _index) {
    require(!enemies[_index].isDead(), "Enemy is dead");
    _;
  }

  constructor(uint16 _level, uint32 _xpReward, uint32 _goldReward , Player _player, Enemy[] memory _enemies) {
    game = msg.sender; // assuming that game contract creates rooms
    level = _level;
    xpReward = _xpReward;
    goldReward = _goldReward;
    player = _player;
    for (uint256 i = 0; i < _enemies.length; i++) {
      addEnemy(_enemies[i]);
    }
  }

  function isCompleted() public view returns (bool) {
    return enemies.length == 0;
  }

  function getEnemy(uint256 _index) public view validEnemyIndex(_index) returns (Enemy) {
    require(_index < enemies.length, "Index out of bounds");
    return enemies[_index];
  }

  function getEnemiesCount() public view returns (uint256) {
    return enemies.length;
  }

  function standartAttackEnemy(uint256 _index) external onlyPlayer validEnemyIndex(_index) aliveEnemy(_index) {
    Enemy enemy = getEnemy(_index);
    uint16 damage = player.standartAttackDamage();
    (uint16 hpDamage, uint16 spDamage) = enemy.getDamage(damage);
    enemy.decreaseHealth(hpDamage);
    enemy.decreaseShield(spDamage);
    if (enemy.isDead()) {
      player.addGold(enemy.goldReward());
      player.addXp(enemy.xpReward());
    } else {
      enemyMove(_index);
    }
  }

  function specialAttackEnemy(uint256 _index) external onlyPlayer validEnemyIndex(_index) aliveEnemy(_index) {
    Enemy enemy = getEnemy(_index);
    uint16 damage = player.specialAttackDamage();
    (uint16 hpDamage, uint16 spDamage) = enemy.getDamage(damage);
    enemy.decreaseHealth(hpDamage);
    enemy.decreaseShield(spDamage);
    if (enemy.isDead()) {
      player.addGold(enemy.goldReward());
      player.addXp(enemy.xpReward());
    } else {
      enemyMove(_index);
    }
  }

  function shieldUp() external onlyPlayer {
    uint16 value = player.shieldUpValue();
    player.increaseShield(value);
    enemyMove(0);
  }

  function reset() external onlyPlayer {
    for (uint256 i = 0; i < enemies.length; i++) {
      enemies[i].reset();
    }
    player.reset();
  }

  function enemyMove(uint256 _index) private validEnemyIndex(_index) {
    Enemy enemy = getEnemy(_index);
    Moves randomMove = Moves(_random(0, 2));

    if (randomMove == Moves.StandartAttack) {
      uint16 damage = enemy.standartAttackDamage();
      (uint16 hpDamage, uint16 spDamage) = player.getDamage(damage);
      player.decreaseHealth(hpDamage);
      player.decreaseShield(spDamage);
    } else if (randomMove == Moves.SpecialAttack) {
      uint16 damage = enemy.specialAttackDamage();
      (uint16 hpDamage, uint16 spDamage) = player.getDamage(damage);
      player.decreaseHealth(hpDamage);
      player.decreaseShield(spDamage);
    } else if (randomMove == Moves.ShieldUp) {
      uint16 value = enemy.shieldUpValue();
      enemy.increaseShield(value);
    } else {
      revert("Invalid move");
    }
  }

  function addEnemy(Enemy _enemy) private {
    enemies.push(_enemy);
  }

  function _random(uint16 min, uint16 max) private view returns (uint16) {
    return uint16(uint256(keccak256(abi.encodePacked(block.timestamp, block.gaslimit))) % (max - min + 1) + min);
  }
}
