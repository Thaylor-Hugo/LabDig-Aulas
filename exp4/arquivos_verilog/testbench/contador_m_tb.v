/* --------------------------------------------------------------------
 * Arquivo   : circuito_contador_m_tb.v
 * Projeto   : Experiencia 4 - Desenvolvimento de Projeto de 
 *             Circuitos Digitais em FPGA
 * --------------------------------------------------------------------
 * Descricao : testbench Verilog do modulo contador_m 
 *
 *             1) Plano de teste com 7 testes
 *
 * --------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     30/01/2024  1.0     Edson Midorikawa  versao inicial
 * --------------------------------------------------------------------
 */

`timescale 1ns/1ns


module contador_m_tb;

  // Sinais de entrada
  reg         clock_in;
  reg         zera_as_in;
  reg         zera_s_in;
  reg         conta_in;

  // Sinais de saida
  wire [12:0] q_out;
  wire        fim_out;
  wire        meio_out;

  // Componente a ser testadp (Device Under Test -- DUT)
  contador_m #( .M(5000), .N(13) ) 
  dut (
    .clock  ( clock_in ),
    .zera_as( zera_as_in ),
    .zera_s ( zera_s_in ),
    .conta  ( conta_in ),
    .Q      ( q_out ),
    .fim    ( fim_out ),
    .meio   ( meio_out )
  );

  // Configuração do clock
  parameter clockPeriod = 20; // in ns, f=50MHz

  // Gerador de clock
  always #(clockPeriod / 2) clock_in = ~clock_in;

  // Gera sinais de estimulo para a simulacao
  integer caso;
  initial begin
    $display("Inicio da simulacao");
    
    // Valores iniciais
    clock_in   = 1'b0;
    zera_as_in = 1'b0;
    zera_s_in  = 1'b0;
    conta_in   = 1'b0;
    caso = 0;
    @(negedge clock_in); // espera borda de descida

    // Teste 1. gera pulso de clear assincrono (1 periodo de clock)
    caso = 1;
    zera_as_in = 1'b1;
    #(clockPeriod) zera_as_in = 1'b0;

    // Teste 2. espera por 10 periodos de clock sem habilitacao de contagem
    caso = 2;
    #(10*clockPeriod);

    // Teste 3. habilita contagem por 20 periodos de clock
    caso = 3;
    conta_in = 1'b1;
    #(20*clockPeriod) conta_in = 1'b0;

    // Teste 4. clear assincrono
    caso = 3;
    zera_as_in = 1'b1;
    #(clockPeriod) zera_as_in = 1'b0;

    // Teste 5. habilita contagem por 100 periodos de clock com intervalo de 10 periodos de clock
    caso = 5;
    conta_in = 1'b1;
    #(40*clockPeriod) conta_in = 1'b0;
    #(10*clockPeriod) conta_in = 1'b1;
    #(60*clockPeriod) conta_in = 1'b0;

    // Teste 6. clear sincrono
    caso = 6;
    zera_s_in = 1'b1;
    #(clockPeriod) zera_s_in = 1'b0;

    // Teste 7. habilita contagem por 5010 periodos de clock
    caso = 7;
    conta_in = 1'b1;
    #(5010*clockPeriod) conta_in = 1'b0; // gera RCO quando contagem chegar a 4999

    #(20*clockPeriod)

    // Final do testbench
    caso = 99;
    $display("fim da simulacao");
    $stop;
  end

endmodule
