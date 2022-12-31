// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "hardhat/console.sol";

contract Domains {

    mapping(string => address) domains;
    mapping(string => string[]) records;

    constructor() {
        console.log("Remember you are learning smart contracts again. First step again.");
    }

    function register(string calldata name) public {
        require(domains[name] == address(0));
        domains[name] = msg.sender;
        console.log("%s has registered a domain %s to address %s", msg.sender, name, domains[name]);
    }

    function getAddress(string calldata name) public view returns (address) {
        console.log("Request received to get address for domain name %s ", name);
        console.log("Uh Ah!");
        return domains[name];
    }

    function setRecord(string calldata name, string calldata record) public {
        console.log("Checking If transaction sender is the actual owner");
        require(domains[name] == msg.sender);
        console.log("Setting record of %s to %s", name , record);
        records[name].push(record);
    }

    function getRecords(string calldata name) public view returns(string[] memory) {
        return records[name];
    }
}