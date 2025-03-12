mod header;
mod datafield;
mod sig;

pub use datafield::{DataField, parse_data};
pub use header::{Header, recreate_2ddoc_header};
pub use sig::{get_public_key, PUBLIC_KEYS, verify_signature};

pub struct DataMatrix<let MAX_FIELDS: u32, let MAX_FIELD_SIZE: u32> {
    pub header: Header,
    pub data: BoundedVec<DataField<MAX_FIELD_SIZE>, MAX_FIELDS>,
}
