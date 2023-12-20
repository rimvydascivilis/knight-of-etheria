import React, {useEffect, useState} from 'react';
import {ethers} from 'ethers';
import constants from '../../utils/constants';
import {useOutletContext} from 'react-router-dom';
import './Wardrobe.css';

function Wardrobe() {
  const itemMaterials = ['none', 'wood', 'iron', 'steel', 'diamond'];
  const itemTypes = ['helmet', 'armor', 'weapon', 'boots'];
  const [provider, playerAddress] = useOutletContext();

  const [inventoryItems, setInventoryItems] = useState(Array(20).fill({
    'type': 0,
    'material': 0,
  }));
  const [equippedItems, setEquippedItems] = useState({
    'helmet': 0,
    'armor': 0,
    'weapon': 0,
    'boots': 0,
  });
  const [CharacterStats, setCharacterStats] = useState({
    'level': 0,
    'xp': 0,
    'hp': {
      'current': 0,
      'max': 0,
    },
    'shield': {
      'current': 0,
      'max': 0,
    },
    'combat': {
      'damage': 0,
      'defense': 0,
    },
  });

  const fetchCharacterStats = async () => {
    const signer = await provider.getSigner();
    const playerContract = new ethers.Contract(playerAddress, constants.playerContract.abi, signer);
    const stats = (await playerContract.getStats()).toString();
    const [level, xp, health, maxHealth, shield, maxShield, damage, defense] = stats.split(',');
    setCharacterStats({
      'level': level,
      'xp': xp,
      'hp': {
        'current': health,
        'max': maxHealth,
      },
      'shield': {
        'current': shield,
        'max': maxShield,
      },
      'combat': {
        'damage': damage,
        'defense': defense,
      },
    });
  };

  const fetchEquippedItems = async () => {
    const signer = await provider.getSigner();
    const playerContract = new ethers.Contract(playerAddress, constants.playerContract.abi, signer);
    const items = (await playerContract.equippedItems()).toString().split(',');
    const [helmet, armor, boots, weapon] = [items[1], items[3], items[5], items[7]];
    setEquippedItems({
      'helmet': helmet,
      'armor': armor,
      'weapon': weapon,
      'boots': boots,
    });
  };

  const fetchInventoryItems = async () => {
    const signer = await provider.getSigner();
    const playerContract = new ethers.Contract(playerAddress, constants.playerContract.abi, signer);
    const items = Array(20);
    for (let i = 0; i < 20; i++) {
      const item = (await playerContract.inventory(i)).toString().split(',');
      items[i] = {
        'type': item[0],
        'material': item[1],
      };
    }
    setInventoryItems(items);
  };

  const equipItem = async (_idx) => {
    const signer = await provider.getSigner();
    const playerContract = new ethers.Contract(playerAddress, constants.playerContract.abi, signer);
    playerContract.equipItem(_idx);
  };

  const unequipItem = async (item, _idx) => {
    if (equippedItems[item] == 0) return;

    const signer = await provider.getSigner();
    const playerContract = new ethers.Contract(playerAddress, constants.playerContract.abi, signer);
    try {
      const tx = await playerContract.unequipItem(_idx);
      await tx.wait();
    } catch (err) {
      console.log(err);
    } finally {
      console.log('finally');
      fetchEquippedItems();
      fetchCharacterStats();
    }
  };

  const getCharacterImageSrc = () => {
    let src = 'character/';
    src += equippedItems.helmet + '_';
    src += equippedItems.armor + '_';
    src += equippedItems.boots + '_';
    src += equippedItems.weapon + '.png';
    return src;
  };

  const getItemImgSrc = (item) => {
    return `items/${itemTypes[item['type']]}/${item['material']}.png`;
  };

  useEffect(() => {
    fetchCharacterStats();
    fetchEquippedItems();
    fetchInventoryItems();
  }, []);

  return (
    <div className="d-flex column-gap-5">
      <div className="d-flex flex-column justify-content-between">
        <img src={getCharacterImageSrc()} className="img-fluid character" alt='character'/>
        <table className="table table-bordered align-self-end">
          <thead className="thead-dark text-center ">
            <tr>
              {Object.keys(equippedItems).map((item) => (
                <th className="text-capitalize" key={item}>{item}</th>
              ))}
            </tr>
          </thead>
          <tbody className="text-center">
            <tr>
              {Object.keys(equippedItems).map((item, idx) => (
                <td className="text-capitalize" key={idx}
                  onClick={() => unequipItem(item, idx)}>{itemMaterials[equippedItems[item]]}</td>
              ))}
            </tr>
          </tbody>
        </table>
      </div>

      <div className="d-flex flex-column justify-content-between">
        <div className="align-self-start stats">
          <h2>Player Stats</h2>
          <h3>Level: {CharacterStats.level}</h3>
          <h3>XP: {CharacterStats.xp}</h3>
          <h3>HP: {CharacterStats.hp.current}/{CharacterStats.hp.max}</h3>
          <h3>Shield: {CharacterStats.shield.current}/{CharacterStats.shield.max}</h3>
          <h3>Damage: {CharacterStats.combat.damage}</h3>
          <h3>Defense: {CharacterStats.combat.defense}</h3>
        </div>

        {inventoryItems[0]['type'] == 0 ? null : (
          <div className="align-self-end">
            <h2>Inventory Items</h2>
            <div className="inventory-items">
              {inventoryItems.map((item, idx) => {
                if (item['type'] == 0) return;
                return (
                  <div key={idx} className="inventory-item border border-dark">
                    <img src={getItemImgSrc(item)} alt="inventory item" onClick={() => equipItem(idx)}></img>
                  </div>
                );
              })}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

export default Wardrobe;
