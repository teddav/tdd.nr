use tdd::{data_checks, TDD, verify_tdd};
use tdd::datamatrix::{DataMatrix, FieldMatcher};

global NUMBER_OF_FIELDS: u32 = 2;
global FIELD_SIZE: u32 = 20;
global MAX_HEADER_SIZE: u32 = 100 + NUMBER_OF_FIELDS * FIELD_SIZE;

global DATA_CHECKS: u32 = 1;
global DATA_CHECKS_FIELD_SIZE: u32 = 20;

fn main(
    data: DataMatrix<NUMBER_OF_FIELDS, FIELD_SIZE>,
    total_len: u64,
    signature: [u8; 64],
    card_number: pub FieldMatcher<DATA_CHECKS_FIELD_SIZE>,
) {
    let tdd = TDD { matrix: data, total_len, signature };
    verify_tdd::<MAX_HEADER_SIZE, NUMBER_OF_FIELDS, FIELD_SIZE>(tdd);
    let checks: BoundedVec<FieldMatcher<DATA_CHECKS_FIELD_SIZE>, DATA_CHECKS> =
        BoundedVec::from_array([card_number]);
    data_checks(tdd.matrix, checks);
}
