// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SWAgreement
{
    address public developer;   // government who creates the agreement
    address public client; // whom address the agreement
    uint public cost;

    uint public beginTime = uint(0);
    uint public finishTime = uint(0);  
    uint public totalTime = uint(0); 
    uint public nowTime = uint(0); 

    //total no of requirements via this contract at any time
    uint public totalReq = uint(0); 
    
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

    //define the agreement software
    constructor  ()   {
        developer = msg.sender;
        client = 0x2fcd44991ca6B22177Dc6b45e8699C6C389066c8;
        beginTime = nowDate();
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
            uint _dateDeliver, 
                string memory _desc, 
                    bool _acceptance,
                        uint _dateAcceptance
        ) public
    {
        totalReq = totalReq + 1;
        _requirement  memory myReq = _requirement (
            {
                reqID: _reqID,
                dateDeliver: _dateDeliver,
                description: _desc,
                acceptance: _acceptance,
                dateAcceptance: _dateAcceptance
            });
        __Reqs[_reqID] = myReq;
        //emit Add(msg.sender, totalReq);
    }
    
    function updateRequirement (string memory _reqID, string memory _desc) public
    {
        (string memory sID, uint uDateDeliv, , , ) = getRequirement(_reqID); 
        _requirement  memory myReq = _requirement (
            {
                reqID: sID,
                dateDeliver: uDateDeliv,
                description: _desc,
                acceptance: false,
                dateAcceptance: 0
            });
        __Reqs[_reqID] = myReq;
    }

    function getRequirement (string memory _req) public view
        returns (string memory, uint, string memory, bool, uint)
    {
        return (
                __Reqs[_req].reqID,
                __Reqs[_req].dateDeliver,
                __Reqs[_req].description,
                __Reqs[_req].acceptance,
                __Reqs[_req].dateAcceptance
                );
                
    }

    function acceptanceRequirement(string memory _reqID) public {
        (string memory sID, uint uDateDeliv, string memory sDesc, bool bAccep, uint uDateAccep) 
            = getRequirement(_reqID); 
        require(bAccep == false);
        bAccep = true;
        uDateAccep = nowDate();
        addRequirement(sID, uDateDeliv, sDesc, bAccep, uDateAccep);
    }

    /*** Increments ***/

    /*
    function acceptanceIncrement(string memmory _incID) public {
        Increment _inc = getIncrement(_incID);
        require(_inc.acceptance == false);
        _inc.acceptance = true;
    }
    */

}
