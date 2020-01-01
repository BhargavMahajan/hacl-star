/* 
  This file was generated by KreMLin <https://github.com/FStarLang/kremlin>
  KreMLin invocation: /home/nkulatov/new2/kremlin/kremlin/krml -fbuiltin-uint128 -fnocompound-literals -fc89-scope -fparentheses -fcurly-braces -funroll-loops 4 -warn-error +9 -add-include "kremlib.h" -add-include "FStar_UInt_8_16_32_64.h" /dist/minimal/testlib.c -skip-compilation -no-prefix Hacl.Impl.P256 -bundle Lib.* -bundle Spec.* -bundle C=C.Endianness -bundle Hacl.Hash.SHA2=Hacl.Hash.*,Spec.Hash.* -bundle Hacl.Impl.P256=Hacl.Impl.P256.Arithmetics,Hacl.Impl.P256.PointDouble,Hacl.Impl.P256.PointAdd,Hacl.Impl.P256,Hacl.Impl.P256.MontgomeryMultiplication,Hacl.Impl.P256.LowLevel,Hacl.Impl.LowLevel,Hacl.Impl.SolinasReduction,Hacl.Spec.P256.*,Hacl.Spec.Curve25519.*,Hacl.Impl.Curve25519.* -bundle Hacl.Impl.ECDSA.P256SHA256.Common=Hacl.Impl.ECDSA.MontgomeryMultiplication,Hacl.Impl.ECDSA.Exponent,Hacl.Impl.ECDSA.P256SHA256.Common -library C,FStar -drop LowStar,Spec,Prims,Lib,C.Loops.*,Hacl.Spec.P256.Lemmas,Hacl.Spec.P256,Hacl.Spec.ECDSA,Hacl.Spec.Ladder -add-include "c/Lib_PrintBuffer.h" -add-include "FStar_UInt_8_16_32_64.h" -tmpdir ecdsap256-c .output/prims.krml .output/FStar_Pervasives_Native.krml .output/FStar_Pervasives.krml .output/FStar_Squash.krml .output/FStar_Classical.krml .output/FStar_StrongExcludedMiddle.krml .output/FStar_FunctionalExtensionality.krml .output/FStar_List_Tot_Base.krml .output/FStar_List_Tot_Properties.krml .output/FStar_List_Tot.krml .output/FStar_Mul.krml .output/FStar_Math_Lib.krml .output/FStar_Math_Lemmas.krml .output/FStar_Seq_Base.krml .output/FStar_Seq_Properties.krml .output/FStar_Seq.krml .output/FStar_Set.krml .output/FStar_Preorder.krml .output/FStar_Ghost.krml .output/FStar_ErasedLogic.krml .output/FStar_PropositionalExtensionality.krml .output/FStar_PredicateExtensionality.krml .output/FStar_TSet.krml .output/FStar_Monotonic_Heap.krml .output/FStar_Heap.krml .output/FStar_Map.krml .output/FStar_Monotonic_Witnessed.krml .output/FStar_Monotonic_HyperHeap.krml .output/FStar_Monotonic_HyperStack.krml .output/FStar_HyperStack.krml .output/FStar_HyperStack_ST.krml .output/FStar_Calc.krml .output/FStar_BitVector.krml .output/FStar_UInt.krml .output/FStar_UInt32.krml .output/FStar_Universe.krml .output/FStar_GSet.krml .output/FStar_ModifiesGen.krml .output/FStar_Range.krml .output/FStar_Reflection_Types.krml .output/FStar_Tactics_Types.krml .output/FStar_Tactics_Result.krml .output/FStar_Tactics_Effect.krml .output/FStar_Tactics_Util.krml .output/FStar_Reflection_Data.krml .output/FStar_Reflection_Const.krml .output/FStar_Char.krml .output/FStar_Exn.krml .output/FStar_ST.krml .output/FStar_All.krml .output/FStar_List.krml .output/FStar_String.krml .output/FStar_Order.krml .output/FStar_Reflection_Basic.krml .output/FStar_Reflection_Derived.krml .output/FStar_Tactics_Builtins.krml .output/FStar_Reflection_Formula.krml .output/FStar_Reflection_Derived_Lemmas.krml .output/FStar_Reflection.krml .output/FStar_Tactics_Derived.krml .output/FStar_Tactics_Logic.krml .output/FStar_Tactics.krml .output/FStar_BigOps.krml .output/LowStar_Monotonic_Buffer.krml .output/LowStar_Buffer.krml .output/LowStar_BufferOps.krml .output/Spec_Loops.krml .output/FStar_UInt64.krml .output/C_Loops.krml .output/FStar_Int.krml .output/FStar_Int64.krml .output/FStar_Int63.krml .output/FStar_Int32.krml .output/FStar_Int16.krml .output/FStar_Int8.krml .output/FStar_UInt63.krml .output/FStar_UInt16.krml .output/FStar_UInt8.krml .output/FStar_Int_Cast.krml .output/FStar_UInt128.krml .output/FStar_Int_Cast_Full.krml .output/FStar_Int128.krml .output/Lib_IntTypes.krml .output/Lib_Loops.krml .output/Lib_LoopCombinators.krml .output/Lib_RawIntTypes.krml .output/Lib_Sequence.krml .output/Lib_ByteSequence.krml .output/LowStar_ImmutableBuffer.krml .output/Lib_Buffer.krml .output/FStar_HyperStack_All.krml .output/Hacl_Spec_ECDSAP256_Definition.krml .output/Spec_Hash_Definitions.krml .output/Spec_Hash_Lemmas0.krml .output/Spec_Hash_PadFinish.krml .output/Spec_SHA1.krml .output/Spec_MD5.krml .output/Spec_SHA2_Constants.krml .output/Spec_SHA2.krml .output/Spec_Hash.krml .output/Hacl_Spec_P256_Definitions.krml .output/FStar_Reflection_Arith.krml .output/FStar_Tactics_Canon.krml .output/Hacl_Spec_P256_Lemmas.krml .output/Hacl_Spec_P256.krml .output/Hacl_Spec_ECDSA.krml .output/Hacl_Impl_LowLevel.krml .output/Hacl_Impl_ECDSA_MontgomeryMultiplication.krml .output/FStar_Kremlin_Endianness.krml .output/C_Endianness.krml .output/C.krml .output/Lib_ByteBuffer.krml .output/Hacl_Impl_ECDSA_P256SHA256_Common.krml .output/Hacl_Spec_P256_MontgomeryMultiplication.krml .output/Hacl_Impl_P256_LowLevel.krml .output/Hacl_Spec_P256_SolinasReduction.krml .output/Hacl_Impl_SolinasReduction.krml .output/Spec_Hash_Incremental.krml .output/Spec_Hash_Lemmas.krml .output/Hacl_Hash_Lemmas.krml .output/LowStar_Modifies.krml .output/Hacl_Hash_Definitions.krml .output/Hacl_Hash_PadFinish.krml .output/Hacl_Hash_MD.krml .output/Hacl_Math.krml .output/Hacl_Impl_P256_MontgomeryMultiplication.krml .output/Hacl_Impl_P256_Arithmetics.krml .output/Hacl_Spec_P256_MontgomeryMultiplication_PointDouble.krml .output/Hacl_Spec_P256_MontgomeryMultiplication_PointAdd.krml .output/Hacl_Spec_P256_Ladder.krml .output/Hacl_Impl_ECDSA_MM_Exponent.krml .output/Hacl_Spec_P256_Normalisation.krml .output/Hacl_Impl_P256_PointDouble.krml .output/Hacl_Impl_P256_PointAdd.krml .output/Hacl_Impl_P256.krml .output/Hacl_Hash_Core_SHA2_Constants.krml .output/Hacl_Hash_Core_SHA2.krml .output/Hacl_Hash_SHA2.krml .output/Hacl_Impl_ECDSA_P256SHA256_Signature.krml .output/Hacl_Impl_ECDSA_P256SHA256_KeyGeneration.krml .output/Hacl_Impl_ECDSA_P256SHA256_Verification.krml .output/Hacl_Impl_ECDSA.krml
  F* version: 0fd6ae12
  KreMLin version: 27ce15c8
 */

#include "kremlib.h"
#ifndef __Hacl_Impl_ECDSA_P256SHA256_Verification_H
#define __Hacl_Impl_ECDSA_P256SHA256_Verification_H

#include "Hacl_Impl_ECDSA_MM_Exponent.h"
#include "Hacl_Impl_P256.h"
#include "Hacl_Hash_SHA2.h"
#include "Hacl_Impl_ECDSA_P256SHA256_Common.h"
#include "kremlib.h"
#include "FStar_UInt_8_16_32_64.h"
#include "c/Lib_PrintBuffer.h"
#include "FStar_UInt_8_16_32_64.h"

void Hacl_Impl_ECDSA_P256SHA256_Verification_bufferToJac(uint64_t *p, uint64_t *result);

bool Hacl_Impl_ECDSA_P256SHA256_Verification_isMoreThanZeroLessThanOrderMinusOne(uint64_t *f);

bool Hacl_Impl_ECDSA_P256SHA256_Verification_isCoordinateValid(uint64_t *p);

bool Hacl_Impl_ECDSA_P256SHA256_Verification_isOrderCorrect(uint64_t *p, uint64_t *tempBuffer);

bool
Hacl_Impl_ECDSA_P256SHA256_Verification_verifyQValidCurvePoint(
  uint64_t *pubKeyAsPoint,
  uint64_t *tempBuffer
);

bool Hacl_Impl_ECDSA_P256SHA256_Verification_compare_felem_bool(uint64_t *a, uint64_t *b);

bool
Hacl_Impl_ECDSA_P256SHA256_Verification_ecdsa_verification_core(
  uint64_t *publicKeyBuffer,
  uint64_t *hashAsFelem,
  uint64_t *r,
  uint64_t *s1,
  uint32_t mLen,
  uint8_t *m,
  uint64_t *xBuffer,
  uint64_t *tempBuffer
);

bool
Hacl_Impl_ECDSA_P256SHA256_Verification_ecdsa_verification(
  uint64_t *pubKey,
  uint64_t *r,
  uint64_t *s1,
  uint32_t mLen,
  uint8_t *m
);

bool
Hacl_Impl_ECDSA_P256SHA256_Verification_ecdsa_verification_u8(
  uint8_t *pubKey,
  uint8_t *r,
  uint8_t *s1,
  uint32_t mLen,
  uint8_t *m
);

#define __Hacl_Impl_ECDSA_P256SHA256_Verification_H_DEFINED
#endif
