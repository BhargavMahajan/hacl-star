module Spec.SHA3.Test

#reset-options "--z3rlimit 100 --max_fuel 0"

open FStar.Mul
open Lib.IntTypes
open Lib.RawIntTypes
open Lib.Sequence
open Lib.ByteSequence

let print_and_compare (len:size_nat) (test_expected:lbytes len) (test_result:lbytes len) =
  IO.print_string "\n\nResult:   ";
  List.iter (fun a -> IO.print_string (UInt8.to_string (u8_to_UInt8 a))) (as_list test_result);
  IO.print_string "\nExpected: ";
  List.iter (fun a -> IO.print_string (UInt8.to_string (u8_to_UInt8 a))) (as_list test_expected);
  for_all2 (fun a b -> uint_to_nat #U8 a = uint_to_nat #U8 b) test_expected test_result


let test_sha3 msg_len msg expected224 expected256 expected384 expected512 =
  let msg:lbytes msg_len = createL msg in
  let expected224:lbytes 28 = createL expected224 in
  let expected256:lbytes 32 = createL expected256 in
  let expected384:lbytes 48 = createL expected384 in
  let expected512:lbytes 64 = createL expected512 in

  let test224 = Spec.SHA3.sha3_224 msg_len msg in
  let test256 = Spec.SHA3.sha3_256 msg_len msg in
  let test384 = Spec.SHA3.sha3_384 msg_len msg in
  let test512 = Spec.SHA3.sha3_512 msg_len msg in

  let r224 = print_and_compare 28 expected224 test224 in
  let r256 = print_and_compare 32 expected256 test256 in
  let r384 = print_and_compare 48 expected384 test384 in
  let r512 = print_and_compare 64 expected512 test512 in
  r224 && r256 && r384 && r512

let test_shake128 msg_len msg out_len expected =
  let msg:lbytes msg_len = createL msg in
  let expected:lbytes out_len = createL expected in

  let test = create out_len (u8 0) in
  let test = Spec.SHA3.shake128 msg_len msg out_len test in
  print_and_compare out_len expected test

let test_shake256 msg_len msg out_len expected =
  let msg:lbytes msg_len = createL msg in
  let expected:lbytes out_len = createL expected in

  let test = create out_len (u8 0) in
  let test = Spec.SHA3.shake256 msg_len msg out_len test in
  print_and_compare out_len expected test

//
// Test1_SHA3
//

let test1_plaintext = List.Tot.map u8_from_UInt8 []

let test1_expected_sha3_224 = List.Tot.map u8_from_UInt8 [
  0x6buy; 0x4euy; 0x03uy; 0x42uy; 0x36uy; 0x67uy; 0xdbuy; 0xb7uy; 0x3buy; 0x6euy; 0x15uy; 0x45uy; 0x4fuy; 0x0euy; 0xb1uy; 0xabuy;
  0xd4uy; 0x59uy; 0x7fuy; 0x9auy; 0x1buy; 0x07uy; 0x8euy; 0x3fuy; 0x5buy; 0x5auy; 0x6buy; 0xc7uy
]

let test1_expected_sha3_256 = List.Tot.map u8_from_UInt8 [
  0xa7uy; 0xffuy; 0xc6uy; 0xf8uy; 0xbfuy; 0x1euy; 0xd7uy; 0x66uy; 0x51uy; 0xc1uy; 0x47uy; 0x56uy; 0xa0uy; 0x61uy; 0xd6uy; 0x62uy;
  0xf5uy; 0x80uy; 0xffuy; 0x4duy; 0xe4uy; 0x3buy; 0x49uy; 0xfauy; 0x82uy; 0xd8uy; 0x0auy; 0x4buy; 0x80uy; 0xf8uy; 0x43uy; 0x4auy
]

let test1_expected_sha3_384 = List.Tot.map u8_from_UInt8 [
  0x0cuy; 0x63uy; 0xa7uy; 0x5buy; 0x84uy; 0x5euy; 0x4fuy; 0x7duy; 0x01uy; 0x10uy; 0x7duy; 0x85uy; 0x2euy; 0x4cuy; 0x24uy; 0x85uy;
  0xc5uy; 0x1auy; 0x50uy; 0xaauy; 0xaauy; 0x94uy; 0xfcuy; 0x61uy; 0x99uy; 0x5euy; 0x71uy; 0xbbuy; 0xeeuy; 0x98uy; 0x3auy; 0x2auy;
  0xc3uy; 0x71uy; 0x38uy; 0x31uy; 0x26uy; 0x4auy; 0xdbuy; 0x47uy; 0xfbuy; 0x6buy; 0xd1uy; 0xe0uy; 0x58uy; 0xd5uy; 0xf0uy; 0x04uy
]

let test1_expected_sha3_512 = List.Tot.map u8_from_UInt8 [
  0xa6uy; 0x9fuy; 0x73uy; 0xccuy; 0xa2uy; 0x3auy; 0x9auy; 0xc5uy; 0xc8uy; 0xb5uy; 0x67uy; 0xdcuy; 0x18uy; 0x5auy; 0x75uy; 0x6euy;
  0x97uy; 0xc9uy; 0x82uy; 0x16uy; 0x4fuy; 0xe2uy; 0x58uy; 0x59uy; 0xe0uy; 0xd1uy; 0xdcuy; 0xc1uy; 0x47uy; 0x5cuy; 0x80uy; 0xa6uy;
  0x15uy; 0xb2uy; 0x12uy; 0x3auy; 0xf1uy; 0xf5uy; 0xf9uy; 0x4cuy; 0x11uy; 0xe3uy; 0xe9uy; 0x40uy; 0x2cuy; 0x3auy; 0xc5uy; 0x58uy;
  0xf5uy; 0x00uy; 0x19uy; 0x9duy; 0x95uy; 0xb6uy; 0xd3uy; 0xe3uy; 0x01uy; 0x75uy; 0x85uy; 0x86uy; 0x28uy; 0x1duy; 0xcduy; 0x26uy
]

//
// Test2_SHA3
//

let test2_plaintext = List.Tot.map u8_from_UInt8 [ 0x61uy; 0x62uy; 0x63uy ]

let test2_expected_sha3_224 = List.Tot.map u8_from_UInt8 [
  0xe6uy; 0x42uy; 0x82uy; 0x4cuy; 0x3fuy; 0x8cuy; 0xf2uy; 0x4auy; 0xd0uy; 0x92uy; 0x34uy; 0xeeuy; 0x7duy; 0x3cuy; 0x76uy; 0x6fuy;
  0xc9uy; 0xa3uy; 0xa5uy; 0x16uy; 0x8duy; 0x0cuy; 0x94uy; 0xaduy; 0x73uy; 0xb4uy; 0x6fuy; 0xdfuy
]

let test2_expected_sha3_256 = List.Tot.map u8_from_UInt8 [
  0x3auy; 0x98uy; 0x5duy; 0xa7uy; 0x4fuy; 0xe2uy; 0x25uy; 0xb2uy; 0x04uy; 0x5cuy; 0x17uy; 0x2duy; 0x6buy; 0xd3uy; 0x90uy; 0xbduy;
  0x85uy; 0x5fuy; 0x08uy; 0x6euy; 0x3euy; 0x9duy; 0x52uy; 0x5buy; 0x46uy; 0xbfuy; 0xe2uy; 0x45uy; 0x11uy; 0x43uy; 0x15uy; 0x32uy
]

let test2_expected_sha3_384 = List.Tot.map u8_from_UInt8 [
  0xecuy; 0x01uy; 0x49uy; 0x82uy; 0x88uy; 0x51uy; 0x6fuy; 0xc9uy; 0x26uy; 0x45uy; 0x9fuy; 0x58uy; 0xe2uy; 0xc6uy; 0xaduy; 0x8duy;
  0xf9uy; 0xb4uy; 0x73uy; 0xcbuy; 0x0fuy; 0xc0uy; 0x8cuy; 0x25uy; 0x96uy; 0xdauy; 0x7cuy; 0xf0uy; 0xe4uy; 0x9buy; 0xe4uy; 0xb2uy;
  0x98uy; 0xd8uy; 0x8cuy; 0xeauy; 0x92uy; 0x7auy; 0xc7uy; 0xf5uy; 0x39uy; 0xf1uy; 0xeduy; 0xf2uy; 0x28uy; 0x37uy; 0x6duy; 0x25uy
]

let test2_expected_sha3_512 = List.Tot.map u8_from_UInt8 [
  0xb7uy; 0x51uy; 0x85uy; 0x0buy; 0x1auy; 0x57uy; 0x16uy; 0x8auy; 0x56uy; 0x93uy; 0xcduy; 0x92uy; 0x4buy; 0x6buy; 0x09uy; 0x6euy;
  0x08uy; 0xf6uy; 0x21uy; 0x82uy; 0x74uy; 0x44uy; 0xf7uy; 0x0duy; 0x88uy; 0x4fuy; 0x5duy; 0x02uy; 0x40uy; 0xd2uy; 0x71uy; 0x2euy;
  0x10uy; 0xe1uy; 0x16uy; 0xe9uy; 0x19uy; 0x2auy; 0xf3uy; 0xc9uy; 0x1auy; 0x7euy; 0xc5uy; 0x76uy; 0x47uy; 0xe3uy; 0x93uy; 0x40uy;
  0x57uy; 0x34uy; 0x0buy; 0x4cuy; 0xf4uy; 0x08uy; 0xd5uy; 0xa5uy; 0x65uy; 0x92uy; 0xf8uy; 0x27uy; 0x4euy; 0xecuy; 0x53uy; 0xf0uy
]

//
// Test3_SHA3
//

let test3_plaintext = List.Tot.map u8_from_UInt8 [
  0x61uy; 0x62uy; 0x63uy; 0x64uy; 0x62uy; 0x63uy; 0x64uy; 0x65uy; 0x63uy; 0x64uy; 0x65uy; 0x66uy; 0x64uy; 0x65uy; 0x66uy; 0x67uy;
  0x65uy; 0x66uy; 0x67uy; 0x68uy; 0x66uy; 0x67uy; 0x68uy; 0x69uy; 0x67uy; 0x68uy; 0x69uy; 0x6auy; 0x68uy; 0x69uy; 0x6auy; 0x6buy;
  0x69uy; 0x6auy; 0x6buy; 0x6cuy; 0x6auy; 0x6buy; 0x6cuy; 0x6duy; 0x6buy; 0x6cuy; 0x6duy; 0x6euy; 0x6cuy; 0x6duy; 0x6euy; 0x6fuy;
  0x6duy; 0x6euy; 0x6fuy; 0x70uy; 0x6euy; 0x6fuy; 0x70uy; 0x71uy
]

let test3_expected_sha3_224 = List.Tot.map u8_from_UInt8 [
  0x8auy; 0x24uy; 0x10uy; 0x8buy; 0x15uy; 0x4auy; 0xdauy; 0x21uy; 0xc9uy; 0xfduy; 0x55uy; 0x74uy; 0x49uy; 0x44uy; 0x79uy; 0xbauy;
  0x5cuy; 0x7euy; 0x7auy; 0xb7uy; 0x6euy; 0xf2uy; 0x64uy; 0xeauy; 0xd0uy; 0xfcuy; 0xceuy; 0x33uy
]

let test3_expected_sha3_256 = List.Tot.map u8_from_UInt8 [
  0x41uy; 0xc0uy; 0xdbuy; 0xa2uy; 0xa9uy; 0xd6uy; 0x24uy; 0x08uy; 0x49uy; 0x10uy; 0x03uy; 0x76uy; 0xa8uy; 0x23uy; 0x5euy; 0x2cuy;
  0x82uy; 0xe1uy; 0xb9uy; 0x99uy; 0x8auy; 0x99uy; 0x9euy; 0x21uy; 0xdbuy; 0x32uy; 0xdduy; 0x97uy; 0x49uy; 0x6duy; 0x33uy; 0x76uy;
]

let test3_expected_sha3_384 = List.Tot.map u8_from_UInt8 [
  0x99uy; 0x1cuy; 0x66uy; 0x57uy; 0x55uy; 0xebuy; 0x3auy; 0x4buy; 0x6buy; 0xbduy; 0xfbuy; 0x75uy; 0xc7uy; 0x8auy; 0x49uy; 0x2euy;
  0x8cuy; 0x56uy; 0xa2uy; 0x2cuy; 0x5cuy; 0x4duy; 0x7euy; 0x42uy; 0x9buy; 0xfduy; 0xbcuy; 0x32uy; 0xb9uy; 0xd4uy; 0xaduy; 0x5auy;
  0xa0uy; 0x4auy; 0x1fuy; 0x07uy; 0x6euy; 0x62uy; 0xfeuy; 0xa1uy; 0x9euy; 0xefuy; 0x51uy; 0xacuy; 0xd0uy; 0x65uy; 0x7cuy; 0x22uy;
]

let test3_expected_sha3_512 = List.Tot.map u8_from_UInt8 [
  0x04uy; 0xa3uy; 0x71uy; 0xe8uy; 0x4euy; 0xcfuy; 0xb5uy; 0xb8uy; 0xb7uy; 0x7cuy; 0xb4uy; 0x86uy; 0x10uy; 0xfcuy; 0xa8uy; 0x18uy;
  0x2duy; 0xd4uy; 0x57uy; 0xceuy; 0x6fuy; 0x32uy; 0x6auy; 0x0fuy; 0xd3uy; 0xd7uy; 0xecuy; 0x2fuy; 0x1euy; 0x91uy; 0x63uy; 0x6duy;
  0xeeuy; 0x69uy; 0x1fuy; 0xbeuy; 0x0cuy; 0x98uy; 0x53uy; 0x02uy; 0xbauy; 0x1buy; 0x0duy; 0x8duy; 0xc7uy; 0x8cuy; 0x08uy; 0x63uy;
  0x46uy; 0xb5uy; 0x33uy; 0xb4uy; 0x9cuy; 0x03uy; 0x0duy; 0x99uy; 0xa2uy; 0x7duy; 0xafuy; 0x11uy; 0x39uy; 0xd6uy; 0xe7uy; 0x5euy
]

//
// Test4_SHA3
//

let test4_plaintext = List.Tot.map u8_from_UInt8 [
  0x61uy; 0x62uy; 0x63uy; 0x64uy; 0x65uy; 0x66uy; 0x67uy; 0x68uy; 0x62uy; 0x63uy; 0x64uy; 0x65uy; 0x66uy; 0x67uy; 0x68uy; 0x69uy;
  0x63uy; 0x64uy; 0x65uy; 0x66uy; 0x67uy; 0x68uy; 0x69uy; 0x6auy; 0x64uy; 0x65uy; 0x66uy; 0x67uy; 0x68uy; 0x69uy; 0x6auy; 0x6buy;
  0x65uy; 0x66uy; 0x67uy; 0x68uy; 0x69uy; 0x6auy; 0x6buy; 0x6cuy; 0x66uy; 0x67uy; 0x68uy; 0x69uy; 0x6auy; 0x6buy; 0x6cuy; 0x6duy;
  0x67uy; 0x68uy; 0x69uy; 0x6auy; 0x6buy; 0x6cuy; 0x6duy; 0x6euy; 0x68uy; 0x69uy; 0x6auy; 0x6buy; 0x6cuy; 0x6duy; 0x6euy; 0x6fuy;
  0x69uy; 0x6auy; 0x6buy; 0x6cuy; 0x6duy; 0x6euy; 0x6fuy; 0x70uy; 0x6auy; 0x6buy; 0x6cuy; 0x6duy; 0x6euy; 0x6fuy; 0x70uy; 0x71uy;
  0x6buy; 0x6cuy; 0x6duy; 0x6euy; 0x6fuy; 0x70uy; 0x71uy; 0x72uy; 0x6cuy; 0x6duy; 0x6euy; 0x6fuy; 0x70uy; 0x71uy; 0x72uy; 0x73uy;
  0x6duy; 0x6euy; 0x6fuy; 0x70uy; 0x71uy; 0x72uy; 0x73uy; 0x74uy; 0x6euy; 0x6fuy; 0x70uy; 0x71uy; 0x72uy; 0x73uy; 0x74uy; 0x75uy
]

let test4_expected_sha3_224 = List.Tot.map u8_from_UInt8 [
  0x54uy; 0x3euy; 0x68uy; 0x68uy; 0xe1uy; 0x66uy; 0x6cuy; 0x1auy; 0x64uy; 0x36uy; 0x30uy; 0xdfuy; 0x77uy; 0x36uy; 0x7auy; 0xe5uy;
  0xa6uy; 0x2auy; 0x85uy; 0x07uy; 0x0auy; 0x51uy; 0xc1uy; 0x4cuy; 0xbfuy; 0x66uy; 0x5cuy; 0xbcuy
]

let test4_expected_sha3_256 = List.Tot.map u8_from_UInt8 [
  0x91uy; 0x6fuy; 0x60uy; 0x61uy; 0xfeuy; 0x87uy; 0x97uy; 0x41uy; 0xcauy; 0x64uy; 0x69uy; 0xb4uy; 0x39uy; 0x71uy; 0xdfuy; 0xdbuy;
  0x28uy; 0xb1uy; 0xa3uy; 0x2duy; 0xc3uy; 0x6cuy; 0xb3uy; 0x25uy; 0x4euy; 0x81uy; 0x2buy; 0xe2uy; 0x7auy; 0xaduy; 0x1duy; 0x18uy
]

let test4_expected_sha3_384 = List.Tot.map u8_from_UInt8 [
  0x79uy; 0x40uy; 0x7duy; 0x3buy; 0x59uy; 0x16uy; 0xb5uy; 0x9cuy; 0x3euy; 0x30uy; 0xb0uy; 0x98uy; 0x22uy; 0x97uy; 0x47uy; 0x91uy;
  0xc3uy; 0x13uy; 0xfbuy; 0x9euy; 0xccuy; 0x84uy; 0x9euy; 0x40uy; 0x6fuy; 0x23uy; 0x59uy; 0x2duy; 0x04uy; 0xf6uy; 0x25uy; 0xdcuy;
  0x8cuy; 0x70uy; 0x9buy; 0x98uy; 0xb4uy; 0x3buy; 0x38uy; 0x52uy; 0xb3uy; 0x37uy; 0x21uy; 0x61uy; 0x79uy; 0xaauy; 0x7fuy; 0xc7uy
]

let test4_expected_sha3_512 = List.Tot.map u8_from_UInt8 [
  0xafuy; 0xebuy; 0xb2uy; 0xefuy; 0x54uy; 0x2euy; 0x65uy; 0x79uy; 0xc5uy; 0x0cuy; 0xaduy; 0x06uy; 0xd2uy; 0xe5uy; 0x78uy; 0xf9uy;
  0xf8uy; 0xdduy; 0x68uy; 0x81uy; 0xd7uy; 0xdcuy; 0x82uy; 0x4duy; 0x26uy; 0x36uy; 0x0fuy; 0xeeuy; 0xbfuy; 0x18uy; 0xa4uy; 0xfauy;
  0x73uy; 0xe3uy; 0x26uy; 0x11uy; 0x22uy; 0x94uy; 0x8euy; 0xfcuy; 0xfduy; 0x49uy; 0x2euy; 0x74uy; 0xe8uy; 0x2euy; 0x21uy; 0x89uy;
  0xeduy; 0x0fuy; 0xb4uy; 0x40uy; 0xd1uy; 0x87uy; 0xf3uy; 0x82uy; 0x27uy; 0x0cuy; 0xb4uy; 0x55uy; 0xf2uy; 0x1duy; 0xd1uy; 0x85uy
]

//
// Test5_SHAKE128
//
let test5_plaintext_shake128 = List.Tot.map u8_from_UInt8 []
let test5_expected_shake128 = List.Tot.map u8_from_UInt8 [
  0x7fuy; 0x9cuy; 0x2buy; 0xa4uy; 0xe8uy; 0x8fuy; 0x82uy; 0x7duy; 0x61uy; 0x60uy; 0x45uy; 0x50uy; 0x76uy; 0x05uy; 0x85uy; 0x3euy]
//
// Test6_SHAKE128
//
let test6_plaintext_shake128 = List.Tot.map u8_from_UInt8 [
  0x52uy; 0x97uy; 0x7euy; 0x53uy; 0x2buy; 0xccuy; 0xdbuy; 0x89uy; 0xdfuy; 0xefuy; 0xf7uy; 0xe9uy; 0xe4uy; 0xaduy]
let test6_expected_shake128 = List.Tot.map u8_from_UInt8 [
  0xfbuy; 0xfbuy; 0xa5uy; 0xc1uy; 0xe1uy; 0x79uy; 0xdfuy; 0x14uy; 0x69uy; 0xfcuy; 0xc8uy; 0x58uy; 0x8auy; 0xe5uy; 0xd2uy; 0xccuy]
//
// Test7_SHAKE128
//
let test7_plaintext_shake128 = List.Tot.map u8_from_UInt8 [
  0x4auy; 0x20uy; 0x6auy; 0x5buy; 0x8auy; 0xa3uy; 0x58uy; 0x6cuy; 0x06uy; 0x67uy; 0xa4uy; 0x00uy; 0x20uy; 0xd6uy; 0x5fuy; 0xf5uy;
  0x11uy; 0xd5uy; 0x2buy; 0x73uy; 0x2euy; 0xf7uy; 0xa0uy; 0xc5uy; 0x69uy; 0xf1uy; 0xeeuy; 0x68uy; 0x1auy; 0x4fuy; 0xc3uy; 0x62uy;
  0x00uy; 0x65uy]
let test7_expected_shake128 = List.Tot.map u8_from_UInt8 [
  0x7buy; 0xb4uy; 0x33uy; 0x75uy; 0x2buy; 0x98uy; 0xf9uy; 0x15uy; 0xbeuy; 0x51uy; 0x82uy; 0xbcuy; 0x1fuy; 0x09uy; 0x66uy; 0x48uy]
//
// Test8_SHAKE128
//
let test8_plaintext_shake128 = List.Tot.map u8_from_UInt8 [
  0x24uy; 0x69uy; 0xf1uy; 0x01uy; 0xc9uy; 0xb4uy; 0x99uy; 0xa9uy; 0x30uy; 0xa9uy; 0x7euy; 0xf1uy; 0xb3uy; 0x46uy; 0x73uy; 0xecuy;
  0x74uy; 0x39uy; 0x3fuy; 0xd9uy; 0xfauy; 0xf6uy; 0x58uy; 0xe3uy; 0x1fuy; 0x06uy; 0xeeuy; 0x0buy; 0x29uy; 0xa2uy; 0x2buy; 0x62uy;
  0x37uy; 0x80uy; 0xbauy; 0x7buy; 0xdfuy; 0xeduy; 0x86uy; 0x20uy; 0x15uy; 0x1cuy; 0xc4uy; 0x44uy; 0x4euy; 0xbeuy; 0x33uy; 0x39uy;
  0xe6uy; 0xd2uy; 0xa2uy; 0x23uy; 0xbfuy; 0xbfuy; 0xb4uy; 0xaduy; 0x2cuy; 0xa0uy; 0xe0uy; 0xfauy; 0x0duy; 0xdfuy; 0xbbuy; 0xdfuy;
  0x3buy; 0x05uy; 0x7auy; 0x4fuy; 0x26uy; 0xd0uy; 0xb2uy; 0x16uy; 0xbcuy; 0x87uy; 0x63uy; 0xcauy; 0x8duy; 0x8auy; 0x35uy; 0xffuy;
  0x2duy; 0x2duy; 0x01uy]
let test8_expected_shake128 = List.Tot.map u8_from_UInt8 [
  0x00uy; 0xffuy; 0x5euy; 0xf0uy; 0xcduy; 0x7fuy; 0x8fuy; 0x90uy; 0xaduy; 0x94uy; 0xb7uy; 0x97uy; 0xe9uy; 0xd4uy; 0xdduy; 0x30uy]
//
// Test9_SHAKE256
//
let test9_plaintext_shake256 = List.Tot.map u8_from_UInt8 []
let test9_expected_shake256 = List.Tot.map u8_from_UInt8 [
  0x46uy; 0xb9uy; 0xdduy; 0x2buy; 0x0buy; 0xa8uy; 0x8duy; 0x13uy; 0x23uy; 0x3buy; 0x3fuy; 0xebuy; 0x74uy; 0x3euy; 0xebuy; 0x24uy;
  0x3fuy; 0xcduy; 0x52uy; 0xeauy; 0x62uy; 0xb8uy; 0x1buy; 0x82uy; 0xb5uy; 0x0cuy; 0x27uy; 0x64uy; 0x6euy; 0xd5uy; 0x76uy; 0x2fuy]
//
// Test10_SHAKE256
//
let test10_plaintext_shake256 = List.Tot.map u8_from_UInt8 [
  0xf9uy; 0xdauy; 0x78uy; 0xc8uy; 0x90uy; 0x84uy; 0x70uy; 0x40uy; 0x45uy; 0x4buy; 0xa6uy; 0x42uy; 0x98uy; 0x82uy; 0xb0uy; 0x54uy;
  0x09uy]
let test10_expected_shake256 = List.Tot.map u8_from_UInt8 [
  0xa8uy; 0x49uy; 0x83uy; 0xc9uy; 0xfeuy; 0x75uy; 0xaduy; 0x0duy; 0xe1uy; 0x9euy; 0x2cuy; 0x84uy; 0x20uy; 0xa7uy; 0xeauy; 0x85uy;
  0xb2uy; 0x51uy; 0x02uy; 0x19uy; 0x56uy; 0x14uy; 0xdfuy; 0xa5uy; 0x34uy; 0x7duy; 0xe6uy; 0x0auy; 0x1cuy; 0xe1uy; 0x3buy; 0x60uy]
//
// Test11_SHAKE256
//
let test11_plaintext_shake256 = List.Tot.map u8_from_UInt8 [
  0xefuy; 0x89uy; 0x6cuy; 0xdcuy; 0xb3uy; 0x63uy; 0xa6uy; 0x15uy; 0x91uy; 0x78uy; 0xa1uy; 0xbbuy; 0x1cuy; 0x99uy; 0x39uy; 0x46uy;
  0xc5uy; 0x04uy; 0x02uy; 0x09uy; 0x5cuy; 0xdauy; 0xeauy; 0x4fuy; 0xd4uy; 0xd4uy; 0x19uy; 0xaauy; 0x47uy; 0x32uy; 0x1cuy; 0x88uy]
let test11_expected_shake256 = List.Tot.map u8_from_UInt8 [
  0x7auy; 0xbbuy; 0xa4uy; 0xe8uy; 0xb8uy; 0xdduy; 0x76uy; 0x6buy; 0xbauy; 0xbeuy; 0x98uy; 0xf8uy; 0xf1uy; 0x69uy; 0xcbuy; 0x62uy;
  0x08uy; 0x67uy; 0x4duy; 0xe1uy; 0x9auy; 0x51uy; 0xd7uy; 0x3cuy; 0x92uy; 0xb7uy; 0xdcuy; 0x04uy; 0xa4uy; 0xb5uy; 0xeeuy; 0x3duy]
//
// Test12_SHAKE256
//
let test12_plaintext_shake256 = List.Tot.map u8_from_UInt8 [
  0xdeuy; 0x70uy; 0x1fuy; 0x10uy; 0xaduy; 0x39uy; 0x61uy; 0xb0uy; 0xdauy; 0xccuy; 0x96uy; 0x87uy; 0x3auy; 0x3cuy; 0xd5uy; 0x58uy;
  0x55uy; 0x81uy; 0x88uy; 0xffuy; 0x69uy; 0x6duy; 0x85uy; 0x01uy; 0xb2uy; 0xe2uy; 0x7buy; 0x67uy; 0xe9uy; 0x41uy; 0x90uy; 0xcduy;
  0x0buy; 0x25uy; 0x48uy; 0xb6uy; 0x5buy; 0x52uy; 0xa9uy; 0x22uy; 0xaauy; 0xe8uy; 0x9duy; 0x63uy; 0xd6uy; 0xdduy; 0x97uy; 0x2cuy;
  0x91uy; 0xa9uy; 0x79uy; 0xebuy; 0x63uy; 0x43uy; 0xb6uy; 0x58uy; 0xf2uy; 0x4duy; 0xb3uy; 0x4euy; 0x82uy; 0x8buy; 0x74uy; 0xdbuy;
  0xb8uy; 0x9auy; 0x74uy; 0x93uy; 0xa3uy; 0xdfuy; 0xd4uy; 0x29uy; 0xfduy; 0xbduy; 0xb8uy; 0x40uy; 0xaduy; 0x0buy]
let test12_expected_shake256 = List.Tot.map u8_from_UInt8 [
  0x64uy; 0x2fuy; 0x3fuy; 0x23uy; 0x5auy; 0xc7uy; 0xe3uy; 0xd4uy; 0x34uy; 0x06uy; 0x3buy; 0x5fuy; 0xc9uy; 0x21uy; 0x5fuy; 0xc3uy;
  0xf0uy; 0xe5uy; 0x91uy; 0xe2uy; 0xe7uy; 0xfduy; 0x17uy; 0x66uy; 0x8duy; 0x1auy; 0x0cuy; 0x87uy; 0x46uy; 0x87uy; 0x35uy; 0xc2uy]

let test () =
  IO.print_string "\nTest1 (SHA3)";
  let res_sha3_1 = test_sha3 0 test1_plaintext test1_expected_sha3_224 test1_expected_sha3_256 test1_expected_sha3_384 test1_expected_sha3_512 in
  IO.print_string "\n\nTest2 (SHA3)";
  let res_sha3_2 = test_sha3 3 test2_plaintext test2_expected_sha3_224 test2_expected_sha3_256 test2_expected_sha3_384 test2_expected_sha3_512 in
  IO.print_string "\n\nTest3 (SHA3)";
  let res_sha3_3 = test_sha3 56 test3_plaintext test3_expected_sha3_224 test3_expected_sha3_256 test3_expected_sha3_384 test3_expected_sha3_512 in
  IO.print_string "\n\nTest4 (SHA3)";
  let res_sha3_4 = test_sha3 112 test4_plaintext test4_expected_sha3_224 test4_expected_sha3_256 test4_expected_sha3_384 test4_expected_sha3_512 in
  let res_sha3 = res_sha3_1 && res_sha3_2 && res_sha3_3 && res_sha3_4 in

  IO.print_string "\n\nTest5 (SHAKE128)";
  let res_shake128_1 = test_shake128 0 test5_plaintext_shake128 16 test5_expected_shake128 in
  IO.print_string "\n\nTest6 (SHAKE128)";
  let res_shake128_2 = test_shake128 14 test6_plaintext_shake128 16 test6_expected_shake128 in
  IO.print_string "\n\nTest7 (SHAKE128)";
  let res_shake128_3 = test_shake128 34 test7_plaintext_shake128 16 test7_expected_shake128 in
  IO.print_string "\n\nTest8 (SHAKE128)";
  let res_shake128_4 = test_shake128 83 test8_plaintext_shake128 16 test8_expected_shake128 in
  let res_shake128 = res_shake128_1 && res_shake128_2 && res_shake128_3 && res_shake128_4 in

  IO.print_string "\n\nTest9 (SHAKE256)";
  let res_shake256_1 = test_shake256 0 test9_plaintext_shake256 32 test9_expected_shake256 in
  IO.print_string "\n\nTest10 (SHAKE256)";
  let res_shake256_2 = test_shake256 17 test10_plaintext_shake256 32 test10_expected_shake256 in
  IO.print_string "\n\nTest11 (SHAKE256)";
  let res_shake256_3 = test_shake256 32 test11_plaintext_shake256 32 test11_expected_shake256 in
  IO.print_string "\n\nTest12 (SHAKE256)";
  let res_shake256_4 = test_shake256 78 test12_plaintext_shake256 32 test12_expected_shake256 in
  let res_shake256 = res_shake256_1 && res_shake256_2 && res_shake256_3 && res_shake256_4 in

  let result = res_sha3 && res_shake128 in
  if result then IO.print_string "\n\nSHA3 : Success!\n"
  else IO.print_string "\n\nSHA3: Failure :(\n"
