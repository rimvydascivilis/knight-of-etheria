const {
  loadFixture,
} = require('@nomicfoundation/hardhat-toolbox/network-helpers');
const {expect} = require('chai');
const {parseEther} = require('ethers');

const ADDRESS_ZERO = '0x0000000000000000000000000000000000000000';

describe('Game', function() {
  async function deployGameFixure() {
    const [owner, otherAccount] = await ethers.getSigners();

    const Game = await ethers.getContractFactory('Game');
    const game = await Game.deploy();

    return {game, owner, otherAccount};
  }

  describe('Deployment', function() {
    it('Game should have Items contract address', async function() {
      const {game} = await loadFixture(deployGameFixure);

      expect(await game.items()).to.not.equal(ADDRESS_ZERO);
    });

    it('Should set the right owner', async function() {
      const {game, owner} = await loadFixture(deployGameFixure);

      expect(await game.owner()).to.equal(owner.address);
    });
  });

  describe('Character', function() {
    describe('Creation', function() {
      it('Withouth ETH should be reverted', async function() {
        const {game} = await loadFixture(deployGameFixure);

        await expect(game.createCharacter({value: 0}))
            .to.be.revertedWith('Character creation cost is 0.1 ether');
      });

      it('With 0.1 ETH should be successful', async function() {
        const {game} = await loadFixture(deployGameFixure);

        await expect(game.createCharacter({value: parseEther('0.1')}))
            .to.emit(game, 'CharacterCreated');
      });

      it('Player should have a character', async function() {
        const {game, owner} = await loadFixture(deployGameFixure);

        await game.createCharacter({value: parseEther('0.1')});

        expect(await game.players(owner.address)).to.not.equal(ADDRESS_ZERO);
      });

      it('Player should not be able to create more than one character', async function() {
        const {game} = await loadFixture(deployGameFixure);

        await game.createCharacter({value: parseEther('0.1')});

        await expect(game.createCharacter({value: parseEther('0.1')}))
            .to.be.revertedWith('Player already has a character');
      });
    });
  });
});
