// SPDX-License-Identifier: MIT

pragma solidity 0.7.6;
pragma abicoder v2;

import {OwnableUpgradeable as Ownable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";

import "../interfaces/IBalanceTracker.sol";
import "../interfaces/events/BalanceUpdateEvent.sol";
import "../interfaces/events/EventWrapper.sol";
import "../interfaces/events/IEventReceiver.sol";

contract BalanceTracker is IEventReceiver, IBalanceTracker, Ownable {
    using SafeMath for uint256;

    bytes32 public constant EVENT_TYPE_DEPOSIT = bytes32("Deposit");
    bytes32 public constant EVENT_TYPE_TRANSFER = bytes32("Transfer");
    bytes32 public constant EVENT_TYPE_SLASH = bytes32("Slash");
    bytes32 public constant EVENT_TYPE_WITHDRAW = bytes32("Withdraw");
    bytes32 public constant EVENT_TYPE_WITHDRAWALREQUEST = bytes32("Withdrawal Request");

    // user account address -> token address -> balance
    mapping(address => mapping(address => TokenBalance)) public accountTokenBalances;
    // token address -> total tracked balance
    mapping(address => uint256) public totalTokenBalances;

    //solhint-disable-next-line no-empty-blocks, func-visibility


    address public eventProxy;

    event ProxyAddressSet(address proxyAddress);

    function init(address eventProxyAddress) public initializer {
        require(eventProxyAddress != address(0), "INVALID_ROOT_PROXY");

        _setEventProxyAddress(eventProxyAddress);
    }

    /// @notice Receive an encoded event from a contract on a different chain
    /// @param sender Contract address of sender on other chain
    /// @param eventType Encoded event type
    /// @param data Event Event data
    function onEventReceive(
        address sender,
        bytes32 eventType,
        bytes calldata data
    ) external override {
        require(msg.sender == eventProxy, "EVENT_PROXY_ONLY");

        _onEventReceive(sender, eventType, data);
    }

    /// @notice Configures the contract that can send events to this contract
    /// @param eventProxyAddress New sender address
    function _setEventProxyAddress(address eventProxyAddress) private {
        eventProxy = eventProxyAddress;

        emit ProxyAddressSet(eventProxy);
    }

    function initialize(address eventProxy) public initializer { 
        __Ownable_init_unchained();
        init(eventProxy);
    }

    function getBalance(address account, address[] calldata tokens)
        external
        view
        override
        returns (TokenBalance[] memory userBalances)
    {
        userBalances = new TokenBalance[](tokens.length);
        for (uint256 i = 0; i < tokens.length; i++) {
           userBalances[i] = accountTokenBalances[account][tokens[i]];
        }

        return userBalances;
    }

    function setBalance(SetTokenBalance[] calldata balances) external override onlyOwner {
        for (uint256 i = 0; i < balances.length; i++) {
            SetTokenBalance calldata balance = balances[i];
            updateBalance({
                account: balance.account,
                token: balance.token,
                amount: balance.amount,
                stateSync: false
            });
        }
    }

    function updateBalance(address account, address token, uint256 amount, bool stateSync) private {
        require(token != address(0), "INVALID_TOKEN_ADDRESS");
        require(account != address(0), "INVALID_ACCOUNT_ADDRESS");

        TokenBalance storage currentUserBalance = accountTokenBalances[account][token];
        uint256 currentTotalBalance = totalTokenBalances[token];

        // stateSync updates balances on an ongoing basis, whereas setBalance is only
        // allowed to update balances that have not been set before
        if (stateSync || currentUserBalance.token == address(0)) {
            uint256 updatedTotalBalance = currentTotalBalance.sub(currentUserBalance.amount).add(amount);
            accountTokenBalances[account][token] = TokenBalance({token: token, amount: amount});
            totalTokenBalances[token] = updatedTotalBalance;
            emit BalanceUpdate(account, token, amount, stateSync, true);
        } else {
            // setBalance may trigger this event if it tries to update the balance
            // of an already set user-token key
            emit BalanceUpdate(account, token, amount, false, false);
        }
    }

    function _onEventReceive(address, bytes32 eventType, bytes calldata data) internal virtual  {
        require(eventType == EVENT_TYPE_DEPOSIT || 
            eventType == EVENT_TYPE_TRANSFER ||
            eventType == EVENT_TYPE_WITHDRAW || 
            eventType == EVENT_TYPE_SLASH ||
            eventType == EVENT_TYPE_WITHDRAWALREQUEST, 
            "INVALID_EVENT_TYPE"
        );

        (BalanceUpdateEvent memory balanceUpdate) = abi.decode(data, (BalanceUpdateEvent));

        updateBalance({
            account: balanceUpdate.account,
            token: balanceUpdate.token,
            amount: balanceUpdate.amount,
            stateSync: true
        });
    }
}