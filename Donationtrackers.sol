// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DonationTracker {
    address public ngo; // NGO wallet address
    uint256 public totalDonations;

    struct Donor {
        uint256 totalAmount;
        uint256 donationsCount;
    }

    mapping(address => Donor) public donors;

    event DonationReceived(address indexed donor, uint256 amount);
    event FundsWithdrawn(address indexed ngo, uint256 amount);

    modifier onlyNGO() {
        require(msg.sender == ngo, "Only NGO can do this");
        _;
    }

    constructor(address _ngo) {
        ngo = _ngo;
    }

    // Donate function (payable so it can receive ETH)
    function donate() public payable {
        require(msg.value > 0, "Donation must be more than 0");

        donors[msg.sender].totalAmount += msg.value;
        donors[msg.sender].donationsCount += 1;
        totalDonations += msg.value;

        emit DonationReceived(msg.sender, msg.value);
    }

    // Get total balance in the contract
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // NGO withdraws all funds
    function withdraw() public onlyNGO {
        uint256 amount = address(this).balance;
        require(amount > 0, "No funds to withdraw");

        payable(ngo).transfer(amount);

        emit FundsWithdrawn(ngo, amount);
    }

    // Get donor details
    function getDonorInfo(address _donor) public view returns (uint256 totalAmount, uint256 donationsCount) {
        Donor memory d = donors[_donor];
        return (d.totalAmount, d.donationsCount);
    }
}


