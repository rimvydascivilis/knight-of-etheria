import React, { useEffect, useState } from 'react';
import { ethers } from 'ethers';
import constants from '../../utils/constants';
import { useOutletContext } from 'react-router-dom';

function Wardrobe() {
  const itemMaterials = ['none', 'wood', 'iron', 'steel', 'diamond'];
  const [provider, playerAddress] = useOutletContext();

  const [inventoryItems, setInventoryItems] = useState([]);
  const [equippedItems, setEquippedItems] = useState({
    'helmet': 0,
    'armor': 0,
    'boots': 0,
    'weapon': 0,
  });
  const [playerStats, setPlayerStats] = useState({
    'level': 0,
    'xp': 0,
    'hp': {
      'current': 0,
      'max': 0
    },
    'shield': {
      'current': 0,
      'max': 0
    },
    'combat': {
      'damage': 0,
      'defense': 0
    }
  });

  const fetchPlayerStats = async () => {
    const signer = await provider.getSigner();
    const playerContract = new ethers.Contract(playerAddress, constants.playerContract.abi, signer);
    let stats = (await playerContract.getStats()).toString();
    const [level, xp, health, maxHealth, shield, maxShield, damage, defense] = stats.split(',');
    setPlayerStats({
      'level': level,
      'xp': xp,
      'hp': {
        'current': health,
        'max': maxHealth
      },
      'shield': {
        'current': shield,
        'max': maxShield
      },
      'combat': {
        'damage': damage,
        'defense': defense
      }
    })
  }

  const fetchEquippedItems = async () => {
    const signer = await provider.getSigner();
    const playerContract = new ethers.Contract(playerAddress, constants.playerContract.abi, signer);
    let items = (await playerContract.equippedItems()).toString().split(',');
    const [helmet, armor, boots, weapon] = [items[1], items[3], items[5], items[7]]
    setEquippedItems({
      'helmet': helmet,
      'armor': armor,
      'boots': boots,
      'weapon': weapon
    })
  }

  useEffect(() => {
    fetchPlayerStats();
    fetchEquippedItems();
  }, []);

  return (
    <>
      <div className="d-flex">
        <div className="ml-5">
          <img src={`character/${equippedItems.helmet}_${equippedItems.armor}_${equippedItems.boots}_${equippedItems.weapon}.png`} className="img-fluid" alt='character' />
        </div>

        <div className="ml-5">
          <div className="align-self-start">
            <h2>Player Stats</h2>
            <div>
              <div>Level: {playerStats.level}</div>
              <div>XP: {playerStats.xp}</div>
              <div>HP: {playerStats.hp.current}/{playerStats.hp.max}</div>
              <div>Shield: {playerStats.shield.current}/{playerStats.shield.max}</div>
              <div>Damage: {playerStats.combat.damage}</div>
              <div>Defense: {playerStats.combat.defense}</div>
            </div>
          </div>

          <div>
            <h2>Equipped Items</h2>
            <div className="d-flex">
              <div className="mr-3">
                <div>Helmet</div>
                <div>{itemMaterials[equippedItems.helmet]}</div>
              </div>
              {Object.keys(equippedItems).map(item => (
                <div key={item} className="mr-3">
                  <div>{item.charAt(0).toUpperCase() + item.slice(1)}</div>
                  <div>{itemMaterials[equippedItems[item]]}</div>
                </div>
              ))}
            </div>
          </div>
        </div>
        <div>
          <h2>Inventory Items</h2>
          <div className="d-flex flex-wrap">
            {inventoryItems.map(item => (
              <div key={item.id} className="mr-3 mb-3">
                <div>{item.name}</div>
                <div>Quantity: {item.quantity}</div>
                <button onClick={() => handleEquipItem(item)}>Equip</button>
              </div>
            ))}
          </div>
        </div>
      </div>
    </>
  );
}

export default Wardrobe;
