// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract HealthData is Ownable, ReentrancyGuard {
    struct AccessGrant {
        bool hasAccess;
        uint256 expiryTime;
    }
    
    struct HealthRecord {
        string ipfsHash;
        uint256 timestamp;
        bool encrypted;
    }
    
    // Patient => Provider => AccessGrant
    mapping(address => mapping(address => AccessGrant)) private accessPermissions;
    // Patient => Records
    mapping(address => HealthRecord[]) private patientRecords;
    
    event AccessGranted(address indexed patient, address indexed provider, uint256 expiryTime);
    event AccessRevoked(address indexed patient, address indexed provider);
    event RecordAdded(address indexed patient, string ipfsHash, bool encrypted);
    
    modifier validAddress(address _address) {
        require(_address != address(0), "Invalid address");
        _;
    }
    
    function grantAccess(address provider, uint256 expiryTime) 
        external 
        validAddress(provider) 
    {
        require(expiryTime > block.timestamp, "Expiry time must be in future");
        accessPermissions[msg.sender][provider] = AccessGrant(true, expiryTime);
        emit AccessGranted(msg.sender, provider, expiryTime);
    }
    
    function revokeAccess(address provider) 
        external 
        validAddress(provider) 
    {
        delete accessPermissions[msg.sender][provider];
        emit AccessRevoked(msg.sender, provider);
    }
    
    function addRecord(string memory ipfsHash, bool encrypted) 
        external 
        nonReentrant 
    {
        require(bytes(ipfsHash).length > 0, "Invalid IPFS hash");
        patientRecords[msg.sender].push(HealthRecord({
            ipfsHash: ipfsHash,
            timestamp: block.timestamp,
            encrypted: encrypted
        }));
        emit RecordAdded(msg.sender, ipfsHash, encrypted);
    }
    
    function getRecords(address patient) 
        external 
        view 
        returns (HealthRecord[] memory) 
    {
        require(
            msg.sender == patient || checkAccess(patient, msg.sender),
            "Not authorized"
        );
        return patientRecords[patient];
    }
    
    function checkAccess(address patient, address provider) 
        public 
        view 
        returns (bool) 
    {
        AccessGrant memory grant = accessPermissions[patient][provider];
        return grant.hasAccess && grant.expiryTime > block.timestamp;
    }
}