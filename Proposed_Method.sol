pragma solidity >= 0.5.0;

import "./DaiCERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract DaiToCompound{
    ERC20 erc20;
    CErc20 cerc20;
    // 100 dai = 100000000000000000000
    uint amountOfDai = 100000000000000000000;
    uint public interestGenerated;
    
    constructor () public {
        erc20 = ERC20(0xB5E5D0F8C0cbA267CD3D7035d6AdC8eBA7Df7Cdd);
        cerc20 = CErc20(0x2B536482a01E620eE111747F8334B395a42A555E);
    }

    function deposit() public returns(bool){
        erc20.approve(address(cerc20), amountOfDai); 
        assert(cerc20.mint(amountOfDai) == 0);
        return true;
    }

    function redeem() public returns(bool, uint){
        uint cTokens = cerc20.balanceOf(address(this));
        if (cerc20.redeem(cTokens) == 0){
            interestGenerated = erc20.balanceOf(address(this)) - amountOfDai;
            return (true, interestGenerated);
        }
        else return(false,0);
    }
}