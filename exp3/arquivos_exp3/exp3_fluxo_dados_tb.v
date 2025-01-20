/* --------------------------------------------------------------------
 * Arquivo   : exp3_fluxo_dados_tb.vhd
 * Projeto   : Experiencia 3 - Projeto de uma Unidade de Controle
 * --------------------------------------------------------------------
 * Descricao : testbench Verilog para circuito do fluxo de dados
 *             da Experiencia 4 
 *
 *             1) plano de teste: 11 casos de teste
 *
 * --------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     16/01/2024  1.0     Edson Midorikawa  versao inicial
 * --------------------------------------------------------------------
*/

`timescale 1ns/1ns

module exp3_fluxo_dados_tb;

    // Sinais para conectar com o DUT
    // valores iniciais para fins de simulacao (ModelSim)
    reg        clock_in     = 1;
    reg        zeraC_in     = 0;
    reg        contaC_in    = 0;
    reg        zeraR_in     = 0;
    reg        registraR_in = 0;
    reg  [3:0] chaves_in    = 4'b0000;
    wire       chavesIgualMemoria_out;
    wire       fimC_out;
    wire [3:0] contagem_out;
    wire [3:0] memoria_out;
    wire [3:0] chaves_out;

    wire       notZeraC_out;
    wire       notZeraR_out;

    // Configuração do clock
    parameter clockPeriod = 20; // in ns, f=50MHz

    // Identificacao do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // instanciacao do DUT (Device Under Test)
    exp3_fluxo_dados dut (
      .clock              ( clock_in               ),
      .zeraR              ( zeraR_in               ),
      .registraR          ( registraR_in           ),
      .contaC             ( contaC_in              ),
      .zeraC              ( zeraC_in               ),
      .chaves             ( chaves_in              ),
      .chavesIgualMemoria ( chavesIgualMemoria_out ),
      .fimC               ( fimC_out               ),
      .db_contagem        ( contagem_out           ),
      .db_chaves          ( chaves_out             ),
      .db_memoria         ( memoria_out            )
    );

    // geracao dos sinais de entrada (estimulos)
    initial begin
      $display("Inicio da simulacao");

      // condicoes iniciais
      caso       = 0;
      clock_in     = 1;
      zeraC_in     = 0;
      contaC_in    = 0;
      zeraR_in     = 0;
      registraR_in = 0;
      chaves_in    = 4'b0000;
      #clockPeriod;

      // Teste 1 (zera contador e registrador)
      caso = 1;
      // gera pulso de reset
      @(negedge clock_in);
      zeraC_in     = 1;
      zeraR_in     = 1;
      #(clockPeriod);
      zeraC_in     = 0;
      zeraR_in     = 0;
      #(clockPeriod);

      // Teste 2 (chaves=0001, endereco=0000, dado=0001, igual=0)
      caso = 2;
      chaves_in    = 4'b0001;
      #(2*clockPeriod);

      // Teste 3 (chaves=0001, registra chaves => db_chaves=0001)
      caso = 3;
      @(negedge clock_in);
      chaves_in    = 4'b0001;
      registraR_in = 1;
      #(clockPeriod);
      registraR_in = 0;

      // Teste 4 (chaves=0001, endereco=0000, dado=0001, igual=1)
      caso = 4;
      @(negedge clock_in);
      chaves_in    = 4'b0001;
      #(clockPeriod);

      // Teste 5 (incrementa contador, endereco=0001)
      caso = 5;
      @(negedge clock_in);
      chaves_in    = 4'b0001;
      contaC_in    = 1;
      #(clockPeriod);
      contaC_in    = 0;

      // Teste 6 (chaves=0010, registra chaves => db_chaves=0010)
      caso = 6;
      @(negedge clock_in);
      chaves_in    = 4'b0010;
      registraR_in = 1;
      #(clockPeriod);
      registraR_in = 0;

      // Teste 7 (chaves=0010, endereco=0001, dado=0010, igual=1)
      caso = 7;
      @(negedge clock_in);
      chaves_in    = 4'b0010;
      #(clockPeriod);

      // Teste 8 (incrementa contador, endereco=0010)
      caso = 8;
      @(negedge clock_in);
      chaves_in    = 4'b0010;
      contaC_in    = 1;
      #(clockPeriod);
      contaC_in    = 0;

      // Teste 9 (chaves=1000, registra chaves => db_chaves=1000)
      caso = 9;
      @(negedge clock_in);
      chaves_in    = 4'b1000;
      registraR_in = 1;
      #(clockPeriod);
      registraR_in = 0;

      // Teste 10 (chaves=1000, endereco=0010, dado=0100, igual=0)
      caso = 10;
      @(negedge clock_in);
      chaves_in    = 4'b1000;
      #(clockPeriod);

      // Teste 11 (incrementa contador até 15 (incrementa 13x) => fimC=1)
      caso = 11;
      @(negedge clock_in);
      chaves_in    = 4'b1000;
      repeat (13) begin
         contaC_in    = 1;
         #(clockPeriod);
         contaC_in    = 0;
         #(clockPeriod);
      end


      // final dos casos de teste da simulacao
      caso = 99;
      #100;
      $display("Fim da simulacao");
      $stop;
    end

  endmodule
