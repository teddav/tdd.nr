use tdd::datamatrix::{
    DataMatrix, get_public_key, Needle, parse_data, recreate_2ddoc_header, verify_signature,
};
use tdd::mystr::MyStrBounded;

fn main(data: DataMatrix<2, 20>, total_len: u64, signature: [u8; 64], card_number: pub Needle<20>) {
    let mut header = recreate_2ddoc_header::<100>(data.header);

    let parsed_data = parse_data::<20, 2>(data.data);
    header.append_mut(MyStrBounded::<50>::from_slice_var(parsed_data));

    let data_hash = header.hash_var(total_len);

    let public_key = get_public_key(data.header.ca_id.as_bytes(), data.header.cert_id.as_bytes());

    verify_signature(signature, data_hash, public_key);

    // check data
    data.data_match(card_number);
}
