use super::mystr::{MyStrBounded, push_front};
use dep::date::Date;

global EPOCH: Date = Date::new(2000, 1, 1);
global HEX_SYMBOLS: [u8; 16] = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70];

pub fn recreate_2ddoc_header<let N: u32>(
    version: u8,
    ca_id: str<4>,
    cert_id: str<4>,
    emit_date: Date,
    sign_date: Date,
    doc_type_id: str<2>,
    perimeter_id: u8,
    country_id: str<2>,
) -> MyStrBounded<N> {
    let mut header = MyStrBounded::<N>::new();

    header.append_mut(MyStrBounded::from_str("DC"));
    header.append_mut(MyStrBounded::<2>::from_uint(version as u32));
    header.append_mut(MyStrBounded::from_str(ca_id));
    header.append_mut(MyStrBounded::from_str(cert_id));
    header.append_mut(diff_date_as_hex_str(emit_date));
    header.append_mut(diff_date_as_hex_str(sign_date));
    header.append_mut(MyStrBounded::from_str(doc_type_id));
    header.append_mut(MyStrBounded::<2>::from_uint(perimeter_id as u32));
    if version == 4 {
        header.append_mut(MyStrBounded::from_str(country_id));
    }

    header
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

