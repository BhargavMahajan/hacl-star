module Hacl.Impl.ECDSA.MontgomeryMultiplication

open FStar.HyperStack.All
open FStar.HyperStack
module ST = FStar.HyperStack.ST

open Lib.IntTypes
open Lib.Buffer

open FStar.Math.Lemmas

open Hacl.Spec.P256.Lemmas
open Hacl.Spec.ECDSAP256.Definition
open Hacl.Impl.LowLevel
open Hacl.Spec.P256.Basic
open Hacl.Spec.P256.Core

open FStar.Tactics
open FStar.Tactics.Canon 

open FStar.Mul

#reset-options "--z3refresh --z3rlimit 200"

inline_for_extraction noextract
val add8_without_carry:
  a: felem8 {wide_as_nat4 a < prime_p256_order * prime_p256_order} -> 
  b: felem8 {wide_as_nat4 b < pow2 320}  -> 
  Tot (r:felem8 {wide_as_nat4 r = wide_as_nat4 a + wide_as_nat4 b})

let add8_without_carry (a0, a1, a2, a3, a4, a5, a6, a7) (b0, b1, b2, b3, b4, b5, b6, b7) = 
  let (carry, r0, r1, r2, r3, r4, r5, r6, r7)  = add8 (a0, a1, a2, a3, a4, a5, a6, a7) (b0, b1, b2, b3, b4, b5, b6, b7) in 
  assert_norm (pow2 320 +  prime_p256_order * prime_p256_order  < pow2 512);
  assert(uint_v carry = 0);
  (r0, r1, r2, r3, r4, r5, r6, r7)


val add8_without_carry1:  t: widefelem -> t1: widefelem -> result: widefelem  -> Stack unit
  (requires fun h -> live h t /\ live h t1 /\ live h result /\ wide_as_nat h t1 < pow2 320 /\
    wide_as_nat h t <  prime_p256_order * prime_p256_order  )
  (ensures fun h0 _ h1 -> modifies (loc result) h0 h1 /\  wide_as_nat h1 result = wide_as_nat h0 t + wide_as_nat h0 t1)

let add8_without_carry1 t r result  = 
  let t0 = index t (size 0) in 
  let t1 = index t (size 1) in 
  let t2 = index t (size 2) in 
  let t3 = index t (size 3) in 
  let t4 = index t (size 4) in 
  let t5 = index t (size 5) in 
  let t6 = index t (size 6) in 
  let t7 = index t (size 7) in 

  let r0 = index r (size 0) in 
  let r1 = index r (size 1) in 
  let r2 = index r (size 2) in 
  let r3 = index r (size 3) in 
  let r4 = index r (size 4) in 
  let r5 = index r (size 5) in 
  let r6 = index r (size 6) in  
  let r7 = index r (size 7) in 

  let (r0, r1, r2, r3, r4, r5, r6, r7) = add8_without_carry (t0, t1, t2, t3, t4, t5, t6, t7) (r0, r1, r2, r3, r4, r5, r6, r7) in 
  load_buffer8 r0 r1 r2 r3 r4 r5 r6 r7 result


private let mul_lemma_1 (a: nat) (c: nat) (b: pos) : Lemma (requires (a < c)) (ensures (a * b < c * b)) = ()
private let mul_lemma_ (a: nat) (b: nat) (c: nat) : Lemma (requires (a < c /\ b < c)) (ensures (a * b < c * c)) = ()
private let add_l2 (a: int) (b: nat) (c: int) (d: nat) : Lemma (requires a <= c /\ b < d) (ensures (a + b < c + d)) = ()
private let div_lemma (a: int) (b: pos) (c: nat) : Lemma (requires a < b) (ensures a / b <= c / b) = ()


val lemma_montgomery_mult_1: t : int  -> 
  k0:nat {k0 = modp_inv2_prime (-prime_p256_order) (pow2 64)} -> 
  r: nat {t <= r} -> 
  Lemma ((t + (((t % pow2 64) * k0) % pow2 64 * prime_p256_order)) / pow2 64 <= (pow2 64 * prime_p256_order + r) / pow2 64)

let lemma_montgomery_mult_1 t k0 r = 
  let t1 = t % pow2 64 in 
  let y = (t1 * k0) % pow2 64 in 
  let t2 = y * prime_p256_order in 
    mul_lemma_1 y (pow2 64) prime_p256_order;
  let t3 = t + t2 in
    add_l2 t t2 r (pow2 64 * prime_p256_order); 
    div_lemma t3 (r + pow2 64 * prime_p256_order) (pow2 64)


val lemma_montgomery_mult_result_less_than_prime_p256_order: 
  a: nat{a < prime_p256_order} -> 
  b: nat{b < prime_p256_order} -> 
  k0:nat {k0 = modp_inv2_prime (-prime_p256_order) (pow2 64)} -> 
  Lemma
  (  
    let t = a * b in 
    let s = 64 in 
  
    let t1 = t % pow2 s in 
    let y = (t1 * k0) % pow2 s in 
    let t2 = y * prime_p256_order in 
    let t3 = t + t2 in
    let t = t3 / pow2 s in 
  
    let t1 = t % pow2 s in 
    let y = (t1 * k0) % pow2 s in 
    let t2 = y * prime_p256_order in 
    let t3 = t + t2 in
    let t = t3 / pow2 s in 
  
    let t1 = t % pow2 s in 
    let y = (t1 * k0) % pow2 s in 
    let t2 = y * prime_p256_order in 
    let t3 = t + t2 in
    let t = t3 / pow2 s in 
    
    let t1 = t % pow2 s in 
    let y = (t1 * k0) % pow2 s in 
    let t2 = y * prime_p256_order in 
    let t3 = t + t2 in
    let t = t3 / pow2 s in 
    t < 2 * prime_p256_order)


let lemma_montgomery_mult_result_less_than_prime_p256_order a b k0 = 
  let t = a * b in 
  let s = 64 in 
    mul_lemma_ a b prime_p256_order;

  let r = prime_p256_order * prime_p256_order + 1 in 

  let t1 = t % pow2 s in 
  let y = (t1 * k0) % pow2 s in 
  let t2 = y * prime_p256_order in 
  let t3 = t + t2 in
  let tU = t3 / pow2 s in 
  lemma_montgomery_mult_1 t k0 r; 

  let t = tU in 
  let r = (pow2 64 * prime_p256_order + r) / pow2 64 in 
  let t1 = t % pow2 s in 
  let y = (t1 * k0) % pow2 s in 
  let t2 = y * prime_p256_order in 
  let t3 = t + t2 in
  let tU = t3 / pow2 s in 
  lemma_montgomery_mult_1 t k0 r; 

  let t = tU in 
  let r = (pow2 64 * prime_p256_order + r) / pow2 64 in 
  let t1 = t % pow2 s in 
  let y = (t1 * k0) % pow2 s in 
  let t2 = y * prime_p256_order in 
  let t3 = t + t2 in
  let tU = t3 / pow2 s in 
  lemma_montgomery_mult_1 t k0 r; 

  let r = (pow2 64 * prime_p256_order + r) / pow2 64 in 
  let t = tU in 
  let t1 = t % pow2 s in 
  let y = (t1 * k0) % pow2 s in 
  let t2 = y * prime_p256_order in 
  let t3 = t + t2 in
  let tU = t3 / pow2 s in 
  lemma_montgomery_mult_1 t k0 r; 
  assert_norm ((pow2 64 * prime_p256_order +  (pow2 64 * prime_p256_order +  (pow2 64 * prime_p256_order +  (pow2 64 * prime_p256_order +  prime_p256_order * prime_p256_order + 1) / pow2 64) / pow2 64) / pow2 64) / pow2 64 < 2 * prime_p256_order)


val lemma_montgomery_mod_inverse_addition: a: nat -> 
  Lemma (
    (a * modp_inv2_prime(pow2 64) prime_p256_order  * modp_inv2_prime (pow2 64) prime_p256_order) % prime_p256_order == (a * modp_inv2_prime(pow2 128) prime_p256_order) % prime_p256_order)

let lemma_montgomery_mod_inverse_addition a =
    assert_norm ((modp_inv2_prime(pow2 64) prime_p256_order * modp_inv2_prime (pow2 64) prime_p256_order) % prime_p256_order == modp_inv2_prime (pow2 128) prime_p256_order % prime_p256_order);
    assert_by_tactic ((a * modp_inv2_prime (pow2 64) prime_p256_order * modp_inv2_prime (pow2 64) prime_p256_order)  == (a * (modp_inv2_prime (pow2 64) prime_p256_order * modp_inv2_prime (pow2 64) prime_p256_order))) canon;
    lemma_mod_mul_distr_r a (modp_inv2_prime (pow2 64) prime_p256_order * modp_inv2_prime (pow2 64) prime_p256_order) prime_p256_order; 
    lemma_mod_mul_distr_r a (modp_inv2_prime (pow2 128) prime_p256_order) prime_p256_order


val lemma_montgomery_mod_inverse_addition2: a: nat -> 
  Lemma ( 
    (a * modp_inv2_prime (pow2 128) prime_p256_order  * modp_inv2_prime (pow2 128) prime_p256_order) % prime_p256_order == (a * modp_inv2_prime (pow2 256) prime_p256_order) % prime_p256_order)

let lemma_montgomery_mod_inverse_addition2 a = 
  assert_norm ((modp_inv2_prime (pow2 128) prime_p256_order * modp_inv2_prime (pow2 128) prime_p256_order) % prime_p256_order == (modp_inv2_prime (pow2 256) prime_p256_order) % prime_p256_order);
    assert_by_tactic ((a * modp_inv2_prime (pow2 128) prime_p256_order * modp_inv2_prime (pow2 128) prime_p256_order)  == (a * (modp_inv2_prime (pow2 128) prime_p256_order * modp_inv2_prime (pow2 128) prime_p256_order))) canon;
    lemma_mod_mul_distr_r a (modp_inv2_prime (pow2 128) prime_p256_order * modp_inv2_prime (pow2 128) prime_p256_order) prime_p256_order; 
    lemma_mod_mul_distr_r a (modp_inv2_prime (pow2 256) prime_p256_order) prime_p256_order


val montgomery_multiplication_one_round_proof: 
  t: nat ->
  k0: nat {k0 = modp_inv2_prime (-prime_p256_order) (pow2 64)}  ->  
  round: nat {round = (t + prime_p256_order * ((k0 * (t % pow2 64)) % pow2 64)) / pow2 64} -> 
  co: nat {co % prime_p256_order = t % prime_p256_order} -> 
  Lemma (round  % prime_p256_order == co * (modp_inv2_prime (pow2 64) prime_p256_order) % prime_p256_order )

let montgomery_multiplication_one_round_proof t k0 round co = 
  mult_one_round_ecdsa_prime t prime_p256_order co k0 


val montgomery_multiplication_round: t: widefelem ->  round: widefelem -> k0: uint64 ->
  Stack unit 
    (requires fun h -> live h t /\ live h round  /\ wide_as_nat h t < prime_p256_order * prime_p256_order)
    (ensures fun h0 _ h1 -> modifies (loc round) h0 h1 /\ 
      wide_as_nat h1 round = (wide_as_nat h0 t + prime_p256_order * ((uint_v k0 * (wide_as_nat h0 t % pow2 64)) % pow2 64) ) / pow2 64)

let montgomery_multiplication_round t round k0 = 
  push_frame(); 
    let h0 = ST.get() in 
    let yBuffer = create (size 8) (u64 0) in 
    let t2 = create (size 8) (u64 0) in 
    let t3 = create (size 8) (u64 0) in 
    let t1 = mod64 t in 
    let y, _ = mul64 t1 k0 in 
      recall_contents prime256order_buffer (Lib.Sequence.of_list p256_order_prime_list);
    shortened_mul prime256order_buffer y t2;
    add8_without_carry1 t t2 t3;
      assert_by_tactic ((wide_as_nat h0 t % pow2 64) * uint_v k0 == uint_v k0 * (wide_as_nat h0 t % pow2 64)) canon;
    shift8 t3 round;
  pop_frame()


inline_for_extraction noextract
val montgomery_multiplication_round_twice: t: widefelem -> result: widefelem -> k0: uint64-> 
  Stack unit 
    (
      requires fun h -> live h t /\ live h result /\ 
      wide_as_nat h t < prime_p256_order * prime_p256_order /\ uint_v k0 == modp_inv2_prime (-prime_p256_order) (pow2 64)
    )
    (
      ensures fun h0 _ h1 -> modifies (loc result) h0 h1 /\ 
      wide_as_nat h1 result % prime_p256_order == (wide_as_nat h0 t * modp_inv2_prime (pow2 128) prime_p256_order) % prime_p256_order /\
      (
	let round = (wide_as_nat h0 t + prime_p256_order * ((uint_v k0 * (wide_as_nat h0 t % pow2 64)) % pow2 64)) / pow2 64 in 
	wide_as_nat h1 result == (round + prime_p256_order * ((uint_v k0 * (round % pow2 64)) % pow2 64)) / pow2 64)  /\
	wide_as_nat h1 result < prime_p256_order * prime_p256_order
      )
    
let montgomery_multiplication_round_twice t result k0 = 
   push_frame();
     let tempRound = create (size 8) (u64 0) in 
       let h0 = ST.get() in 
   montgomery_multiplication_round t tempRound k0; 
       let h1 = ST.get() in 
   montgomery_multiplication_one_round_proof (wide_as_nat h0 t) (uint_v k0) (wide_as_nat h1 tempRound) (wide_as_nat h0 t);
   montgomery_multiplication_round tempRound result k0; 
      let h2 = ST.get() in 
   montgomery_multiplication_one_round_proof (wide_as_nat h1 tempRound) (uint_v k0) (wide_as_nat h2 result) (wide_as_nat h0 t * modp_inv2_prime (pow2 64) prime_p256_order); 
   lemma_montgomery_mod_inverse_addition (wide_as_nat h0 t); 
  pop_frame()


let reduction_prime_prime_2prime_with_carry x result  = 
  push_frame();
    let tempBuffer = create (size 4) (u64 0) in 
    let tempBufferForSubborrow = create (size 1) (u64 0) in 
    let cin = Lib.Buffer.index x (size 4) in 
    let x = Lib.Buffer.sub x (size 0) (size 4) in 
        recall_contents prime256order_buffer (Lib.Sequence.of_list p256_order_prime_list);
    let c = Hacl.Impl.LowLevel.sub4_il x prime256order_buffer tempBuffer in
    let carry = sub_borrow c cin (u64 0) tempBufferForSubborrow in 
    cmovznz4 carry tempBuffer x result;
 pop_frame()   


val lemma_reduction1: a: nat {a < pow2 256} -> r: nat{if a >= prime_p256_order then r = a - prime_p256_order else r = a} -> 
  Lemma (r = a % prime_p256_order)

let lemma_reduction1 a r = 
  let prime256 = prime_p256_order in 
  assert_norm (pow2 256 - prime_p256_order < prime_p256_order)


let reduction_prime_2prime_order x result  = 
  push_frame();
    let tempBuffer = create (size 4) (u64 0) in 
    recall_contents prime256order_buffer (Lib.Sequence.of_list p256_order_prime_list);
      let h0 = ST.get() in 
    let c = sub4_il x prime256order_buffer tempBuffer in 
      let h1 = ST.get() in 
      assert(as_nat h1 tempBuffer = as_nat h0 x - prime_p256_order + uint_v c * pow2 256);
      assert(let x = as_nat h0 x in if x < prime_p256_order then uint_v c = 1 else uint_v c = 0);
    cmovznz4 c tempBuffer x result ;
    let h2 = ST.get() in 
    lemma_reduction1 (as_nat h0 x) (as_nat h2 result);
  pop_frame()  
  

val lemma_montgomery_mult_2: a: nat{a < prime_p256_order} -> b: nat {b < prime_p256_order} -> 
  Lemma (
    (
      let mod = modp_inv2_prime (pow2 64) prime_p256_order in  
      a * b *  mod * mod * mod * mod) % prime_p256_order == (a * b * modp_inv2_prime (pow2 256) prime_p256_order) % prime_p256_order)


let lemma_montgomery_mult_2 a b  =
  assert_norm(
      (modp_inv2_prime (pow2 64) prime_p256_order  * 
      modp_inv2_prime (pow2 64) prime_p256_order  *
      modp_inv2_prime (pow2 64) prime_p256_order *
      modp_inv2_prime (pow2 64) prime_p256_order) % prime_p256_order  ==
  (modp_inv2_prime (pow2 256) prime_p256_order) % prime_p256_order);
   let k = modp_inv2_prime (pow2 64) prime_p256_order in 
   assert_by_tactic ((a * b * k * k * k * k)  ==  ((a * b) * (k * k * k * k))) canon;
   lemma_mod_mul_distr_r (a * b) (k * k * k * k) prime_p256_order; 
   lemma_mod_mul_distr_r (a * b) (modp_inv2_prime (pow2 256) prime_p256_order) prime_p256_order
  

val upload_ecdsa_prime_p256_order: p: lbuffer uint64 (size 4) -> Stack unit
  (requires fun h -> live h p)
  (ensures fun h0 _ h1 -> modifies (loc p) h0 h1 /\ as_nat h1 p == prime_p256_order)

let upload_ecdsa_prime_p256_order p = 
  upd p (size 0) (u64 17562291160714782033);
  upd p (size 1) (u64 13611842547513532036);
  upd p (size 2) (u64 18446744073709551615);
  upd p (size 3) (u64 18446744069414584320)


val upload_k0: unit ->  Tot (r: uint64 {uint_v r == modp_inv2_prime (-prime_p256_order) (pow2 64)})

let upload_k0 () = 
  admit();
  (* 
  SAGE: 
  
  prime_p256_order = 115792089210356248762697446949407573529996955224135760342422259061068512044369
  inverse_mod(884452912994769583, 2**64)

     14758798090332847183  
  *)
  (*assume ((884452912994769583 **% ((pow2 64) -2)) % (pow2 64) == 14758798090332847183);*)
  (u64 14758798090332847183)



let fromDomain_ a = (a * modp_inv2_prime (pow2 256) prime_p256_order) % prime_p256_order

let toDomain_ a = (a * pow2 256) % prime_p256_order 


let lemmaFromDomainToDomain a = 
   let fromA = (a * modp_inv2_prime (pow2 256) prime_p256_order) % prime_p256_order in 
   let toFromA = (((a * modp_inv2_prime (pow2 256) prime_p256_order) % prime_p256_order) * pow2 256) % prime_p256_order in 
   lemma_mod_mul_distr_l (a * modp_inv2_prime (pow2 256) prime_p256_order) (pow2 256) prime_p256_order;
     admit();
     assert(toFromA == (a * modp_inv2_prime (pow2 256) prime_p256_order * pow2 256) % prime_p256_order);
   lemma_mod_mul_distr_r a (modp_inv2_prime (pow2 256) prime_p256_order * pow2 256) prime_p256_order;
   assert_norm((modp_inv2_prime (pow2 256) prime_p256_order * pow2 256) % prime_p256_order == 1);
   assert(toFromA == (a) % prime_p256_order);
   small_modulo_lemma_1 a prime_p256_order;
   assert(toFromA == a);
   assert(toFromA == toDomain_ (fromDomain_ a))


val multiplicationInDomain: #k: nat -> #l: nat -> 
  a: nat {a == toDomain_ (k) /\ a < prime} -> 
  b: nat {b == toDomain_ (l) /\ b < prime} -> 
  Lemma  ((a *  b * modp_inv2_prime (pow2 256) prime) % prime_p256_order == toDomain_ (k * l))

let multiplicationInDomain #k #l a b = 
  let f = a * b * modp_inv2_prime (pow2 256) prime in 
  let z = toDomain_ (k * l) in 
  assert_by_tactic (((k * pow2 256) % prime_p256_order) * ((l * pow2 256) % prime_p256_order) * modp_inv2_prime (pow2 256) prime = 
    ((k * pow2 256) % prime_p256_order) * (((l * pow2 256) % prime_p256_order) * modp_inv2_prime (pow2 256) prime)) canon;
  lemma_mod_mul_distr_l (k * pow2 256) (((l * pow2 256) % prime_p256_order) * modp_inv2_prime (pow2 256) prime) prime_p256_order;
  assert_by_tactic (
    ((k * pow2 256) * (((l * pow2 256) % prime_p256_order) * modp_inv2_prime (pow2 256) prime)) % prime_p256_order = 
    ((((l * pow2 256) % prime_p256_order) * (((k * pow2 256) * modp_inv2_prime (pow2 256) prime)) % prime_p256_order))) canon;
  lemma_mod_mul_distr_l (l * pow2 256)  ((k * pow2 256) * modp_inv2_prime (pow2 256) prime) prime_p256_order;
  assert_by_tactic ( ((l * pow2 256 * ((k * pow2 256) * modp_inv2_prime (pow2 256) prime))) == 
     ((l * pow2 256 * k) * (pow2 256 * modp_inv2_prime (pow2 256) prime))) canon;
  lemma_mod_mul_distr_r (l * pow2 256 * k) (pow2 256 * modp_inv2_prime (pow2 256) prime) prime_p256_order;
  assert_norm ((pow2 256 * modp_inv2_prime (pow2 256) prime) % prime_p256_order == 1);
  assert_by_tactic ((l * pow2 256 * k) == ((k * l) * pow2 256)) canon
  

val inDomain_mod_is_not_mod: a: nat -> Lemma (toDomain_ a == toDomain_ (a % prime_p256_order))

let inDomain_mod_is_not_mod a = 
   lemma_mod_mul_distr_l a (pow2 256) prime_p256_order


let lemmaToDomainFromDomain a = 
  let to = (a * pow2 256) % prime_p256_order in 
  let from_to = ((((a * pow2 256) % prime_p256_order) * modp_inv2_prime (pow2 256) prime_p256_order) % prime_p256_order) in 
  lemma_mod_mul_distr_l (a * pow2 256) (modp_inv2_prime (pow2 256) prime_p256_order) prime_p256_order;
  assert_by_tactic ((a * pow2 256) * modp_inv2_prime (pow2 256) prime_p256_order == a * (pow2 256 * modp_inv2_prime (pow2 256) prime_p256_order)) canon;
  lemma_mod_mul_distr_r a (pow2 256 * modp_inv2_prime (pow2 256) prime_p256_order) prime_p256_order;
  assert_norm ((pow2 256 * modp_inv2_prime (pow2 256) prime_p256_order) % prime_p256_order == 1)


let montgomery_multiplication_ecdsa_module a b result =
  push_frame();
    let t = create (size 8) (u64 0) in 
    let round2 = create (size 8) (u64 0) in 
    let round4 = create (size 8) (u64 0) in  
    let prime_p256_orderBuffer = create (size 4) (u64 0) in 

    let k0 = upload_k0() in 

      let h0 = ST.get() in     
    mul a b t;
      mul_lemma_ (as_nat h0 a) (as_nat h0 b) prime_p256_order;
   montgomery_multiplication_round_twice t round2 k0; 
     let h2 = ST.get() in 
   montgomery_multiplication_round_twice round2 round4 k0;
     lemma_mod_mul_distr_l (wide_as_nat h2 round2) (modp_inv2_prime (pow2 128) prime_p256_order) prime_p256_order;
     lemma_mod_mul_distr_l (as_nat h0 a * as_nat h0 b * modp_inv2_prime (pow2 128) prime_p256_order) (modp_inv2_prime (pow2 128) prime_p256_order) prime_p256_order;
     lemma_montgomery_mod_inverse_addition2 (as_nat h0 a * as_nat h0 b);
     lemma_montgomery_mult_result_less_than_prime_p256_order (as_nat h0 a) (as_nat h0 b) (uint_v k0);
     reduction_prime_prime_2prime_with_carry round4 result; 
     
     lemmaFromDomainToDomain (as_nat h0 a);
     lemmaFromDomainToDomain (as_nat h0 b);
     multiplicationInDomain #(fromDomain_ (as_nat h0 a)) #(fromDomain_ (as_nat h0 b)) (as_nat h0 a) (as_nat h0 b);
     inDomain_mod_is_not_mod (fromDomain_ (as_nat h0 a) * fromDomain_ (as_nat h0 b));

    pop_frame()
