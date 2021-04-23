pragma solidity 0.5.7;
pragma experimental ABIEncoderV2;

import { Require } from "./Require.sol";
import { Token } from "./Token.sol";
import { Types } from "./Types.sol";
import { IExchangeWrapper } from "../interfaces/IExchangeWrapper.sol";

library Exchange {
    using Types for Types.Wei;

    // ============ Constants ============

    bytes32 constant FILE = "Exchange";

    // ============ Library Functions ============

    function transferOut(
        address token,
        address to,
        Types.Wei memory deltaWei
    )
        internal
    {
        Require.that(
            !deltaWei.isPositive(),
            FILE,
            "Cannot transferOut positive",
            deltaWei.value
        );

        Token.transfer(
            token,
            to,
            deltaWei.value
        );
    }

    function transferIn(
        address token,
        address from,
        Types.Wei memory deltaWei
    )
        internal
    {
        Require.that(
            !deltaWei.isNegative(),
            FILE,
            "Cannot transferIn negative",
            deltaWei.value
        );

        Token.transferFrom(
            token,
            from,
            address(this),
            deltaWei.value
        );
    }

    function getCost(
        address exchangeWrapper,
        address supplyToken,
        address borrowToken,
        Types.Wei memory desiredAmount,
        bytes memory orderData
    )
        internal
        view
        returns (Types.Wei memory)
    {
        Require.that(
            !desiredAmount.isNegative(),
            FILE,
            "Cannot getCost negative",
            desiredAmount.value
        );

        Types.Wei memory result;
        result.sign = false;
        result.value = IExchangeWrapper(exchangeWrapper).getExchangeCost(
            supplyToken,
            borrowToken,
            desiredAmount.value,
            orderData
        );

        return result;
    }

    function exchange(
        address exchangeWrapper,
        address accountOwner,
        address supplyToken,
        address borrowToken,
        Types.Wei memory requestedFillAmount,
        bytes memory orderData
    )
        internal
        returns (Types.Wei memory)
    {
        Require.that(
            !requestedFillAmount.isPositive(),
            FILE,
            "Cannot exchange positive",
            requestedFillAmount.value
        );

        transferOut(borrowToken, exchangeWrapper, requestedFillAmount);

        Types.Wei memory result;
        result.sign = true;
        result.value = IExchangeWrapper(exchangeWrapper).exchange(
            accountOwner,
            address(this),
            supplyToken,
            borrowToken,
            requestedFillAmount.value,
            orderData
        );

        transferIn(supplyToken, exchangeWrapper, result);

        return result;
    }
}
