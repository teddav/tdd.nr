use crate::mystr::{MyStrBounded, push_front};
use dep::date::Date;

global EPOCH: Date = Date::new(2000, 1, 1);
global HEX_SYMBOLS: [u8; 16] = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70];

pub struct Header {
    pub version: u8,
    pub ca_id: str<4>,
    pub cert_id: str<4>,
    pub emit_date: Date,
    pub sign_date: Date,
    pub doc_type_id: str<2>,
    pub perimeter_id: u8,
    pub country_id: str<2>,
}

pub fn recreate_2ddoc_header<let N: u32>(header: Header) -> MyStrBounded<N> {
    let mut result = MyStrBounded::<N>::new();

    result.append_mut(MyStrBounded::from_str("DC"));
    result.append_mut(MyStrBounded::<2>::from_uint(header.version as u32));
    result.append_mut(MyStrBounded::from_str(header.ca_id));
    result.append_mut(MyStrBounded::from_str(header.cert_id));
    result.append_mut(diff_date_as_hex_str(header.emit_date));
    result.append_mut(diff_date_as_hex_str(header.sign_date));
    result.append_mut(MyStrBounded::from_str(header.doc_type_id));
    result.append_mut(MyStrBounded::<2>::from_uint(header.perimeter_id as u32));
    if header.version == 4 {
        result.append_mut(MyStrBounded::from_str(header.country_id));
    }

    result
}

fn diff_date_as_hex_str(date: Date) -> MyStrBounded<4> {
    // TO CHECK: if the date is always 2 bytes (4 char)
    let length = 4;

    let mut diff = date.get_duration_in_days(EPOCH, true);
    let mut result = MyStrBounded::<4>::new();

    for _ in 0..length {
        let byte = diff % 16;
        let digit_str = HEX_SYMBOLS[byte];
        result.data = push_front(result.data, digit_str);
        diff = diff / 16;
    }

    result
}

