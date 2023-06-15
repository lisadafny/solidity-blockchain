// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import "@openzeppelin/contracts/utils/Strings.sol";

contract Logger {

    event armazenarLogs(uint horario, string mensagem);
}

contract DonoDoContrato is Logger {
    address public locador;
    string public hashDasPartes;

    modifier apenasLocador() {
        require(msg.sender == locador, "Apenas o Locador pode fazer isso");
        emit armazenarLogs(block.number,
            string.concat(
                Strings.toHexString(msg.sender),
                " ",
                "realizou acesso a um metodo sensivel"
            )
        );
        _;
    }

    constructor() {
        locador = msg.sender;
    }

    function mudarAddressLocador(address _novoLocador)
        public
        apenasLocador
        returns (bool)
    {
        require(
            _novoLocador != locador,
            "Novo locador deve ser diferente do locador atual"
        );
        emit armazenarLogs(block.number,
            string.concat(
                "Locador alterado de: ",
                Strings.toHexString(locador),
                "para: ",
                Strings.toHexString(_novoLocador),
                "alterado por: ",
                Strings.toHexString(msg.sender)
            )
        );
        hashDasPartes = "";
        locador = _novoLocador;
        return true;
    }

    function armazenarHashDasPartes(address _locatario)
        external
        apenasLocador
        returns (string memory)
    {
        hashDasPartes = string.concat(
            "locador: ",
            Strings.toHexString(locador),
            ", locatario: ",
            Strings.toHexString(_locatario)
        );
        emit armazenarLogs(block.number, string.concat("Hash armazenado: ", hashDasPartes));
        return hashDasPartes;
    }
}

contract ContratoAluguel is DonoDoContrato {
    struct Contrato {
        string locador;
        string locatario;
        uint32[] valorAluguel;
    }

    Contrato public _contrato;

    constructor(
        string memory locador,
        string memory locatario,
        uint32 valorInicialAluguel
    ) {
        require(bytes(locador).length > 0, "Insira o nome do Locador");
        require(bytes(locatario).length > 0, "Insira o nome do Locatario");
        require(valorInicialAluguel > 0, "Se quer alugar tem que pagar");
        _contrato.locador = locador;
        _contrato.locatario = locatario;
        for (uint256 i; i < 36; i++) {
            _contrato.valorAluguel.push(valorInicialAluguel);
        }
    }

    modifier validarMes(uint8 mes) {
        require(mes > 0 && mes < 37, "Insira um mes entre 1 e 36");
        _;
    }

    function valorAluguelMes(uint8 mes)
        external
        view
        validarMes(mes)
        returns (uint32 aluguel)
    {
        return _contrato.valorAluguel[mes - 1];
    }

    function partesDoContrato()
        external
        view
        returns (string memory locador, string memory locatario)
    {
        return (_contrato.locador, _contrato.locatario);
    }

    function alterarParteContrato(string memory nomeAlteracao, uint8 tipoPessoa)
        external
        returns (bool sucesso)
    {
        require(bytes(nomeAlteracao).length > 0, "Insira o nome");
        require(
            tipoPessoa == 1 || tipoPessoa == 2,
            "Tipo pessoa deve ser 1 para alterar Locador ou 2 para alterar Locatario"
        );
        if (tipoPessoa == 1) {
            emit armazenarLogs(block.number,
                string.concat(
                    "Nome locador alterado de: ",
                    _contrato.locador,
                    " para: ",
                    nomeAlteracao
                )
            );
            _contrato.locador = nomeAlteracao;
            return true;
        }
        emit armazenarLogs(block.number,
            string.concat(
                "Nome locador alterado de: ",
                _contrato.locatario,
                " para: ",
                nomeAlteracao
            )
        );
        _contrato.locatario = nomeAlteracao;
        return true;
    }

    function ajustarValorAluguelAposMes(uint32 valor, uint8 mes)
        external
        validarMes(mes)
        returns (bool sucesso)
    {
        require(valor > 0, "O ajuste deve ser superior a 0");
        emit armazenarLogs(block.number,
            string.concat(
                "Valor alterado de: ",
                Strings.toString(_contrato.valorAluguel[mes - 1]),
                " para: ",
                Strings.toString(_contrato.valorAluguel[mes - 1] + valor),
                " em: ",
                Strings.toString(36 - mes),
                " meses"
            )
        );
        for (uint256 i = mes - 1; i < _contrato.valorAluguel.length; i++) {
            _contrato.valorAluguel[i] = _contrato.valorAluguel[i] + valor;
        }
        return true;
    }
}
//0xc5E3BBf1347A559aE1849095ca786204DE922f4a
