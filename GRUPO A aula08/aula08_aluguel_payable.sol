// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/// @author Caroline, David, Diogo, Eros, Fabio, Faury, Lisa, Lucas, Tiago, Vinicius, Walter
contract Aluguel {
    uint8 public constant MAXIMO_NUMERO_PARCELAS = 36;
    ContratoAluguel public contratoAluguel;

    event Track(string indexed _function, address sender, uint value, bytes data);

    struct ContratoAluguel {
        address locador;
        address locatario;
        uint256[MAXIMO_NUMERO_PARCELAS] valorAluguel;
    }

    //O nome das partes, locador e locatário, e o valor inicial de cada aluguel deve ser informado no momento da publicação do contrato.
    constructor(
        address _locatario,
        uint256 valorInicialAluguel
    ) {
        uint256[MAXIMO_NUMERO_PARCELAS] memory valoresAluguel;
        for (uint8 i = 0; i < valoresAluguel.length; i++) {
            valoresAluguel[i] = valorInicialAluguel;
        }

        contratoAluguel.locador = msg.sender;
        contratoAluguel.locatario = _locatario;
        contratoAluguel.valorAluguel = valoresAluguel;
    }

    modifier validateOperation(string memory _passCode) {
        require(
            contratoAluguel.locador == msg.sender,
            "Somente o locador pode alterar o contrato"
        );
        _;
    }

    modifier somenteMesValido(uint8 _numeroMes) {
        require(_numeroMes < MAXIMO_NUMERO_PARCELAS, "Mes invalido");
        _;
    }

    //- funcao que recebe o numero do mes e retorna o valor do aluguel daquele mes
    function retornaValorAluguelMes(uint8 _numeroMes)
        public
        view
        somenteMesValido(_numeroMes)
        returns (uint256)
    {
        return contratoAluguel.valorAluguel[_numeroMes - 1];
    }

    //- funcao que retorna o nome do locador e do locatario
    function retornaLocadorLocatario()
        public
        view
        returns (address nomeLocador, address nomeLocatario)
    {
        return (contratoAluguel.locador, contratoAluguel.locatario);
    }

    //- funcao que altera o nome do locador se você passar o tipoPessoa 1 e alterna o nome do locatario se voce passar o tipoPessoa 2
    function alteraPessoa(
        address pessoa,
        uint8 tipoPessoa,
        string memory _passCode
    ) public validateOperation(_passCode) returns (bool) {
        if (tipoPessoa == 1) {
            contratoAluguel.locador = pessoa;
        } else if (tipoPessoa == 2) {
            contratoAluguel.locatario = pessoa;
        } else {
            revert(
                "Tipo de pessoa invalido, deve ser 1 para locador e 2 para locatario"
            );
        }

        return true;
    }

    //- funcao que reajusta os valores dos alugueis após de um determinado mes.
    //Exemplo: soma 100 aos alugueis depois do mes 15
    function alteraValorAluguel(
        uint8 _numeroMes,
        uint256 _valorNovoAluguel,
        string memory _passCode
    )
        public
        validateOperation(_passCode)
        somenteMesValido(_numeroMes)
        returns (bool)
    {
        require(_valorNovoAluguel > 0, "O novo valor deve ser preenchido!");

        for (
            uint8 i = _numeroMes - 1;
            i < contratoAluguel.valorAluguel.length;
            i++
        ) {
            contratoAluguel.valorAluguel[i] = _valorNovoAluguel;
        }

        return true;
    }

    function pagarAluguel(uint8 mes) public payable{
        require(contratoAluguel.valorAluguel[mes - 1] > 0, "Esse mes esta pago");
        require(msg.value == contratoAluguel.valorAluguel[mes - 1], "valor do aluguel nao condiz com o mes");
        contratoAluguel.valorAluguel[mes - 1] = 0;
        emit Track("pagarAluguel()", msg.sender, msg.value, "");
    }

    function saqueParcial(uint valor) public returns(bool){
        require(msg.sender == contratoAluguel.locador, "Somente o Locador pode sacar");
        require(
            address(this).balance >= valor,
            "valor solicitado inferior ao saldo disponivel"
        );
        (bool success, ) = contratoAluguel.locador.call{value: valor}("");
        require(success, "Falhou em enviar ether");
        return success;
    }

    function saqueTotal() public returns(bool){
        uint amount = address(this).balance;
        bool success = saqueParcial(amount);
        require(success, "Falhou em enviar ether");
        return success;
    }

    function balance() public view returns(uint) {
        return address(this).balance;
    }
}
//Contrato 0xf699D972Eae24476117356d0137594372F6E4Fd9
