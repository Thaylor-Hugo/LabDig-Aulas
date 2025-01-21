`timescale 1ns/1ns

module circuito_exp3_desafio_tb;

    // Sinais para conectar com o DUT
    // valores iniciais para fins de simulacao (ModelSim)
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        iniciar_in = 0;
    reg  [3:0] chaves_in  = 4'b0000;
    wire       pronto_out;
    wire       db_igual_out;
    wire       db_iniciar_out;
    wire [6:0] db_contagem_out;
    wire [6:0] db_memoria_out;
    wire [6:0] db_chaves_out;
    wire [6:0] db_estado_out;
    wire [3:0] db_estado_enum;
    wire [3:0] db_contagem_enum;
    wire [3:0] db_memoria_enum;
    wire [3:0] db_chaves_enum;

    // Configuração do clock
    parameter clockPeriod = 20; // in ns, f=50MHz

    // Identificacao do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // instanciacao do DUT (Device Under Test)
    circuito_exp3_desafio dut (
      .clock       ( clock_in        ),
      .reset       ( reset_in        ),
      .iniciar     ( iniciar_in      ),
      .chaves      ( chaves_in       ),
      .pronto      ( pronto_out      ),
      .acertou     ( acertou_out     ),
	    .errou	     ( errou_out		   ),
      .db_igual    ( db_igual_out    ),
      .db_iniciar  ( db_iniciar_out  ),
      .db_contagem ( db_contagem_out ),
      .db_memoria  ( db_memoria_out  ),
      .db_chaves   ( db_chaves_out   ),
      .db_estado   ( db_estado_out   ),
      .dec_chaves  ( db_chaves_enum  ),
      .dec_contagem( db_contagem_enum),
      .dec_memoria ( db_memoria_enum ),
      .dec_estado  ( db_estado_enum  )
    );

    // geracao dos sinais de entrada (estimulos)
    initial begin
      $display("Inicio da simulacao");

      // condicoes iniciais
      caso       = 0;
      clock_in   = 1;
      reset_in   = 0;
      iniciar_in = 0;
      chaves_in  = 4'b0000;
      #clockPeriod;

      // Teste 1 (resetar circuito)
      caso = 1;
      // gera pulso de reset
      @(negedge clock_in);
      reset_in = 1;
      #(clockPeriod);
      reset_in = 0;

      // Teste 2 (iniciar=0 por 5 periodos de clock)
      caso = 2;
      iniciar_in = 1;
      #(clockPeriod);
      iniciar_in = 0;
      chaves_in = 4'b0001;
      #(2*clockPeriod);

      // Teste 3 (ajustar chaves para 0100, acionar iniciar por 1 periodo de clock)
      caso = 3;
      chaves_in = 4'b0010;
      #(3*clockPeriod);
      // Teste 4 (manter chaves em 0100 por 1 periodo de clock)
      caso = 4;
      chaves_in = 4'b0100;
      #(3*clockPeriod);

      // Teste 4 (manter chaves em 0100 por 1 periodo de clock)
      caso = 5;
      chaves_in = 4'b1000;
      #(3*clockPeriod);

      // Teste 4 (manter chaves em 0100 por 1 periodo de clock)
      caso = 6;
      chaves_in = 4'b0100;
      #(3*clockPeriod);

      // Teste 4 (manter chaves em 0100 por 1 periodo de clock)
      caso = 7;
      chaves_in = 4'b0010;
      #(3*clockPeriod);

      // Teste 4 (manter chaves em 0100 por 1 periodo de clock)
      caso = 8;
      chaves_in = 4'b0001;
      #(3*clockPeriod);

      // Teste 4 (manter chaves em 0100 por 1 periodo de clock)
      caso = 9;
      chaves_in = 4'b0001;
      #(3*clockPeriod);

      // Teste 4 (manter chaves em 0100 por 1 periodo de clock)
      caso = 10;
      chaves_in = 4'b0010;
      #(3*clockPeriod);

      // Teste 4 (manter chaves em 0100 por 1 periodo de clock)
      caso = 11;
      chaves_in = 4'b0010;
      #(3*clockPeriod);

      // Teste 4 (manter chaves em 0100 por 1 periodo de clock)
      caso = 12;
      chaves_in = 4'b0100;
      #(3*clockPeriod);

      caso = 13;
      chaves_in = 4'b0100;
      #(3*clockPeriod);

      caso = 14;
      chaves_in = 4'b1000;
      #(3*clockPeriod);

      caso = 15;
      chaves_in = 4'b1000;
      #(3*clockPeriod);

      caso = 16;
      chaves_in = 4'b0001;
      #(3*clockPeriod);

      caso = 17;
      chaves_in = 4'b1110;
      #(4*clockPeriod);

      // final dos casos de teste da simulacao
      caso = 99;
      #100;
      $display("Fim da simulacao");
      $stop;
    end

  endmodule
