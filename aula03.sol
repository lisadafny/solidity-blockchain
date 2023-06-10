// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract ContratoAluguel{
string public _locador;
string public _locatario;
uint32[] public _valorAluguel;

constructor(string memory locador, string memory locatorio, uint32 valorInicialAluguel){
    _locador = locador;
    _locatario = locatorio;
    for (uint i; i < 36; i++) {
        _valorAluguel.push(valorInicialAluguel);
    }
}

 function valorAluguelMes(uint8 mes) external view returns(uint32 aluguel){
return _valorAluguel[mes + 1];
 }

 function partesDoContrato() external view returns(string memory locador, string memory locatario){
     return (_locador, _locatario);
 }

 function alterarParteContrato(string memory nomeAlteracao, uint8 tipoPessoa) external returns(bool sucesso){
     if(tipoPessoa == 1){
         _locador = nomeAlteracao;
         return true;
     }
     if(tipoPessoa ==2 ){
        _locatario = nomeAlteracao;
        return true;
     }
    return false;
 }
 function ajustarValorAluguelAposMes(uint32 valor, uint8 mes) external returns(bool sucesso){
     for (uint256 i = mes - 1; i < _valorAluguel.length; i++) {
            _valorAluguel[i] = _valorAluguel[i] + valor;
        }
    return true;
 }
}

//0x0e1ce2ecb9c9e8513889cdc405cb2ec2e8434816a6bf3d8ed6633c8ecd5be530