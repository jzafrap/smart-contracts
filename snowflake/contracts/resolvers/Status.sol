pragma solidity ^0.4.24;

import "./SnowflakeResolver.sol";


contract Snowflake {
    function withdrawFrom(string hydroIdFrom, address to, uint amount) public returns (bool);
    function getHydroId(address _address) public view returns (string hydroId);
}


contract Status is SnowflakeResolver {
    mapping (string => string) internal statuses;

    uint signUpFee = 1000000000000000000;
    string firstStatus = "My first status 😎";

    constructor () public {
        snowflakeName = "Status";
        snowflakeDescription = "Set your status.";
    }

    // implement signup function
    function onSignUp(string hydroId, uint allowance) public returns (bool) {
        require(msg.sender == snowflakeAddress, "Did not originate from Snowflake.");
        require(allowance == signUpFee, "Must set an allowance of 1.");
        Snowflake snowflake = Snowflake(snowflakeAddress);
        require(snowflake.withdrawFrom(hydroId, owner, signUpFee), "Could not charge fee.");
        statuses[hydroId] = firstStatus;
        emit StatusUpdated(hydroId, firstStatus);
        return true;
    }

    function getStatus(string hydroId) public view returns (string) {
        return statuses[hydroId];
    }

    // example function that calls withdraw on a linked hydroID
    function setStatus(string status) public {
        Snowflake snowflake = Snowflake(snowflakeAddress);
        string memory hydroId = snowflake.getHydroId(msg.sender);
        statuses[hydroId] = status;
        emit StatusUpdated(hydroId, status);
    }

    event StatusUpdated(string hydroId, string status);
}
