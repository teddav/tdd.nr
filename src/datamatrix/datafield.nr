pub struct DataField<let MAX_DATA_SIZE: u32> {
    pub id: str<2>,
    pub data: BoundedVec<u8, MAX_DATA_SIZE>,
}

// pub fn parse_data<let N: u32, let M: u32>(signed_data: BoundedVec<SignedData<N>, M>) -> [u8] {
//     let mut full_data: [u8] = [];
//     for doc in signed_data.storage() {
//         if doc.data.len() > 0 {
//             full_data = full_data.append(doc.id.as_bytes());
//             for i in 0..N {
//                 if i < doc.data.len() {
//                     full_data = full_data.append([doc.data.storage()[i]]);
//                 }
//             }
//         }
//     }

//     full_data
// }

pub fn parse_data<let N: u32, let M: u32>(signed_data: BoundedVec<DataField<N>, M>) -> [u8; N * M] {
    let mut full_data: [u8; N * M] = [0; N * M];
    let mut index = 0;
    for doc in signed_data.storage() {
        if doc.data.len() > 0 {
            for id in doc.id.as_bytes() {
                full_data[index] = id;
                index += 1;
            }

            for i in 0..N {
                if i < doc.data.len() {
                    full_data[index] = doc.data.storage()[i];
                    index += 1;
                }
            }
        }
    }

    full_data
}

