// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
* @author Wilson Soto
* @notice Smart Contract Software Development Agreement
*/

import './AggregatorV3Interface.sol';

contract SWAgreement
{
    address public client = 0x2fcd44991ca6B22177Dc6b45e8699C6C389066c8;   // government who creates the agreement
    address public developer; // whom address the agreement
    uint public cost;
    mapping(address => uint256) public addressToAmount;


    uint public beginTime = uint(0);
    uint public finishTime = uint(0);  
    uint public totalTime = uint(0); 
    uint public nowTime = uint(0); 
    uint public signTime = uint(0);
    //total no of requirements via this contract at any time
    uint public totalReq = uint(0); 
    bool public signAgreement = false;
    uint public minimumUsd = 50;
    
    struct _requirement 
    {
        string reqID;
        uint dateDeliver; 
        string description;
        bool acceptance; 
        uint dateAcceptance;
    } 

    mapping (string => _requirement ) public __Reqs; 

    struct _increment 
    {
        string incID;
        uint dateEstimateDeliver;
        uint dateDeliver; 
        string description;
        _requirement[] reqsByInc; 
        bool acceptance; 
        uint dateAcceptance;
    }

    /*** General Data Agreement ***/
    constructor  ()   {
        developer = msg.sender;
        beginTime = nowDate();
        signature();
    }
    
    //Signature agreement
    function signature () public {
        signTime = nowDate();
        signAgreement = true;
    }

    //addition event
    //event Add(address _client, uint _reqID);
    
    modifier isOwner
    {
        require(msg.sender == developer);
        _;
    }
    
    //Begin date agreement
    function initTime() public returns (uint) {
        beginTime = block.timestamp; 
        return beginTime;
    }
    
    function nowDate () public returns (uint) {
        nowTime = block.timestamp; 
        return nowTime;
    }

    //End date agreement
    function endTime() public returns (uint) {
        finishTime = block.timestamp; 
        return finishTime;
    }

    function showTotalTime(uint _beginTime, uint _finishTime) public returns (uint) {
         // 1 day = (3600 * 24)
        totalTime = (_finishTime - _beginTime) / 60;
        return totalTime;
    }

    /*** Requirements ***/

    function addRequirement 
        (string memory _reqID, 
                string memory _desc
        ) public
    {
        totalReq = totalReq + 1;
        _requirement  memory myReq = _requirement (
            {
                reqID: _reqID,
                dateDeliver: initTime(),
                description: _desc,
                acceptance: false,
                dateAcceptance: initTime()
            });
        __Reqs[_reqID] = myReq;
        //emit Add(msg.sender, totalReq);
    }
    
    function updateRequirement (string memory _reqID, string memory _desc) public
    {
        (string memory sID, uint uDateDeliv, , bool bAccep, uint uDateAccep) 
            = getRequirement(_reqID);
        _requirement memory myReq = _requirement (
            {
                reqID: sID,
                dateDeliver: uDateDeliv,
                description: _desc,
                acceptance: bAccep,
                dateAcceptance: uDateAccep
            });
        __Reqs[_reqID] = myReq;
    }

    function getRequirement (string memory _reqID) public view
        returns (string memory, uint, string memory, bool, uint)
    {
        return (
                __Reqs[_reqID].reqID,
                __Reqs[_reqID].dateDeliver,
                __Reqs[_reqID].description,
                __Reqs[_reqID].acceptance,
                __Reqs[_reqID].dateAcceptance
                );
                
    }

    function acceptanceRequirement(string memory _reqID) public {
        (string memory sID, uint uDateDeliv, string memory sDesc, bool bAccep, ) 
            = getRequirement(_reqID); 
        require(bAccep == false);
        _requirement memory myReq = _requirement (
        {
            reqID: sID,
            dateDeliver: uDateDeliv,
            description: sDesc,
            acceptance: true,
            dateAcceptance: nowDate()
        });
        __Reqs[_reqID] = myReq;
    }

    /*** Increments ***/

    /*
    function acceptanceIncrement(string memmory _incID) public {
        Increment _inc = getIncrement(_incID);
        require(_inc.acceptance == false);
        _inc.acceptance = true;
    }
    */

    /*** Payments ***/

    uint public payTime = uint(0);

    function validateMinimumPay(uint valueUsd) public payable {
        uint256 minimumWei = minimumUsd * 10 ** 18;  
        uint256 valueWei = valueUsd * 10 ** 18;
        require(valueWei >= minimumWei ," You need to spend more ETH");
        payTime = nowDate();
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface valPay = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return valPay.version();
    }

    function getPrice () public view returns (uint256) {
        AggregatorV3Interface valPay = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,) = valPay.latestRoundData();
        return uint256(answer * 10000000000);
    }

    // 1 Eth = 1000000000000000000 Wei
    function getConversionRate (uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }

    //fund account
    function fundAccount () public payable {
        validateMinimumPay(msg.value);
        addressToAmount[developer] += msg.value;
    }


    //return funds to client
    function withdrawAccount () public payable isOwner {
        payable(developer).transfer(address(this).balance);
    }

}
