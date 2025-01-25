//------------------------------------------------------------------
// Arquivo   : exp3_unidade_controle.v
// Projeto   : Experiencia 3 - Projeto de uma Unidade de Controle
//------------------------------------------------------------------
// Descricao : Unidade de controle
//
// usar este codigo como template (modelo) para codificar 
// máquinas de estado de unidades de controle            
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/01/2024  1.0     Edson Midorikawa  versao inicial
//     12/01/2025  1.1     Edson Midorikawa  revisao
//------------------------------------------------------------------
//

module exp3_unidade_controle (
    input clock,
    input reset,
    input iniciar,
    input fim,
    input jogada,
    input igual,
    output reg zeraC,
    output reg contaC,
    output reg zeraR,
    output reg registraR,
    output reg acertou,
    output reg errou,
    output reg pronto,
    output reg [3:0] db_estado
);

    // Define estados
    parameter inicial           = 4'b0000;  // 0
    parameter preparacao        = 4'b0001;  // 1
    parameter espera_jogada     = 4'b0010;  // 2
    parameter registra_jogada   = 4'b0100;  // 4
    parameter compara_jogada    = 4'b0101;  // 5
    parameter proximo           = 4'b0110;  // 6
    parameter final_acertou     = 4'b1110;  // E
    parameter final_errou       = 4'b1111;  // F

    // Variaveis de estado
    reg [3:0] Eatual, Eprox;

    initial begin
        Eatual = inicial;
    end

    // Memoria de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox;
    end

    // Logica de proximo estado
    always @* begin
        case (Eatual)
            inicial:          Eprox <= iniciar ? preparacao : inicial;
            preparacao:       Eprox <= espera_jogada;
            espera_jogada:    Eprox <= jogada ? registra_jogada : espera_jogada;
            registra_jogada:  Eprox <= compara_jogada;
            compara_jogada:   Eprox <= igual ? proximo : final_errou;
            proximo:          Eprox <= fim  ? final_acertou : espera_jogada;
            final_errou:      Eprox <= iniciar ? preparacao : final_errou;
            final_acertou:    Eprox <= iniciar ? preparacao : final_acertou;
            default:          Eprox <= inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraC     <= (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        zeraR     <= (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        registraR <= (Eatual == registra_jogada) ? 1'b1 : 1'b0;
        contaC    <= (Eatual == proximo) ? 1'b1 : 1'b0;
        pronto    <= (Eatual == final_acertou || Eatual == final_errou ) ? 1'b1 : 1'b0;
        acertou   <= (Eatual == final_acertou) ? 1'b1 : 1'b0;
        errou     <= (Eatual == final_errou) ? 1'b1 : 1'b0;

        // Saida de depuracao (estado)
        case (Eatual)
            inicial:            db_estado <= 4'b0000;  // 0
            preparacao:         db_estado <= 4'b0001;  // 1
            espera_jogada:      db_estado <= 4'b0010;  // 2
            registra_jogada:    db_estado <= 4'b0100;  // 4
            compara_jogada:     db_estado <= 4'b0101;  // 5
            proximo:            db_estado <= 4'b0110;  // 6
            final_acertou:      db_estado <= 4'b1110;  // E
            final_errou:        db_estado <= 4'b1111;  // F
            default:            db_estado <= 4'b0011;  // 3 ERRO
        endcase
    end

endmodule