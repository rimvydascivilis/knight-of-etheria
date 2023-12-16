import React from 'react';
import { ethers, parseEther } from 'ethers';
import constants from '../utils/constants.js';

export default function CreatePlayer({provider, setPlayerAddress}) {
  const createPlayer = async () => {
    const fetchPlayerAddress = async () => {
      const signer = await provider.getSigner();
      const gameContract = new ethers.Contract(constants.gameContract.address, constants.gameContract.abi, signer);
      let player = await gameContract.getCharacterAddress();
      player = player.toString();
      setPlayerAddress(player);
    }
    const signer = await provider.getSigner();
    const gameContract = new ethers.Contract(constants.gameContract.address, constants.gameContract.abi, signer);
    const transaction = await gameContract.createCharacter({ value: parseEther('0.1') });
    await transaction.wait().then(() => {
      fetchPlayerAddress();
    });
  };

  return (
    <>
      <h1>Create Player</h1>
      <button onClick={createPlayer}>Create Player 0.1 Eth</button>
    </>
  );
}
