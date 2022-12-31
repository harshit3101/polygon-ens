// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import { StringUtils } from "./libraries/StringUtils.sol";
import "hardhat/console.sol";

contract Domains2 {

    string public my_tld;

    mapping(string => address) domains;
    mapping(string => string[]) records;

    constructor(string memory _tld) payable {
        my_tld = _tld;
        console.log("Remember you are learning smart contracts again. First step again.");
    }

    function getPrice(string calldata name) public pure returns(uint) {
        uint len = StringUtils.strlen(name);
        require(len > 0);
        if (len == 3) {
            return 5 * 10*17;
        } else if (len == 4 ) {
            return 3 * 10**17;
        } else {
            return 1 * 10**17;
        }
     }

    function register(string calldata name) public payable {
        require(domains[name] == address(0));

        uint my_price = getPrice(name);

        console.log("%s has sent only %s Matic", msg.sender, msg.value);

        require(msg.value >= my_price, "Insufficent paid money");

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