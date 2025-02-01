`timescale 1ns/1ns

module circuito_exp4_desafioo_tb;

    // Sinais para conectar com o DUT
    // valores iniciais para fins de simulacao (ModelSim)
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        iniciar_in = 0;
    reg  [3:0] chaves_in  = 4'b0000;

    wire       acertou_out;
    wire       errou_out  ;
    wire       pronto_out ;
    wire [3:0] leds_out   ;

    wire       db_igual_out      ;
    wire [6:0] db_contagem_out   ;
    wire [6:0] db_memoria_out    ;
    wire [6:0] db_estado_out     ;
    wire [6:0] db_jogadafeita_out;
    wire       db_clock_out      ;
    wire       db_iniciar_out    ;
    wire       db_tem_jogada_out ;
    wire       db_timeout_out;

    // Configuração do clock
    parameter clockPeriod = 1_000_000; // in ns, f=1KHz

    // Identificacao do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // instanciacao do DUT (Device Under Test)
    circuito_exp4 dut (
        .clock          ( clock_in    ),
        .reset          ( reset_in    ),
        .iniciar        ( iniciar_in  ),
        .chaves         ( chaves_in   ),
        .acertou        ( acertou_out ),
        .errou          ( errou_out   ),
        .pronto         ( pronto_out  ),
        .leds           ( leds_out    ),
        .db_igual       ( db_igual_out       ),
        .db_contagem    ( db_contagem_out    ),
        .db_memoria     ( db_memoria_out     ),
        .db_estado      ( db_estado_out      ),
        .db_jogadafeita ( db_jogadafeita_out ),
        .db_clock       ( db_clock_out       ),
        .db_iniciar     ( db_iniciar_out     ),    
        .db_tem_jogada  ( db_tem_jogada_out  ),
        .db_timeout     (db_timeout_out) 
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

        /*
        * Cenario de Teste exemplo - acerta 4 jogadas e erra a 5a jogada
        */

        // Teste 1. resetar circuito
        caso = 1;
        // gera pulso de reset
        @(negedge clock_in);
        reset_in = 1;
        #(clockPeriod);
        reset_in = 0;
        // espera
        #(10*clockPeriod);


        // Teste 2. aguardar por 10 periodos de clock
        caso = 2;
        #(10*clockPeriod);


        // Teste 3. iniciar=1 por 5 periodos de clock
        caso = 3;
        iniciar_in = 1;
        #(5*clockPeriod);
        iniciar_in = 0;
        // espera
        #(10*clockPeriod);

        // Teste 4. jogada #0 (ajustar chaves para 0001 por 10 periodos de clock
        caso = 4;
        @(negedge clock_in);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        // espera entre jogadas
        #(10*clockPeriod);

        // Teste 5. jogada #1 (ajustar chaves para 0010 por 10 periodos de clock
        caso = 5;
        @(negedge clock_in);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        // espera entre jogadas
        #(10*clockPeriod); 
        #(10000*clockPeriod);

        // final dos casos de teste da simulacao
        caso = 99;
        #100;
        $display("Fim da simulacao");
        $stop;
    end

  endmodule