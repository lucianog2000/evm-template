# Instructions

1. Install packages with `yarn` or `npm i`
2. Install TypeChain with `npm install --save-dev typechain @typechain/hardhat @typechain/ethers-v6`
3. Add the following statements to your hardhat.config.js:
   import '@typechain/hardhat'
   import '@nomicfoundation/hardhat-ethers'
   import '@nomicfoundation/hardhat-chai-matchers'
4. Test contracts compile, this also creates a required types by the deploy file:
   `yarn hardhat compile`
5. Check contract size: `yarn hardhat size-contracts`
6. Run prettier: `yarn prettier`
7. Copy .env.example into .env and set your variables, for the moment we need only:
   MOONBASE_URL
   MOONBEAM_URL
   MOONSCAN_APIKEY
   PRIVATE_KEY
8. Deploy SimpleMultiAsset contract on testnet: `yarn hardhat run scripts/deploySimpleMultiAsset.ts --network moonbaseAlpha`
   Remember to give credit to RMRK if you're using it's technology. Check the license and notice for more details.
9. Always you want to create or modify a smart contract, use the RMKR Wizard to obtain the smart contract template and its deployment script.
