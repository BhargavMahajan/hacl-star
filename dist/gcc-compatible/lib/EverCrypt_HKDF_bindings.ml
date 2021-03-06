open Ctypes
module Bindings(F:Cstubs.FOREIGN) =
  struct
    open F
    include (Hacl_Spec_bindings.Bindings)(Hacl_Spec_stubs)
    let everCrypt_HKDF_expand_sha1 =
      foreign "EverCrypt_HKDF_expand_sha1"
        ((ptr uint8_t) @->
           ((ptr uint8_t) @->
              (uint32_t @->
                 ((ptr uint8_t) @->
                    (uint32_t @-> (uint32_t @-> (returning void)))))))
      
    let everCrypt_HKDF_extract_sha1 =
      foreign "EverCrypt_HKDF_extract_sha1"
        ((ptr uint8_t) @->
           ((ptr uint8_t) @->
              (uint32_t @->
                 ((ptr uint8_t) @-> (uint32_t @-> (returning void))))))
      
    let everCrypt_HKDF_expand_sha2_256 =
      foreign "EverCrypt_HKDF_expand_sha2_256"
        ((ptr uint8_t) @->
           ((ptr uint8_t) @->
              (uint32_t @->
                 ((ptr uint8_t) @->
                    (uint32_t @-> (uint32_t @-> (returning void)))))))
      
    let everCrypt_HKDF_extract_sha2_256 =
      foreign "EverCrypt_HKDF_extract_sha2_256"
        ((ptr uint8_t) @->
           ((ptr uint8_t) @->
              (uint32_t @->
                 ((ptr uint8_t) @-> (uint32_t @-> (returning void))))))
      
    let everCrypt_HKDF_expand_sha2_384 =
      foreign "EverCrypt_HKDF_expand_sha2_384"
        ((ptr uint8_t) @->
           ((ptr uint8_t) @->
              (uint32_t @->
                 ((ptr uint8_t) @->
                    (uint32_t @-> (uint32_t @-> (returning void)))))))
      
    let everCrypt_HKDF_extract_sha2_384 =
      foreign "EverCrypt_HKDF_extract_sha2_384"
        ((ptr uint8_t) @->
           ((ptr uint8_t) @->
              (uint32_t @->
                 ((ptr uint8_t) @-> (uint32_t @-> (returning void))))))
      
    let everCrypt_HKDF_expand_sha2_512 =
      foreign "EverCrypt_HKDF_expand_sha2_512"
        ((ptr uint8_t) @->
           ((ptr uint8_t) @->
              (uint32_t @->
                 ((ptr uint8_t) @->
                    (uint32_t @-> (uint32_t @-> (returning void)))))))
      
    let everCrypt_HKDF_extract_sha2_512 =
      foreign "EverCrypt_HKDF_extract_sha2_512"
        ((ptr uint8_t) @->
           ((ptr uint8_t) @->
              (uint32_t @->
                 ((ptr uint8_t) @-> (uint32_t @-> (returning void))))))
      
    let everCrypt_HKDF_expand =
      foreign "EverCrypt_HKDF_expand"
        (spec_Hash_Definitions_hash_alg @->
           ((ptr uint8_t) @->
              ((ptr uint8_t) @->
                 (uint32_t @->
                    ((ptr uint8_t) @->
                       (uint32_t @-> (uint32_t @-> (returning void))))))))
      
    let everCrypt_HKDF_extract =
      foreign "EverCrypt_HKDF_extract"
        (spec_Hash_Definitions_hash_alg @->
           ((ptr uint8_t) @->
              ((ptr uint8_t) @->
                 (uint32_t @->
                    ((ptr uint8_t) @-> (uint32_t @-> (returning void)))))))
      
    let everCrypt_HKDF_hkdf_expand =
      foreign "EverCrypt_HKDF_hkdf_expand"
        (spec_Hash_Definitions_hash_alg @->
           ((ptr uint8_t) @->
              ((ptr uint8_t) @->
                 (uint32_t @->
                    ((ptr uint8_t) @->
                       (uint32_t @-> (uint32_t @-> (returning void))))))))
      
    let everCrypt_HKDF_hkdf_extract =
      foreign "EverCrypt_HKDF_hkdf_extract"
        (spec_Hash_Definitions_hash_alg @->
           ((ptr uint8_t) @->
              ((ptr uint8_t) @->
                 (uint32_t @->
                    ((ptr uint8_t) @-> (uint32_t @-> (returning void)))))))
      
  end