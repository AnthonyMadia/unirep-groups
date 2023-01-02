pragma solidity ^0.7.0;

import { Unirep } from '@unirep/contracts/Unirep.sol';

contract GroupManagement {
    // Address of the Unirep contract
    address public unirep;

    // Mapping of group names to their member lists
    mapping(string => address[]) public groups;

    // Mapping of addresses to the groups they are a member of
    mapping(address => string[]) public memberships;

    constructor(address _unirep) public {
        unirep = _unirep;
    }

    // Creates a new group with the given name and adds the caller as the first member
    function createGroup(string memory groupName) public {
        require(groups[groupName].length == 0, "Group already exists");
        groups[groupName].push(msg.sender);
        memberships[msg.sender].push(groupName);
    }

    // Adds a member to the given group
    function addMember(string memory groupName, address member) public {
        require(groups[groupName].length > 0, "Group does not exist");
        require(!isMember(groupName, member), "Member is already in group");
        groups[groupName].push(member);
        memberships[member].push(groupName);
    }

    // Removes a member from the given group
    function removeMember(string memory groupName, address member) public {
        require(groups[groupName].length > 0, "Group does not exist");
        require(isMember(groupName, member), "Member is not in group");
        uint256 index = groups[groupName].indexOf(member);
        // Remove the member from the group's member list
        delete groups[groupName][index];
        // Remove the group from the member's membership list
        index = memberships[member].indexOf(groupName);
        delete memberships[member][index];
    }

    // Returns true if the given address is a member of the group
    function isMember(string memory groupName, address member) public view returns (bool) {
        return groups[groupName].indexOf(member) != -1;
    }

    // Returns the total number of members in the group
    function getNumMembers(string memory groupName) public view returns (uint256) {
        return groups[groupName].length;
    }

    // Returns the list of groups that the given address is a member of
    function getMemberships(address member) public view returns (string[] memory) {
        return memberships[member];
    }
}
