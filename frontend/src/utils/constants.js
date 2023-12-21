import {abi as gameContractAbi} from '../artifacts/contracts/Game.sol/Game.json';
import {abi as playerContractAbi} from '../artifacts/contracts/Player.sol/Player.json';
import {abi as itemsContractAbi} from '../artifacts/contracts/Items.sol/Items.json';

const constants = {
  addressZero: '0x0000000000000000000000000000000000000000',
  gameContract: {
    address: '0x0000000000000000000000000000000000000000',
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
