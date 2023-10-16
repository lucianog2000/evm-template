import { ethers, run, network } from 'hardhat';
import { BigNumber } from 'ethers';
import { SimpleNestable } from '../typechain-types';
import { getRegistry } from './getRegistry';

async function main() {
  await deployContracts();
}

async function deployContracts(): Promise<void> {
  console.log(`Deploying SimpleNestable to ${network.name} blockchain...`);

  const contractFactory = await ethers.getContractFactory('SimpleNestable');
  const args = [
    'ipfs://QmTGdXVgJiab9R3waNDHQQ1kHZEHgoNR5nYdMFPqJ5ePa2',
    BigNumber.from(2),
    '0x48d113853023Ca865d9bc0Df8Df5d27de3AfB811',
    100,
  ] as const;

  const contract: SimpleNestable = await contractFactory.deploy(...args);
  await contract.deployed();
  console.log(`SimpleNestable deployed to ${contract.address} on ${network.name}`);

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
    contract: 'contracts/SimpleNestable.sol:SimpleNestable',
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
