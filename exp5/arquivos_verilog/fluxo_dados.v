//------------------------------------------------------------------
// Arquivo   : exp3_fluxo_dados.v
// Projeto   : Experiencia 3 - Projeto de uma Unidade de Controle 
//------------------------------------------------------------------
// Descricao : Modulo do fluxo de dados da experiencia
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor            Descricao
//     18/01/2025  1.0     T5BB5            versao inicial
//------------------------------------------------------------------
//

module fluxo_dados (
    input clock,
    input zeraE,
    input contaE,
    input zeraL,
    input contaL,
    input zeraR,
    input registraR,
    input [3:0] botoes,
	input contaT,
    output botoesIgualMemoria,
    output fimE,
    output fimL,
    output endecoIgualLimite,
    output endecoMenorLimite,
    output jogada_feita,
    output db_tem_jogada,
    output [3:0] db_limite,
    output [3:0] db_contagem,
    output [3:0] db_memoria,
    output [3:0] db_jogada,
	output timeout

);

    wire [3:0] s_endereco, s_dado, s_botoes, s_limite;  // sinal interno para interligacao dos componentes
    wire s_jogada;
    wire sinal = botoes[0] | botoes[1] | botoes[2] | botoes[3];

    // contador_163
    contador_163 contador (
        .clock    (clock),
        .clr      (~zeraE),
        .ld       (1'b1),
        .ent      (1'b1),
        .enp      (contaE),
        .D        (4'b0),
        .Q        (s_endereco),
        .rco      (fimE)
    );

    // contador_163
    contador_163 contadorLmt (
        .clock    (clock),
        .clr      (~zeraL),
        .ld       (1'b1),
        .ent      (1'b1),
        .enp      (contaL),
        .D        (4'b0),
        .Q        (s_limite),
        .rco      (fimL)
    );
	 
	 // contador_m
    contador_m  #(.M(4000), .N(16)) contador_timeout (
       .clock     (clock),   
       .zera_as   (~contaT),
       .zera_s    (1'b0),
       .conta	  (contaT),
       .Q         (),
       .fim       (timeout),
       .meio      ()
    );

     // edge_detector
    edge_detector detector (
        .clock      (clock), 
        .reset      (zeraL),
        .sinal      (sinal),
        .pulso      (s_jogada)
    );

    // memoria_rom_16x4
    sync_rom_16x4 rom (
        .clock      (clock),
        .address    (s_endereco),
        .data_out   (s_dado)
    );

    // registrador de 4 bits
    registrador_4 registrador (
        .clock  (clock),
        .clear  (zeraR),
        .enable (registraR),
        .D      (botoes),
        .Q      (s_botoes)
    );

    // comparador_85
    comparador_85 comparador (
        .A    (s_dado),
        .B    (s_botoes),
        .ALBi (1'b0),
        .AGBi (1'b0),
        .AEBi (1'b1),
        .ALBo (    ),
        .AGBo (    ),
        .AEBo (botoesIgualMemoria)
    );
    
    // comparador_85
    comparador_85 comparadorLmt (
        .A    (s_endereco),
        .B    (s_limite),
        .ALBi (1'b0),
        .AGBi (1'b0),
        .AEBi (1'b1),
        .ALBo (endecoMenorLimite),
        .AGBo (    ),
        .AEBo (endecoIgualLimite)
    );

    // saida de depuracao
    assign db_contagem = s_endereco;
    assign db_memoria = s_dado;
    assign db_jogada = s_botoes;
    assign jogada_feita = s_jogada;
    assign db_tem_jogada = sinal;
    assign db_limite = s_limite;

 endmodule
