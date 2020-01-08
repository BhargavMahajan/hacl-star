/* MIT License
 *
 * Copyright (c) 2016-2020 INRIA, CMU and Microsoft Corporation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */


#include "Hacl_Curve25519_64.h"

inline static uint64_t add10(uint64_t *out1, uint64_t *f1, uint64_t f2)
{
  #if EVERCRYPT_TARGETCONFIG_GCC
  return add1_inline(out1, f1, f2);
  #else
  uint64_t scrut = add1(out1, f1, f2);
  return scrut;
  #endif
}

inline static void fadd(uint64_t *out1, uint64_t *f1, uint64_t *f2)
{
  #if EVERCRYPT_TARGETCONFIG_GCC
  fadd_inline(out1, f1, f2);
  #else
  uint64_t uu____0 = fadd_(out1, f1, f2);
  #endif
}

inline static void fsub(uint64_t *out1, uint64_t *f1, uint64_t *f2)
{
  #if EVERCRYPT_TARGETCONFIG_GCC
  fsub_inline(out1, f1, f2);
  #else
  uint64_t uu____0 = fsub_(out1, f1, f2);
  #endif
}

inline static void fmul(uint64_t *out1, uint64_t *f1, uint64_t *f2, uint64_t *tmp)
{
  #if EVERCRYPT_TARGETCONFIG_GCC
  fmul_inline(tmp, f1, out1, f2);
  #else
  uint64_t uu____0 = fmul_(tmp, f1, out1, f2);
  #endif
}

inline static void fmul20(uint64_t *out1, uint64_t *f1, uint64_t *f2, uint64_t *tmp)
{
  #if EVERCRYPT_TARGETCONFIG_GCC
  fmul2_inline(tmp, f1, out1, f2);
  #else
  uint64_t uu____0 = fmul2(tmp, f1, out1, f2);
  #endif
}

inline static void fmul10(uint64_t *out1, uint64_t *f1, uint64_t f2)
{
  #if EVERCRYPT_TARGETCONFIG_GCC
  fmul1_inline(out1, f1, f2);
  #else
  uint64_t uu____0 = fmul1(out1, f1, f2);
  #endif
}

inline static void fsqr0(uint64_t *out1, uint64_t *f1, uint64_t *tmp)
{
  #if EVERCRYPT_TARGETCONFIG_GCC
  fsqr_inline(tmp, f1, out1);
  #else
  uint64_t uu____0 = fsqr(tmp, f1, out1);
  #endif
}

inline static void fsqr20(uint64_t *out1, uint64_t *f, uint64_t *tmp)
{
  #if EVERCRYPT_TARGETCONFIG_GCC
  fsqr2_inline(tmp, f, out1);
  #else
  uint64_t uu____0 = fsqr2(tmp, f, out1);
  #endif
}

inline static void cswap20(uint64_t bit, uint64_t *p1, uint64_t *p2)
{
  #if EVERCRYPT_TARGETCONFIG_GCC
  cswap2_inline(bit, p1, p2);
  #else
  uint64_t uu____0 = cswap2(bit, p1, p2);
  #endif
}

static uint8_t
g25519[32U] =
  {
    (uint8_t)9U, (uint8_t)0U, (uint8_t)0U, (uint8_t)0U, (uint8_t)0U, (uint8_t)0U, (uint8_t)0U,
    (uint8_t)0U, (uint8_t)0U, (uint8_t)0U, (uint8_t)0U, (uint8_t)0U, (uint8_t)0U, (uint8_t)0U,
    (uint8_t)0U, (uint8_t)0U, (uint8_t)0U, (uint8_t)0U, (uint8_t)0U, (uint8_t)0U, (uint8_t)0U,
    (uint8_t)0U, (uint8_t)0U, (uint8_t)0U, (uint8_t)0U, (uint8_t)0U, (uint8_t)0U, (uint8_t)0U,
    (uint8_t)0U, (uint8_t)0U, (uint8_t)0U, (uint8_t)0U
  };

static void point_add_and_double(uint64_t *q, uint64_t *p01_tmp1, uint64_t *tmp2)
{
  uint64_t *nq = p01_tmp1;
  uint64_t *nq_p1 = p01_tmp1 + (uint32_t)8U;
  uint64_t *tmp1 = p01_tmp1 + (uint32_t)16U;
  uint64_t *x1 = q;
  uint64_t *x2 = nq;
  uint64_t *z2 = nq + (uint32_t)4U;
  uint64_t *z3 = nq_p1 + (uint32_t)4U;
  uint64_t *a = tmp1;
  uint64_t *b = tmp1 + (uint32_t)4U;
  uint64_t *ab = tmp1;
  uint64_t *dc = tmp1 + (uint32_t)8U;
  uint64_t *x3;
  uint64_t *z31;
  uint64_t *d0;
  uint64_t *c0;
  uint64_t *a1;
  uint64_t *b1;
  uint64_t *d;
  uint64_t *c;
  uint64_t *ab1;
  uint64_t *dc1;
  fadd(a, x2, z2);
  fsub(b, x2, z2);
  x3 = nq_p1;
  z31 = nq_p1 + (uint32_t)4U;
  d0 = dc;
  c0 = dc + (uint32_t)4U;
  fadd(c0, x3, z31);
  fsub(d0, x3, z31);
  fmul20(dc, dc, ab, tmp2);
  fadd(x3, d0, c0);
  fsub(z31, d0, c0);
  a1 = tmp1;
  b1 = tmp1 + (uint32_t)4U;
  d = tmp1 + (uint32_t)8U;
  c = tmp1 + (uint32_t)12U;
  ab1 = tmp1;
  dc1 = tmp1 + (uint32_t)8U;
  fsqr20(dc1, ab1, tmp2);
  fsqr20(nq_p1, nq_p1, tmp2);
  a1[0U] = c[0U];
  a1[1U] = c[1U];
  a1[2U] = c[2U];
  a1[3U] = c[3U];
  fsub(c, d, c);
  fmul10(b1, c, (uint64_t)121665U);
  fadd(b1, b1, d);
  fmul20(nq, dc1, ab1, tmp2);
  fmul(z3, z3, x1, tmp2);
}

static void point_double(uint64_t *nq, uint64_t *tmp1, uint64_t *tmp2)
{
  uint64_t *x2 = nq;
  uint64_t *z2 = nq + (uint32_t)4U;
  uint64_t *a = tmp1;
  uint64_t *b = tmp1 + (uint32_t)4U;
  uint64_t *d = tmp1 + (uint32_t)8U;
  uint64_t *c = tmp1 + (uint32_t)12U;
  uint64_t *ab = tmp1;
  uint64_t *dc = tmp1 + (uint32_t)8U;
  fadd(a, x2, z2);
  fsub(b, x2, z2);
  fsqr20(dc, ab, tmp2);
  a[0U] = c[0U];
  a[1U] = c[1U];
  a[2U] = c[2U];
  a[3U] = c[3U];
  fsub(c, d, c);
  fmul10(b, c, (uint64_t)121665U);
  fadd(b, b, d);
  fmul20(nq, dc, ab, tmp2);
}

static void montgomery_ladder(uint64_t *out, uint8_t *key, uint64_t *init1)
{
  uint64_t tmp2[16U] = { 0U };
  uint64_t p01_tmp1_swap[33U] = { 0U };
  uint64_t *p0 = p01_tmp1_swap;
  uint64_t *p01 = p01_tmp1_swap;
  uint64_t *p03 = p01;
  uint64_t *p11 = p01 + (uint32_t)8U;
  uint64_t *x0;
  uint64_t *z0;
  uint64_t *p01_tmp1;
  uint64_t *p01_tmp11;
  uint64_t *nq10;
  uint64_t *nq_p11;
  uint64_t *swap1;
  uint64_t sw0;
  uint64_t *nq1;
  uint64_t *tmp1;
  memcpy(p11, init1, (uint32_t)8U * sizeof init1[0U]);
  x0 = p03;
  z0 = p03 + (uint32_t)4U;
  x0[0U] = (uint64_t)1U;
  x0[1U] = (uint64_t)0U;
  x0[2U] = (uint64_t)0U;
  x0[3U] = (uint64_t)0U;
  z0[0U] = (uint64_t)0U;
  z0[1U] = (uint64_t)0U;
  z0[2U] = (uint64_t)0U;
  z0[3U] = (uint64_t)0U;
  p01_tmp1 = p01_tmp1_swap;
  p01_tmp11 = p01_tmp1_swap;
  nq10 = p01_tmp1_swap;
  nq_p11 = p01_tmp1_swap + (uint32_t)8U;
  swap1 = p01_tmp1_swap + (uint32_t)32U;
  cswap20((uint64_t)1U, nq10, nq_p11);
  point_add_and_double(init1, p01_tmp11, tmp2);
  swap1[0U] = (uint64_t)1U;
  {
    uint32_t i;
    for (i = (uint32_t)0U; i < (uint32_t)251U; i = i + (uint32_t)1U)
    {
      uint64_t *p01_tmp12 = p01_tmp1_swap;
      uint64_t *swap2 = p01_tmp1_swap + (uint32_t)32U;
      uint64_t *nq2 = p01_tmp12;
      uint64_t *nq_p12 = p01_tmp12 + (uint32_t)8U;
      uint64_t
      bit =
        (uint64_t)(key[((uint32_t)253U - i)
        / (uint32_t)8U]
        >> ((uint32_t)253U - i) % (uint32_t)8U
        & (uint8_t)1U);
      uint64_t sw = swap2[0U] ^ bit;
      cswap20(sw, nq2, nq_p12);
      point_add_and_double(init1, p01_tmp12, tmp2);
      swap2[0U] = bit;
    }
  }
  sw0 = swap1[0U];
  cswap20(sw0, nq10, nq_p11);
  nq1 = p01_tmp1;
  tmp1 = p01_tmp1 + (uint32_t)16U;
  point_double(nq1, tmp1, tmp2);
  point_double(nq1, tmp1, tmp2);
  point_double(nq1, tmp1, tmp2);
  memcpy(out, p0, (uint32_t)8U * sizeof p0[0U]);
}

static void fsquare_times(uint64_t *o, uint64_t *inp, uint64_t *tmp, uint32_t n1)
{
  uint32_t i;
  fsqr0(o, inp, tmp);
  for (i = (uint32_t)0U; i < n1 - (uint32_t)1U; i = i + (uint32_t)1U)
  {
    fsqr0(o, o, tmp);
  }
}

static void finv(uint64_t *o, uint64_t *i, uint64_t *tmp)
{
  uint64_t t1[16U] = { 0U };
  uint64_t *a0 = t1;
  uint64_t *b = t1 + (uint32_t)4U;
  uint64_t *c = t1 + (uint32_t)8U;
  uint64_t *t00 = t1 + (uint32_t)12U;
  uint64_t *tmp1 = tmp;
  uint64_t *a;
  uint64_t *t0;
  fsquare_times(a0, i, tmp1, (uint32_t)1U);
  fsquare_times(t00, a0, tmp1, (uint32_t)2U);
  fmul(b, t00, i, tmp);
  fmul(a0, b, a0, tmp);
  fsquare_times(t00, a0, tmp1, (uint32_t)1U);
  fmul(b, t00, b, tmp);
  fsquare_times(t00, b, tmp1, (uint32_t)5U);
  fmul(b, t00, b, tmp);
  fsquare_times(t00, b, tmp1, (uint32_t)10U);
  fmul(c, t00, b, tmp);
  fsquare_times(t00, c, tmp1, (uint32_t)20U);
  fmul(t00, t00, c, tmp);
  fsquare_times(t00, t00, tmp1, (uint32_t)10U);
  fmul(b, t00, b, tmp);
  fsquare_times(t00, b, tmp1, (uint32_t)50U);
  fmul(c, t00, b, tmp);
  fsquare_times(t00, c, tmp1, (uint32_t)100U);
  fmul(t00, t00, c, tmp);
  fsquare_times(t00, t00, tmp1, (uint32_t)50U);
  fmul(t00, t00, b, tmp);
  fsquare_times(t00, t00, tmp1, (uint32_t)5U);
  a = t1;
  t0 = t1 + (uint32_t)12U;
  fmul(o, t0, a, tmp);
}

static void store_felem(uint64_t *b, uint64_t *f)
{
  uint64_t f30 = f[3U];
  uint64_t top_bit0 = f30 >> (uint32_t)63U;
  uint64_t carry0;
  uint64_t f31;
  uint64_t top_bit;
  uint64_t carry;
  uint64_t f0;
  uint64_t f1;
  uint64_t f2;
  uint64_t f3;
  uint64_t m0;
  uint64_t m1;
  uint64_t m2;
  uint64_t m3;
  uint64_t mask;
  uint64_t f0_;
  uint64_t f1_;
  uint64_t f2_;
  uint64_t f3_;
  uint64_t o0;
  uint64_t o1;
  uint64_t o2;
  uint64_t o3;
  f[3U] = f30 & (uint64_t)0x7fffffffffffffffU;
  carry0 = add10(f, f, (uint64_t)19U * top_bit0);
  f31 = f[3U];
  top_bit = f31 >> (uint32_t)63U;
  f[3U] = f31 & (uint64_t)0x7fffffffffffffffU;
  carry = add10(f, f, (uint64_t)19U * top_bit);
  f0 = f[0U];
  f1 = f[1U];
  f2 = f[2U];
  f3 = f[3U];
  m0 = FStar_UInt64_gte_mask(f0, (uint64_t)0xffffffffffffffedU);
  m1 = FStar_UInt64_eq_mask(f1, (uint64_t)0xffffffffffffffffU);
  m2 = FStar_UInt64_eq_mask(f2, (uint64_t)0xffffffffffffffffU);
  m3 = FStar_UInt64_eq_mask(f3, (uint64_t)0x7fffffffffffffffU);
  mask = ((m0 & m1) & m2) & m3;
  f0_ = f0 - (mask & (uint64_t)0xffffffffffffffedU);
  f1_ = f1 - (mask & (uint64_t)0xffffffffffffffffU);
  f2_ = f2 - (mask & (uint64_t)0xffffffffffffffffU);
  f3_ = f3 - (mask & (uint64_t)0x7fffffffffffffffU);
  o0 = f0_;
  o1 = f1_;
  o2 = f2_;
  o3 = f3_;
  b[0U] = o0;
  b[1U] = o1;
  b[2U] = o2;
  b[3U] = o3;
}

static void encode_point(uint8_t *o, uint64_t *i)
{
  uint64_t *x = i;
  uint64_t *z = i + (uint32_t)4U;
  uint64_t tmp[4U] = { 0U };
  uint64_t u64s[4U] = { 0U };
  uint64_t tmp_w[16U] = { 0U };
  finv(tmp, z, tmp_w);
  fmul(tmp, tmp, x, tmp_w);
  store_felem(u64s, tmp);
  {
    uint32_t i0;
    for (i0 = (uint32_t)0U; i0 < (uint32_t)4U; i0 = i0 + (uint32_t)1U)
    {
      store64_le(o + i0 * (uint32_t)8U, u64s[i0]);
    }
  }
}

void Hacl_Curve25519_64_scalarmult(uint8_t *out, uint8_t *priv, uint8_t *pub)
{
  uint64_t init1[8U] = { 0U };
  uint64_t tmp[4U] = { 0U };
  uint64_t tmp3;
  uint64_t *x;
  uint64_t *z;
  {
    uint32_t i;
    for (i = (uint32_t)0U; i < (uint32_t)4U; i = i + (uint32_t)1U)
    {
      uint64_t *os = tmp;
      uint8_t *bj = pub + i * (uint32_t)8U;
      uint64_t u = load64_le(bj);
      uint64_t r = u;
      uint64_t x0 = r;
      os[i] = x0;
    }
  }
  tmp3 = tmp[3U];
  tmp[3U] = tmp3 & (uint64_t)0x7fffffffffffffffU;
  x = init1;
  z = init1 + (uint32_t)4U;
  z[0U] = (uint64_t)1U;
  z[1U] = (uint64_t)0U;
  z[2U] = (uint64_t)0U;
  z[3U] = (uint64_t)0U;
  x[0U] = tmp[0U];
  x[1U] = tmp[1U];
  x[2U] = tmp[2U];
  x[3U] = tmp[3U];
  montgomery_ladder(init1, priv, init1);
  encode_point(out, init1);
}

void Hacl_Curve25519_64_secret_to_public(uint8_t *pub, uint8_t *priv)
{
  uint8_t basepoint[32U] = { 0U };
  {
    uint32_t i;
    for (i = (uint32_t)0U; i < (uint32_t)32U; i = i + (uint32_t)1U)
    {
      uint8_t *os = basepoint;
      uint8_t x = g25519[i];
      os[i] = x;
    }
  }
  Hacl_Curve25519_64_scalarmult(pub, priv, basepoint);
}

bool Hacl_Curve25519_64_ecdh(uint8_t *out, uint8_t *priv, uint8_t *pub)
{
  uint8_t zeros1[32U] = { 0U };
  Hacl_Curve25519_64_scalarmult(out, priv, pub);
  {
    uint8_t res = (uint8_t)255U;
    uint8_t z;
    bool r;
    {
      uint32_t i;
      for (i = (uint32_t)0U; i < (uint32_t)32U; i = i + (uint32_t)1U)
      {
        uint8_t uu____0 = FStar_UInt8_eq_mask(out[i], zeros1[i]);
        res = uu____0 & res;
      }
    }
    z = res;
    r = z == (uint8_t)255U;
    return !r;
  }
}

