//------------------------------------------------------------------
// Arquivo   : circuito_exp5.v
// Projeto   : Experiencia 5 - Projeto de um Sistema Digital 
//------------------------------------------------------------------
// Descricao : Modulo principal da experiencia
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor            Descricao
//     18/01/2025  1.0     T5BB5            versao inicial
//------------------------------------------------------------------
//

module circuito_exp5 (
    input clock,
    input reset,
    input iniciar,
    input [3:0] botoes,
    output acertou,
    output errou,
    output pronto,
    output [3:0] leds,
    output db_igual,
    output [6:0] db_contagem,
    output [6:0] db_memoria,
    output [6:0] db_estado,
    output [6:0] db_jogadafeita,
    output [6:0] db_limite,
    output db_clock,
    output db_iniciar,
    output db_tem_jogada,
	output db_timeout
);


wire [3:0] s_botoes, s_memoria, s_contagem, s_estado, s_limite;
wire s_fimE, s_fimL, s_botoes_igual_memoria, s_zeraE, s_zeraL, s_contaE, s_contaL, s_zeraR, s_registraR, s_jogada, s_timeout, s_contaT, s_endereco_igual_limite, s_endereco_menor_limite;

assign leds = s_botoes;
assign db_iniciar = iniciar;
assign db_clock = clock;
assign db_igual = s_botoes_igual_memoria;
assign db_timeout = s_timeout;

unidade_controle controlUnit (
    .clock                  (clock),
    .reset                  (reset),
    .iniciar                (iniciar),
    .jogada                 (s_jogada),
	.timeout                (s_timeout),
    .botoesIgualMemoria     (s_botoes_igual_memoria),
    .fimE                   (s_fimE),
    .fimL                   (s_fimL),
    .enderecoIgualLimite    (s_endereco_igual_limite),
    .enderecoMenorLimite    (s_endereco_menor_limite),
    .zeraE                  (s_zeraE),
    .contaE                 (s_contaE),
    .zeraL                  (s_zeraL),
    .contaL                 (s_contaL),
    .zeraR                  (s_zeraR),
    .registraR              (s_registraR),
    .acertou                (acertou),
    .errou                  (errou),
    .pronto                 (pronto),
    .db_estado              (s_estado),
	.contaT                 (s_contaT)
);

fluxo_dados fluxo_dados (
    .clock                  (clock),
    .zeraE                  (s_zeraE),
    .contaE                 (s_contaE),
    .zeraL                  (s_zeraL),
    .contaL                 (s_contaL),
    .zeraR                  (s_zeraE),
    .registraR              (s_registraR),
    .botoes                 (botoes),
	.contaT                 (s_contaT),
    .botoesIgualMemoria     (s_botoes_igual_memoria),
    .fimE                   (s_fimE),
    .fimL                   (s_fimL),
    .endecoIgualLimite      (s_endereco_igual_limite),
    .endecoMenorLimite      (s_endereco_menor_limite),
    .jogada_feita           (s_jogada),
    .db_tem_jogada          (db_tem_jogada),
    .db_limite              (s_limite),
    .db_contagem            (s_contagem),
    .db_memoria             (s_memoria),
    .db_jogada              (s_botoes),
	.timeout                (s_timeout)
	 
);

hexa7seg display_jogada (
    .hexa       (s_botoes),
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

hexa7seg display_limite (
    .hexa       (s_limite),
    .display    (db_limite)
);

endmodule