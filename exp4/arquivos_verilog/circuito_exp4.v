//------------------------------------------------------------------
// Arquivo   : circuito_exp3.v
// Projeto   : Experiencia 3 - Projeto de uma Unidade de Controle 
//------------------------------------------------------------------
// Descricao : Modulo principal da experiencia
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor            Descricao
//     18/01/2025  1.0     T5BB5            versao inicial
//------------------------------------------------------------------
//

module circuito_exp3_desafio (
    input clock,
    input reset,
    input iniciar,
    input [3:0] chaves,
    output pronto,
    output acertou,
    output errou,
    output db_igual,
    output db_iniciar,
    output [6:0] db_contagem,
    output [6:0] db_memoria,
    output [6:0] db_chaves,
    output [6:0] db_estado,
    output [3:0] dec_contagem,
    output [3:0] dec_memoria,
    output [3:0] dec_chaves,
    output [3:0] dec_estado
);

wire [3:0] s_chaves, s_memoria, s_contagem, s_estado;
wire s_fim, s_zeraC, s_zeraR, s_conta, s_registraR;

exp3_unidade_controle controlUnit (
    .clock       (clock),
    .reset       (reset),
    .iniciar     (iniciar),
    .chavesIgualMemoria (db_igual),
    .errou       (errou),
    .acertou     (acertou),
    .fimC        (s_fim),
    .zeraC       (s_zeraC),
    .contaC      (s_conta),
    .zeraR       (s_zeraR),
    .registraR   (s_registraR),
    .pronto      (pronto),
    .db_estado   (s_estado)
);

exp3_fluxo_dados fluxo_dados (
    .clock              (clock),
    .chaves             (chaves),
    .zeraR              (s_zeraR),
    .registraR          (s_registraR),
    .contaC             (s_conta),
    .zeraC              (s_zeraC),
    .chavesIgualMemoria (db_igual),
    .fimC               (s_fim),
    .db_contagem        (s_contagem),
    .db_chaves          (s_chaves),
    .db_memoria         (s_memoria)
);

hexa7seg display_chaves (
    .hexa       (s_chaves),
    .display    (db_chaves)
);

hexa7seg display_contagem (
    .hexa       (s_contagem),
    .display    (db_contagem)
);

hexa7seg display_memoria (
    .hexa       (s_memoria),
    .display    (db_memoria)
);

hexa7seg display_estado (
    .hexa       (s_estado),
    .display    (db_estado)
);

assign db_iniciar = iniciar;
assign dec_chaves = s_chaves;
assign dec_contagem = s_contagem;
assign dec_estado = s_estado;
assign dec_memoria = s_memoria;

endmodule