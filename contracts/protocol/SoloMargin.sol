pragma solidity 0.5.7;
pragma experimental ABIEncoderV2;

import { Admin } from "./Admin.sol";
import { Getters } from "./Getters.sol";
import { Operation } from "./Operation.sol";
import { Permission } from "./Permission.sol";
import { State } from "./State.sol";
import { Storage } from "./lib/Storage.sol";

contract SoloMargin is
    State,
    Admin,
    Getters,
    Operation,
    Permission
{
    // ============ Constructor ============

    constructor(
        Storage.RiskParams memory riskParams,
        Storage.RiskLimits memory riskLimits
    )
        public
    {
        g_state.riskParams = riskParams;
        g_state.riskLimits = riskLimits;
    }
}
