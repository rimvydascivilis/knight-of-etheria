// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import { Player } from "./Player.sol";
import { Equipment } from "./Character.sol";
import { Items, ItemKey, MaterialType, ItemType } from "./Items.sol";

contract Game {
  address public owner;
  Items public items;
  mapping(address => Player) public players;

  uint16 public constant MAX_ROOMS = 5;

  event CharacterCreated(address indexed player);

  modifier validRoomLevel(uint16 _roomLevel) {
    require(_roomLevel > 0 && _roomLevel <= MAX_ROOMS, "Invalid room level");
    _;
  }

  constructor() {
    owner = msg.sender;
    items = new Items();
  }

  function createCharacter() public payable {
    require(msg.value == 0.1 ether, "Character creation cost is 0.1 ether");
    require(address(players[msg.sender]) == address(0), "Player already has a character");
    Equipment memory equippedItems = Equipment(
      ItemKey(ItemType.Helmet, MaterialType.Wood),
      ItemKey(ItemType.Armor, MaterialType.Wood),
      ItemKey(ItemType.Weapon, MaterialType.Wood),
      ItemKey(ItemType.Boots, MaterialType.Wood)
    );
    players[msg.sender] = new Player(0, address(items), equippedItems);
    emit CharacterCreated(msg.sender);
  }

  // TODO: implement room creation and item shop
}
