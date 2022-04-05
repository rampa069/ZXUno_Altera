`timescale 1ns / 1ns
`default_nettype none

//    This file is part of the ZXUNO Spectrum core. 
//    Creation date is 02:28:18 2014-02-06 by Miguel Angel Rodriguez Jodar
//    (c)2014-2020 ZXUNO association.
//    ZXUNO official repository: http://svn.zxuno.com/svn/zxuno
//    Username: guest   Password: zxuno
//    Github repository for this core: https://github.com/mcleod-ideafix/zxuno_spectrum_core
//
//    ZXUNO Spectrum core is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    ZXUNO Spectrum core is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with the ZXUNO Spectrum core.  If not, see <https://www.gnu.org/licenses/>.
//
//    Any distributed copy of this file must keep this notice intact.

module tld_zxuno_NeptUNO (
   input wire clk50mhz,

   output wire [5:0] r,
   output wire [5:0] g,
   output wire [5:0] b,
   output wire hsync,
   output wire vsync,
//   output wire VGA_BLANK,
//	output wire VGA_CLOCK,
	
	
   inout wire clkps2,
   inout wire dataps2,
   inout wire mouseclk,
   inout wire mousedata,
   output wire audio_out_left,
   output wire audio_out_right,
   input wire ear,
//	input wire ear_maxduino,

	
//	output wire MCLK,
   output wire SCLK,
   output wire LRCLK,
   output wire SDIN,

	
   output wire midi_out,
   input wire clkbd,
   input wire wsbd,
   input wire dabd,    

   output wire uart_tx,
   input wire uart_rx,
   output wire uart_rts,
   output wire uart_reset,

   //output wire stdn,
   //output wire stdnb,
   
   output wire [19:0] sram_addr,
   inout wire [7:0] sram_data,
   output wire sram_we_n,
	
   output wire sram_ub_n,
	output wire sram_lb_n,
   output wire sram_oe_n,
	
	
//   output wire flash_cs_n,
//   output wire flash_clk,
//   output wire flash_mosi,
//   input wire flash_miso,

//   input wire  joyup,
//   input wire  joydown,
//   input wire  joyleft,
//   input wire  joyright,
//   input wire  joyfire,
//   output wire joyp7_o,
//   input wire  joyfire2,
   
	output wire   JOY_CLK,
   output wire   JOY_LOAD,
   input  wire   JOY_DATA,
   output wire   joyp7_o,
	
   output wire sd_cs_n,    
   output wire sd_clk,     
   output wire sd_mosi,    
   input wire sd_miso,

//   output wire flashled,
   output wire sdled,
	output wire stm_rst_o
	
   );

//	wire audio_out_left;
//   wire audio_out_right;

	wire [5:0] ri_monochrome, gi_monochrome, bi_monochrome;
	wire [1:0] monochrome_switcher;
	wire wifi_switcher;
	
	wire flash_cs_n;
   wire flash_clk;
   wire flash_mosi;
   wire flash_miso;
	
   wire sysclk;
	wire clk50;
   wire [2:0] pll_frequency_option;
   
//   clock_generator relojes_maestros
//   (// Clock in ports
//    .CLK_IN1            (clk50mhz),
//    .pll_option         (pll_frequency_option),
//    // Clock out ports
//    .sysclk             (sysclk)
//    );
 
   wire locked;

   relojes	relojes_inst (
			.inclk0 	( clk50mhz ),
			.c0 		( sysclk ),
			.c1 		( clk50 ),
			.locked 	( locked )
	);


   wire [2:0] ri, gi, bi;
   wire [5:0] ro, go, bo;
   wire hsync_pal, vsync_pal, csync_pal;
   wire vga_enable, scanlines_enable;
   wire clk14en_tovga;
   
//   wire joy1up, joy1down, joy1left, joy1right, joy1fire1, joy1fire2;
//   wire joy2up, joy2down, joy2left, joy2right, joy2fire1, joy2fire2;
 
   wire [20:0] sram_addr_int;
   assign sram_addr = sram_addr_int[19:0];
	
	wire [8:0] audio_left_i2s;
	wire [8:0] audio_right_i2s;
   
//	wire midi_o;
//   assing midi_out =	~ midi_o;

   zxuno #(.FPGA_MODEL(3'b010), .MASTERCLK(28000000)) la_maquina (
    .sysclk(sysclk),
    .power_on_reset_n(1'b1),  // s�lo para simulaci�n. Para implementacion, dejar a 1
    .r(ri),
    .g(gi),
    .b(bi),
    .hsync(hsync_pal),
    .vsync(vsync_pal),
    .csync(csync_pal),
	 .monochrome_switcher(monochrome_switcher),
	 .wifi_switcher(wifi_switcher), 
	 
    .clkps2(clkps2),
    .dataps2(dataps2),
    .ear_ext( ~ear ),  // negada porque el hardware tiene un transistor inversor
    .audio_out_left(audio_out_left),
    .audio_out_right(audio_out_right),
	 
	 .left (audio_left_i2s),
	 .right(audio_right_i2s), 
    
    .midi_out(midi_out),
    .clkbd(clkbd),
    .wsbd(wsbd),
    .dabd(dabd),
	 
    .uart_tx(uart_tx),
    .uart_rx(uart_rx), //1'b1
    .uart_rts(uart_rts),

    .sram_addr(sram_addr_int),
    .sram_data(sram_data),
    .sram_we_n(sram_we_n),
    
    .flash_cs_n(flash_cs_n),
    .flash_clk(flash_clk),
    .flash_di(flash_mosi),
    .flash_do(flash_miso),
    
    .sd_cs_n(sd_cs_n),
    .sd_clk(sd_clk),
    .sd_mosi(sd_mosi),
    .sd_miso(sd_miso),
    
    .joy1up(joy1up),
    .joy1down(joy1down),
    .joy1left(joy1left),
    .joy1right(joy1right),
    .joy1fire1(joy1fire1),
    .joy1fire2(joy1fire2),    
	 
    .joy2up(joy2up),
    .joy2down(joy2down),
    .joy2left(joy2left),
    .joy2right(joy2right),
    .joy2fire1(joy2fire1),
    .joy2fire2(joy2fire2),   

//    .mouseclk(mouseclk),
//    .mousedata(mousedata),
    
    .clk14en_tovga(clk14en_tovga),
    .vga_enable(vga_enable),
    .scanlines_enable(scanlines_enable),
    .freq_option(pll_frequency_option),
    
    .ad724_xtal(),
    .ad724_mode(),
    .ad724_enable_gencolorclk()
    );

 
`ifdef MONOCHROMERGB
  monochrome monochromergb (
    .monochrome_selection(monochrome_switcher),
    .ri({ri,ri}),
    .gi({gi,gi}),
    .bi({bi,bi}),
    .ro(ri_monochrome),
    .go(gi_monochrome),
    .bo(bi_monochrome)  
  );
  
`else
   assign ri_monochrome = {ri,ri};
	assign gi_monochrome = {gi,gi};
	assign bi_monochrome = {bi,bi};
`endif 
	 
	 
	vga_scandoubler #(.CLKVIDEO(14000)) salida_vga (
		.clk(sysclk),
      .clkcolor4x(1'b1),
      .clk14en(clk14en_tovga),
      .enable_scandoubling(vga_enable),
      .disable_scaneffect(~scanlines_enable),
		.ri(ri_monochrome),
		.gi(gi_monochrome),
		.bi(bi_monochrome),
		.hsync_ext_n(hsync_pal),
		.vsync_ext_n(vsync_pal),
      .csync_ext_n(csync_pal),
		.ro(ro),
		.go(go),
		.bo(bo),
		.hsync(hsync),
		.vsync(vsync)
   );	 
   
//	assign VGA_CLOCK = sysclk; 
//	assign VGA_BLANK = 1'b1;
   assign r = ro;
   assign g = go;
   assign b = bo;

	
	assign stm_rst_o = 1'b0;
	assign sram_ub_n = 1'b1;
	assign sram_lb_n = 1'b0;
   assign sram_oe_n = 1'b0;
	
   assign joyp7_o = 1'b1;	
//   assign flashled = flash_cs_n;
   assign sdled = !sd_cs_n;
   assign uart_reset = 1'bz;
	
	
	`ifdef UART_ESP8266_OPTION
		assign uart_reset = (!wifi_switcher) ? 1'b0 : 1'bz;
	`else
	   assign uart_reset = 1'b0;
	`endif
	
   
   
	
	audio_top audio_top (  // Audio Output I2S
		.clk_50MHz		(clk50), // I should be clk50mhz, but it makes inteferences
		.dac_MCLK		(),  //MCLK
		.dac_LRCK		(LRCLK),
		.dac_SCLK		(SCLK),
		.dac_SDIN		(SDIN),
		.L_data			({audio_left_i2s,7'b0000000}),
		.R_data			({audio_right_i2s,7'b0000000})
	); 

	
	wire joy1up;
   wire joy1down;
   wire joy1left;
   wire joy1right;
   wire joy1fire1;
   wire joy1fire2;

   wire joy2up;
   wire joy2down;
   wire joy2left;
   wire joy2right;
   wire joy2fire1;
   wire joy2fire2;

neptuno_joydecoder  neptuno_joydecoder
(
	.clk_i           ( sysclk ),
	.joy_data_i      ( JOY_DATA ),
	.joy_clk_o       ( JOY_CLK ),
	.joy_load_o      ( JOY_LOAD ),

	.joy1_up_o       ( joy1up ),
	.joy1_down_o     ( joy1down ),
	.joy1_left_o     ( joy1left ),
	.joy1_right_o    ( joy1right ),
	.joy1_fire1_o    ( joy1fire1 ),
	.joy1_fire2_o    ( joy1fire2 ),

	.joy2_up_o       ( joy2up ),
	.joy2_down_o     ( joy2down ),
	.joy2_left_o     ( joy2left ),
	.joy2_right_o    ( joy2right ),
	.joy2_fire1_o    ( joy2fire1 ),
	.joy2_fire2_o    ( joy2fire2 )
);

endmodule
