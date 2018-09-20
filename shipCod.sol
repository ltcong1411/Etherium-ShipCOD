pragma solidity ^0.4.18;

contract shipCOD {
    struct order {
        string Name;
        uint Cost;
        address Customer_addr;
    }
    
    uint feeShip;
    order private order1;
    
    address private adminAddr;
    address private shopperAddr = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    address private shipperAddr = 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db;
    address private customerAddr = 0x583031d1113ad414f02576bd6afabfb302140225;
    
    mapping(address => uint) private userList;
    constructor() public {
        adminAddr = msg.sender;
        userList[adminAddr]=100;
        userList[shopperAddr]=100;
        userList[shipperAddr]=100;
        userList[customerAddr]=100;
    }
    
    function costShip(uint fee) public {
        feeShip = fee;
    }
    
    function createOrder(string name, uint cost, address customer_addr) public retricted(shopperAddr) {
        order1.Name = name;
        order1.Cost = cost;
        order1.Customer_addr = customer_addr;
    }
    
    function viewWallet(address addr) public view returns (uint) {
        return userList[addr];
    }

    function shipperAccepted() public retricted(shipperAddr) {
        userList[msg.sender] = userList[msg.sender] - order1.Cost;
        userList[adminAddr] = userList[adminAddr] + order1.Cost;
    }
    
    function customerComfirm() public retricted(customerAddr) {
        userList[msg.sender] = userList[msg.sender] - order1.Cost - feeShip;
        userList[shipperAddr] = userList[shipperAddr] + order1.Cost + (feeShip/2);
        userList[adminAddr] = userList[adminAddr] - order1.Cost + (feeShip/2);
        userList[shopperAddr] = userList[shopperAddr] + order1.Cost;
    }
    
    modifier retricted(address currentUser){
        require(msg.sender == currentUser, "You are not authorized");
        _;
    }
    
}