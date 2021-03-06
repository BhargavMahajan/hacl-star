open Ctypes
module Bindings(F:Cstubs.FOREIGN) =
  struct
    open F
    let hacl_Impl_Curve25519_Field51_fadd =
      foreign "Hacl_Impl_Curve25519_Field51_fadd"
        ((ptr uint64_t) @->
           ((ptr uint64_t) @-> ((ptr uint64_t) @-> (returning void))))
      
    let hacl_Impl_Curve25519_Field51_fsub =
      foreign "Hacl_Impl_Curve25519_Field51_fsub"
        ((ptr uint64_t) @->
           ((ptr uint64_t) @-> ((ptr uint64_t) @-> (returning void))))
      
    let hacl_Impl_Curve25519_Field51_fmul1 =
      foreign "Hacl_Impl_Curve25519_Field51_fmul1"
        ((ptr uint64_t) @->
           ((ptr uint64_t) @-> (uint64_t @-> (returning void))))
      
    let hacl_Curve25519_51_scalarmult =
      foreign "Hacl_Curve25519_51_scalarmult"
        ((ptr uint8_t) @->
           ((ptr uint8_t) @-> ((ptr uint8_t) @-> (returning void))))
      
    let hacl_Curve25519_51_secret_to_public =
      foreign "Hacl_Curve25519_51_secret_to_public"
        ((ptr uint8_t) @-> ((ptr uint8_t) @-> (returning void)))
      
    let hacl_Curve25519_51_ecdh =
      foreign "Hacl_Curve25519_51_ecdh"
        ((ptr uint8_t) @->
           ((ptr uint8_t) @-> ((ptr uint8_t) @-> (returning bool))))
      
  end