// SPDX-License-Identifier: MIT

pragma solidity >=0.6.11;

// IFxMessageProcessor represents interface to process message
interface IFxMessageProcessor {
    function processMessageFromRoot(address rootMessageSender, bytes calldata data) external;
}