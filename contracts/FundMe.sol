// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";
contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD=5e18;
     address public immutable i_owner;
    address[] public funders;

    mapping (address funder=> uint256 fundedAmt) public addressToFundedAmt;
  
    constructor() {
       i_owner=msg.sender;
    }

    function fund() public payable {

        require(msg.value.rateConversion()>=MINIMUM_USD,"Please send minimum $5 bucks.");
        funders.push(msg.sender);
        addressToFundedAmt[msg.sender]+=msg.value;

    }

    function withdraw() public onlyOwner{

        for(uint256 index=0;index<funders.length;index++){
            address fundersAddress=funders[index];
            addressToFundedAmt[fundersAddress]=0;
        }
        funders=new address[](0);

        // to send ether using transfer,send,call
        //transfer
        //payable (msg.sender).transfer(address(this).balance);

        //  //send
        // bool success=payable (msg.sender).send(address(this).balance);
        // require(success,"Send Failed !");

        //call
       (bool success,)= payable (msg.sender).call{value:address(this).balance}("");
       require(success,"Call Failed !");

    }

    modifier onlyOwner{
        // this ensures that modifier should run after code inside function
       // _;
        require(msg.sender==i_owner,"Sender is not owner");
        // this ensures that modifier should run before code inside function
        _;
    }
    receive() external payable {
        fund();
     }
     fallback() external payable {
        fund();
      }
    
}