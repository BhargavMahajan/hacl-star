module Hacl.Spec.P256.Lemmas

open Lib.IntTypes
open FStar.Math.Lemmas
open FStar.Math.Lib
open Hacl.Spec.P256.Basic

open FStar.Mul

open Hacl.Spec.P256.Definitions

open FStar.Tactics 
open FStar.Tactics.Canon 

#reset-options " --z3rlimit 100" 

noextract
val log_and: a: uint64 -> b: uint64{uint_v b == 0 \/ uint_v b == pow2 64 - 1} -> 
Lemma (if uint_v b = 0 then uint_v (logand a b) == 0 else uint_v (logand a b) == uint_v a)

let log_and a b = 
  logand_lemma b a;
  logand_spec a b;
  logand_spec b a;
  UInt.logand_commutative #(bits U64) (v a) (v b)

val logor_commutative: a: uint64 -> b: uint64 -> 
  Lemma (logor a b == logor b a)

let logor_commutative a b = 
  logor_spec a b;
  logor_spec b a;
  UInt.logor_commutative #(bits U64) (v a) (v b)
  

noextract
val log_or: a: uint64 -> b: uint64 {uint_v b == 0 \/ uint_v a == 0} -> 
Lemma (if uint_v b = 0 then uint_v (logor a b) == uint_v a else uint_v (logor a b) == uint_v b)

let log_or a b = 
    if uint_v b = 0 then 
       begin
	 logor_lemma b a;
	 logor_commutative a b
       end
    else 
      begin
	assert(uint_v a == 0);
	logor_lemma a b
      end

type elem (n:pos) = x:nat{x < n}

let fmul (#n:pos) (x:elem n) (y:elem n) : elem n = (x * y) % n

val exp: #n:pos -> a:elem n -> b:pos -> Tot (res:elem n) (decreases b)

let rec exp #n a b =
  if b = 1 then a
  else
    if b % 2 = 0 then exp (fmul a a) (b / 2)
    else fmul a (exp (fmul a a) (b / 2))


noextract 
let modp_inv_prime (prime: pos {prime > 3}) (x: elem prime)  : Tot (r: elem prime) = 
  (exp #prime x (prime - 2)) % prime

noextract
let modp_inv2_prime (x: int) (p: nat {p > 3}) : Tot (r: elem p) = modp_inv_prime p (x % p)

noextract
let modp_inv2 (x: nat) : Tot (r: elem prime256) = 
  assert_norm (prime256 > 3);
  modp_inv2_prime x prime256



noextract
val modulo_distributivity_mult: a: int -> b: int -> c: pos -> Lemma ((a * b) % c = ((a % c) * (b % c)) % c)

let modulo_distributivity_mult a b c = 
  lemma_mod_mul_distr_l a b c;
  lemma_mod_mul_distr_r (a % c) b c


val power_one: a: nat -> Lemma (pow 1 a == 1) 

let rec power_one a = 
  match a with 
  | 0 -> assert_norm (pow 1 0 == 1)
  | _ -> power_one (a - 1); 
    assert(pow 1 (a - 1) == 1)


noextract
val pow_plus: a: nat -> b: nat -> c: nat -> Lemma (ensures (pow a b * pow a c = pow a (b + c)))
(decreases b)

let rec pow_plus a b c = 
  match b with 
  | 0 -> assert_norm (pow a 0 = 1)
  | _ -> pow_plus a (b - 1) c; 
    assert_norm(pow a (b - 1) * a = pow a b)


noextract
val power_distributivity: a: nat -> b: nat -> c: pos -> Lemma ((pow (a % c) b) % c = (pow a b) % c)

let rec power_distributivity a b c =
   match b with 
   | 0 -> ()
   | _ -> 
     power_distributivity a (b - 1) c; 
     modulo_distributivity_mult (pow a (b -1)) a c;
     lemma_mod_twice a c;
     modulo_distributivity_mult (pow (a % c) (b -1)) (a % c) c


val power_distributivity_2: a: nat -> b: nat -> c: pos -> 
  Lemma (pow (a * b) c == pow a c * pow b c)

let rec power_distributivity_2 a b c = 
  match c with 
  |0 -> ()
  |1 -> ()
  | _ ->
    power_distributivity_2 a b (c - 1);
    assert_by_tactic (pow a (c - 1) * pow b (c - 1) * a * b == (pow a c * pow b c)) canon



noextract
val power_mult: a: nat -> b: nat -> c: nat -> Lemma (pow (pow a b) c == pow a (b * c))

let rec power_mult a b c = 
  match c with 
  |0 -> ()
  |_ ->  power_mult a b (c - 1); 
    pow_plus a (b * (c - 1)) b


(* Start of Marina RSA PSS code *)
val lemma_fpow_unfold0: a: nat -> b: pos {1 < b /\ b % 2 = 0} -> prime: pos { a < prime} -> Lemma (
  exp #prime a b = exp #prime (fmul a a) (b / 2))

let lemma_fpow_unfold0 a b prime = ()


val lemma_fpow_unfold1: a: nat -> b: pos {1 < b /\ b % 2 = 1} -> prime: pos { a < prime} -> Lemma (
  exp #prime a b = fmul (exp #prime (fmul a a) (b / 2)) a)

let lemma_fpow_unfold1 a b prime = ()


val lemma_pow_unfold: a:nat -> b:pos -> Lemma (a * pow a (b - 1) == pow a b)
let lemma_pow_unfold a b = ()


val lemma_mul_ass3: a:nat -> b:nat -> c:nat -> Lemma
  (a * b * c == a * c * b)
let lemma_mul_ass3 a b c = ()


val lemma_pow_double: a:nat -> b:nat -> Lemma
  (pow (a * a) b == pow a (b + b))
let rec lemma_pow_double a b =
  if b = 0 then ()
  else begin
    calc (==) {
      pow (a * a) b;
      (==) { lemma_pow_unfold (a * a) b }
      a * a * pow (a * a) (b - 1);
      (==) { lemma_pow_double a (b - 1) }
      a * a * pow a (b + b - 2);
      (==) {power_one  a }
      pow a 1 * pow a 1 * pow a (b + b - 2);
      (==) { pow_plus a 1 1 }
      pow a 2 * pow a (b + b - 2);
      (==) { pow_plus a 2 (b + b - 2) }
      pow a (b + b);
    };
    assert (pow (a * a) b == pow a (b + b))
  end


val lemma_pow_mod_n_is_fpow: n:pos -> a:nat{a < n} -> b:pos -> Lemma
  (ensures (exp #n a b == pow a b % n)) (decreases b)
  
let rec lemma_pow_mod_n_is_fpow n a b =
  if b = 1 then ()
  else begin
    if b % 2 = 0 then begin
      calc (==) {
	exp #n a b;
	(==) { lemma_fpow_unfold0 a b n}
	exp #n (fmul #n a a) (b / 2);
	(==) { lemma_pow_mod_n_is_fpow n (fmul #n a a) (b / 2) }
	pow (fmul #n a a) (b / 2) % n;
	(==) { power_distributivity (a * a) (b / 2) n }
	pow (a * a) (b / 2) % n;
	(==) { lemma_pow_double a (b / 2) }
	pow a b % n;
      };
      assert (exp #n a b == pow a b % n) end
    else begin
      calc (==) {
	exp #n a b;
	(==) { lemma_fpow_unfold1 a b n }
	fmul a (exp (fmul #n a a) (b / 2));
	(==) { lemma_pow_mod_n_is_fpow n (fmul #n a a) (b / 2) }
	fmul a (pow (fmul #n a a) (b / 2) % n);
	(==) { power_distributivity (a * a) (b / 2) n }
	fmul a (pow (a * a) (b / 2) % n);
	(==) { lemma_pow_double a (b / 2) }
	fmul a (pow a (b / 2 * 2) % n);
	(==) { Math.Lemmas.lemma_mod_mul_distr_r a (pow a (b / 2 * 2)) n }
	a * pow a (b / 2 * 2) % n;
	(==) { power_one a }
	pow a 1 * pow a (b / 2 * 2) % n;
	(==) { power_distributivity_2 a 1 (b / 2 * 2) }
	pow a (b / 2 * 2 + 1) % n;
	(==) { Math.Lemmas.euclidean_division_definition b 2 }
	pow a b % n;
      };
      assert (exp #n a b == pow a b % n) end
  end

(* End of Marina RSA PSS code *) 


val modulo_distributivity_mult_last_two: a: int -> b: int -> c: int -> d: int -> e: int -> f: pos -> 
Lemma ((a * b * c * d * e) % f = (a * b * c * ((d * e) % f)) % f)

let modulo_distributivity_mult_last_two a b c d e f =
  let open FStar.Tactics in 
  let open FStar.Tactics.Canon in 

  assert_by_tactic (a * b * c * d * e == a * b * c * (d * e)) canon;
  lemma_mod_mul_distr_r (a * b * c) (d * e) f

noextract
let modp_inv2_pow (x: nat) : Tot (r: nat {r < prime256}) = 
   power_distributivity x (prime256 - 2) prime256;
   pow x (prime256 - 2) % prime256
  

val lemma_mod_twice : a:int -> p:pos -> Lemma ((a % p) % p == a % p)

let lemma_mod_twice a p = lemma_mod_mod (a % p) a p


val lemma_multiplication_to_same_number: a: nat -> b: nat ->c: nat -> prime: pos ->  
  Lemma (requires (a % prime = b % prime)) (ensures ((a * c) % prime = (b * c) % prime))


let lemma_multiplication_to_same_number a b c prime = 
  lemma_mod_mul_distr_l a c prime;
  lemma_mod_mul_distr_l b c prime


val lemma_division_is_multiplication: t3: nat{ exists (k: nat) . k * pow2 64 = t3} -> prime_: pos {prime_ > 3 /\
  (prime_ = 115792089210356248762697446949407573529996955224135760342422259061068512044369 \/ prime_ = prime256)} ->   
  Lemma (ensures (t3 * modp_inv2_prime (pow2 64) prime_  % prime_ = (t3 / pow2 64) % prime_))


let lemma_division_is_multiplication t3 prime_ =  
  let open FStar.Tactics in 
  let open FStar.Tactics.Canon in 
  let remainder = t3 / pow2 64 in 
    assert_norm(prime256 > 3); 
  let prime2 = 115792089210356248762697446949407573529996955224135760342422259061068512044369 in 
  assert_norm((modp_inv2_prime (pow2 64) prime256 * pow2 64) % prime256 = 1);
  assert_norm ((modp_inv2_prime (pow2 64) prime2 * pow2 64) % prime2 = 1);
  let k =  (modp_inv2_prime (pow2 64) prime_ * pow2 64) in 
  modulo_distributivity_mult remainder k prime_;
    assert((remainder * k) % prime_ = ((remainder % prime_)) % prime_);
  lemma_mod_twice remainder prime_;
  assert_by_tactic (t3 / pow2 64 * (modp_inv2_prime (pow2 64) prime_ * pow2 64) == t3/ pow2 64 * pow2 64 * modp_inv2_prime (pow2 64) prime_) canon;
    assert((t3 / pow2 64 * (modp_inv2_prime (pow2 64) prime_ * pow2 64)) % prime_ = remainder % prime_);
    assert((t3  * modp_inv2_prime (pow2 64) prime_) % prime_ = remainder % prime_)


val lemma_multiplication_same_number2: a: int -> b: int -> c: int{a * b = c} -> d: int -> Lemma
    (a * b * d == c * d) 

let lemma_multiplication_same_number2 a b c d = ()


val lemma_add_mod5: a: nat -> b: nat -> c: nat -> d: nat -> e: nat -> f: nat {f = a - b + c + d - e} -> k: pos -> 
  Lemma (
    f % k == ((a % k) - (b % k) + ( c % k) + (d % k) - (e % k)) % k)


let lemma_add_mod5 a b c d e f k = 
    assert(f % k == (a - b + c + d - e) % k);
  lemma_mod_sub_distr (a - b + c + d) e k;
    assert(f % k == (a - b + c + d - (e % k)) % k);
  lemma_mod_sub_distr (a + c + d - (e % k)) b k;
    assert(f % k == (a + c + d - (b % k) - (e % k)) % k);
  lemma_mod_add_distr (a + c  - (b % k) - (e % k)) d k;
  lemma_mod_add_distr (a - (b % k) - (e % k) + (d % k)) c k;
  lemma_mod_add_distr ((d % k) - (e % k) - (b % k) + (c % k)) a k


#reset-options " --z3rlimit 200" 

val lemma_reduce_mod_by_sub3 : t: nat -> Lemma ((t + (t % pow2 64) * prime256) % pow2 64 == 0)

let lemma_reduce_mod_by_sub3 t = 
  let t_ = (t + (t % pow2 64) * prime256) % pow2 64 in 
  lemma_mod_add_distr t ((t % pow2 64) * prime256) (pow2 64);
  lemma_mod_mul_distr_l t prime256 (pow2 64);
    assert(t_ == (t + (t * prime256) % pow2 64) % pow2 64);
  lemma_mod_add_distr t (t * prime256) (pow2 64);  
  assert_norm(t * (prime256 + 1) % pow2 64 == 0)


val mult_one_round: t: nat -> co: nat{t % prime256 == co% prime256}  -> Lemma
(let result = (t + (t % pow2 64) * prime256) / pow2 64 % prime256 in result == (co * modp_inv2 (pow2 64)) % prime256)


let mult_one_round t co = 
let t1 = t % pow2 64 in 
    let t2 = t1 * prime256 in 
    let t3 = t + t2 in 
      modulo_addition_lemma t prime256 (t % pow2 64);
      assert(t3 % prime256 = co % prime256);
      lemma_div_mod t3 (pow2 64);
      lemma_reduce_mod_by_sub3 t;
      assert(t3 % pow2 64 == 0);
      assert(let rem = t3/ pow2 64 in rem * pow2 64 = t3);
      assert(exists (k: nat). k * pow2 64 = t3);
      assert_norm (prime256 > 3);
      lemma_division_is_multiplication t3 prime256;
      lemma_multiplication_to_same_number t3 co (modp_inv2 (pow2 64)) prime256


val lemma_reduce_mod_ecdsa_prime:
  prime : nat {prime = 115792089210356248762697446949407573529996955224135760342422259061068512044369} ->
  t: nat -> k0: nat {k0 = modp_inv2_prime (-prime) (pow2 64)} ->  
  Lemma((t + prime * (k0 * (t % pow2 64) % pow2 64)) % pow2 64 == 0)
    

let lemma_reduce_mod_ecdsa_prime prime t k0 = 
    let open FStar.Tactics in 
    let open FStar.Tactics.Canon in 

  let f = prime * (k0 * (t % pow2 64) % pow2 64) in 
  let t0 = (t + f) % pow2 64 in 
  lemma_mod_add_distr t f (pow2 64);
  modulo_addition_lemma t (pow2 64) f;
  assert(t0 == (t + f % pow2 64) % pow2 64); 
  lemma_mod_mul_distr_r k0 t (pow2 64);
    assert(k0 * (t % pow2 64) % pow2 64 = (k0 * t) % pow2 64);
  lemma_mod_mul_distr_r prime (k0 * t) (pow2 64); 
    assert((prime * (k0 * (t % pow2 64) % pow2 64)) % pow2 64 == (prime * (k0 * t)) % pow2 64);
    assert_by_tactic(prime * (k0 * t) == (prime * k0) * t) canon;
    assert((prime * (k0 * (t % pow2 64) % pow2 64)) % pow2 64 == ((prime * k0) * t) % pow2 64);
    lemma_mod_mul_distr_l (prime * k0) t (pow2 64); 
      (*
       SAGE: 
       prime = 115792089210356248762697446949407573529996955224135760342422259061068512044369
       inverse_mod (- prime, 2 ** 64) * prime % 2 ** 64  == (-1) % 2** 64	*)
      (* z3 computes it incorrectly *)
    assume((prime * k0) % pow2 64 == (-1) % pow2 64); 
    assert((prime * (k0 * (t % pow2 64) % pow2 64)) % pow2 64 == ((-1) % pow2 64 * t) % pow2 64);
    lemma_mod_mul_distr_l (-1) t (pow2 64);
    assert(f % pow2 64 == (-t) % pow2 64);
    assert((t + f) % pow2 64 == (t + ((-t) % pow2 64)) % pow2 64);
    lemma_mod_add_distr t (-t) (pow2 64);
    assert((t + f) % pow2 64 == 0)
  

val mult_one_round_ecdsa_prime: t: nat -> 
  prime: pos {prime = 115792089210356248762697446949407573529996955224135760342422259061068512044369} -> 
  co: nat {t % prime == co % prime} -> k0: nat {k0 = modp_inv2_prime (-prime) (pow2 64)} -> Lemma
  (let result = (t + prime * ((k0 * (t % pow2 64)) % pow2 64)) / pow2 64 in 
    result % prime == (co * modp_inv2_prime (pow2 64) prime) % prime)


let mult_one_round_ecdsa_prime t prime co k0 = 
  assert_norm (prime > 3);
  let t2 = ((k0 * (t % pow2 64)) % pow2 64) * prime in 
  let t3 = t + t2 in 
    modulo_addition_lemma t prime ((k0 * (t % pow2 64)) % pow2 64);
    assert(t3 % prime = co % prime);
    lemma_div_mod t3 (pow2 64);
    lemma_reduce_mod_ecdsa_prime prime t k0;
    assert(let rem = t3/ pow2 64 in rem * pow2 64 = t3);
    assert(exists (k: nat). k * pow2 64 = t3);
    lemma_division_is_multiplication t3 prime;
    lemma_multiplication_to_same_number t3 co (modp_inv2_prime (pow2 64) prime) prime


val lemma_decrease_pow: a: nat -> Lemma
  ((a * modp_inv2 (pow2 64) * modp_inv2 (pow2 64) * modp_inv2 (pow2 64) * modp_inv2 (pow2 64)) % prime256 == 
  (a * modp_inv2 (pow2 256)) % prime256) 

let lemma_decrease_pow a = 
  assert_norm(modp_inv2 (pow2 64) = 6277101733925179126845168871924920046849447032244165148672);
  assert_norm(modp_inv2 (pow2 256) = 115792089183396302114378112356516095823261736990586219612555396166510339686400 );
  assert_norm((modp_inv2 (pow2 64) * modp_inv2 (pow2 64) * modp_inv2 (pow2 64) * modp_inv2(pow2 64)) % prime256  = (modp_inv2 (pow2 256)) % prime256);
  lemma_mod_mul_distr_r a (modp_inv2 (pow2 64) * modp_inv2 (pow2 64) * modp_inv2 (pow2 64) * modp_inv2(pow2 64)) prime256;
  lemma_mod_mul_distr_r a (modp_inv2 (pow2 256)) prime256


val lemma_brackets : a: int -> b: int -> c: int -> Lemma (a * b * c = a * (b * c))

let lemma_brackets a b c = ()


val lemma_brackets_l: a: int -> b: int -> c: int -> Lemma (a * b * c = (a * b) * c)

let lemma_brackets_l a b c = ()


val lemma_brackets1: a: int -> b: int -> c: int -> Lemma (a * (b * c) = b * (a * c))

let lemma_brackets1 a b c = ()


val lemma_brackets5: a: nat -> b: nat -> c: nat -> d: nat -> e: nat -> Lemma (a * b * c * d * e = a * b * c * (d * e))

let lemma_brackets5 a b c d e = ()


val lemma_brackets5_twice: a: int -> b: int -> c: int -> d: int -> e: int -> Lemma (a * b * c * d * e = (a * d) * (b * e) * c)

let lemma_brackets5_twice a b c d e = 
  let open FStar.Tactics in 
  let open FStar.Tactics.Canon in 
  assert_by_tactic (a * b * c * d * e == (a * d) * (b * e) * c) canon


val lemma_brackets7: a: int -> b: int -> c: int -> d: int -> e: int -> f: int -> g: int -> Lemma (a * b * c * d * e * f * g = a * b * c * d * e * (f * g))

let lemma_brackets7 a b c d e f g = ()


val lemma_brackets7_twice: a: int -> b: int -> c: int -> d: int -> e: int -> f: int -> g: int -> Lemma (a * b * c * d * e * f * g = (a * e) * (b * f) * (c * g) * d)

let lemma_brackets7_twice a b c d e f g = ()


val lemma_distr_mult3: a: int -> b: int -> c: int -> Lemma (a * b * c = a * c * b)

let lemma_distr_mult3 a b c = ()


val lemma_distr_mult : a: nat -> b: nat -> c: nat -> d: nat -> e: nat -> Lemma (a * b * c * d * e = a * b * d * c * e) 

let lemma_distr_mult a b c d e = ()


val lemma_twice_brackets: a: int -> b: int -> c: int -> d: int -> e: int -> f: int -> h: int-> Lemma 
  ((a * b * c) * (d * e * f) * h = a * b * c * d * e * f * h)

let lemma_twice_brackets a b c d e f h = ()


val lemma_distr_mult7: a: int -> b: int -> c: int -> d: int -> e: int -> f: int -> h: int-> Lemma 
  (a * b * c * d * e * f * h = a * b * d * e * f * h * c)

let lemma_distr_mult7 a b c d e f h = ()

val lemma_prime_as_wild_nat: a: felem8{wide_as_nat4 a < 2 * prime256} -> 
  Lemma (let (t0, t1, t2, t3, t4, t5, t6, t7) = a in 
    uint_v t7 = 0 /\ uint_v t6 = 0 /\ uint_v t5 = 0 /\ (uint_v t4 = 0 \/ uint_v t4 = 1) /\
    as_nat4 (t0, t1, t2, t3) + uint_v t4 * pow2 256 = wide_as_nat4 a)

let lemma_prime_as_wild_nat (t0, t1, t2, t3, t4, t5, t6, t7) = 
   assert_norm(pow2 64 * pow2 64 = pow2 128);
   assert_norm(pow2 64 * pow2 64 * pow2 64 = pow2 192);
   assert_norm(pow2 64 * pow2 64 * pow2 64 * pow2 64 = pow2 256);
   assert_norm(pow2 64 * pow2 64 * pow2 64  * pow2 64 * pow2 64= pow2 320);
   assert_norm(pow2 64 * pow2 64 * pow2 64  * pow2 64 * pow2 64 * pow2 64 = pow2 (6 * 64));
   assert_norm(pow2 64 * pow2 64 * pow2 64  * pow2 64 * pow2 64* pow2 64 * pow2 64 = pow2 (7 * 64));
   assert_norm (2 * prime256 < 2 * pow2 256);
   
   assert(
     v t0 + v t1 * pow2 64 + v t2 * pow2 64 * pow2 64 +
     v t3 * pow2 64 * pow2 64 * pow2 64 +
     v t4 * pow2 64 * pow2 64 * pow2 64 * pow2 64 +
     v t5 * pow2 64 * pow2 64 * pow2 64 * pow2 64 * pow2 64 +
     v t6 * pow2 64 * pow2 64 * pow2 64 * pow2 64 * pow2 64 * pow2 64 +
     v t7 * pow2 64 * pow2 64 * pow2 64 * pow2 64 * pow2 64 * pow2 64 * pow2 64 < 2 * pow2 256)


val lemma_mul_nat2: a: nat -> b: nat -> Lemma (a * b >= 0)

let lemma_mul_nat2 a b = ()


val lemma_mul_nat: a:nat -> b:nat -> c: nat -> Lemma (a * b * c >= 0)

let lemma_mul_nat a b c = ()


val lemma_mul_nat4: a:nat -> b:nat -> c: nat -> d: nat -> Lemma (a * b * c * d >= 0)

let lemma_mul_nat4 a b c d = ()


val lemma_mul_nat5: a: nat -> b: nat -> c: nat -> d: nat -> e: nat -> Lemma (a * b * c * d * e >= 0)

let lemma_mul_nat5 a b c d e = ()


val modulo_distributivity_mult2: a: int -> b: int -> c: int -> d: pos -> Lemma (((a % d) * (b % d) * c) % d = (a * b * c)% d)

let modulo_distributivity_mult2 a b c d = 
  lemma_mod_mul_distr_l a ((b % d) * c) d;
    assert((a % d * ((b % d) * c)) % d == (a * ((b % d) * c)) % d);
  let open FStar.Tactics in 
  let open FStar.Tactics.Canon in 
    assert_by_tactic (a * ((b % d) * c) == (b % d) * a * c) canon;
  lemma_mod_mul_distr_l b (a * c) d


val lemma_minus_distr (a: int) (b: int): Lemma ((a % prime256 - b % prime256) % prime256 = (a - b)%prime256)

let lemma_minus_distr a b = 
  lemma_mod_sub_distr (a % prime256) b prime256;
  lemma_mod_add_distr (- b) a prime256


val lemma_multiplication_not_mod_prime: a: nat{a < prime256} -> b: nat {b > 0 /\ b % prime256 <> 0} -> 
  Lemma ((a * b) % prime256 == 0 <==> a == 0)

let lemma_multiplication_not_mod_prime a b = admit()

(*If k a ≡ k b (mod n) and k is coprime with n, then a ≡ b (mod n) *)

val lemma_modular_multiplication_p256: a: nat{a < prime256} -> b: nat{b < prime256} -> 
  Lemma 
  (a * modp_inv2 (pow2 256) % prime256 = b * modp_inv2 (pow2 256) % prime256  ==> a == b)

(*If k a ≡ k b (mod n) and k is coprime with n, then a ≡ b (mod n) *)

let lemma_modular_multiplication_p256 a b = admit()


val lemma_mod_sub_distr (a:int) (b:int) (n:pos) : Lemma ((a - b % n) % n = (a - b) % n)

val lemma_mod_add_distr (a:int) (b:int) (n:pos) : Lemma ((a + b % n) % n = (a + b) % n)

let lemma_mod_sub_distr (a:int) (b:int) (n:pos) =
  lemma_div_mod b n;
  distributivity_sub_left 0 (b / n) n;
  lemma_mod_plus (a - (b % n)) (-(b / n)) n

let lemma_mod_add_distr (a:int) (b:int) (n:pos) =
  lemma_div_mod b n;
  lemma_mod_plus (a + (b % n)) (b / n) n


val lemma_log_and1: a: uint64 {v a = 0 \/ v a = maxint U64} ->
  b: uint64 {v b = 0 \/ v b = maxint U64}  -> 
  Lemma (uint_v a = pow2 64 - 1 && uint_v b = pow2 64 - 1 <==> uint_v (logand a b) == pow2 64 - 1)

let lemma_log_and1 a b = logand_lemma a b


val lemma_xor_copy_cond: a: uint64 -> b: uint64 -> mask: uint64{uint_v mask = 0 \/ uint_v mask = pow2 64 -1} ->
  Lemma(let r = logxor a (logand mask (logxor a b)) in 
  if uint_v mask = pow2 64 - 1 then r == b else r == a)

let lemma_xor_copy_cond a b mask = 
  let fst = logxor a b in 
  let snd = logand mask fst in 
    logand_lemma mask fst;
  let thrd = logxor a snd in    
    logxor_lemma a snd;
    logxor_lemma a b


val lemma_equality: a: felem4 -> b: felem4 -> Lemma
    (
      let (a_0, a_1, a_2, a_3) = a in 
      let (b_0, b_1, b_2, b_3) = b in 
      if  (uint_v a_0 = uint_v b_0 && uint_v a_1 = uint_v b_1 && uint_v a_2 = uint_v b_2 && uint_v a_3 = uint_v b_3) then as_nat4 a == as_nat4 b else as_nat4 a <> as_nat4 b)

let lemma_equality a b = ()


val cmovznz4_lemma: cin: uint64 -> x: uint64 -> y: uint64 -> Lemma (
  let mask = neq_mask cin (u64 0) in 
  let r = logor (logand y mask) (logand x (lognot mask)) in 
  if uint_v cin = 0 then uint_v r == uint_v x else uint_v r == uint_v y)

let cmovznz4_lemma cin x y = 
  let x2 = neq_mask cin (u64 0) in 
      neq_mask_lemma cin (u64 0);
  let x3 = logor (logand y x2) (logand x (lognot x2)) in
  let ln = lognot (neq_mask cin (u64 0)) in 
    log_and y x2; 
    lognot_lemma x2;
    log_and x ln;
    log_or (logand y x2) (logand x (lognot x2))


val lemma_equ_felem: a: nat{ a < pow2 64} -> b: nat {b < pow2 64} -> c: nat {c < pow2 64} -> d: nat {d < pow2 64} ->
   a1: nat{a1 < pow2 64} -> b1: nat {b1 < pow2 64} -> c1: nat {c1 < pow2 64} -> d1: nat {d1 < pow2 64} ->
  Lemma (requires (
    a + b * pow2 64 + c * pow2 64 * pow2 64 + d *  pow2 64 * pow2 64 * pow2 64 == 
    a1 + b1 * pow2 64 + c1 * pow2 64 * pow2 64  + d1 *  pow2 64 * pow2 64 * pow2 64))
  (ensures (a == a1 /\ b == b1 /\ c == c1 /\ d == d1))


let lemma_equ_felem a b c d  a1 b1 c1 d1  = 
  assert(a = a1 + b1 * pow2 64 + c1 * pow2 128 + d1 * pow2 192 -  b * pow2 64 - c * pow2 128 - d * pow2 192);
  assert(a == a1);
  assert(b == b1);
  assert(c == c1);
  assert(d == d1)

val lemma_eq_funct: a: felem_seq -> b: felem_seq -> Lemma
   (requires (felem_seq_as_nat a == felem_seq_as_nat b))
   (ensures (a == b))

let lemma_eq_funct a b = 
  let a_seq = felem_seq_as_nat a in 
  let b_seq = felem_seq_as_nat b in 

  
  let a0 = Lib.Sequence.index a 0 in 
  let a1 =  Lib.Sequence.index a 1 in 
  let a2 =  Lib.Sequence.index  a 2 in 
  let a3 =  Lib.Sequence.index a 3 in 

  let b0 = Lib.Sequence.index b 0 in 
  let b1 = Lib.Sequence.index b 1 in 
  let b2 = Lib.Sequence.index b 2 in 
  let b3 = Lib.Sequence.index b 3 in 

  assert(uint_v a0 < pow2 64);
  assert(uint_v b0 < pow2 64);
  
  assert(uint_v a0 < pow2 64);
  assert(uint_v b0 < pow2 64);

  assert_norm (pow2 64 * pow2 64 = pow2 128);
  assert_norm (pow2 64 * pow2 64 * pow2 64 = pow2 192);
  
  assert(
  uint_v a0 + uint_v a1 * pow2 64 + uint_v a2 * pow2 128 + uint_v a3 * pow2 192 == 
  uint_v b0 + uint_v b1 * pow2 64 + uint_v b2 * pow2 128 + uint_v b3 * pow2 192);

  lemma_equ_felem (uint_v a0) (uint_v a1) (uint_v a2) (uint_v a3) (uint_v b0) (uint_v b1) (uint_v b2) (uint_v b3);

  assert(Lib.Sequence.index a 0 == Lib.Sequence.index b 0);
  assert(Lib.Sequence.index a 1 == Lib.Sequence.index b 1);
  assert(Lib.Sequence.index a 2 == Lib.Sequence.index b 2);
  assert(Lib.Sequence.index a 3 == Lib.Sequence.index b 3);  

  assert(Lib.Sequence.equal a b)

