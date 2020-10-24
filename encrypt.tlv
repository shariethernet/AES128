\m4_TLV_version 1d: tl-x.org
\SV

   // =========================================
   // Welcome!  Try the tutorials via the menu.
   // =========================================

   // Default Makerchip TL-Verilog Code Template
   
   // Macro providing required top-level module definition, random
   // stimulus support, and Verilator config.
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)
   m4_include_url(['https://raw.githubusercontent.com/stevehoover/tlv_flow_lib/aa1f91c9e09326e8506bd81d8a077455ddfb0606/arrays.tlv'])
   //m4_define_hier(['M4_SBOX'], 2)
	// Parameters description for the encryption ciphers and
	// manuplating variables for each encrypt round.




   function [7 : 0] gm2(input [7 : 0] op);
     begin
       gm2 = {op[6 : 0], 1'b0} ^ (8'h1b & {8{op[7]}});
     end
   endfunction // gm2

   function [7 : 0] gm3(input [7 : 0] op);
     begin
       gm3 = gm2(op) ^ op;
     end
   endfunction // gm3

   function logic [31 : 0] mixw(input [31 : 0] w);
     reg [7 : 0] b0, b1, b2, b3;
     reg [7 : 0] mb0, mb1, mb2, mb3;
     begin
      b0 = w[31 : 24];
      b1 = w[23 : 16];
      b2 = w[15 : 08];
      b3 = w[07 : 00];

      mb0 = gm2(b0) ^ gm3(b1) ^ b2      ^ b3;
      mb1 = b0      ^ gm2(b1) ^ gm3(b2) ^ b3;
      mb2 = b0      ^ b1      ^ gm2(b2) ^ gm3(b3);
      mb3 = gm3(b0) ^ b1      ^ b2      ^ gm2(b3);

      mixw = {mb0, mb1, mb2, mb3};
     end
   endfunction // mixw
   function logic [127 : 0] mixcolumns(input [127 : 0] data);
     reg [31 : 0] w0, w1, w2, w3;
     reg [31 : 0] ws0, ws1, ws2, ws3;
     begin
      w0 = data[127 : 096];
      w1 = data[095 : 064];
      w2 = data[063 : 032];
      w3 = data[031 : 000];

      ws0 = mixw(w0);
      ws1 = mixw(w1);
      ws2 = mixw(w2);
      ws3 = mixw(w3);

      mixcolumns = {ws0, ws1, ws2, ws3};
     end
   endfunction // mixcolumns
   function logic [127 : 0] shiftrows(input [127 : 0] data);
     reg [31 : 0] w0, w1, w2, w3;
     reg [31 : 0] ws0, ws1, ws2, ws3;
     begin
      w0 = data[127 : 096];
      w1 = data[095 : 064];
      w2 = data[063 : 032];
      w3 = data[031 : 000];

      ws0 = {w0[31 : 24], w1[23 : 16], w2[15 : 08], w3[07 : 00]};
      ws1 = {w1[31 : 24], w2[23 : 16], w3[15 : 08], w0[07 : 00]};
      ws2 = {w2[31 : 24], w3[23 : 16], w0[15 : 08], w1[07 : 00]};
      ws3 = {w3[31 : 24], w0[23 : 16], w1[15 : 08], w2[07 : 00]};

      shiftrows = {ws0, ws1, ws2, ws3};
     end
   endfunction // shiftrows
   function logic [127 : 0] addroundkey(input [127 : 0] data, input [127 : 0] rkey);
      begin
      addroundkey = data ^ rkey;
      end
   endfunction // addroundkey
   function logic [7:0] sboxvalue (input [7:0] blockvalue);
      begin
         sboxvalue = (blockvalue == 8'h00) ? 8'h63 : 
                     (blockvalue == 8'h01) ? 8'h7c :
                     (blockvalue == 8'h02) ? 8'h77 : 
                     (blockvalue == 8'h03) ? 8'h7b : 
                     (blockvalue == 8'h04) ? 8'hf2 : 
                     (blockvalue == 8'h05) ? 8'h6b : 
                     (blockvalue == 8'h06) ? 8'h6f : 
                     (blockvalue == 8'h07) ? 8'hc5 : 
                     (blockvalue == 8'h08) ? 8'h30 : 
                     (blockvalue == 8'h09) ? 8'h01 : 
                     (blockvalue == 8'h0a) ? 8'h67 :
                     (blockvalue == 8'h0b) ? 8'h2b :
                     (blockvalue == 8'h0c) ? 8'hfe :
                     (blockvalue == 8'h0d) ? 8'hd7 :
                     (blockvalue == 8'h0e) ? 8'hab :
                     (blockvalue == 8'h0f) ? 8'h76 :
                     (blockvalue == 8'h10) ? 8'hca : 
                     (blockvalue == 8'h11) ? 8'h82 :
                     (blockvalue == 8'h12) ? 8'hc9 : 
                     (blockvalue == 8'h13) ? 8'h7d : 
                     (blockvalue == 8'h14) ? 8'hfa : 
                     (blockvalue == 8'h15) ? 8'h59 : 
                     (blockvalue == 8'h16) ? 8'h47 : 
                     (blockvalue == 8'h17) ? 8'hf0 : 
                     (blockvalue == 8'h18) ? 8'had : 
                     (blockvalue == 8'h19) ? 8'hd4 : 
                     (blockvalue == 8'h1a) ? 8'ha2 :
                     (blockvalue == 8'h1b) ? 8'haf :
                     (blockvalue == 8'h1c) ? 8'h9c :
                     (blockvalue == 8'h1d) ? 8'ha4 :
                     (blockvalue == 8'h1e) ? 8'h72 :
                     (blockvalue == 8'h1f) ? 8'ha0 :
                     (blockvalue == 8'h20) ? 8'hb7 : 
                     (blockvalue == 8'h21) ? 8'hfd :
                     (blockvalue == 8'h22) ? 8'h93 : 
                     (blockvalue == 8'h23) ? 8'h26 : 
                     (blockvalue == 8'h24) ? 8'h36 : 
                     (blockvalue == 8'h25) ? 8'h3f : 
                     (blockvalue == 8'h26) ? 8'hf7 : 
                     (blockvalue == 8'h27) ? 8'hcc : 
                     (blockvalue == 8'h28) ? 8'h34 : 
                     (blockvalue == 8'h29) ? 8'ha5 : 
                     (blockvalue == 8'h2a) ? 8'he5 :
                     (blockvalue == 8'h2b) ? 8'hf1 :
                     (blockvalue == 8'h2c) ? 8'h71 :
                     (blockvalue == 8'h2d) ? 8'hd8:
                     (blockvalue == 8'h2e) ? 8'h31 :
                     (blockvalue == 8'h2f) ? 8'h15 :
                     (blockvalue == 8'h30) ? 8'h04 : 
                     (blockvalue == 8'h31) ? 8'hc7 :
                     (blockvalue == 8'h32) ? 8'h23 : 
                     (blockvalue == 8'h33) ? 8'hc3 : 
                     (blockvalue == 8'h34) ? 8'h18 : 
                     (blockvalue == 8'h35) ? 8'h96 : 
                     (blockvalue == 8'h36) ? 8'h05 : 
                     (blockvalue == 8'h37) ? 8'h9a : 
                     (blockvalue == 8'h38) ? 8'h07 : 
                     (blockvalue == 8'h39) ? 8'h12 : 
                     (blockvalue == 8'h3a) ? 8'h80 :
                     (blockvalue == 8'h3b) ? 8'he2 :
                     (blockvalue == 8'h3c) ? 8'heb :
                     (blockvalue == 8'h3d) ? 8'h27 :
                     (blockvalue == 8'h3e) ? 8'hb2 :
                     (blockvalue == 8'h3f) ? 8'h75 :
                     (blockvalue == 8'h40) ? 8'h09 : 
                     (blockvalue == 8'h41) ? 8'h83 :
                     (blockvalue == 8'h42) ? 8'h2c : 
                     (blockvalue == 8'h43) ? 8'h1a : 
                     (blockvalue == 8'h44) ? 8'h1b : 
                     (blockvalue == 8'h45) ? 8'h6e : 
                     (blockvalue == 8'h46) ? 8'h5a : 
                     (blockvalue == 8'h47) ? 8'ha0 : 
                     (blockvalue == 8'h48) ? 8'h52 : 
                     (blockvalue == 8'h49) ? 8'h3b : 
                     (blockvalue == 8'h4a) ? 8'hd6 :
                     (blockvalue == 8'h4b) ? 8'hb3 :
                     (blockvalue == 8'h4c) ? 8'h29 :
                     (blockvalue == 8'h4d) ? 8'he3 :
                     (blockvalue == 8'h4e) ? 8'h2f :
                     (blockvalue == 8'h4f) ? 8'h84 :
         			   (blockvalue == 8'h50) ? 8'h53 : 
                     (blockvalue == 8'h51) ? 8'hd1 :
                     (blockvalue == 8'h52) ? 8'h00 : 
                     (blockvalue == 8'h53) ? 8'hed : 
                     (blockvalue == 8'h54) ? 8'h20 : 
                     (blockvalue == 8'h55) ? 8'hfc : 
                     (blockvalue == 8'h56) ? 8'hb1 : 
                     (blockvalue == 8'h57) ? 8'h5b : 
                     (blockvalue == 8'h58) ? 8'h6a : 
                     (blockvalue == 8'h59) ? 8'hcb : 
                     (blockvalue == 8'h5a) ? 8'hbe :
                     (blockvalue == 8'h5b) ? 8'h39 :
                     (blockvalue == 8'h5c) ? 8'h4a :
                     (blockvalue == 8'h5d) ? 8'h4c :
                     (blockvalue == 8'h5e) ? 8'h58 :
                     (blockvalue == 8'h5f) ? 8'hcf :
                     (blockvalue == 8'h60) ? 8'hd0 : 
                     (blockvalue == 8'h61) ? 8'hef :
                     (blockvalue == 8'h62) ? 8'haa : 
                     (blockvalue == 8'h63) ? 8'hfb : 
                     (blockvalue == 8'h64) ? 8'h43 : 
                     (blockvalue == 8'h65) ? 8'h4d : 
                     (blockvalue == 8'h66) ? 8'h33 : 
                     (blockvalue == 8'h67) ? 8'h85 : 
                     (blockvalue == 8'h68) ? 8'h45 : 
                     (blockvalue == 8'h69) ? 8'hf9 : 
                     (blockvalue == 8'h6a) ? 8'h02 :
                     (blockvalue == 8'h6b) ? 8'h7f :
                     (blockvalue == 8'h6c) ? 8'h50 :
                     (blockvalue == 8'h6d) ? 8'h3c :
                     (blockvalue == 8'h6e) ? 8'h9f :
                     (blockvalue == 8'h6f) ? 8'ha8 :
                     (blockvalue == 8'h70) ? 8'h51 : 
                     (blockvalue == 8'h71) ? 8'ha3 :
                     (blockvalue == 8'h72) ? 8'h40 : 
                     (blockvalue == 8'h73) ? 8'h8f : 
                     (blockvalue == 8'h74) ? 8'h92 : 
                     (blockvalue == 8'h75) ? 8'h9d : 
                     (blockvalue == 8'h76) ? 8'h38 : 
                     (blockvalue == 8'h77) ? 8'hf5 : 
                     (blockvalue == 8'h78) ? 8'hbc : 
                     (blockvalue == 8'h79) ? 8'hb6 : 
                     (blockvalue == 8'h7a) ? 8'hda :
                     (blockvalue == 8'h7b) ? 8'h21 :
                     (blockvalue == 8'h7c) ? 8'h10 :
                     (blockvalue == 8'h7d) ? 8'hff :
                     (blockvalue == 8'h7e) ? 8'hf3 :
                     (blockvalue == 8'h7f) ? 8'hd2 :
         			   (blockvalue == 8'h80) ? 8'hcd : 
                     (blockvalue == 8'h81) ? 8'h0c :
                     (blockvalue == 8'h82) ? 8'h13 : 
                     (blockvalue == 8'h83) ? 8'hec : 
                     (blockvalue == 8'h84) ? 8'h5f : 
                     (blockvalue == 8'h85) ? 8'h97 : 
                     (blockvalue == 8'h86) ? 8'h44 : 
                     (blockvalue == 8'h87) ? 8'h17 : 
                     (blockvalue == 8'h88) ? 8'hc4 : 
                     (blockvalue == 8'h89) ? 8'ha7 : 
                     (blockvalue == 8'h8a) ? 8'h7e :
                     (blockvalue == 8'h8b) ? 8'h3d :
                     (blockvalue == 8'h8c) ? 8'h64 :
                     (blockvalue == 8'h8d) ? 8'h5d :
                     (blockvalue == 8'h8e) ? 8'h19 :
                     (blockvalue == 8'h8f) ? 8'h73 :
           			   (blockvalue == 8'h90) ? 8'h60 : 
                     (blockvalue == 8'h91) ? 8'h81 :
                     (blockvalue == 8'h92) ? 8'h4f : 
                     (blockvalue == 8'h93) ? 8'hdc : 
                     (blockvalue == 8'h94) ? 8'h22 : 
                     (blockvalue == 8'h95) ? 8'h2a : 
                     (blockvalue == 8'h96) ? 8'h90 : 
                     (blockvalue == 8'h97) ? 8'h88 : 
                     (blockvalue == 8'h98) ? 8'h46 : 
                     (blockvalue == 8'h99) ? 8'hee : 
                     (blockvalue == 8'h9a) ? 8'hb8 :
                     (blockvalue == 8'h9b) ? 8'h14 :
                     (blockvalue == 8'h9c) ? 8'hde :
                     (blockvalue == 8'h9d) ? 8'h5e :
                     (blockvalue == 8'h9e) ? 8'h0b :
                     (blockvalue == 8'h9f) ? 8'hdb :
         			   (blockvalue == 8'ha0) ? 8'he0 : 
                     (blockvalue == 8'ha1) ? 8'h32 :
                     (blockvalue == 8'ha2) ? 8'h3a : 
                     (blockvalue == 8'ha3) ? 8'h0a : 
                     (blockvalue == 8'ha4) ? 8'h49 : 
                     (blockvalue == 8'ha5) ? 8'h06 : 
                     (blockvalue == 8'ha6) ? 8'h24 : 
                     (blockvalue == 8'ha7) ? 8'h5c : 
                     (blockvalue == 8'ha8) ? 8'hc2 : 
                     (blockvalue == 8'ha9) ? 8'hd3 : 
                     (blockvalue == 8'haa) ? 8'hac :
                     (blockvalue == 8'hab) ? 8'h62 :
                     (blockvalue == 8'hac) ? 8'h91 :
                     (blockvalue == 8'had) ? 8'h95 :
                     (blockvalue == 8'hae) ? 8'he4 :
                     (blockvalue == 8'haf) ? 8'h79 :
         			   (blockvalue == 8'hb0) ? 8'he7 : 
                     (blockvalue == 8'hb1) ? 8'hc8 :
                     (blockvalue == 8'hb2) ? 8'h37 : 
                     (blockvalue == 8'hb3) ? 8'h6d : 
                     (blockvalue == 8'hb4) ? 8'h8d : 
                     (blockvalue == 8'hb5) ? 8'hd5 : 
                     (blockvalue == 8'hb6) ? 8'h4e : 
                     (blockvalue == 8'hb7) ? 8'ha9 : 
                     (blockvalue == 8'hb8) ? 8'h6c : 
                     (blockvalue == 8'hb9) ? 8'h56 : 
                     (blockvalue == 8'hba) ? 8'hf4 :
                     (blockvalue == 8'hbb) ? 8'hea :
                     (blockvalue == 8'hbc) ? 8'h65 :
                     (blockvalue == 8'hbd) ? 8'h7a :
                     (blockvalue == 8'hbe) ? 8'hae :
                     (blockvalue == 8'hbf) ? 8'h08 :
         			   (blockvalue == 8'hc0) ? 8'hba : 
                     (blockvalue == 8'hc1) ? 8'h78 :
                     (blockvalue == 8'hc2) ? 8'h25 : 
                     (blockvalue == 8'hc3) ? 8'h2e : 
                     (blockvalue == 8'hc4) ? 8'h1c : 
                     (blockvalue == 8'hc5) ? 8'ha6 : 
                     (blockvalue == 8'hc6) ? 8'hb4 : 
                     (blockvalue == 8'hc7) ? 8'hc6 : 
                     (blockvalue == 8'hc8) ? 8'he8 : 
                     (blockvalue == 8'hc9) ? 8'hdd : 
                     (blockvalue == 8'hca) ? 8'h74 :
                     (blockvalue == 8'hcb) ? 8'h1f :
                     (blockvalue == 8'hcc) ? 8'h4b :
                     (blockvalue == 8'hcd) ? 8'hbd :
                     (blockvalue == 8'hce) ? 8'h8b :
                     (blockvalue == 8'hcf) ? 8'h8a :
         			   (blockvalue == 8'hd0) ? 8'h70 : 
                     (blockvalue == 8'hd1) ? 8'h3e :
                     (blockvalue == 8'hd2) ? 8'hb5 : 
                     (blockvalue == 8'hd3) ? 8'h66 : 
                     (blockvalue == 8'hd4) ? 8'h48 : 
                     (blockvalue == 8'hd5) ? 8'h03 : 
                     (blockvalue == 8'hd6) ? 8'hf6 : 
                     (blockvalue == 8'hd7) ? 8'h0e : 
                     (blockvalue == 8'hd8) ? 8'h61 : 
                     (blockvalue == 8'hd9) ? 8'h35 : 
                     (blockvalue == 8'hda) ? 8'h57 :
                     (blockvalue == 8'hdb) ? 8'hb9 :
                     (blockvalue == 8'hdc) ? 8'h86 :
                     (blockvalue == 8'hdd) ? 8'hc1 :
                     (blockvalue == 8'hde) ? 8'h1d :
                     (blockvalue == 8'hdf) ? 8'h9e :
         			   (blockvalue == 8'he0) ? 8'he1 : 
                     (blockvalue == 8'he1) ? 8'hf8 :
                     (blockvalue == 8'he2) ? 8'h98 : 
                     (blockvalue == 8'he3) ? 8'h11 : 
                     (blockvalue == 8'he4) ? 8'h69 : 
                     (blockvalue == 8'he5) ? 8'hd9 : 
                     (blockvalue == 8'he6) ? 8'h8e : 
                     (blockvalue == 8'he7) ? 8'h94 : 
                     (blockvalue == 8'he8) ? 8'h9b : 
                     (blockvalue == 8'he9) ? 8'h1e : 
                     (blockvalue == 8'hea) ? 8'h87 :
                     (blockvalue == 8'heb) ? 8'he9 :
                     (blockvalue == 8'hec) ? 8'hce :
                     (blockvalue == 8'hed) ? 8'h55 :
                     (blockvalue == 8'hee) ? 8'h28 :
                     (blockvalue == 8'hef) ? 8'hdf :
         			   (blockvalue == 8'hf0) ? 8'hac : 
                     (blockvalue == 8'hf1) ? 8'ha1 :
                     (blockvalue == 8'hf2) ? 8'h89 : 
                     (blockvalue == 8'hf3) ? 8'h0d : 
                     (blockvalue == 8'hf4) ? 8'hbf : 
                     (blockvalue == 8'hf5) ? 8'he6 : 
                     (blockvalue == 8'hf6) ? 8'h42 : 
                     (blockvalue == 8'hf7) ? 8'h68 : 
                     (blockvalue == 8'hf8) ? 8'h41 : 
                     (blockvalue == 8'hf9) ? 8'h99 : 
                     (blockvalue == 8'hfa) ? 8'h2d :
                     (blockvalue == 8'hfb) ? 8'h0f :
                     (blockvalue == 8'hfc) ? 8'hb0 :
                     (blockvalue == 8'hfd) ? 8'h54 :
                     (blockvalue == 8'hfe) ? 8'hbb : 8'h16;
                    // (blockvalue == 8'hff) ? 8'h16 : 8'hxx;
     end
   endfunction
   function logic [127:0] sboxupdate (input [127:0] block_new);
      sboxupdate = {sboxvalue(block_new[127:120]), sboxvalue(block_new[119:112]), sboxvalue(block_new[111:104]), sboxvalue(block_new[103:096]), sboxvalue(block_new[095:088]),
                   sboxvalue(block_new[087:080]), sboxvalue(block_new[079:072]), sboxvalue(block_new[071:064]), sboxvalue(block_new[063:056]), sboxvalue(block_new[055:048]),
                   sboxvalue(block_new[047:040]), sboxvalue(block_new[039:032]), sboxvalue(block_new[031:024]), sboxvalue(block_new[023:016]), sboxvalue(block_new[015:008]), 
                   sboxvalue(block_new[007:000])};
   endfunction
   function logic [127:0] round (input [127:0] data, input [127:0] key);
      round = addroundkey(mixcolumns(shiftrows(sboxupdate(data))),key);
   endfunction 
 
\TLV
   |encrypt
      @0
         $reset = *reset;
         $valid = !$reset;
         $block_rec[127:0] = 128'h98765432;
         $key0[127:0] = 128'h12345678;
         $key1[127:0] = 128'h23456789;
         $key2[127:0] = 128'h3456789a;
         $key3[127:0] = 128'h456789ab;
         $key4[127:0] = 128'h56789abc;
         $key5[127:0] = 128'h6789abcd;
         $key6[127:0] = 128'h789abcde;
         $key7[127:0] = 128'h89abcdef;
         $key8[127:0] = 128'h9abcdef0;
         $key9[127:0] = 128'habcdef01;
         $key10[127:0] = 128'hbcdef012;
      ?$valid
         @1
            $block_round0[127:0] = addroundkey($block_rec, $key0);
         @2
            $block_round1[127:0] = round($block_round0, $key1);
            $block_round2[127:0] = round($block_round1, $key2);
            $block_round3[127:0] = round($block_round2, $key3);
            $block_round4[127:0] = round($block_round3, $key4);
            $block_round5[127:0] = round($block_round4, $key5);
            $block_round6[127:0] = round($block_round5, $key6);
            $block_round7[127:0] = round($block_round6, $key7);
            $block_round8[127:0] = round($block_round7, $key8);
            $block_round9[127:0] = round($block_round8, $key9);
            
            
            
            
            
            
            
            
         
         
   

   //...

   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule

