module AEShash_stdcalls

open X64.CPU_Features_s
open FStar.HyperStack.ST
module B = LowStar.Buffer
module HS = FStar.HyperStack
module DV = LowStar.BufferView.Down
module UV = LowStar.BufferView.Up
open FStar.Mul
open Words_s
open Words.Seq_s
open AES_s
open Interop.Base
open Types_s

unfold
let uint8_p = B.buffer UInt8.t

inline_for_extraction
val aes128_keyhash_init_stdcall:
  key:Ghost.erased (Seq.seq nat32) ->
  roundkeys_b:uint8_p ->
  hkeys_b:uint8_p ->
  Stack unit
    (requires fun h0 ->
      B.disjoint roundkeys_b hkeys_b /\

      B.live h0 roundkeys_b /\ B.live h0 hkeys_b /\

      B.length roundkeys_b = 176 /\
      B.length hkeys_b = 160 /\

      is_aes_key_LE AES_128 (Ghost.reveal key) /\
      (Seq.equal (B.as_seq h0 roundkeys_b)
        (seq_nat8_to_seq_uint8 (le_seq_quad32_to_bytes (key_to_round_keys_LE AES_128 (Ghost.reveal key))))) /\

      (Seq.equal (B.as_seq h0 hkeys_b) (Seq.create 160 0uy)) /\

      aesni_enabled)
    (ensures fun h0 _ h1 ->
      B.modifies (B.loc_buffer hkeys_b) h0 h1 /\
  
      (let v = seq_nat8_to_seq_uint8 (le_quad32_to_bytes (reverse_bytes_quad32 (aes_encrypt_LE AES_128 (Ghost.reveal key) (Mkfour 0 0 0 0)))) in
      Seq.equal (B.as_seq h1 hkeys_b) 
        (Seq.append (Seq.create 32 0uy) (Seq.append v (Seq.create 112 0uy)))))

inline_for_extraction
val aes256_keyhash_init_stdcall:
  key:Ghost.erased (Seq.seq nat32) ->
  roundkeys_b:uint8_p ->
  hkeys_b:uint8_p ->
  Stack unit
    (requires fun h0 ->
      B.disjoint roundkeys_b hkeys_b /\

      B.live h0 roundkeys_b /\ B.live h0 hkeys_b /\

      B.length roundkeys_b = 240 /\
      B.length hkeys_b = 160 /\

      is_aes_key_LE AES_256 (Ghost.reveal key) /\
      (Seq.equal (B.as_seq h0 roundkeys_b)
        (seq_nat8_to_seq_uint8 (le_seq_quad32_to_bytes (key_to_round_keys_LE AES_256 (Ghost.reveal key))))) /\

      (Seq.equal (B.as_seq h0 hkeys_b) (Seq.create 160 0uy)) /\

      aesni_enabled)
    (ensures fun h0 _ h1 ->
      B.modifies (B.loc_buffer hkeys_b) h0 h1 /\
  
      (let v = seq_nat8_to_seq_uint8 (le_quad32_to_bytes (reverse_bytes_quad32 (aes_encrypt_LE AES_256 (Ghost.reveal key) (Mkfour 0 0 0 0)))) in
      Seq.equal (B.as_seq h1 hkeys_b) 
        (Seq.append (Seq.create 32 0uy) (Seq.append v (Seq.create 112 0uy)))))
