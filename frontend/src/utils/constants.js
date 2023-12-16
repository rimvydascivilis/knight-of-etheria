import {abi as gameContractAbi} from '../artifacts/contracts/Game.sol/Game.json';
import {abi as playerContractAbi} from '../artifacts/contracts/Player.sol/Player.json';

const constants = {
  addressZero: '0x0000000000000000000000000000000000000000',
  gameContract: {
    address: '0x5FbDB2315678afecb367f032d93F642f64180aa3',
    abi: gameContractAbi,
  },
  playerContract: {
    abi: playerContractAbi,
  },
};

export default constants;
