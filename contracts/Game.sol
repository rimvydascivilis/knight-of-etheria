// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import { Player } from "./Player.sol";
import { Items } from "./Items.sol";
import { main } from "./Library.sol";

contract Game {
  using main for main.ItemKey;
  using main for main.ItemType;
  using main for main.MaterialType;

  address private owner;
  Items public items;
  mapping(address => Player) private players;
  uint16 private constant MAX_ROOMS = 5;

  function _validRoomLevel(uint16 _roomLevel) private pure {
    require(_roomLevel > 0 && _roomLevel <= MAX_ROOMS, "Invalid room level");
  }

  modifier validRoomLevel(uint16 _roomLevel) {
    _validRoomLevel(_roomLevel);
    _;
  }

  constructor() {
    owner = msg.sender;
    items = new Items();
  }

  function getCharacterAddress() public view returns (address) {
    return address(players[msg.sender]);
  }

  function createCharacter() public payable {
    require(msg.value == 0.1 ether, "Character creation cost is 0.1 ether");
    require(address(players[msg.sender]) == address(0), "Player already has a character");
    main.Equipment memory equippedItems = main.Equipment(
      main.ItemKey(main.ItemType.Helmet, main.MaterialType.Wood),
      main.ItemKey(main.ItemType.Armor, main.MaterialType.Wood),
      main.ItemKey(main.ItemType.Weapon, main.MaterialType.Wood),
      main.ItemKey(main.ItemType.Boots, main.MaterialType.Wood)
    );
    players[msg.sender] = new Player(0, address(items), equippedItems);
  }

  function buyGold() public payable {
    require(msg.value == 0.01 ether, "100 gold cost 0.01 ether");
    require(address(players[msg.sender]) != address(0), "Player does not have a character");
    Player player = players[msg.sender];
    player.setGold(player.gold() + 100);
  }

  function buyItem(main.ItemType _itemType, main.MaterialType _materialType) public payable {
    require(address(players[msg.sender]) != address(0), "Player does not have a character");
    main.ItemKey memory key = main.ItemKey(_itemType, _materialType);
    Player player = players[msg.sender];
    uint16 price = items.getItemPrice(key);
    require(player.gold() >= price, "Not enough gold");
    player.setGold(player.gold() - price);
    player.addInventoryItem(key);
  }

  function sellItem(uint256 _index) public payable {
    require(address(players[msg.sender]) != address(0), "Player does not have a character");
    Player player = players[msg.sender];
    main.ItemType itemType;
    main.MaterialType materialType;
    (itemType, materialType) = player.inventory(_index);
    main.ItemKey memory key = main.ItemKey(itemType, materialType);
    uint16 price = items.getItemPrice(key);
    player.setGold(player.gold() + price);
    player.removeInventoryItem(_index);
  }
}
