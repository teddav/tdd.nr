global PUB_KEY_X: [u8; 32] = [
    169, 143, 13, 124, 205, 98, 128, 136, 147, 190, 196, 212, 54, 231, 157, 24, 52, 161, 214, 224,
    1, 215, 15, 28, 76, 220, 205, 157, 158, 47, 226, 41,
];
global PUB_KEY_Y: [u8; 32] = [
    247, 36, 5, 20, 232, 221, 192, 202, 152, 208, 199, 68, 12, 156, 196, 146, 132, 154, 15, 189,
    167, 63, 195, 146, 244, 218, 10, 224, 127, 132, 194, 60,
];

pub fn verify_signature(signature: [u8; 64], data_hash: [u8; 32]) {
    let valid_signature =
        std::ecdsa_secp256r1::verify_signature(PUB_KEY_X, PUB_KEY_Y, signature, data_hash);
    assert(valid_signature);
}

