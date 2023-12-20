import {abi as gameContractAbi} from '../artifacts/contracts/Game.sol/Game.json';
import {abi as playerContractAbi} from '../artifacts/contracts/Player.sol/Player.json';
import {abi as itemsContractAbi} from '../artifacts/contracts/Items.sol/Items.json';

const constants = {
  addressZero: '0x0000000000000000000000000000000000000000',
  gameContract: {
    address: '0x9A676e781A523b5d0C0e43731313A708CB607508',
    abi: gameContractAbi,
  },
  playerContract: {
    abi: playerContractAbi,
  },
  itemsContract: {
    abi: itemsContractAbi,
  },
};

export default constants;
