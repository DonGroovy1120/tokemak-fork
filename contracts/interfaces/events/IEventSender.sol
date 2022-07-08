// SPDX-License-Identifier: MIT

pragma solidity >=0.6.11;
pragma experimental ABIEncoderV2;


interface IEventSender {
    event EventSendSet(bool eventSendSet);
    
    /// @notice Enables or disables the sending of events
    function setEventSend(bool eventSendSet) external;

    /// @notice Enables or disables the sending of events
    function setEventProxy(address _eventProxy) external;

}
