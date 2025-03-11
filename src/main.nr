pub mod data;
pub mod header;
pub mod sig;
pub mod mystr;
mod tests;

use dep::date::Date;
use data::{parse_data, SignedData};
use header::recreate_2ddoc_header;
use mystr::MyStrBounded;
use sig::verify_signature;
use std::collections::bounded_vec::BoundedVec;

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

    verify_signature(signature, data_hash);
}
