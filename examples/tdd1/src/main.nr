use tdd::data::{parse_data, SignedData};
use tdd::Date;
use tdd::header::recreate_2ddoc_header;
use tdd::mystr::MyStrBounded;
use tdd::sig::{get_public_key, verify_signature};

fn main(
    version: pub u8,
    ca_id: pub str<4>,
    cert_id: pub str<4>,
    emit_date: pub Date,
    sign_date: pub Date,
    doc_type_id: pub str<2>,
    perimeter_id: pub u8,
    country_id: pub str<2>,
    data: pub BoundedVec<SignedData<20>, 2>,
    total_len: pub u64,
    signature: pub [u8; 64],
) {
    let mut header = recreate_2ddoc_header::<100>(
        version,
        ca_id,
        cert_id,
        emit_date,
        sign_date,
        doc_type_id,
        perimeter_id,
        country_id,
    );

    let parsed_data = parse_data::<20, 2>(data);
    header.append_mut(MyStrBounded::<50>::from_slice_var(parsed_data));

    let data_hash = header.hash_var(total_len);

    let public_key = get_public_key(ca_id.as_bytes(), cert_id.as_bytes());

    verify_signature(signature, data_hash, public_key);
}
