// SPDX-License-Identifier:	AGPL-3.0
pragma solidity ^0.8.13;

/**
 * @notice Onchain contract registry which stores the list of mapped names
 * @author Modified from Mangrove: https://github.com/mangrovedao/mangrove-core
 */
contract ToyENS {
    event Set(string name, address addr);

    mapping(string => address) public _addrs;
    mapping(string => bytes) public _bytecodes; // todo - combine mappings in one
    string[] _names;

    /* ! Warning ! */
    /* ToyENS should not have any constructor code because its deployed code is sometimes directly written to addresses, either using vm.etch or using anvil_setCode. */

    function get(string calldata name) public view returns (address payable addr) {
        addr = payable(_addrs[name]);
        require(addr != address(0), string.concat("ToyENS: address not found for ", name));
    }

    function getBytes(string calldata name) public view returns (bytes memory bytecode) {
        bytecode = _bytecodes[name];
        require(keccak256(bytecode) != keccak256(new bytes(0)), string.concat("ToyENS: bytecode not found for ", name));
    }

    function set(string calldata name, address addr, bytes memory bytecode) public {
        // 0 is a strong absence marker, can't lose that invariant
        require(addr != address(0), "ToyENS: cannot record a name as 0x0");
        if (_addrs[name] == address(0)) {
            _names.push(name);
        }
        _addrs[name] = addr;
        _bytecodes[name] = bytecode;
        emit Set(name, addr);
    }

    function set(string[] calldata names, address[] calldata addrs, bytes[] memory bytecodes) external {
        for (uint i = 0; i < names.length; i++) {
            set(names[i], addrs[i], bytecodes[i]);
        }
    }

    function all() external view returns (string[] memory names, address[] memory addrs, bytes[] memory bytecodes) {
        names = _names;
        addrs = new address[](names.length);
        bytecodes = new bytes[](names.length);
        for (uint i = 0; i < _names.length; i++) {
            addrs[i] = _addrs[names[i]];
            bytecodes[i] = _bytecodes[names[i]];
        }
    }
}
