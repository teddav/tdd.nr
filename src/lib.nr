pub mod datamatrix;
mod mystr;
mod utils;

mod tests;

use datamatrix::{
    DataMatrix, FieldMatcher, get_public_key, parse_data, recreate_2ddoc_header, verify_signature,
};
use mystr::MyStrBounded;

pub struct TDD<let MAX_FIELDS: u32, let MAX_FIELD_SIZE: u32> {
    matrix: DataMatrix<MAX_FIELDS, MAX_FIELD_SIZE>,
    total_len: u64,
    signature: [u8; 64],
}

pub fn verify_tdd<let MAX_HEADER_SIZE: u32, let MAX_FIELDS: u32, let MAX_FIELD_SIZE: u32, let MAX_DATA_CHECKS: u32, let MAX_DATA_CHECKS_FIELD_SIZE: u32>(
    tdd: TDD<MAX_FIELDS, MAX_FIELD_SIZE>,
    data_checks: pub BoundedVec<FieldMatcher<MAX_DATA_CHECKS_FIELD_SIZE>, MAX_DATA_CHECKS>,
) {
    let mut header = recreate_2ddoc_header::<MAX_HEADER_SIZE>(tdd.matrix.header);

    let parsed_data = parse_data::<MAX_FIELDS, MAX_FIELD_SIZE>(tdd.matrix.fields);
    header.append_mut(MyStrBounded::<MAX_FIELDS * MAX_FIELD_SIZE + 1>::from_slice_var(parsed_data));

    let data_hash = header.hash_var(tdd.total_len);
    let public_key = get_public_key(
        tdd.matrix.header.ca_id.as_bytes(),
        tdd.matrix.header.cert_id.as_bytes(),
    );
    verify_signature(tdd.signature, data_hash, public_key);

    assert(data_checks.len() > 0);

    // check data
    for needle in data_checks.storage() {
        tdd.matrix.data_match(needle);
    }
}
