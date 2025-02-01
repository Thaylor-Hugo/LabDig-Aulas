/* --------------------------------------------------------------------
 * Arquivo   : circuito_exp5_acerto_tb.v
 * Projeto   : Experiencia 5 - Desenvolvimento de Projeto de 
 *             Circuitos Digitais em FPGA
 * --------------------------------------------------------------------
 * Descricao : testbench Verilog alterado para circuito da Experiencia 5 
 *              baseado no modelo fornecido
 *
 *             1) Plano de teste com todas jogadas certas
 *
 * --------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     27/01/2024  1.0     Edson Midorikawa  versao inicial
 *     16/01/2024  1.1     Edson Midorikawa  revisao
 *     25/01/2025  1.2     T5BB5             revisao
 * --------------------------------------------------------------------
 */

`timescale 1ns/1ns

module circuito_exp5_acerto_tb;

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
    wire [6:0] db_limite_out     ;
    wire       db_clock_out      ;
    wire       db_iniciar_out    ;
    wire       db_tem_jogada_out ;
    wire       db_timeout_out    ;

    // Configuração do clock
    parameter clockPeriod = 1_000_000; // in ns, f=1KHz

    // Identificacao do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // instanciacao do DUT (Device Under Test)
    circuito_exp5 dut (
        .clock          ( clock_in    ),
        .reset          ( reset_in    ),
        .iniciar        ( iniciar_in  ),
        .botoes         ( chaves_in   ),
        .acertou        ( acertou_out ),
        .errou          ( errou_out   ),
        .pronto         ( pronto_out  ),
        .leds           ( leds_out    ),
        .db_igual       ( db_igual_out       ),
        .db_contagem    ( db_contagem_out    ),
        .db_memoria     ( db_memoria_out     ),
        .db_estado      ( db_estado_out      ),
        .db_jogadafeita ( db_jogadafeita_out ),
        .db_limite      ( db_limite_out      ),
        .db_clock       ( db_clock_out       ),
        .db_iniciar     ( db_iniciar_out     ),    
        .db_tem_jogada  ( db_tem_jogada_out  ),
        .db_timeout     ( db_timeout_out     )
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

        // Teste 4. Rodada #0 - Chaves 0001
        caso = 4;
        @(negedge clock_in);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        // espera entre jogadas
        #(10*clockPeriod);

        // Teste 5. Rodada #1 Todas as anteriores + chaves 0010
        caso = 5;
        @(negedge clock_in);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;

        #(10*clockPeriod);
        chaves_in = 4'b0000;
        // espera entre jogadas
        #(10*clockPeriod);

        // Teste 6. Rodada #2 Todas as anteriores + chaves 0100
        caso = 6;
        @(negedge clock_in);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);

        chaves_in = 4'b0000;
        // espera entre jogadas
        #(10*clockPeriod);

        // Teste 7. Rodada #3 Todas as anteriores + chaves 1000
        caso = 7;
        @(negedge clock_in);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b1000;
        #(10*clockPeriod);

        chaves_in = 4'b0000;
        // espera entre jogadas
        #(10*clockPeriod);

        // Teste 8. Rodada #4 Todas as anteriores + chaves 0100
        caso = 8;
        @(negedge clock_in);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b1000;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);

        chaves_in = 4'b0000;
        // espera entre jogadas
        #(10*clockPeriod);

        // Teste 9. Rodada #5 Todas as anteriores + chaves 0010
        caso = 9;
        @(negedge clock_in);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b1000;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);

        chaves_in = 4'b0000;
        // espera entre jogadas
        #(10*clockPeriod);

        // Teste 10. Rodada #6 Todas as anteriores + chaves 0001
        caso = 10;
        @(negedge clock_in);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b1000;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0001;
        #(10*clockPeriod);

        chaves_in = 4'b0000;
        // espera entre jogadas
        #(10*clockPeriod);

        // Teste 11. Rodada #7 Todas as anteriores + chaves 0001
        caso = 11;
        @(negedge clock_in);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b1000;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0001;
        #(10*clockPeriod);

        chaves_in = 4'b0000;
        // espera entre jogadas
        #(10*clockPeriod);

        // Teste 12. Rodada #8 Todas as anteriores + chaves 0010
        caso = 12;
        @(negedge clock_in);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b1000;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);

        chaves_in = 4'b0000;
        // espera entre jogadas
        #(10*clockPeriod);

        // Teste 13. Rodada #9 Todas as anteriores + chaves 0010
        caso = 13;
        @(negedge clock_in);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b1000;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);

        chaves_in = 4'b0000;
        // espera entre jogadas
        #(10*clockPeriod);

        // Teste 14. Rodada #A Todas as anteriores + chaves 0100
        caso = 14;
        @(negedge clock_in);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b1000;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        
        chaves_in = 4'b0000;
        // espera entre jogadas
        #(10*clockPeriod);

        // Teste 15. Rodada #B Todas as anteriores + chaves 0100
        caso = 15;
        @(negedge clock_in);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b1000;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);

        chaves_in = 4'b0000;
        // espera entre jogadas
        #(10*clockPeriod);

        // Teste 16. Rodada #C Todas as anteriores + chaves 1000
        caso = 16;
        @(negedge clock_in);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b1000;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b1000;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);

        chaves_in = 4'b0000;
        // espera entre jogadas
        #(10*clockPeriod);

        // Teste 17. Rodada #D Todas as anteriores + chaves 1000
        caso = 17;
        @(negedge clock_in);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b1000;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b1000;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b1000;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);

        chaves_in = 4'b0000;
        // espera entre jogadas
        #(10*clockPeriod);

        // Teste 18. Rodada #E Todas as anteriores + chaves 0001
        caso = 18;
        @(negedge clock_in);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b1000;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b1000;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b1000;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);

        chaves_in = 4'b0000;
        // espera entre jogadas
        #(10*clockPeriod);

        // Teste 19. Rodada #F Todas as anteriores + chaves 0100
        caso = 19;
        @(negedge clock_in);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b1000;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0010;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b1000;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b1000;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0001;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        chaves_in = 4'b0100;
        #(10*clockPeriod);
        chaves_in = 4'b0000;
        #(10*clockPeriod);
        
        chaves_in = 4'b0000;
        // espera entre jogadas
        #(10*clockPeriod);

        // Teste 20. Iniciar nova tentativa
        caso = 20;
        @(negedge clock_in);
        iniciar_in = 1;
        #(5*clockPeriod);
        iniciar_in = 0;
        // espera
        #(10*clockPeriod);
        
        // Teste 21. Resetar circuito
        caso = 21;
        @(negedge clock_in);
        reset_in = 1;
        #(5*clockPeriod);
        reset_in = 0;
        // espera
        #(10*clockPeriod);

        // final dos casos de teste da simulacao
        caso = 99;
        #100;
        $display("Fim da simulacao");
        $stop;
    end

  endmodule
