use dep::date::Date;

use crate::datamatrix::{
    DataField, get_public_key, Header, parse_data, PUBLIC_KEYS, recreate_2ddoc_header,
    verify_signature,
};
use crate::mystr::MyStrBounded;

#[test]
fn test_verify_signature() {
    // DC03FR000001FFFF18EAA501AL12345678901AI30112019UBVQ7MMXTQ5FE3LZPIAZY6HZNGQJ3GLTKU6T4NJ5PGSKFECBUQIAPEWMZYIIEHZSQBDKG2QCJIXUONTMFXYMYYTTITJAOCVJQ7EOARY

    let signature = [
        160, 107, 15, 177, 151, 156, 58, 82, 109, 121, 122, 1, 156, 120, 249, 105, 160, 157, 153,
        115, 85, 61, 62, 53, 61, 121, 164, 162, 144, 65, 164, 16, 7, 146, 204, 206, 16, 130, 31, 50,
        128, 70, 163, 106, 2, 74, 47, 71, 54, 108, 45, 240, 204, 98, 115, 68, 210, 7, 10, 169, 135,
        200, 224, 71,
    ];

    let header = Header {
        version: 3,
        ca_id: "FR00",
        cert_id: "0001",
        emit_date: Date::new(2179, 06, 06),
        sign_date: Date::new(2017, 06, 18),
        doc_type_id: "A5",
        perimeter_id: 1,
        country_id: "FR",
    };

    let mut header = recreate_2ddoc_header::<100>(header);

    let data = "AL12345678901AI30112019";
    header.append_mut(MyStrBounded::from_str(data));

    let data_hash = header.hash();

    let key = get_public_key("FR00".as_bytes(), "0001".as_bytes());
    verify_signature(signature, data_hash, key);
}

#[test]
fn test_parse_data() {
    let mut signed_data: BoundedVec<DataField<20>, 5> = BoundedVec::new();
    signed_data.push(DataField { id: "AL", data: BoundedVec::from_array("12345678901".as_bytes()) });
    signed_data.push(DataField { id: "AI", data: BoundedVec::from_array("30112019".as_bytes()) });
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
    let header = Header {
        version: 3,
        ca_id: "FR00",
        cert_id: "0001",
        emit_date: Date::new(2179, 06, 06),
        sign_date: Date::new(2017, 06, 18),
        doc_type_id: "A5",
        perimeter_id: 1,
        country_id: "FR",
    };
    let header = recreate_2ddoc_header::<24>(header);
    // println(f"HEADER {header}");
    let s = header.as_str();
    // println(f"s {s}");
    assert(s == "DC03FR000001FFFF18EAA501");
}

#[test]
pub fn test_public_keys() {
    let key = PUBLIC_KEYS.get(("FR00".as_bytes(), "0001".as_bytes()));
    assert(key.is_some());
    assert(
        key.unwrap().x
            == [
                169, 143, 13, 124, 205, 98, 128, 136, 147, 190, 196, 212, 54, 231, 157, 24, 52, 161,
                214, 224, 1, 215, 15, 28, 76, 220, 205, 157, 158, 47, 226, 41,
            ],
    );
    assert(
        key.unwrap().y
            == [
                247, 36, 5, 20, 232, 221, 192, 202, 152, 208, 199, 68, 12, 156, 196, 146, 132, 154,
                15, 189, 167, 63, 195, 146, 244, 218, 10, 224, 127, 132, 194, 60,
            ],
    );
}
