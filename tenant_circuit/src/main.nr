use tdd::{
    datamatrix::DataField, mystr::str_vec_to_lower, TDD, utils::boundedvec_to_uint, verify_tdd,
};

global NUMBER_OF_FIELDS: u32 = 7;
global FIELD_SIZE: u32 = 20;
global MAX_HEADER_SIZE: u32 = 100 + NUMBER_OF_FIELDS * FIELD_SIZE;

global DATA_CHECKS_FIELD_SIZE: u32 = 15;

struct Output {
    first_name: BoundedVec<u8, DATA_CHECKS_FIELD_SIZE>,
    last_name: BoundedVec<u8, DATA_CHECKS_FIELD_SIZE>,
    base_revenue: u32,
    year: u32,
}

fn main(
    tdd_id: TDD<NUMBER_OF_FIELDS, FIELD_SIZE>,
    id_first_name: pub BoundedVec<u8, DATA_CHECKS_FIELD_SIZE>,
    id_last_name: pub BoundedVec<u8, DATA_CHECKS_FIELD_SIZE>,
    tdd_taxes: TDD<NUMBER_OF_FIELDS, FIELD_SIZE>,
    taxes_first_name: pub BoundedVec<u8, DATA_CHECKS_FIELD_SIZE>,
    taxes_last_name: pub BoundedVec<u8, DATA_CHECKS_FIELD_SIZE>,
    taxes_base_revenue: pub u32,
    taxes_year: pub u32,
) -> pub Output {
    verify_tdd::<MAX_HEADER_SIZE, NUMBER_OF_FIELDS, FIELD_SIZE>(tdd_id);
    verify_tdd::<MAX_HEADER_SIZE, NUMBER_OF_FIELDS, FIELD_SIZE>(tdd_taxes);

    let id_first_name = str_vec_to_lower(id_first_name);
    let id_last_name = str_vec_to_lower(id_last_name);
    let taxes_first_name = str_vec_to_lower(taxes_first_name);
    let taxes_last_name = str_vec_to_lower(taxes_last_name);

    assert(id_first_name.storage() == taxes_first_name.storage());
    assert(id_last_name.storage() == taxes_last_name.storage());

    for i in 0..NUMBER_OF_FIELDS {
        let field_id = tdd_id.matrix.fields.get(i);
        if field_id.id == "60" {
            data_check_name(field_id, id_first_name, 0);
        } else if field_id.id == "62" {
            data_check_name(field_id, id_last_name, 0);
        }

        let field_taxes = tdd_taxes.matrix.fields.get(i);
        if field_taxes.id == "41" {
            data_check_number(field_taxes, taxes_base_revenue, 1);
        } else if field_taxes.id == "45" {
            data_check_number(field_taxes, taxes_year, 0);
        } else if field_taxes.id == "46" {
            data_check_name(field_taxes, taxes_last_name, 0);
            data_check_name(field_taxes, taxes_first_name, taxes_last_name.len() + 1);
        }
    }

    Output {
        first_name: id_first_name,
        last_name: id_last_name,
        base_revenue: taxes_base_revenue,
        year: taxes_year,
    }
}

fn data_check_name<let MAX_FIELD_SIZE: u32, let MAX_NAME_SIZE: u32>(
    field: DataField<MAX_FIELD_SIZE>,
    name: BoundedVec<u8, MAX_NAME_SIZE>,
    start: u32,
) {
    let expected = str_vec_to_lower(field.data);

    for i in 0..MAX_NAME_SIZE {
        if i < name.len() {
            assert(expected.get(start + i) == name.get(i));
        }
    }
}

fn data_check_number<let MAX_FIELD_SIZE: u32, let MAX_NAME_SIZE: u32>(
    field: DataField<MAX_FIELD_SIZE>,
    value: u32,
    inequality: u8,
) {
    let mut data = field.data;
    if data.get(data.len() - 1) == 0x1d {
        let _ = data.pop();
    }
    let expected_value = boundedvec_to_uint(data);

    if inequality == 0 {
        assert(expected_value == value as u64);
    } else if inequality == 1 {
        assert(expected_value > value as u64);
    } else if inequality == 2 {
        assert(expected_value < value as u64);
    }
}
