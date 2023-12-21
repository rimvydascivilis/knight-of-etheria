import {abi as gameContractAbi} from '../artifacts/contracts/Game.sol/Game.json';
import {abi as playerContractAbi} from '../artifacts/contracts/Player.sol/Player.json';
import {abi as itemsContractAbi} from '../artifacts/contracts/Items.sol/Items.json';

const constants = {
  addressZero: '0x0000000000000000000000000000000000000000',
  gameContract: {
    address: '0x4aFB79417F6662b9A63332e2cA72dAC4C0796E9e',
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
