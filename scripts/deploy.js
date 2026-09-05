const hre = require("hardhat");

async function main() {
  const contract = await hre.ethers.deployContract("BlockLoyaltyToken");
  await contract.waitForDeployment();
  console.log(`BlockLoyaltyToken deployed to: ${await contract.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});