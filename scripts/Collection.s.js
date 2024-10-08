const hre = require("hardhat");

async function main() {
  const Collection = await hre.ethers.getContractFactory("Collection");
  const collection = await Collection.deploy();
  await collection.deployed();

  console.log("Contract is deployed with address", collection.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
