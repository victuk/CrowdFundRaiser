// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "hardhat/console.sol";

contract Lock {
    address owner;

    constructor() {
        owner = msg.sender;
    }



    struct CroudFundingDetails {
        string title;
        string description;
        address payable benefactor;
        uint goal;
        uint deadline;
        uint amountRaised;
    }

    mapping (uint croudFundingID => CroudFundingDetails) public campaigns;

    event CampaignCreated(address indexed createdBy, uint indexed campaignID, string campaignTitle);
    event DonationReceived(address indexed from, uint indexed amount, uint campaignID);
    event CampaignEnded(address indexed from, address indexed to, uint amount);

    // Function to check if the campaign already exists
    function checkIfCampaignExists (uint campaignID) internal view returns (bool) {
        return bytes(campaigns[campaignID].title).length > 0;
    }

    // Function to create a campaign
    function createCampaign(
        uint _campaignID,
        string memory _title,
        string memory _description,
        address payable _benefactor,
        uint _goal,
        uint _deadline
    ) public {
        if(checkIfCampaignExists(_campaignID)) {
            revert("Campaign already exist");
        }

        campaigns[_campaignID] = CroudFundingDetails(_title, _description, _benefactor, _goal, _deadline, 0);

        emit CampaignCreated(msg.sender, _campaignID, _title);

    }

    // Function to donate to a campaign
    function donate(uint campaignID) public payable {
        if(!checkIfCampaignExists(campaignID)) {
            revert("Account does not exist");
        } else if (block.timestamp > campaigns[campaignID].deadline) {
            revert("Can't donate. Donation date has passed");
        } else {
            campaigns[campaignID].amountRaised = campaigns[campaignID].amountRaised + msg.value;
            emit DonationReceived(msg.sender, msg.value, campaignID);
        }
    }

    // Function to end the campaign
    function endCampaign(uint _campaignID) public {
        if (block.timestamp < campaigns[_campaignID].deadline) {
            revert("Campaign has not expired");
        }

        if(msg.sender != owner) {
                revert("Unauthorized request: Only the smart contract owner can trigger this event");
        }

        (bool success, ) = campaigns[_campaignID].benefactor.call{value: campaigns[_campaignID].amountRaised}("");

        if(success == false) {
            revert("Funding the benefactor failed, please try again leter");
        }

        emit CampaignEnded(msg.sender, campaigns[_campaignID].benefactor, campaigns[_campaignID].amountRaised);
    }

    // This was for test, I wanted to see how I can convert the timestamp to a future date.
    function getCurrentTimeStamp() public view returns (uint) {
        return block.timestamp;
    }


}
