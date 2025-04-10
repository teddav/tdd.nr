mod header;
mod datafield;
mod sig;

pub use datafield::{DataField, parse_data};
pub use header::{Header, recreate_2ddoc_header};
pub use sig::{get_public_key, PUBLIC_KEYS, PublicKey, verify_signature};

use crate::utils::boundedvec_to_uint;

pub struct DataMatrix<let MAX_FIELDS: u32, let MAX_FIELD_SIZE: u32> {
    pub header: Header,
    pub fields: BoundedVec<DataField<MAX_FIELD_SIZE>, MAX_FIELDS>,
}

/*
field_type:
1 - string
2 - number

inequality:
0 - equal: value == needle.value
1 - greater than: value > needle.value
2 - less than: value < needle.value
*/
pub struct FieldMatcher<let MAX_DATA_SIZE: u32> {
    pub tdd_field_id: str<2>,
    pub field_type: u8,

    // if it's a string, this is the pattern
    pub pattern: Option<BoundedVec<u8, MAX_DATA_SIZE>>,

    // if it's a number, this is the min value
    pub value: Option<u64>,
    pub inequality: Option<u8>,
}

impl<let MAX_FIELDS: u32, let MAX_FIELD_SIZE: u32> DataMatrix<MAX_FIELDS, MAX_FIELD_SIZE> {
    pub fn data_match<let MAX_DATA_CHECKS_FIELD_SIZE: u32>(
        self,
        needle: FieldMatcher<MAX_DATA_CHECKS_FIELD_SIZE>,
    ) {
        let mut checked: bool = false;

        for i in 0..MAX_FIELDS {
            let field = self.fields.get(i);
            if field.id == needle.tdd_field_id {
                assert(needle.field_type > 0);
                assert(needle.field_type <= 2);

                if needle.field_type == 1 {
                    assert(needle.pattern.is_some());
                    field.data_match(needle.pattern.unwrap(), false);
                } else if needle.field_type == 2 {
                    assert(needle.value.is_some());
                    assert(needle.inequality.is_some());

                    // the last item might be a separator 0x1d, so we need to remove it
                    let mut data = field.data;
                    if data.get(data.len() - 1) == 0x1d {
                        let _ = data.pop();
                    }

                    let value = boundedvec_to_uint(data);
                    let inequality = needle.inequality.unwrap();

                    if inequality == 0 {
                        assert(value == needle.value.unwrap());
                    } else if inequality == 1 {
                        assert(value > needle.value.unwrap());
                    } else if inequality == 2 {
                        assert(value < needle.value.unwrap());
                    }
                }

                checked = true;
            }
        }

        assert(checked);
    }
}
