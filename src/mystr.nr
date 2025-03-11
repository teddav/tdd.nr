use std::collections::bounded_vec::BoundedVec;

// use std::hash::sha256_var;
use dep::sha256::sha256_var;

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

