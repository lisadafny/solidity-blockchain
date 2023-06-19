// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./aula07.sol";

/// @author Caroline, David, Diogo, Eros, Fabio, Faury, Lisa, Lucas, Tiago, Vinicius, Walter
contract Autorizador {
    IERC20 public token;

    constructor() {
        token = IERC20(0x2B4CC3ee041eBc98C8aB2071bC9dDBd2D8a8cE41);
    }

    modifier estouAutorizado(address clienteBanco) {
        require(token.balanceOf(clienteBanco) > 0, "nao esta autorizado");
        _;
    }
}

contract ClienteBanco {
    string public cpf;
    IERC20 public addressRealDigital;
    address public operadorBanco;

    constructor(string memory _cpf) {
        cpf = _cpf;
        operadorBanco = msg.sender;
        addressRealDigital = IERC20(0x2B4CC3ee041eBc98C8aB2071bC9dDBd2D8a8cE41);
    }

    modifier somenteBanco() {
        require(
            msg.sender == operadorBanco,
            "somente o banco pode fazer essa operacao"
        );
        _;
    }

    function saldoCliente() public view returns (uint256) {
        return addressRealDigital.balanceOf(address(this));
    }

    function saque(uint256 valor) external somenteBanco returns (bool) {
        require(
            saldoCliente() >= valor,
            "valor solicitado inferior ao saldo disponivel"
        );
        bool success = addressRealDigital.transfer(operadorBanco, valor);
        require(success, "houve falha no saque");

        return success;
    }


    function cobrar(uint256 valor) external somenteBanco returns (bool) {
        IERC20 realDigital = IERC20(addressRealDigital);
        require(realDigital.balanceOf(operadorBanco) >= valor);
        bool sucesso = realDigital.transferFrom(operadorBanco, address(this), valor);
        require(sucesso, "houve falha no deposito");

        return sucesso;
    }

    function aprovarUsoDoSaldoEmTerceiros(uint256 valor, address terceiro)
        external
        somenteBanco
        returns (bool)
    {
        IERC20 realDigital = IERC20(addressRealDigital);
        require(realDigital.balanceOf(address(this)) > valor);
        bool sucesso = realDigital.approve(terceiro, valor);
        require(sucesso, "houve falha no deposito");

        return sucesso;
    }
}

contract OperadoraCartao is Autorizador {
    function transferir(uint256 valor, address contaClienteBanco)
        external
        estouAutorizado(contaClienteBanco)
        returns (bool)
    {
        bool sucesso = token.transferFrom(
            contaClienteBanco,
            address(this),
            valor
        );
        require(sucesso, "houve falha no saque");

        return sucesso;
    }
}
//Contrato Operadora Cartao 0x3A4dC4Aa6125b8443476b0bD94c621BB709eD73F
//Contrato Cliente com Banco 0x28424CEB09d83e92685bb04dFe89c86d3EA3468f
//Real Digital ERC20 0x2B4CC3ee041eBc98C8aB2071bC9dDBd2D8a8cE41
