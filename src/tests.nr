use dep::date::Date;

use super::data::{parse_data, SignedData};
use super::header::recreate_2ddoc_header;
use super::mystr::MyStrBounded;
use super::sig::verify_signature;

#[test]
fn test_verify_signature() {
    // DC03FR000001FFFF18EAA501AL12345678901AI30112019UBVQ7MMXTQ5FE3LZPIAZY6HZNGQJ3GLTKU6T4NJ5PGSKFECBUQIAPEWMZYIIEHZSQBDKG2QCJIXUONTMFXYMYYTTITJAOCVJQ7EOARY

    let signature = [
        160, 107, 15, 177, 151, 156, 58, 82, 109, 121, 122, 1, 156, 120, 249, 105, 160, 157, 153,
        115, 85, 61, 62, 53, 61, 121, 164, 162, 144, 65, 164, 16, 7, 146, 204, 206, 16, 130, 31, 50,
        128, 70, 163, 106, 2, 74, 47, 71, 54, 108, 45, 240, 204, 98, 115, 68, 210, 7, 10, 169, 135,
        200, 224, 71,
    ];

    let mut header = recreate_2ddoc_header::<100>(
        3,
        "FR00",
        "0001",
        Date::new(2179, 06, 06),
        Date::new(2017, 06, 18),
        "A5",
        1,
        "FR",
    );

    let data = "AL12345678901AI30112019";
    header.append_mut(MyStrBounded::from_str(data));

    let data_hash = header.hash();
    verify_signature(signature, data_hash);
}

#[test]
fn test_parse_data() {
    let mut signed_data: BoundedVec<SignedData<20>, 5> = BoundedVec::new();
    signed_data.push(
        SignedData { id: "AL", data: BoundedVec::from_array("12345678901".as_bytes()) },
    );
    signed_data.push(SignedData { id: "AI", data: BoundedVec::from_array("30112019".as_bytes()) });
    let full_data = parse_data(signed_data);
    // assert(full_data == "AL12345678901AI30112019".as_bytes());
    let expected = [
        65, 76, 49, 50, 51, 52, 53, 54, 55, 56, 57, 48, 49, 65, 73, 51, 48, 49, 49, 50, 48, 49, 57,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    ];
    assert(full_data == expected);
}

#[test]
fn test_2ddoc_header() {
    let header = recreate_2ddoc_header::<24>(
        3,
        "FR00",
        "0001",
        Date::new(2179, 06, 06),
        Date::new(2017, 06, 18),
        "A5",
        1,
        "FR",
    );
    // println(f"HEADER {header}");
    let s = header.as_str();
    // println(f"s {s}");
    assert(s == "DC03FR000001FFFF18EAA501");
}
