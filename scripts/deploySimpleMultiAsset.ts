import { ethers, run, network } from 'hardhat';
import { BigNumber } from 'ethers';
import { SimpleMultiAsset } from '../typechain-types';
import { getRegistry } from './getRegistry';

async function main() {
  await deployContracts();
}

async function deployContracts(): Promise<void> {
  console.log(`Deploying SimpleMultiAsset to ${network.name} blockchain...`);

  const contractFactory = await ethers.getContractFactory('SimpleMultiAsset');
  const args = [
    'ipfs://QmcmvhCT5AngUoxHuESdBLN1gMoNa5KLgnqbhTJYsE7rsw',
    BigNumber.from(10000),
    '0x48d113853023Ca865d9bc0Df8Df5d27de3AfB811',
    100,
  ] as const;

  const contract: SimpleMultiAsset = await contractFactory.deploy(...args);
  await contract.deployed();
  console.log(`SimpleMultiAsset deployed to ${contract.address}.`);

  // Only do on testing, or if whitelisted for production
  const registry = await getRegistry();
  await registry.addExternalCollection(contract.address, args[0]);
  console.log('Collection added to Singular Registry');

  const chainId = (await ethers.provider.getNetwork()).chainId;
  if (chainId === 31337) {
    console.log('Skipping verify on local chain');
    return;
  }

  console.log('Waiting for the propagation of the contract...');
  await new Promise((resolve) => setTimeout(resolve, 30000));

  await run('verify:verify', {
    address: contract.address,
    constructorArguments: args,
    contract: 'contracts/SimpleMultiAsset.sol:SimpleMultiAsset',
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
