mod header;
mod datafield;
mod sig;

pub use datafield::{DataField, parse_data};
pub use header::{Header, recreate_2ddoc_header};
pub use sig::{get_public_key, PUBLIC_KEYS, verify_signature};

pub struct DataMatrix<let MAX_FIELDS: u32, let MAX_FIELD_SIZE: u32> {
    pub header: Header,
    pub fields: BoundedVec<DataField<MAX_FIELD_SIZE>, MAX_FIELDS>,
}

pub struct FieldMatcher<let MAX_DATA_SIZE: u32> {
    pub pattern: BoundedVec<u8, MAX_DATA_SIZE>,
    pub tdd_field_id: str<2>,
}

impl<let MAX_FIELDS: u32, let MAX_FIELD_SIZE: u32> DataMatrix<MAX_FIELDS, MAX_FIELD_SIZE> {
    pub fn data_match<let MAX_DATA_CHECKS_FIELD_SIZE: u32>(
        self,
        needle: FieldMatcher<MAX_DATA_CHECKS_FIELD_SIZE>,
    ) {
        for i in 0..MAX_FIELDS {
            if self.fields.get(i).id == needle.tdd_field_id {
                self.fields.get(i).data_match(needle.pattern, false);
            }
        }
    }
}
