import {abi as gameContractAbi} from '../artifacts/contracts/Game.sol/Game.json';
import {abi as playerContractAbi} from '../artifacts/contracts/Player.sol/Player.json';
import {abi as itemsContractAbi} from '../artifacts/contracts/Items.sol/Items.json';

const constants = {
  addressZero: '0x0000000000000000000000000000000000000000',
  gameContract: {
    address: '0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0',
    abi: gameContractAbi,
  },
  playerContract: {
    abi: playerContractAbi,
  },
  itemsContract: {
    abi: itemsContractAbi,
  }
};

export default constants;
