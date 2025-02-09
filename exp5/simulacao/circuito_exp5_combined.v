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
	 input botaoDificuldade,
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
	 output db_timeout,
	 output db_dificuldade
);


wire [3:0] s_botoes, s_memoria, s_contagem, s_estado, s_limite;
wire s_fimE, s_fimL, s_botoes_igual_memoria,s_meioL, s_dificuldade, s_zeraE, s_zeraL, s_contaE, s_contaL, s_zeraR, s_registraR, s_jogada, s_timeout, s_contaT, s_endereco_igual_limite, s_endereco_menor_limite;

assign leds = s_botoes;
assign db_iniciar = iniciar;
assign db_clock = clock;
assign db_igual = s_botoes_igual_memoria;
assign db_timeout = s_timeout;
assign db_dificuldade = s_dificuldade;

unidade_controle controlUnit (
    .clock                  (clock),
    .reset                  (reset),
    .iniciar                (iniciar),
    .jogada                 (s_jogada),
	.timeout                (s_timeout),
    .botoesIgualMemoria     (s_botoes_igual_memoria),
    .fimE                   (s_fimE),
    .fimL                   (s_fimL),
	 .meioL						 (s_meioL),
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
	.contaT                 (s_contaT),
	.db_dificuldade 			(s_dificuldade),
	.chaveDificuldade			(botaoDificuldade)
);

fluxo_dados fluxo_dados (
    .clock                  (clock),
    .zeraE                  (s_zeraE),
    .contaE                 (s_contaE),
    .zeraL                  (s_zeraL),
    .contaL                 (s_contaL),
    .zeraR                  (s_zeraR),
    .registraR              (s_registraR),
    .botoes                 (botoes),
	 .contaT                 (s_contaT),
    .botoesIgualMemoria     (s_botoes_igual_memoria),
    .fimE                   (s_fimE),
    .fimL                   (s_fimL),
	 .meioL 						 (s_meioL),
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

endmodule/* -----------------------------------------------------------------
 *  Arquivo   : comparador_85.v
 *  Projeto   : Experiencia 2 - Um Fluxo de Dados Simples
 * -----------------------------------------------------------------
 * Descricao : comparador de magnitude de 4 bits 
 *             similar ao CI 7485
 *             baseado em descricao comportamental disponivel em	
 * https://web.eecs.umich.edu/~jhayes/iscas.restore/74L85b.v
 * -----------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     21/12/2023  1.0     Edson Midorikawa  criacao
 * -----------------------------------------------------------------
 */

module comparador_85 (ALBi, AGBi, AEBi, A, B, ALBo, AGBo, AEBo);

    input[3:0] A, B;
    input      ALBi, AGBi, AEBi;
    output     ALBo, AGBo, AEBo;
    wire[4:0]  CSL, CSG;

    assign CSL  = ~A + B + ALBi;
    assign ALBo = ~CSL[4];
    assign CSG  = A + ~B + AGBi;
    assign AGBo = ~CSG[4];
    assign AEBo = ((A == B) && AEBi);

endmodule /* comparador_85 *///------------------------------------------------------------------
// Arquivo   : contador_163.v
// Projeto   : Experiencia 2 - Um Fluxo de Dados Simples
//------------------------------------------------------------------
// Descricao : Contador binario de 4 bits, modulo 16
//             similar ao componente 74163
//
// baseado no componente Vrcntr4u.v do livro Digital Design Principles 
// and Practices, Fifth Edition, by John F. Wakerly              
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/12/2023  1.0     Edson Midorikawa  versao inicial
//------------------------------------------------------------------
//
module contador_163 ( clock, clr, ld, ent, enp, D, Q, rco );
    input clock, clr, ld, ent, enp;
    input [3:0] D;
    output reg [3:0] Q;
    output reg rco;

    always @ (posedge clock)
        if (~clr)               Q <= 4'd0;
        else if (~ld)           Q <= D;
        else if (ent && enp)    Q <= Q + 1'b1;
        else                    Q <= Q;
 
    always @ (Q or ent)
        if (ent && (Q == 4'd15))   rco = 1;
        else                       rco = 0;
endmodule
/*---------------Laboratorio Digital-------------------------------------
 * Arquivo   : contador_m.v
 * Projeto   : Experiencia 4 - Desenvolvimento de Projeto de 
 *                             Circuitos Digitais em FPGA
 *-----------------------------------------------------------------------
 * Descricao : contador binario, modulo m, com parametros 
 *             M (modulo do contador) e N (numero de bits),
 *             sinais para clear assincrono (zera_as) e sincrono (zera_s)
 *             e saidas de fim e meio de contagem
 *             
 *-----------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     30/01/2024  1.0     Edson Midorikawa  criacao
 *     16/01/2025  1.1     Edson Midorikawa  revisao
 *-----------------------------------------------------------------------
 */

module contador_m #(parameter M=100, N=7)
  (
   input  wire          clock,
   input  wire          zera_as,
   input  wire          zera_s,
   input  wire          conta,
   output reg  [N-1:0]  Q,
   output reg           fim,
   output reg           meio
  );

  always @(posedge clock or posedge zera_as) begin
    if (zera_as) begin
      Q <= 0;
    end else if (clock) begin
      if (zera_s) begin
        Q <= 0;
      end else if (conta) begin
        if (Q == M-1) begin
          Q <= 0;
        end else begin
          Q <= Q + 1'b1;
        end
      end
    end
  end

  // Saidas
  always @ (Q)
      if (Q == M-1)   fim = 1;
      else            fim = 0;

  always @ (Q)
      if (Q == M/2-1) meio = 1;
      else            meio = 0;

endmodule
/* ------------------------------------------------------------------------
 *  Arquivo   : edge_detector.v
 *  Projeto   : Experiencia 4 - Desenvolvimento de Projeto de
 *                              Circuitos Digitais com FPGA
 * ------------------------------------------------------------------------
 *  Descricao : detector de borda
 *              gera um pulso na saida de 1 periodo de clock
 *              a partir da detecao da borda de subida sa entrada
 * 
 *              sinal de reset ativo em alto
 * 
 *              > codigo adaptado a partir de codigo VHDL disponivel em
 *                https://surf-vhdl.com/how-to-design-a-good-edge-detector/
 * ------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      26/01/2024  1.0     Edson Midorikawa  versao inicial
 * ------------------------------------------------------------------------
 */
 
module edge_detector (
    input  clock,
    input  reset,
    input  sinal,
    output pulso
);

    reg reg0;
    reg reg1;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            reg0 <= 1'b0;
            reg1 <= 1'b0;
        end else if (clock) begin
            reg0 <= sinal;
            reg1 <= reg0;
        end
    end

    assign pulso = ~reg1 & reg0;

endmodule
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
	 output meioL,
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

   
	 
	 // contador_m
    contador_m  #(.M(16),.N(16)) contadorLmt (
       .clock     (clock),   
       .zera_as   (zeraL),
       .zera_s    (1'b0),
       .conta	  (contaL),
       .Q         (s_limite),
       .fim       (fimL),
       .meio      (meioL)
    );
	 
	 // contador_m
    contador_m  #(.M(4000), .N(16)) contador_timeout (
       .clock     (clock),   
       .zera_as   (~contaT),
       .zera_s    (1'b0),
       .conta	   (contaT),
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
/* ----------------------------------------------------------------
 * Arquivo   : hexa7seg.v
 * Projeto   : Experiencia 2 - Um Fluxo de Dados Simples
 *--------------------------------------------------------------
 * Descricao : decodificador hexadecimal para 
 *             display de 7 segmentos 
 * 
 * entrada : hexa - codigo binario de 4 bits hexadecimal
 * saida   : sseg - codigo de 7 bits para display de 7 segmentos
 *
 * baseado no componente bcd7seg.v da Intel FPGA
 *--------------------------------------------------------------
 * dica de uso: mapeamento para displays da placa DE0-CV
 *              bit 6 mais significativo é o bit a esquerda
 *              p.ex. sseg(6) -> HEX0[6] ou HEX06
 *--------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     24/12/2023  1.0     Edson Midorikawa  criacao
 *--------------------------------------------------------------
 */

module hexa7seg (hexa, display);
    input      [3:0] hexa;
    output reg [6:0] display;

    /*
     *    ---
     *   | 0 |
     * 5 |   | 1
     *   |   |
     *    ---
     *   | 6 |
     * 4 |   | 2
     *   |   |
     *    ---
     *     3
     */
        
    always @(hexa)
    case (hexa)
        4'h0:    display = 7'b1000000;
        4'h1:    display = 7'b1111001;
        4'h2:    display = 7'b0100100;
        4'h3:    display = 7'b0110000;
        4'h4:    display = 7'b0011001;
        4'h5:    display = 7'b0010010;
        4'h6:    display = 7'b0000010;
        4'h7:    display = 7'b1111000;
        4'h8:    display = 7'b0000000;
        4'h9:    display = 7'b0010000;
        4'ha:    display = 7'b0001000;
        4'hb:    display = 7'b0000011;
        4'hc:    display = 7'b1000110;
        4'hd:    display = 7'b0100001;
        4'he:    display = 7'b0000110;
        4'hf:    display = 7'b0001110;
        default: display = 7'b1111111;
    endcase
endmodule
/*------------------------------------------------------------------------
 * Arquivo   : mux2x1.v
 * Projeto   : Jogo do Desafio da Memoria
 *------------------------------------------------------------------------
 * Descricao : multiplexador 2x1
 * 
 * adaptado a partir do codigo my_4t1_mux.vhd do livro "Free Range VHDL"
 * 
 * exemplo de uso: ver testbench mux2x1_tb.v
 *------------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     15/02/2024  1.0     Edson Midorikawa  criacao
 *     31/01/2025  1.1     Edson Midorikawa  revisao
 *------------------------------------------------------------------------
 */

module mux2x1 (
    input      D0,
    input      D1,
    input      SEL,
    output reg OUT
);

always @(*) begin
    case (SEL)
        1'b0:    OUT = D0;
        1'b1:    OUT = D1;
        default: OUT = 1'b1; // saida em 1
    endcase
end

endmodule
//------------------------------------------------------------------
// Arquivo   : registrador_4.v
// Projeto   : Experiencia 3 - Projeto de uma Unidade de Controle 
//------------------------------------------------------------------
// Descricao : Registrador de 4 bits
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/12/2023  1.0     Edson Midorikawa  versao inicial
//------------------------------------------------------------------
//
module registrador_4 (
    input        clock,
    input        clear,
    input        enable,
    input  [3:0] D,
    output [3:0] Q
);

    reg [3:0] IQ;

    always @(posedge clock or posedge clear) begin
        if (clear)
            IQ <= 0;
        else if (enable)
            IQ <= D;
    end

    assign Q = IQ;

endmodule//------------------------------------------------------------------
// Arquivo   : sync_rom_16x4.v
// Projeto   : Experiencia 3 - Projeto de uma Unidade de Controle 
//------------------------------------------------------------------
// Descricao : ROM sincrona 16x4 (conteúdo pre-programado)
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/12/2023  1.0     Edson Midorikawa  versao inicial
//------------------------------------------------------------------
//
module sync_rom_16x4 (clock, address, data_out);
    input            clock;
    input      [3:0] address;
    output reg [3:0] data_out;

    always @ (posedge clock)
    begin
        case (address)
            4'b0000: data_out = 4'b0001; //1
            4'b0001: data_out = 4'b0010; //2
            4'b0010: data_out = 4'b0100; //3
            4'b0011: data_out = 4'b1000; //4
            4'b0100: data_out = 4'b0100; //5
            4'b0101: data_out = 4'b0010; //6
            4'b0110: data_out = 4'b0001; //7
            4'b0111: data_out = 4'b0001; //8
            4'b1000: data_out = 4'b0010; //9
            4'b1001: data_out = 4'b0010; //10
            4'b1010: data_out = 4'b0100; //11
            4'b1011: data_out = 4'b0100; //12
            4'b1100: data_out = 4'b1000; //13
            4'b1101: data_out = 4'b1000; //14
            4'b1110: data_out = 4'b0001; //15
            4'b1111: data_out = 4'b0100; //16
        endcase
    end
endmodule

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

module unidade_controle (
    input clock,
    input reset,
    input iniciar,
    input jogada,
	 input timeout,
    input botoesIgualMemoria,
    input fimE,
    input fimL,
	 input meioL,
    input enderecoIgualLimite,
    input enderecoMenorLimite,
	 input chaveDificuldade,
    output reg zeraE,
    output reg contaE,
    output reg zeraL,
    output reg contaL,
    output reg zeraR,
    output reg registraR,
    output reg acertou,
    output reg errou,
    output reg pronto,
    output reg [3:0] db_estado,
	 output reg contaT,
	 output  db_dificuldade
);

    // Define estados
    parameter inicial               = 4'b0000;  // 0
    parameter preparacao            = 4'b0001;  // 1
    parameter inicia_sequencia      = 4'b0010;  // 2
    parameter espera_jogada         = 4'b0011;  // 3
    parameter registra_jogada       = 4'b0100;  // 4
    parameter compara_jogada        = 4'b0101;  // 5
    parameter proxima_jogada        = 4'b0110;  // 6
    parameter foi_ultima_sequencia  = 4'b0111;  // 7
    parameter proxima_sequencia     = 4'b1000;  // 8
    parameter final_timeout 	    	= 4'b1101;  // D
    parameter final_acertou         = 4'b1110;  // E
    parameter final_errou           = 4'b1111;  // F
	 

    // Variaveis de estado
    reg [3:0] Eatual, Eprox;
	 reg Dificuldade;

    initial begin
        Eatual = inicial;
		  Dificuldade = 1'b0;
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
            inicia_sequencia: Eprox <= espera_jogada;
            espera_jogada:    begin 
                if (jogada) begin
					Eprox <= registra_jogada;
				end else if (timeout) begin
					Eprox <= final_timeout;
				end else begin
					Eprox <= espera_jogada;
				end
            end													
            registra_jogada:  Eprox <= compara_jogada;
            compara_jogada:   begin 
                if (enderecoMenorLimite && botoesIgualMemoria) begin
					Eprox <= proxima_jogada;
				end else if (enderecoIgualLimite && botoesIgualMemoria) begin
					Eprox <= foi_ultima_sequencia ;
				end else begin
					Eprox <= final_errou;
				end
            end													
            proxima_jogada:         Eprox <= espera_jogada;
            foi_ultima_sequencia:   Eprox <= (fimL || (meioL && ~Dificuldade)) ? final_acertou : proxima_sequencia;
            proxima_sequencia:      Eprox <= espera_jogada;
			   final_timeout:          Eprox <= iniciar ? preparacao : final_timeout;
            final_errou:            Eprox <= iniciar ? preparacao : final_errou;
            final_acertou:          Eprox <= iniciar ? preparacao : final_acertou;
            default:                Eprox <= inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraL     	<= (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        zeraR     	<= (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        zeraE     	<= (Eatual == inicial || Eatual == preparacao || Eatual == proxima_sequencia) ? 1'b1 : 1'b0;
        registraR 	<= (Eatual == registra_jogada) ? 1'b1 : 1'b0;
        contaL    	<= (Eatual == proxima_sequencia) ? 1'b1 : 1'b0;
        contaE    	<= (Eatual == proxima_jogada) ? 1'b1 : 1'b0;
        pronto    	<= (Eatual == final_acertou || Eatual == final_errou || Eatual == final_timeout) ? 1'b1 : 1'b0;
        acertou   	<= (Eatual == final_acertou) ? 1'b1 : 1'b0;
        errou     	<= (Eatual == final_errou) ? 1'b1 : 1'b0;
		  contaT	   	<= (Eatual == espera_jogada) ? 1'b1 : 1'b0;
		  if (Eatual == preparacao) begin 
				Dificuldade <= chaveDificuldade;
			end

        // Saida de depuracao (estado)
        case (Eatual)
            inicial:                db_estado <= 4'b0000;  // 0
            preparacao:             db_estado <= 4'b0001;  // 1
            inicia_sequencia:       db_estado <= 4'b0010;  // 2
            espera_jogada:          db_estado <= 4'b0011;  // 3
            registra_jogada:        db_estado <= 4'b0100;  // 4
            compara_jogada:         db_estado <= 4'b0101;  // 5
            proxima_jogada:         db_estado <= 4'b0110;  // 6
            foi_ultima_sequencia:   db_estado <= 4'b0111;  // 7
            proxima_sequencia:      db_estado <= 4'b1000;  // 8
			   final_timeout:	 	    db_estado <= 4'b1101;  // D
            final_acertou:          db_estado <= 4'b1110;  // E
            final_errou:            db_estado <= 4'b1111;  // F
            default:                db_estado <= 4'b1001;  // 9 ERRO
        endcase
    end
	
	assign db_dificuldade = Dificuldade;

endmodule