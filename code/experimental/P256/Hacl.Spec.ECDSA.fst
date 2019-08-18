module Hacl.Spec.ECDSA

open FStar.Mul 
open Hacl.Spec.ECDSAP256.Definition
open Hacl.Spec.P256.Lemmas

open Lib.ByteSequence
open Lib.IntTypes
open Lib.Sequence

open Spec.Hash
open Hacl.Spec.P256 

(*
def toB(x):
    for i in range(4):
        print(((x >> i * 64) % (2 ** 64)))

qx = 0xe424dc61d4bb3cb7ef4344a7f8957a0c5134e16f7a67c074f82e6e12f49abf3c
qy = 0x970eed7aa2bc48651545949de1dddaf0127e5965ac85d1243d6f60e7dfaee927

primeOrder = 115792089210356248762697446949407573529996955224135760342422259061068512044369

R = 0xbf96b99aa49c705c910be33142017c642ff540c76349b9dab72f981fd9347f4f
S = 0x17c55095819089c2e03b9cd415abdf12444e323075d98f31920b9e0f57ec871c
z = 18096356966075357844 + 13937533974375268201 * 2**64 + 2811996616035378163 * 2**128 + 15112091478601597678 * 2**192

u1 = (inverse_mod(S, primeOrder) * z) % primeOrder
u2 = (inverse_mod(S, primeOrder) * R) % primeOrder

prime = Zmod(Integer(115792089210356248762697446949407573530086143415290314195533631308867097853951))
p2 = 41058363725152142129326129780047268409114441015993725554835256314039467401291

c = EllipticCurve(prime, [-3, p2])
basePoint = c(0x6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296, 0x4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5)
pk = c(qx, qy)

u1g = basePoint * u1
u2Q = pk * u2
x1 = (u1g + u2Q).xy()[0]
print(x1 == R)
print(Integer(x1) % primeOrder)
print(Integer(R) % primeOrder)



*)

let prime = prime_p256_order 
let nat_prime = (n: nat {n < prime})


let ith_bit (k:lbytes 32) (i:nat{i < 256}) : (t: uint64 {uint_v t == 0 \/ uint_v t == 1}) =
  let q = i / 8 in let r = size (i % 8) in
    admit();
  to_u64 ((index k q >>. r) &. u8 1)

let ( *% ) a b = (a * b) % prime


val _exp_step0: p: nat_prime -> q: nat_prime -> 
  Tot (t: tuple2 nat_prime nat_prime {let t0, t1 = t in t0 == (p * p) % prime_p256_order /\ t1 == (p * q) % prime_p256_order})

let _exp_step0 r0 r1 = 
  let r1 = r0 *% r1 in 
  let r0 = r0 *% r0 in 
  r0, r1

val _exp_step1: p: nat_prime -> q: nat_prime -> 
  Tot (t: tuple2 nat_prime nat_prime {let t0, t1 = t in t0 == (p * q) % prime_p256_order /\ t1 == (q * q) % prime_p256_order})

let _exp_step1 r0 r1 = 
  let r0 = r0 *% r1 in 
  let r1 = r1 *% r1 in 
  (r0, r1)


val swap: p: nat_prime -> q: nat_prime -> Tot (r: tuple2 nat_prime nat_prime{let pNew, qNew = r in 
  pNew == q /\ qNew == p})

let swap p q = (q, p)


val conditional_swap: i: uint64 -> p: nat_prime -> q: nat_prime -> Tot (r: tuple2 nat_prime nat_prime
  {
    let pNew, qNew = r in 
    if uint_v i = 0 then pNew == p /\ qNew == q
    else
      let p1, q1 = swap p q in 
      p1 == pNew /\ q1 == qNew
 }
)

#reset-options "--z3refresh --z3rlimit  100"

let conditional_swap i p q = 
  if uint_v i = 0 then 
    (p, q)
  else
    (q, p)

val lemma_swaped_steps: p: nat_prime -> q: nat_prime -> 
  Lemma (
    let (afterSwapP, afterSwapQ) = swap p q in 
    let p1, q1 = _exp_step0 afterSwapP afterSwapQ in 
    let p2, q2 = swap p1 q1 in 
    let r0, r1 = _exp_step1 p q in 
    p2 == r0 /\ q2 == r1)

let lemma_swaped_steps p q = ()

open Lib.RawIntTypes 

val _exp_step: k:  lseq uint8 32 ->  i: nat{i < 256} -> tuple2 nat_prime nat_prime ->
  Tot (t: tuple2 nat_prime nat_prime)

let _exp_step k i (p, q) = 
  let bit = 255 - i in 
  let bit = ith_bit k bit in 
  if uint_to_nat bit = 0 then 
      _exp_step0 p q 
  else _exp_step1 p q  

#reset-options "--z3refresh --z3rlimit 300"

val _exponent_spec: k: lseq uint8 32  -> tuple2 nat_prime nat_prime -> Tot (tuple2 nat_prime nat_prime)

let _exponent_spec k (p, q) = 
  Lib.LoopCombinators.repeati 256  (_exp_step k) (p, q)


unfold let prime_p256_order_inverse_list: list uint8 = 
   [
     (u8 79); (u8 37); (u8 99); (u8 252); (u8 194); (u8 202); (u8 185); (u8 243); 
     (u8 132); (u8 158); (u8 23); (u8 167); (u8 173); (u8 250); (u8 230); (u8 188); 
     (u8 255); (u8 255); (u8 255); (u8 255); (u8 255); (u8 255); (u8 255); (u8 255);
     (u8 0); (u8 0); (u8 0); (u8 0); (u8 255); (u8 255); (u8 255); (u8 255)
   ]

let prime_p256_order_inverse_seq: lseq uint8 32 = 
  assert_norm (List.Tot.length prime_p256_order_inverse_list == 32);
  of_list prime_p256_order_inverse_list


unfold let prime_p256_order_list: list uint8 = 
   [
     (u8 81); (u8 37); (u8 99); (u8 252); (u8 194); (u8 202); (u8 185); (u8 243); 
     (u8 132); (u8 158); (u8 23); (u8 167); (u8 173); (u8 250); (u8 230); (u8 188); 
     (u8 255); (u8 255); (u8 255); (u8 255); (u8 255); (u8 255); (u8 255); (u8 255);
     (u8 0); (u8 0); (u8 0); (u8 0); (u8 255); (u8 255); (u8 255); (u8 255)
   ]

let prime_p256_order_seq: lseq uint8 32 = 
  assert_norm (List.Tot.length prime_p256_order_list == 32);
  of_list prime_p256_order_list

open Hacl.Spec.P256.Definitions

val exponent_spec: a: nat_prime -> Tot (r: nat_prime {r = pow a (prime_p256_order - 2) % prime_p256_order})

let exponent_spec a = 
    admit();
    let a0, _ = _exponent_spec prime_p256_order_inverse_seq (1, a) in
    a0

val toJacobianCoordinates: tuple2 nat nat -> Tot (tuple3 nat nat nat)

let toJacobianCoordinates (r0, r1) = (r0, r1, 1)

val changeEndian: i: felem_seq -> Tot felem_seq

let changeEndian i = 
  let zero =  Lib.Sequence.index i 0 in 
  let one =   Lib.Sequence.index i 1 in 
  let two =   Lib.Sequence.index i 2 in 
  let three = Lib.Sequence.index i 3 in 

  let o = Lib.Sequence.upd i 0 three in 
  let o = Lib.Sequence.upd o 1 two in 
  let o = Lib.Sequence.upd o 2 one in 
	  Lib.Sequence.upd o 3 zero



val verifyQValidCurvePointSpec: publicKey: tuple3 nat nat nat -> bool

let verifyQValidCurvePointSpec publicKey = 
  let (x, y, z) = publicKey in 
  if x < prime256 && y < prime256 && z < prime256 && isPointOnCurve (x,y, z) &&
    isPointAtInfinity (scalar_multiplication prime_p256_order_seq publicKey) then true else false

val checkCoordinates: r: nat -> s: nat -> bool

let checkCoordinates r s = 
  if r > 0 && r < prime_p256_order && s > 0 && s < prime_p256_order then true else false


val ecdsa_verification: publicKey: tuple2 nat nat -> r: nat -> s: nat -> 
  mLen: size_nat{mLen < Spec.Hash.Definitions.max_input_length Spec.Hash.Definitions.SHA2_256} -> input: lseq uint8 mLen -> Tot bool


let ecdsa_verification publicKey r s mLen input = 
  let publicJacobian = toJacobianCoordinates publicKey in 
  let qValid = verifyQValidCurvePointSpec publicJacobian in 
    if qValid = false then false else begin
  let step1 = checkCoordinates r s in if step1 = false then false else begin

  let hashResult = Spec.Hash.hash Spec.Hash.Definitions.SHA2_256 input in 
  let hashNat = (felem_seq_as_nat (Lib.ByteSequence.uints_from_bytes_le hashResult)) % prime_p256_order in 

  let u1 = (Hacl.Spec.P256.Definitions.pow s (prime_p256_order - 2) * hashNat) % prime_p256_order in 
  let u2 = (Hacl.Spec.P256.Definitions.pow s (prime_p256_order - 2) * r) % prime_p256_order in 

  let u1Buffer = Lib.ByteSequence.uints_to_bytes_le (Hacl.Spec.ECDSAP256.Definition.nat_as_seq u1) in
  let u2Buffer = Lib.ByteSequence.uints_to_bytes_le (Hacl.Spec.ECDSAP256.Definition.nat_as_seq u2) in 
  
  let basePoint = (0x6B17D1F2E12C4247F8BCE6E563A440F277037D812DEB33A0F4A13945D898C296, 0x4FE342E2FE1A7F9B8EE7EB4A7C0F9E162BCE33576B315ECECBB6406837BF51F5, 1) in 
  let pointAtInfinity = (0, 0, 0) in 

   let u1D, _ = montgomery_ladder_spec u1Buffer (pointAtInfinity, basePoint) in 
   let u2D, _ = montgomery_ladder_spec u2Buffer (pointAtInfinity, publicJacobian) in 
   let sumPoints = _point_add u1D u2D in 
   let pointNorm = _norm sumPoints in 
   let (xResult, yResult, zResult) = pointNorm in 
   if Hacl.Spec.P256.isPointAtInfinity pointNorm then false else 
   xResult = r
end end   