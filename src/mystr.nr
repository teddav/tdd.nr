use std::hash::sha256_var;
// use dep::sha256::sha256_var;

pub struct MyStrBounded<let N: u32> {
    pub data: BoundedVec<u8, N>,
}

pub fn push_front<T, let N: u32>(v: BoundedVec<T, N>, value: T) -> BoundedVec<T, N> {
    let mut result: BoundedVec<T, N> = BoundedVec::from_array([value]);
    result.extend_from_bounded_vec(v);
    result
}

impl<let N: u32> MyStrBounded<N> {
    pub fn new() -> Self {
        Self { data: BoundedVec::new() }
    }

    pub fn len(self) -> u32 {
        self.data.len()
    }

    pub fn from_str(s: str<N>) -> Self {
        Self { data: BoundedVec::from_array(s.as_bytes()) }
    }

    pub fn from_str_var<let M: u32>(s: str<M>) -> Self {
        Self { data: BoundedVec::from_array(s.as_bytes()) }
    }

    pub fn from_uint(mut num: u32) -> Self {
        let mut data: BoundedVec<u8, N> = BoundedVec::new();
        for _ in 0..N {
            let digit = (num % 10) as u8;
            let digit_str = digit + 48;
            data = push_front(data, digit_str);
            num = num / 10;
        }
        Self { data }
    }

    pub fn from_slice(value: [u8]) -> Self {
        Self { data: BoundedVec::from_array(value.as_array()) }
    }

    pub fn from_slice_var<let M: u32>(value: [u8; M]) -> Self {
        Self { data: BoundedVec::from_array(value) }
    }

    pub fn as_str(self) -> str<N> {
        self.data.storage().as_str_unchecked()
    }

    pub fn as_array(self) -> [u8; N] {
        self.data.storage()
    }

    pub fn hash(self) -> [u8; 32] {
        let arr = self.as_array();
        let len = self.len();
        sha256_var(arr, len as u64)
    }

    pub fn hash_var(self, len: u64) -> [u8; 32] {
        let arr = self.as_array();
        sha256_var(arr, len)
    }

    pub fn append<let M: u32>(self, other: MyStrBounded<M>) -> MyStrBounded<N + M> {
        let mut data: BoundedVec<u8, N + M> = BoundedVec::new();
        data.extend_from_bounded_vec(self.data);
        data.extend_from_bounded_vec(other.data);
        MyStrBounded { data }
    }

    pub fn append_mut<let M: u32>(&mut self, other: MyStrBounded<M>) {
        self.data.extend_from_bounded_vec(other.data);
    }
}

pub fn str_to_lower<let N: u32>(s: str<N>) -> str<N> {
    let mut result = [0; N];
    let s = s.as_bytes();
    for i in 0..N {
        let c = s[i];
        if c >= 65 & c <= 90 {
            result[i] = c + 32;
        } else {
            result[i] = c;
        }
    }
    result.as_str_unchecked()
}

pub fn str_to_upper<let N: u32>(s: str<N>) -> str<N> {
    let mut result = [0; N];
    let s = s.as_bytes();
    for i in 0..N {
        let c = s[i];
        if c >= 97 & c <= 122 {
            result[i] = c - 32;
        } else {
            result[i] = c;
        }
    }
    result.as_str_unchecked()
}

pub fn str_vec_to_lower<let N: u32>(s: BoundedVec<u8, N>) -> BoundedVec<u8, N> {
    let mut result: BoundedVec<u8, N> = BoundedVec::new();
    let storage = s.storage();
    for i in 0..N {
        if i < s.len() {
            let c = storage[i];
            if c >= 65 & c <= 90 {
                result.push(c + 32);
            } else {
                result.push(c);
            }
        }
    }
    result
}

pub fn str_vec_to_upper<let N: u32>(s: BoundedVec<u8, N>) -> BoundedVec<u8, N> {
    let mut result: BoundedVec<u8, N> = BoundedVec::new();
    let storage = s.storage();
    for i in 0..N {
        if i < s.len() {
            let c = storage[i];
            if c >= 97 & c <= 122 {
                result.push(c - 32);
            } else {
                result.push(c);
            }
        }
    }
    result
}

#[test]
fn test_str_lower_upper() {
    let name = "DaViD";

    let lower_name = str_to_lower(name);
    assert(lower_name == "david");

    let upper_name1 = str_to_upper(name);
    let upper_name2 = str_to_upper(lower_name);
    assert(upper_name1 == "DAVID");
    assert(upper_name2 == "DAVID");
}

#[test]
fn test_str_vec_to_lower_upper() {
    let name: BoundedVec<u8, 20> = BoundedVec::from_array("DaViD".as_bytes());

    let lower_name = str_vec_to_lower(name);
    assert_eq(lower_name, BoundedVec::from_array("david".as_bytes()));

    let upper_name1 = str_vec_to_upper(name);
    let upper_name2 = str_vec_to_upper(lower_name);
    assert(upper_name1 == BoundedVec::from_array("DAVID".as_bytes()));
    assert(upper_name2 == BoundedVec::from_array("DAVID".as_bytes()));
}
