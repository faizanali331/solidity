// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract WillThrow{
    error NotAllowedError(string);
    function aFunction() public pure{
        // require(false, "Throwing an error");
        //assert(false);
        revert NotAllowedError("Not allowed error ");
    }
}
contract ErrorHandling{
    event ErrorLoging(string message);
    event ErrorLogCode(uint code);
    event ErrorLogBytes(bytes);

    function handleError() public{

        WillThrow will = new WillThrow();
        try will.aFunction() {
            // code for execution
        }catch Error(string memory reason){
            emit ErrorLoging(reason);
        }catch Panic(uint errorCode){
            emit ErrorLogCode(errorCode);
        }catch (bytes memory lowLevelData){
            emit ErrorLogBytes(lowLevelData);
        }
    }
}