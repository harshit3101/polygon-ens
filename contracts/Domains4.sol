// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import { StringUtils } from "./libraries/StringUtils.sol";

import "@openzeppelin/contracts/utils/Base64.sol";

import "hardhat/console.sol";

contract Domains4 is ERC721URIStorage {

    error Unauthorized();
    error AlreadyRegistered();
    error InvalidName(string name);

    address payable public owner;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string public my_tld;

    string svgPartOne = '<svg xmlns="http://www.w3.org/2000/svg" fill="none" width="120" height="120"><path fill="url(#B)" d="M0 0h270v270H0z"></path><defs><filter id="A" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="270" width="270"><feDropShadow dx="0" dy="1" stdDeviation="2" flood-opacity=".225" width="200%" height="200%"></feDropShadow></filter></defs><defs><linearGradient id="B" x1="0" y1="0" x2="270" y2="270" gradientUnits="userSpaceOnUse"><stop stop-color="#cb5eee"></stop><stop offset="1" stop-color="#0cd7e4" stop-opacity=".99"></stop></linearGradient></defs><text filter="url(#A)" font-family="Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" font-weight="bold" y="80" x="10" font-size="12" fill="#fff">';
    string svgPartTwo = '</text></svg>';

    mapping(string => address) public domains;
    mapping(string => string) public records;
    mapping (uint => string) public names;

    constructor(string memory _tld) payable ERC721("Munna Naming Service", "MNS") {
        owner = payable(msg.sender);
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
        if (domains[name] != address(0)) revert AlreadyRegistered();
        if (!valid(name)) revert InvalidName(name);

        uint my_price = getPrice(name);
        console.log("%s has sent only %s Matic", msg.sender, msg.value);

        require(msg.value >= my_price, "Insufficent paid money");

        string memory _name = string(abi.encodePacked(name, ".", my_tld));
        string memory finalSvg = string(abi.encodePacked(svgPartOne,_name,svgPartTwo));
        uint256 newRecordId = _tokenIds.current();
        console.log("New record Id generated: %s", newRecordId);
        uint256 length = StringUtils.strlen(name);
        string memory strLen = Strings.toString(length);

        console.log("Registering %s.%s on the contract with tokenID %d", name, my_tld, newRecordId);

        string memory json = Base64.encode(
         abi.encodePacked(
                '{"name": "',
                _name,
                '", "description": "A domain on the Ninja name service", "image": "data:image/svg+xml;base64,',
                Base64.encode(bytes(finalSvg)),
                '","length":"',
                strLen,
                '"}'
            )
        );

        string memory finalTokenUri = string(abi.encodePacked("data:application/json;base64,", json));

        console.log("\n--------------------------------------------------------");
        console.log("Final tokenURI", finalTokenUri);
        console.log("--------------------------------------------------------\n");

        _safeMint(msg.sender, newRecordId);
        _setTokenURI(newRecordId, finalTokenUri);

        domains[name] = msg.sender;
        console.log("%s has registered a domain %s to address %s", msg.sender, name, domains[name]);

        names[newRecordId] = name;
        _tokenIds.increment();
    }

    function getAddress(string calldata name) public view returns (address) {
        console.log("Request received to get address for domain name %s ", name);
        console.log("Uh Ah!");
        return domains[name];
    }

    function setRecord(string calldata name, string calldata recordIn) public {
        console.log("Checking If transaction sender is the actual owner");
//        require(domains[name] == msg.sender);
        if(msg.sender != domains[name]) revert Unauthorized();
        console.log("Setting record of %s to %s", name , recordIn);
        records[name] = (recordIn);
    }

    function getRecord(string calldata name) public view returns(string memory) {
        return records[name];
    }

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }

    function withdraw() public onlyOwner {
        uint amount = address(this).balance;

        (bool success, ) = msg.sender.call{value: amount}("");

        require(success, "Failed to withdraw Matic");
    }

    // Add this anywhere in your contract body
    function getAllNames() public view returns (string[] memory) {
        console.log("Getting all names from contract");
        string[] memory allNames = new string[](_tokenIds.current());
        for (uint i = 0; i < _tokenIds.current(); i++) {
            allNames[i] = names[i];
            console.log("Name for token %d is %s", i, allNames[i]);
        }

        return allNames;
    }

    function valid(string calldata name) public pure returns(bool) {
        return StringUtils.strlen(name) >= 3 && StringUtils.strlen(name) <= 10;
    }
}