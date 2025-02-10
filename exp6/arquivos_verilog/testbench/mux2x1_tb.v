/*------------------------------------------------------------------------
 * Arquivo   : mux2x1_tb.v
 * Projeto   : Jogo do Desafio da Memoria
 *------------------------------------------------------------------------
 * Descricao : testbench para o multiplexador 2x1 
 * 
 *------------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     15/02/2024  1.0     Edson Midorikawa  criacao
 *     31/01/2025  1.1     Edson Midorikawa  revisao
 *------------------------------------------------------------------------
 */
 
`timescale 1ns/1ns

module mux2x1_tb;
    
    // Entradas
    reg D0, D1;
    reg SEL;
    
    // Saída
    wire OUT;
    
    // Instanciacao do DUT
    mux2x1 mux_inst (
        .D0  ( D0  ),
        .D1  ( D1  ),
        .SEL ( SEL ),
        .OUT ( OUT )
    );
    
    // Geracao de Estimulos
    initial begin
        $monitor("Time=%0t D0=%b D1=%b SEL=%b MUX_OUT=%b", $time, D0, D1, SEL, OUT);
        
        // Caso de teste 1: SEL = 0
        SEL = 0;
        D0 = 1'b0; D1 = 1'b1;
        #10;

        // Caso de teste 2: SEL = 0
        SEL = 0;
        D0 = 1'b1; D1 = 1'b0;
        #10;
 
        // Caso de teste 3: SEL = 1
        SEL = 1;
        D0 = 1'b0; D1 = 1'b1;
        #10;
 
        // Caso de teste 4: SEL = 1
        SEL = 1;
        D0 = 1'b1; D1 = 1'b0;
        #10;
        
        // Caso de teste 5: SEL = X
        SEL = 1'bx;
        D0 = 1'b0; D1 = 1'b0;
        #10;
        
        // Caso de teste 6: SEL = X
        SEL = 1'bx;
        D0 = 1'b1; D1 = 1'b0;
        #10;
        
        // Fim da simulacao
        $stop;
    end
    
endmodule
