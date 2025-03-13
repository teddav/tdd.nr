use tdd::datamatrix::{DataMatrix, Needle};
use tdd::verify_tdd;

fn main(data: DataMatrix<2, 20>, total_len: u64, signature: [u8; 64], card_number: pub Needle<20>) {
    let data_checks: BoundedVec<Needle<20>, 1> = BoundedVec::from_array([card_number]);
    verify_tdd::<100, 2, 20, 1>(data, total_len, signature, data_checks);
}
