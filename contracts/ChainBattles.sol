// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

// Deployed to Polygon Mumbai 0xb3142AD7D5D53E155d37eA87409a4A6aA215D6Bb

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    mapping(uint256 => Character) public tokenIdToLevels;

    //Struct for character stats
    struct Character {
        uint256 level; // Begins at 1
        uint256 hp; // 1-100
        uint256 strength; // 1-20
        uint256 speed; // 1-10
    }

    //track levels
    uint constant lvl = 1;
    uint constant hp = 100;
    uint constant strength = 20;
    uint constant speed = 20;
    
    //track hp
    //track strength
    //track speed

    constructor() ERC721("Chain Battles", "CBTLS") {}

    // Generate random number from hashing timestamp and difficulty
    // with number as the value range from 1 to number; this is deterministic and unsecure
    function generateRandom(uint256 number) public view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.difficulty,
                        msg.sender
                    )
                )
            ) % number;
    }

    function generateCharacter(uint256 tokenId) public returns (string memory) {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior",
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Level: ",
            getLevel(tokenId),
            "Hit Points",
            getHitPoints(tokenId),
            "Strength",
            getStrength(tokenId),
            "Speed",
            getSpeed(tokenId),
            "</text>",
            "</svg>"
        );
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getLevel(uint256 tokenId) public view returns (string memory) {
        uint256 _level = tokenIdToLevels[tokenId].level;
        return _level.toString();
    }

    function getHitPoints(uint256 tokenId) public view returns (string memory) {
        uint256 _hp = tokenIdToLevels[tokenId].hp;
        return _hp.toString();
    }
    function getStrength(uint256 tokenId) public view returns (string memory) {
        uint256 _strength = tokenIdToLevels[tokenId].strength;
        return _strength.toString();
    }
    function getSpeed(uint256 tokenId) public view returns (string memory) {
            uint256 _speed = tokenIdToLevels[tokenId].speed;
            return _speed.toString();
        }

    function getTokenURI(uint256 tokenId) public returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            tokenId.toString(),
            '",',
            '"description": "Battles on chain",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function mint() public {
        _tokenIds.increment();
        uint _level = 1;
        uint _hp = generateRandom(hp);
        uint _strength = generateRandom(strength);
        uint _speed = generateRandom(speed);
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToLevels[newItemId].level = _level;
        tokenIdToLevels[newItemId].hp = _hp;
        tokenIdToLevels[newItemId].strength = _strength;
        tokenIdToLevels[newItemId].speed = _speed;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Please use an existing token");
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this token to train it."
        );
        uint256 currentLevel = tokenIdToLevels[tokenId].level;
        uint256 currentHp = tokenIdToLevels[tokenId].hp;
        uint256 currentStrength = tokenIdToLevels[tokenId].strength;
        uint256 currentSpeed = tokenIdToLevels[tokenId].speed;
        

        tokenIdToLevels[tokenId].level = currentLevel + 1;
        tokenIdToLevels[tokenId].hp = currentHp + 1;
        tokenIdToLevels[tokenId].strength = currentStrength + 1;
        tokenIdToLevels[tokenId].speed = currentSpeed + 1;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}

function random(uint256 number) view returns (uint256) {
    return
        uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.difficulty, msg.sender)
            )
        ) % number;
}
