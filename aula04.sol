// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract ContratoAluguel{

    struct Contrato{
        string locador;
        string locatario;
        uint32[] valorAluguel;
    }

    Contrato public _contrato;

    constructor(string memory locador, string memory locatario, uint32 valorInicialAluguel){
        require(bytes(locador).length > 0, "Insira o nome do Locador");
        require(bytes(locatario).length > 0, "Insira o nome do Locatario");
        require(valorInicialAluguel > 0, "Se quer alugar tem que pagar");
        _contrato.locador = locador;
        _contrato.locatario = locatario;
        for (uint i; i < 36; i++) {
            _contrato.valorAluguel.push(valorInicialAluguel);
        }
    }

    modifier validarMes(uint8 mes){
        require(mes > 0 && mes < 37, "Insira um mes entre 1 e 36");
        _;
    }

    function valorAluguelMes(uint8 mes) 
        external 
        view 
        validarMes(mes) 
        returns(uint32 aluguel){
        return _contrato.valorAluguel[mes - 1];
    }

    function partesDoContrato() 
        external 
        view 
        returns(string memory locador, string memory locatario){
        return (_contrato.locador, _contrato.locatario);
    }

    function alterarParteContrato(string memory nomeAlteracao, uint8 tipoPessoa) 
        external 
        returns(bool sucesso){
        require(bytes(nomeAlteracao).length > 0, "Insira o nome");
        require(tipoPessoa == 1 || tipoPessoa == 2, "Tipo pessoa deve ser 1 para alterar Locador ou 2 para alterar Locatario");
        if(tipoPessoa == 1){
            _contrato.locador = nomeAlteracao;
            return true;
        }
        _contrato.locatario = nomeAlteracao;
        return true;
    }

    function ajustarValorAluguelAposMes(uint32 valor, uint8 mes) 
        external 
        validarMes(mes) 
        returns(bool sucesso) {
            require(valor > 0, "O ajuste deve ser superior a 0");
            for (uint256 i = mes - 1; i < _contrato.valorAluguel.length; i++) {
                _contrato.valorAluguel[i] = _contrato.valorAluguel[i] + valor;
            }
        return true;
    }
}

//0x7C1b2038194b1788e27a14182aEB2191d620CA75