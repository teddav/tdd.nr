pub mod datamatrix;
mod mystr;

mod tests;

use datamatrix::{
    DataMatrix, FieldMatcher, get_public_key, parse_data, recreate_2ddoc_header, verify_signature,
};
use mystr::MyStrBounded;

// TODO: parse data with JS into JSON -> convert to Prover.toml

pub fn verify_tdd<let MAX_HEADER_SIZE: u32, let MAX_FIELDS: u32, let MAX_FIELD_SIZE: u32, let MAX_DATA_CHECKS: u32, let MAX_DATA_CHECKS_FIELD_SIZE: u32>(
    data: DataMatrix<MAX_FIELDS, MAX_FIELD_SIZE>,
    total_len: u64,
    signature: [u8; 64],
    data_checks: pub BoundedVec<FieldMatcher<MAX_DATA_CHECKS_FIELD_SIZE>, MAX_DATA_CHECKS>,
) {
    let mut header = recreate_2ddoc_header::<MAX_HEADER_SIZE>(data.header);

    let parsed_data = parse_data::<MAX_FIELDS, MAX_FIELD_SIZE>(data.data);
    header.append_mut(MyStrBounded::<MAX_FIELDS * MAX_FIELD_SIZE + 1>::from_slice_var(parsed_data));

    let data_hash = header.hash_var(total_len);

    let public_key = get_public_key(data.header.ca_id.as_bytes(), data.header.cert_id.as_bytes());

    verify_signature(signature, data_hash, public_key);

    assert(data_checks.len() > 0);

    // check data
    for needle in data_checks.storage() {
        data.data_match(needle);
    }
}
