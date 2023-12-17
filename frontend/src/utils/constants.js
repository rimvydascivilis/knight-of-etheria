import {abi as gameContractAbi} from '../artifacts/contracts/Game.sol/Game.json';
import {abi as playerContractAbi} from '../artifacts/contracts/Player.sol/Player.json';

const constants = {
  addressZero: '0x0000000000000000000000000000000000000000',
  gameContract: {
    address: '0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9',
    abi: gameContractAbi,
  },
  playerContract: {
    abi: playerContractAbi,
  },
};

export default constants;
