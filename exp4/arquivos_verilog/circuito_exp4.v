//------------------------------------------------------------------
// Arquivo   : circuito_exp4.v
// Projeto   : Experiencia 4 - Projeto de um Sistema Digital 
//------------------------------------------------------------------
// Descricao : Modulo principal da experiencia
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor            Descricao
//     18/01/2025  1.0     T5BB5            versao inicial
//------------------------------------------------------------------
//

module circuito_exp4 (
    input clock,
    input reset,
    input iniciar,
    input [3:0] chaves,
    output acertou,
    output errou,
    output pronto,
    output [3:0] leds,
    output db_igual,
    output [6:0] db_contagem,
    output [6:0] db_memoria,
    output [6:0] db_estado,
    output [6:0] db_jogadafeita,
    output db_clock,
    output db_iniciar,
    output db_tem_jogada,
	 output db_timeout

);


wire [3:0] s_chaves, s_memoria, s_contagem, s_estado;
wire s_fim, s_igual, s_zeraC, s_zeraR, s_conta, s_registraR, s_jogada, s_timeout, s_contaT;

assign leds = s_chaves;
assign db_tem_jogada = s_jogada;
assign db_iniciar = iniciar;
assign db_clock = clock;
assign db_igual = s_igual;
assign db_timeout = s_timeout;

exp3_unidade_controle controlUnit (
    .clock      (clock),
    .reset      (reset),
    .iniciar    (iniciar),
    .fim        (s_fim),
    .jogada     (s_jogada),
    .igual      (s_igual),
    .zeraC      (s_zeraC),
    .contaC     (s_conta),
    .zeraR      (s_zeraR),
    .registraR  (s_registraR),
    .acertou    (acertou),
    .errou      (errou),
    .pronto     (pronto),
    .db_estado  (s_estado),
	 .contaT     (s_contaT),
	 .timeout    (s_timeout)
);

exp3_fluxo_dados fluxo_dados (
    .clock              (clock),
    .chaves             (chaves),
    .zeraR              (s_zeraR),
    .registraR          (s_registraR),
    .contaC             (s_conta),
    .zeraC              (s_zeraC),
    .igual              (s_igual),
    .fimC               (s_fim),
    .db_contagem        (s_contagem),
    .db_jogada          (s_chaves),
    .db_memoria         (s_memoria),
    .jogada_feita       (s_jogada),
	 .contaT     			(s_contaT),
	 .timeout    			(s_timeout)
	 
);

hexa7seg display_jogada (
    .hexa       (s_chaves),
    .display    (db_jogadafeita)
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

endmodule