use tdd::{data_checks, TDD, verify_tdd};
use tdd::datamatrix::FieldMatcher;
use tdd::mystr::str_vec_to_lower;

global NUMBER_OF_FIELDS: u32 = 7;
global FIELD_SIZE: u32 = 20;
global MAX_HEADER_SIZE: u32 = 100 + NUMBER_OF_FIELDS * FIELD_SIZE;

global DATA_CHECKS_ID: u32 = 2;
global DATA_CHECKS_TAXES: u32 = 4;
global DATA_CHECKS_FIELD_SIZE: u32 = 15;

fn main(
    tdd_id: TDD<NUMBER_OF_FIELDS, FIELD_SIZE>,
    id_first_name: pub FieldMatcher<DATA_CHECKS_FIELD_SIZE>,
    id_last_name: pub FieldMatcher<DATA_CHECKS_FIELD_SIZE>,
    tdd_taxes: TDD<NUMBER_OF_FIELDS, FIELD_SIZE>,
    taxes_first_name: pub FieldMatcher<DATA_CHECKS_FIELD_SIZE>,
    taxes_last_name: pub FieldMatcher<DATA_CHECKS_FIELD_SIZE>,
    taxes_base_revenue: pub FieldMatcher<DATA_CHECKS_FIELD_SIZE>,
    taxes_year: pub FieldMatcher<DATA_CHECKS_FIELD_SIZE>,
) {
    verify_tdd::<MAX_HEADER_SIZE, NUMBER_OF_FIELDS, FIELD_SIZE>(tdd_id);
    let data_checks_id: BoundedVec<FieldMatcher<DATA_CHECKS_FIELD_SIZE>, DATA_CHECKS_ID> =
        BoundedVec::from_array([id_first_name, id_last_name]);
    data_checks(tdd_id.matrix, data_checks_id);

    verify_tdd::<MAX_HEADER_SIZE, NUMBER_OF_FIELDS, FIELD_SIZE>(tdd_taxes);
    let data_checks_taxes: BoundedVec<FieldMatcher<DATA_CHECKS_FIELD_SIZE>, DATA_CHECKS_TAXES> = BoundedVec::from_array(
        [taxes_first_name, taxes_last_name, taxes_base_revenue, taxes_year],
    );
    data_checks(tdd_taxes.matrix, data_checks_taxes);

    let first_name1 = str_vec_to_lower(id_first_name.pattern.unwrap());
    let first_name2 = str_vec_to_lower(taxes_first_name.pattern.unwrap());
    assert(first_name1.storage() == first_name2.storage());

    let last_name1 = str_vec_to_lower(id_last_name.pattern.unwrap());
    let last_name2 = str_vec_to_lower(taxes_last_name.pattern.unwrap());
    assert(last_name1.storage() == last_name2.storage());
}
