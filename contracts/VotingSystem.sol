// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract Adminable{
    address public admin;
    constructor(){
        admin = msg.sender;
    }
    modifier onlyAdmin(){
        require(msg.sender==admin, "you are not Admin...");
        _;
    }
}

contract VotingSystem is Adminable{

    event CandidateAdded(uint indexed id, string name);
    event VoterRegistered(address indexed voter);
    event VotingStarted();
    event VotingClosed();
    event VoteCast(address indexed voter, uint indexed candidateId);

    uint public votingStartTime;
    uint public votingEndTime;
    uint public totalVotes;
    uint counter;

    mapping(uint => Candidate) candidates;
    mapping(address => bool) public hasVoted;
    mapping(address => bool) public isRegisteredVoter;

    struct Candidate{
        uint id;
        string name;
        uint voteCount;
    }

    function addCandidate(string memory _name) public onlyAdmin{
        require(block.timestamp < votingStartTime || votingStartTime == 0, "Voting already started");
        counter++;
        candidates[counter] = Candidate(counter, _name, 0);
        emit CandidateAdded(counter, _name);
    }
    function registerVoter(address _voter) public onlyAdmin{
        require(block.timestamp < votingStartTime || votingStartTime == 0, "Voting already started");
        require(!isRegisteredVoter[_voter], "Voter is already registered");
        isRegisteredVoter[_voter] = true;
        hasVoted[_voter] = false;
        emit VoterRegistered(_voter);
    }
    function startVoting(uint _durationInSeconds) public onlyAdmin{
        require(votingStartTime == 0, "Voting already started");
        require(_durationInSeconds > 0, "Invalid duration");

        votingStartTime = block.timestamp;
        votingEndTime = block.timestamp + _durationInSeconds;
        emit VotingStarted();
    }
    
    function castVote(uint _id)public{
        require(block.timestamp >= votingStartTime, "Voting not started");
        require(block.timestamp <= votingEndTime, "Voting ended");
        require(isRegisteredVoter[msg.sender], "You are not a registered voter");
        require(!hasVoted[msg.sender], "you already voted");
        require(_id > 0 && _id <= counter, "Candidate does not exist");

        hasVoted[msg.sender] = true;
        candidates[_id].voteCount = candidates[_id].voteCount + 1;
        totalVotes++;
        emit VoteCast(msg.sender, _id);
    }
    function getCandidate(uint _id)public view returns (Candidate memory){
        require(_id>0&&_id<=counter, "Invalid candidate");
        return candidates[_id];
    }
    function winner()public view returns(Candidate memory){
        require(block.timestamp > votingEndTime, "Voting still running");
        require(counter > 0, "No candidates");
        uint maxVote = 0;
        uint winnerId = 0;
        for(uint i = 1; i <= counter; i++){
            if(candidates[i].voteCount > maxVote){
                maxVote = candidates[i].voteCount;
                winnerId = i;
            }
        }
        return candidates[winnerId];
    }
}