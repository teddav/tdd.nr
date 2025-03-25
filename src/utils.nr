// Adapted from https://github.com/madztheo/noir-string-utils/blob/main/src/lib.nr
// thanks to madztheo for the implementation
global ZERO_INDEX: u8 = 48;
global NINE_INDEX: u8 = 57;

pub fn str_to_uint<let N: u32>(s: str<N>) -> u64 {
    let mut result = 0;
    for i in 0..N {
        let byte = s.as_bytes()[i];
        assert((byte >= ZERO_INDEX) & (byte <= NINE_INDEX), "Character is not a digit");
        let digit = byte - ZERO_INDEX;
        result = result * 10 + digit as u64;
    }
    result
}

pub fn boundedvec_to_uint<let N: u32>(s: BoundedVec<u8, N>) -> u64 {
    let mut result = 0;
    for i in 0..N {
        if i < s.len() {
            let byte = s.get(i);
            assert((byte >= ZERO_INDEX) & (byte <= NINE_INDEX), "Character is not a digit");
            let digit = byte - ZERO_INDEX;
            result = result * 10 + digit as u64;
        }
    }
    result
}

#[test]
fn test_str_to_uint() {
    let num = str_to_uint("12345");
    assert(num == 12345);

    let b: BoundedVec<u8, 10> = BoundedVec::from_array("654321".as_bytes());
    let num = boundedvec_to_uint(b);
    assert(num == 654321);
}
