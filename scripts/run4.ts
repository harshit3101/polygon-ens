import {ContractTransaction} from "ethers";


const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();

    const ownerBalance = await hre.ethers.provider.getBalance(owner.address);
    console.log("Owner balance in the start:", hre.ethers.utils.formatEther(ownerBalance));

    const domainContractFactory = await hre.ethers.getContractFactory('Domains3');

    const domainContract = await domainContractFactory.deploy("munna");
    await domainContract.deployed();

    console.log("Contract deployed to:", domainContract.address);

    const MY_FIRST_DOMAIN_NAME = "itislive"

    // const txn = await domainContract.register(MY_FIRST_DOMAIN_NAME);
    const txn = await domainContract.register(MY_FIRST_DOMAIN_NAME, {value: hre.ethers.utils.parseEther('1')});
    await txn.wait();

    const ownerBalance1 = await hre.ethers.provider.getBalance(owner.address);
    console.log("Owner balance after first txn:", hre.ethers.utils.formatEther(ownerBalance1));

    const txn2 = await domainContract.register(MY_FIRST_DOMAIN_NAME+2, {value: hre.ethers.utils.parseEther('0.1')});
    await txn2.wait();

    const domainOwner = await domainContract.getAddress(MY_FIRST_DOMAIN_NAME);
    console.log("So %s is the mapping of %s", domainOwner, MY_FIRST_DOMAIN_NAME);


    const balance = await hre.ethers.provider.getBalance(domainContract.address);

    console.log("Contract balance:", hre.ethers.utils.formatEther(balance));


    const ownerBalance2 = await hre.ethers.provider.getBalance(owner.address);
    console.log("Owner balance in the end:", hre.ethers.utils.formatEther(ownerBalance2));
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