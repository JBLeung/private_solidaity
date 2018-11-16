#Getting start
1. npm install
## command
### test
`npm run test`
### build
`npm run build`
### deploy
`npm run deploy`
### start http server
`npm run server`
### flattener contract
`npm run flattener`



# Deployed Smart contract
##### Contract Address: 
0xad6F6415B8BA017ABd0c25ff4816A5411c6b24D3
##### Contract Rinkeby EtherScan : 
https://rinkeby.etherscan.io/address/0xad6F6415B8BA017ABd0c25ff4816A5411c6b24D3
##### Transaction ID: 
0xb7e8c0ec24d2efe7b01a1044253f3a6b5dd2848ffa923e3da657962afdf6548b
##### Transaction Rinkeby EtherScan : 
https://rinkeby.etherscan.io/tx/0xb7e8c0ec24d2efe7b01a1044253f3a6b5dd2848ffa923e3da657962afdf6548b

# Contract ABI API
https://api.etherscan.io/api?module=contract&action=getabi&address=0xad6F6415B8BA017ABd0c25ff4816A5411c6b24D3&apikey=9db30a31447f41ea9c7b86d28f34e3bb


# smart contract deploy
## truffle guide line
### deploy smart contract to rinkeby
1. please make sure following config is correct.
   1. `truffle.js`
      1. update the `mnemonic` with your wallet secret
      1. update the `HDWalletProvider` endpoint. For example you can get one from infura.io.
## Remix guide
### steps
1. go to `https://remix.ethereum.org/`
1. create a `<name>.sol` file
1. under `compile` tag
   1. choose the compiler version (base on the contract `pragma solidity <version>`)
1. under `run` tag
   1. choose `environment`
   1. choose `contract`
   1. deploy
### after deploy
1. you can see the ABI in contract detail under `compile` tag 
1. you can get the contract address under `run` tag
      
# Make the web page work with the smart contract
## webpage config
1. please make sure following config is correct.
   1. `starNotaryContractAddress` should be the smart contract address
   1. `contractABI` the ABI of the smart contract, you can get it from the build folder after deploy/compile with truffle
   
