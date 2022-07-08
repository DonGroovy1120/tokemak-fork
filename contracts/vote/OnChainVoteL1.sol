// SPDX-License-Identifier: MIT

pragma solidity 0.7.6;
pragma abicoder v2;

import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import {SafeMathUpgradeable as SafeMath} from "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";
import {MathUpgradeable as Math} from "@openzeppelin/contracts-upgradeable/math/MathUpgradeable.sol";
import {OwnableUpgradeable as Ownable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ERC20Upgradeable as ERC20} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {PausableUpgradeable as Pausable} from "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import "../interfaces/structs/UserVotePayload.sol";
import "../interfaces/events/IEventSender.sol";
import "../interfaces/IEventProxy.sol";

contract OnChainVoteL1 is Initializable, Ownable, Pausable, IEventSender {
    bool public _eventSend;
    IEventProxy public eventProxy;
    modifier onEventSend() {
        if (_eventSend) {
            _;
        }
    }

    function initialize() public initializer {
        __Ownable_init_unchained();
        __Pausable_init_unchained();
    }

    function vote(UserVotePayload memory userVotePayload) external whenNotPaused {
        require(msg.sender == userVotePayload.account, "INVALID_ACCOUNT");
        bytes32 eventSig = "Vote";
        encodeAndSendData(eventSig, userVotePayload);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function setEventSend(bool _eventSendSet) external override onlyOwner {
        require(address(eventProxy) != address(0), "DESTINATIONS_NOT_SET");
        
        _eventSend = _eventSendSet;

        emit EventSendSet(_eventSendSet);
    }

    function encodeAndSendData(bytes32 _eventSig, UserVotePayload memory userVotePayload)
        private
        onEventSend
    {
        require(address(eventProxy) != address(0), "ADDRESS_NOT_SET");
     
        bytes memory data = abi.encode(_eventSig, abi.encode(userVotePayload));

        eventProxy.processMessageFromRoot(address(this), data);
    }

    function setEventProxy(address _eventProxy) external override onEventSend {
        require(_eventProxy != address(0), "ADDRESS INVALID");
        eventProxy = IEventProxy(_eventProxy);
    }
}
