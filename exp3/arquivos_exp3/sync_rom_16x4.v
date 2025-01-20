//------------------------------------------------------------------
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

