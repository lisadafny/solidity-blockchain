// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract ContratoVendedor{
//nome vendedor
string public _vendedor;
//bonus dele (fator do bonus)
uint256 public _fatorBonus;
uint256 public _valorVenda;

constructor(string memory vendedor, uint256 fatorBonus, uint256 valorVenda){
    _vendedor = vendedor;
    _fatorBonus = fatorBonus;
    _valorVenda = valorVenda;
}

//função que passando o valor de venda ele retorna o valor do bonus
    function processarVenda() public view returns (uint256){
        uint256 ganho = _valorVenda * _fatorBonus;
        return ganho;
    }
}
//Contrato
//0x804364379c0707566311877874B357493FbBe6f7