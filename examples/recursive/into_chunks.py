import hashlib


def hash(data):
    return hashlib.sha256(data).hexdigest()


def split_into_chunks(s, chunk_size=64, prefix="0x"):
    return [prefix + s[i:i+chunk_size] for i in range(0, len(s), chunk_size)]


proof_file = open("first/proof/proof", "rb").read()
proof = split_into_chunks(proof_file.hex()[8:])
print("============ PROOF =============")
print(len(proof))
print(proof)

vk_file = open("first/proof/vk", "rb").read()
vk = split_into_chunks(vk_file.hex()[8:])
print("============ VK =============")
print(len(vk))
print(vk)
print("KEY HASH: ", "0x" + hash(vk_file))
