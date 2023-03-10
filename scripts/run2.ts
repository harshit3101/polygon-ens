import {ContractTransaction} from "ethers";


const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const domainContractFactory = await hre.ethers.getContractFactory('Domains');
    const domainContract = await domainContractFactory.deploy();
    await domainContract.deployed();
    console.log("Contract deployed to:", domainContract.address);
    console.log("Contract deployed by:", owner.address);

    const MY_FIRST_DOMAIN_NAME = "itislive"

    const txn = await domainContract.register(MY_FIRST_DOMAIN_NAME);
    await txn.wait();

    const domainOwner = await domainContract.getAddress(MY_FIRST_DOMAIN_NAME);
    console.log("So %s is the mapping of %s", domainOwner, MY_FIRST_DOMAIN_NAME);
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();