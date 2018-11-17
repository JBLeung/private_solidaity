/* global web3 artifacts contract beforeEach describe it assert */

const StarNotary = artifacts.require('StarNotary')

contract('StarNotary', (accounts) => {
  beforeEach(async function() {
    this.contract = await StarNotary.new({from: accounts[0]})
  })

  describe('createStar', () => {

    const name = "Star power 103!"
    const story = "I love my wonderful star"
    const cent = "ra_032.155"
    const dec = "dec_121.874"
    const mag = "mag_245.978"

    it('first star index is 1', async function () {
      assert.equal((await this.contract.nextStarIndex()).toNumber(), 1)
    })

    it('star is not exist', async function () {
      // check star is not exist
      assert.equal(await this.contract.checkIfStarExist(await this.contract.getCoordinatorsHash(cent, dec, mag)), false)
    })

    describe('create a star and check the star', async function () {
      it('create star', async function () {
        // create a star
        const starId = (await this.contract.nextStarIndex()).toNumber()
        await this.contract.createStar(name, story, cent, dec, mag, {from: accounts[0]})
        assert.equal(await this.contract.checkIfStarExist(await this.contract.getCoordinatorsHash(cent, dec, mag)), true)
      })
      describe('verify the star after create', ()=>{
        beforeEach(async function() {
          await this.contract.createStar(name, story, cent, dec, mag, {from: accounts[0]})
        })

        it('double check star create as expect', async function () {
          assert.equal(await this.contract.tokenIdToStarInfo((await this.contract.nextStarIndex()).toNumber() - 1), [name, story, cent, dec, mag, true].toString())
        })

        it('the next star index is auto increment to 2', async function () {
          assert.equal((await this.contract.nextStarIndex()).toNumber(), 2)
        })
      })
    })
  })

  describe('buying and selling stars', () => {
    const user1 = accounts[1]
    const user2 = accounts[2]

    let starId
    const starPrice = web3.toWei(0.01, 'ether')

    const name = "Star power 103!"
    const story = "I love my wonderful star"
    const cent = "ra_032.155"
    const dec = "dec_121.874"
    const mag = "mag_245.978"

    beforeEach(async function () {
      starId = starId = (await this.contract.nextStarIndex()).toNumber()
      await this.contract.createStar(name, story, cent, dec, mag, {from: user1})
    })

    it('user1 can put up their star for sale', async function () {
      assert.equal(await this.contract.ownerOf(starId), user1)
      await this.contract.putStarUpForSale(starId, starPrice, {from: user1})

      assert.equal(await this.contract.starsForSale(starId), starPrice)
    })

    describe('user2 can buy a star that was put up for sale', () => {
      beforeEach(async function () {
        await this.contract.putStarUpForSale(starId, starPrice, {from: user1})
      })

      it('user2 is the owner of the star after they buy it', async function() {
        await this.contract.buyStar(starId, {from: user2, value: starPrice, gasPrice: 0})
        assert.equal(await this.contract.ownerOf(starId), user2)
      })

      it('user2 ether balance changed correctly', async function () {
        const overpaidAmount = web3.toWei(0.05, 'ether')
        const balanceBeforeTransaction = web3.eth.getBalance(user2)
        await this.contract.buyStar(starId, {from: user2, value: overpaidAmount, gasPrice: 0})
        const balanceAfterTransaction = web3.eth.getBalance(user2)

        assert.equal(balanceBeforeTransaction.sub(balanceAfterTransaction), starPrice)
      })
    })
  })
})
