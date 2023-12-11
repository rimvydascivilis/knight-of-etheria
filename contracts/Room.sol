// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import { Player } from "./Player.sol";
import { Enemy } from "./Enemy.sol";

contract Room {
  Enemy[] public enemies;
  uint16 public level;
  uint16 public reward;
  Player public player;

  modifier onlyPlayer() {
    require(msg.sender == address(player), "Only player can call this function");
    _;
  }

  modifier validEnemyIndex(uint256 _index) {
    require(_index < enemies.length, "Index out of bounds");
    _;
  }

  constructor(uint16 _level, uint16 _reward, Player _player, Enemy[] memory _enemies) {
    level = _level;
    reward = _reward;
    player = _player;
    for (uint256 i = 0; i < _enemies.length; i++) {
      addEnemy(_enemies[i]);
    }
  }

  function addEnemy(Enemy _enemy) private {
    enemies.push(_enemy);
  }

  function removeEnemy(uint256 _index) private validEnemyIndex(_index) {
    enemies[_index] = enemies[enemies.length - 1];
    enemies.pop();
  }

  function getEnemy(uint256 _index) public view validEnemyIndex(_index) returns (Enemy) {
    require(_index < enemies.length, "Index out of bounds");
    return enemies[_index];
  }

  function getEnemiesCount() public view returns (uint256) {
    return enemies.length;
  }

  function standartAttackEnemy(uint256 _index) external validEnemyIndex(_index) {
    Enemy enemy = getEnemy(_index);
    uint16 damage = player.standartAttackDamage();
    (uint16 hpDamage, uint16 spDamage) = enemy.getDamage(damage);
    enemy.decreaseHealth(hpDamage);
    enemy.decreaseShield(spDamage);
    if (enemy.isDead()) {
      player.addGold(enemy.goldReward());
      player.addXp(enemy.xpReward());
      removeEnemy(_index);
    } else {
      enemyMove(_index);
    }
  }

  // TODO: implement special attack, shield up, and enemy move

  function enemyMove(uint256 _index) private validEnemyIndex(_index) {
    // pick random move and execute it
  }
}
