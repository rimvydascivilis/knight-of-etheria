import React, { useEffect, useState } from 'react';
import ConnectToMetaMask from '../components/ConnectMetaMask.jsx';
import CreatePlayer from '../components/CreatePlayer.jsx';
import NavBar from '../components/NavBar.jsx';
import { Outlet } from "react-router-dom";
import { ethers } from 'ethers';
import constants from '../utils/constants.js';

function Root() {
  const [playerAddress, setPlayerAddress] = useState(constants.addressZero);
  const [provider, setProvider] = useState(null);

  const fetchPlayerAddress = async () => {
    const signer = await provider.getSigner();
    const gameContract = new ethers.Contract(constants.gameContract.address, constants.gameContract.abi, signer);
    let player = (await gameContract.getCharacterAddress()).toString();
    setPlayerAddress(player);
  }

  useEffect(() => {
    const initializeProvider = async () => {
      if (window.ethereum) {
        await window.ethereum.request({ method: 'eth_requestAccounts' });
        const provider = new ethers.BrowserProvider(window.ethereum);
        setProvider(provider);
      }
    };
    initializeProvider()
  }, []);

  useEffect(() => {
    if (provider) {
      fetchPlayerAddress();
    }
  }, [provider]);

  if (!provider) {
    return (
      <>
        <NavBar />
        <div className='container d-flex justify-content-center align-items-center'>
          <ConnectToMetaMask />
        </div>
      </>
    );
  } else if (!playerAddress || playerAddress === constants.addressZero) {
    return (
      <>
        <NavBar />
        <div className='container d-flex justify-content-center align-items-center'>
          <CreatePlayer provider={provider} setPlayerAddress={setPlayerAddress} />
        </div>
      </>
    )
  }

  return (
    <>
      <NavBar />
      <div className='container d-flex justify-content-center align-items-center'>
        <Outlet context={[provider, playerAddress]} />
      </div>
    </>
  );
}

export default Root;
