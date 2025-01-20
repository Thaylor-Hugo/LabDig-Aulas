module exp3_fluxo_dados (
    input clock,
    input [3:0] chaves,
    input zeraR,
    input registraR,
    input contaC,
    input zeraC,
    output chavesIgualMemoria,
    output fimC,
    output [3:0] db_contagem,
    output [3:0] db_chaves,
    output [3:0] db_memoria
);

    wire   [3:0] s_endereco, s_dado, s_chaves;  // sinal interno para interligacao dos componentes

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
      .AEBo (chavesIgualMemoria)
    );

    // saida de depuracao
    assign db_contagem = s_endereco;
    assign db_memoria = s_dado;
    assign db_chaves = s_chaves;

 endmodule

module sync_rom_16x4 (clock, address, data_out);
    input            clock;
    input      [3:0] address;
    output reg [3:0] data_out;

    always @ (posedge clock)
    begin
        case (address)
            4'b0000: data_out = 4'b0001;
            4'b0001: data_out = 4'b0010;
            4'b0010: data_out = 4'b0100;
            4'b0011: data_out = 4'b1000;
            4'b0100: data_out = 4'b0100;
            4'b0101: data_out = 4'b0010;
            4'b0110: data_out = 4'b0001;
            4'b0111: data_out = 4'b0001;
            4'b1000: data_out = 4'b0010;
            4'b1001: data_out = 4'b0010;
            4'b1010: data_out = 4'b0100;
            4'b1011: data_out = 4'b0100;
            4'b1100: data_out = 4'b1000;
            4'b1101: data_out = 4'b1000;
            4'b1110: data_out = 4'b0001;
            4'b1111: data_out = 4'b0100;
        endcase
    end
endmodule

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

endmodule

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

endmodule /* comparador_85 */