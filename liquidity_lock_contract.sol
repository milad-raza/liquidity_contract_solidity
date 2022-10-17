pragma solidity ^0.8.0;
contract SmartLiquidity{
    uint defaultTimeStamp = 60 seconds;
    struct AmountHistory{
        address from;
        uint amount;
        uint dateTime;
    }
    mapping(address=>AmountHistory) addressHistory;
    address owner;
      constructor() {
        owner = msg.sender;
    }
    mapping(address => uint256) ownerBalance;
    function addAmount() public payable{
        ownerBalance[msg.sender] = msg.value;
        AmountHistory memory addressNew = addressHistory[msg.sender];
        uint newAmount =  addressNew.amount + msg.value;
        addressNew.amount = newAmount;
        addressNew.from = msg.sender;
        addressNew.dateTime = block.timestamp;
        addressHistory[msg.sender] = addressNew;
    }
    function getCurrentUserAmount() public view returns(AmountHistory memory){
        return addressHistory[msg.sender];
    }
    function widthdrawAmount(address payable payee) public {
        require(msg.sender == owner, "Not Allowed");
        require(ownerBalance[payee] > 0, "Zero Balance");
        bool isTransctionAllow =true;
        AmountHistory memory amountHIstory = addressHistory[msg.sender];
        if(msg.sender==owner){
            if((amountHIstory.dateTime + defaultTimeStamp)<block.timestamp){
                isTransctionAllow = false;
            } else {
                isTransctionAllow = true;
           }
        }
        require(!isTransctionAllow,"Tranaction not allow before 1 minute.");
        uint amount = ownerBalance[payee];
        payee.transfer(amount);
                AmountHistory memory addressNew = addressHistory[msg.sender];
        uint newAmount =  0;
        addressNew.amount = newAmount;
        addressNew.from = msg.sender;
        addressNew.dateTime = 0;
        addressHistory[msg.sender] = addressNew;
    }
    function getBalance() public view returns(uint){
        return ownerBalance[msg.sender];
    }
}