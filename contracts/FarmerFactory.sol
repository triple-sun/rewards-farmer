// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "./lib/ProxyFactory.sol";

contract FarmerFactory is ProxyFactory {

    // maps user address to address of deployed proxy
    mapping (address => address) public farmerProxy;

    // Logic contract
    address public logicContract;

    constructor(
        address _logicContract
    ) public {
        logicContract = _logicContract;
    }

    function deployProxy(address owner, address cToken)
        public
        virtual
        returns (address proxy)
    {
        bytes memory data = _encodeData(owner, cToken);
        proxy = deployMinimal(logicContract, data);
        farmerProxy[msg.sender] = proxy;
        return proxy;
    }

    function _encodeData(address user, address cToken)
        internal
        pure
        returns (bytes memory)
    {
        bytes4 selector = 0xc4d66de8;
        return abi.encodeWithSelector(
            selector,
            user,
            cToken
        );
    }

}