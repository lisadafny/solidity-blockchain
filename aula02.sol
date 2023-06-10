// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract ContratoVendedor{
//nome vendedor
string public _vendedor;
//bonus dele (fator do bonus)
uint256 public _fatorBonus;

constructor(string memory vendedor, uint256 fatorBonus){
    _vendedor = vendedor;
    _fatorBonus = fatorBonus;
}

//função que passando o valor de venda ele retorna o valor do bonus
    function processarVenda(uint256 valorVenda) public view returns (uint256){
        uint256 ganho = valorVenda * _fatorBonus;
        return ganho;
    }
}
//Contrato
//0xaF49F9b678FE75E1E9Dbe61b859Ce9b6ac3aBb85
