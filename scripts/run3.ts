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

    try {
        const anotherTxn = await domainContract.connect(randomPerson)
            .setRecord(MY_FIRST_DOMAIN_NAME, "172.0.0.1");
        await anotherTxn.wait();
    }catch (error) {
        console.log("Some went wromg here %s", error)
    }

    try {
        const anotherTxn = await domainContract.connect(owner)
            .setRecord(MY_FIRST_DOMAIN_NAME, "172.0.0.1");
        await anotherTxn.wait();
    }catch (error) {
        console.log(error)
    }

    const recordList = await domainContract.getRecords(MY_FIRST_DOMAIN_NAME);
    console.log("Domain name %s is set to records: %s",MY_FIRST_DOMAIN_NAME,recordList);

    try {
        const anotherTxn = await domainContract.connect(owner)
            .setRecord(MY_FIRST_DOMAIN_NAME, "172.0.0.2");
        await anotherTxn.wait();
    }catch (error) {
        console.log(error)
    }

    const recordList2 = await domainContract.getRecords(MY_FIRST_DOMAIN_NAME);
    console.log("After second addition, Domain name %s is set to records: %s",MY_FIRST_DOMAIN_NAME,recordList2);
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