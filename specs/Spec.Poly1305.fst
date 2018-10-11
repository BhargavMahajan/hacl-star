module Spec.Poly1305

#reset-options "--z3rlimit 60 --initial_fuel 0 --max_fuel 0 --initial_ifuel 0 --max_ifuel 0"

open FStar.Mul
open Lib.IntTypes
open Lib.Sequence
open Lib.ByteSequence
open Lib.NatMod

(* Field types and parameters *)
let prime : pos =  
  let p = pow2 130 - 5 in
  assert_norm(p >0);
  p
unfold type elem = nat_mod prime
let to_elem (x:nat) : elem = x `modulo` prime
let from_elem (x:elem) : nat = nat_mod_v #prime x
let zero : elem = to_elem 0


(* Poly1305 parameters *)
let blocksize : size_nat = 16
let keysize   : size_nat = 32
type block = lbytes blocksize
type tag   = lbytes blocksize
type key   = lbytes keysize


noeq type state = {
  r:elem;
  s:elem;
  acc:elem
}

let set_acc (st:state) (acc:elem) =
  {st with acc = acc}

(* Poly1305 specification *)
let update1 (len:size_nat{len <= blocksize}) (b:lbytes len) (st:state) : state =
  Math.Lemmas.pow2_le_compat 128 (8 * len);
  assert (pow2 (8 * len) <= pow2 128);
  let n = to_elem (pow2 (8 * len)) +% to_elem (nat_from_bytes_le b) in
  let acc = (n +% st.acc) *% st.r in
  set_acc st acc

let poly (text:bytes) (st:state) : state =
  repeat_blocks #uint8 #state blocksize text 
    (fun b ->update1 blocksize b)
    (fun l b a -> if l = 0 then a else update1 l b a)
  st
  
let finish (st:state) : tag =
  let n = (from_elem st.acc + from_elem st.s) % pow2 128 in
  nat_to_bytes_le 16 n

let encode_r (rb:block) : elem =
  let (&.) = logand #U8 in
  let rb = rb.[3] <- rb.[3] &. u8 15 in
  let rb = rb.[7] <- rb.[7] &. u8 15 in
  let rb = rb.[11] <- rb.[11] &. u8 15 in
  let rb = rb.[15] <- rb.[15] &. u8 15 in
  let rb = rb.[4] <- rb.[4] &. u8 252 in
  let rb : lseq uint8 16 = rb.[8] <- rb.[8] &. u8 252 in
  let rb : lseq uint8 16 = rb.[12] <- rb.[12] &. u8 252 in
  to_elem (nat_from_bytes_le rb)

let poly1305_init (k:key) : state =
  let r = encode_r (slice k 0 16) in
  let s = to_elem (nat_from_bytes_le (slice k 16 32)) in
  {r = r; s = s; acc = zero}

let poly1305 (msg:bytes) (k:key) : tag =
  let st = poly1305_init k in
  let st = poly msg st in
  finish st
