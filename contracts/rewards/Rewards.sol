// SPDX-License-Identifier: MIT

pragma solidity 0.6.11;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "../interfaces/IRewards.sol";

contract Rewards is Ownable, IRewards {
    using SafeMath for uint256;
    using ECDSA for bytes32;
    using SafeERC20 for IERC20;

    mapping(address => uint256) public override claimedAmounts;

    bytes32 private constant EIP712_DOMAIN_TYPEHASH =
        keccak256(
            "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
        );

    bytes32 private constant RECIPIENT_TYPEHASH =
        keccak256("Recipient(uint256 chainId,uint256 cycle,address wallet,uint256 amount)");

    bytes32 private immutable domainSeparator;

    IERC20 public immutable override tokeToken;
    address public override rewardsSigner;

    constructor(address token, address signerAddress) public {
        require(address(token) != address(0), "Invalid TOKE Address");
        require(signerAddress != address(0), "Invalid Signer Address");
        tokeToken = IERC20(token);
        rewardsSigner = signerAddress;

        domainSeparator = _hashDomain(
            EIP712Domain({
                name: "TOKE Distribution",
                version: "1",
                chainId: _getChainID(),
                verifyingContract: address(this)
            })
        );
    }

    function _hashDomain(EIP712Domain memory eip712Domain) private pure returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    EIP712_DOMAIN_TYPEHASH,
                    keccak256(bytes(eip712Domain.name)),
                    keccak256(bytes(eip712Domain.version)),
                    eip712Domain.chainId,
                    eip712Domain.verifyingContract
                )
            );
    }

    function _hashRecipient(Recipient memory recipient) private pure returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    RECIPIENT_TYPEHASH,
                    recipient.chainId,
                    recipient.cycle,
                    recipient.wallet,
                    recipient.amount
                )
            );
    }

    function _hash(Recipient memory recipient) private view returns (bytes32) {
        return keccak256(abi.encodePacked("\x19\x01", domainSeparator, _hashRecipient(recipient)));
    }

    function _getChainID() private view returns (uint256) {
        uint256 id;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            id := chainid()
        }
        return id;
    }

    function setSigner(address newSigner) external override onlyOwner {
        require(newSigner != address(0), "Invalid Signer Address");
        rewardsSigner = newSigner;

        emit SignerSet(newSigner);
    }

    function getClaimableAmount(address recipient, uint256 amount)
        external
        view
        override
        returns (uint256)
    {
        return amount.sub(claimedAmounts[recipient]);
    }

    function claim(
        uint256 cycle,
        uint256 amount
    ) external override {

        uint256 claimableAmount = amount.sub(claimedAmounts[msg.sender]);

        require(claimableAmount > 0, "Invalid claimable amount");
        require(tokeToken.balanceOf(address(this)) >= claimableAmount, "Insufficient Funds");

        claimedAmounts[msg.sender] = claimedAmounts[msg.sender].add(claimableAmount);

        tokeToken.safeTransfer(msg.sender, claimableAmount);

        emit Claimed(cycle, msg.sender, claimableAmount);
    }
}
