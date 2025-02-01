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

module exp3_fluxo_dados (
    input clock,
    input zeraC,
    input contaC,
    input zeraR,
    input registraR,
    input [3:0] chaves,
	input contaT,
    output igual,
    output fimC,
    output jogada_feita,
    output db_tem_jogada,
    output [3:0] db_contagem,
    output [3:0] db_memoria,
    output [3:0] db_jogada,
	output timeout

);

    wire   [3:0] s_endereco, s_dado, s_chaves;  // sinal interno para interligacao dos componentes
    wire s_jogada;
    wire sinal = chaves[0] | chaves[1] | chaves[2] | chaves[3];

    // contador_163
    contador_163 contador (
        .clock    (clock),
        .clr      (~zeraC),
        .ld       (1'b1),
        .ent      (1'b1),
        .enp      (contaC),
        .D        (4'b0),
        .Q        (s_endereco),
        .rco      (fimC)
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
        .reset      (zeraC),
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
        .D      (chaves),
        .Q      (s_chaves)
    );

    // comparador_85
    comparador_85 comparador (
        .A    (s_dado),
        .B    (s_chaves),
        .ALBi (1'b0),
        .AGBi (1'b0),
        .AEBi (1'b1),
        .ALBo (    ),
        .AGBo (    ),
        .AEBo (igual)
    );

    // saida de depuracao
    assign db_contagem = s_endereco;
    assign db_memoria = s_dado;
    assign db_jogada = s_chaves;
    assign jogada_feita = s_jogada;
    assign db_tem_jogada = sinal;

 endmodule
