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
    IERC20 public token;
    address public chave;

    constructor(string memory _cpf) {
        cpf = _cpf;
        chave = msg.sender;
        token = IERC20(0x2B4CC3ee041eBc98C8aB2071bC9dDBd2D8a8cE41);
    }

    modifier somenteBanco() {
        require(
            msg.sender == chave,
            "somente o banco pode fazer essa operacao"
        );
        _;
    }

    function saldoCliente() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function saque(uint256 valor) external somenteBanco returns (bool) {
        require(
            saldoCliente() >= valor,
            "valor solicitado inferior ao saldo disponivel"
        );
        bool success = token.transfer(chave, valor);
        require(success, "houve falha no saque");

        return success;
    }

    function depositar(uint256 valor) external somenteBanco returns (bool) {
        IERC20 contrato = IERC20(token);
        require(contrato.balanceOf(chave) >= valor);
        bool sucesso = contrato.transferFrom(chave, address(this), valor);
        require(sucesso, "houve falha no deposito");

        return sucesso;
    }

    function aprovarUsoDoSaldoEmTerceiros(uint256 valor, address terceiro)
        external
        somenteBanco
        returns (bool)
    {
        IERC20 contrato = IERC20(token);
        require(contrato.balanceOf(address(this)) > valor);
        bool sucesso = contrato.approve(terceiro, valor);
        require(sucesso, "houve falha no deposito");

        return sucesso;
    }
}

contract OperadoraCartao is Autorizador {
    function transferir(uint256 valor, address contratoCliente)
        external
        estouAutorizado(contratoCliente)
        returns (bool)
    {
        bool sucesso = token.transferFrom(
            contratoCliente,
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