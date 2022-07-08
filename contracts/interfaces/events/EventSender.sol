// SPDX-License-Identifier: MIT

pragma solidity 0.6.11;
pragma experimental ABIEncoderV2;

import "./IEventSender.sol";
import "../IEventProxy.sol";
/// @title Base contract for sending events to our Governance layer
abstract contract EventSender is IEventSender {
    bool public eventSend;
    IEventProxy public eventProxy;
    modifier onEventSend() {
        // Only send the event when enabled
        if (eventSend) {
            _;
        }
    }

    modifier onlyEventSendControl() {
        // Give the implementing contract control over permissioning
        require(canControlEventSend(), "CANNOT_CONTROL_EVENTS");
        _;
    }

    /// @notice Enables or disables the sending of events
    function setEventSend(bool eventSendSet) external virtual override onlyEventSendControl {
        eventSend = eventSendSet;

        emit EventSendSet(eventSendSet);
    }

    /// @notice Determine permissions for controlling event sending
    /// @dev Should not revert, just return false
    function canControlEventSend() internal view virtual returns (bool);

    /// @notice Send event data to Governance layer
    function sendEvent(bytes memory data) internal virtual {
        require(address(eventProxy) != address(0), "ADDRESS_NOT_SET");
        eventProxy.processMessageFromRoot(address(this), data);
    }
    function setEventProxy(address _eventProxy) external override onlyEventSendControl {
        require(_eventProxy != address(0), "ADDRESS INVALID");
        eventProxy = IEventProxy(_eventProxy);
    }

}
