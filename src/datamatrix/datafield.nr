use crate::mystr::str_vec_to_lower;
use dep::string_search::{StringBody, StringBody64, SubString, SubString32};
pub struct DataField<let MAX_DATA_SIZE: u32> {
    pub id: str<2>,
    pub data: BoundedVec<u8, MAX_DATA_SIZE>,
}

pub fn parse_data<let MAX_FIELDS: u32, let MAX_FIELD_SIZE: u32>(
    signed_data: BoundedVec<DataField<MAX_FIELD_SIZE>, MAX_FIELDS>,
) -> [u8; MAX_FIELDS * MAX_FIELD_SIZE] {
    let mut full_data: [u8; MAX_FIELDS * MAX_FIELD_SIZE] = [0; MAX_FIELDS * MAX_FIELD_SIZE];
    let mut index = 0;
    for field in signed_data.storage() {
        if field.data.len() > 0 {
            for id in field.id.as_bytes() {
                full_data[index] = id;
                index += 1;
            }

            for i in 0..MAX_FIELD_SIZE {
                if i < field.data.len() {
                    full_data[index] = field.data.storage()[i];
                    index += 1;
                }
            }
        }
    }

    full_data
}

impl<let N: u32> DataField<N> {
    pub fn data_match<let MAX_NEEDLE_SIZE: u32>(
        self,
        needle: BoundedVec<u8, MAX_NEEDLE_SIZE>,
        case_sensitive: bool,
    ) {
        let (haystack, needle) = if case_sensitive {
            (self.data, needle)
        } else {
            (str_vec_to_lower(self.data), str_vec_to_lower(needle))
        };

        let haystack: StringBody64 = StringBody::new(haystack.storage(), N);
        let needle: SubString32 = SubString::new(needle.storage(), needle.len() as u32);
        let (result, _) = haystack.substring_match(needle);
        assert(result);
    }
}

#[test]
fn test_data_match() {
    let data_field =
        DataField::<20> { id: "60", data: BoundedVec::from_array("David Hello".as_bytes()) };
    let expected_data: BoundedVec<u8, 20> = BoundedVec::from_array("David".as_bytes());

    data_field.data_match(expected_data, true);
    data_field.data_match(expected_data, false);
}

