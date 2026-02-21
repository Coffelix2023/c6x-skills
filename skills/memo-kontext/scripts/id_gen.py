import hashlib
import time

def encode_base36(num, length):
    alphabet = "0123456789abcdefghijklmnopqrstuvwxyz"
    if num == 0:
        return alphabet[0].zfill(length)
    
    arr = []
    base = 36
    while num:
        num, rem = divmod(num, base)
        arr.append(alphabet[rem])
    
    res = "".join(reversed(arr))
    return res.zfill(length)[-length:]

def generate_hash_id(prefix, title, description, creator, length=4, nonce=0):
    # Combine content to match kontext logic
    # content := fmt.Sprintf("%s|%s|%s|%d|%d", title, description, creator, timestamp.UnixNano(), nonce)
    timestamp_nano = int(time.time() * 1e9)
    content = f"{title}|{description}|{creator}|{timestamp_nano}|{nonce}"
    
    # SHA256 Hash
    h = hashlib.sha256(content.encode('utf-8')).digest()
    
    # Determine num_bytes based on length (matching beads/kontext internal logic)
    if length == 3:
        num_bytes = 2
    elif length == 4:
        num_bytes = 3
    elif length >= 5 and length <= 6:
        num_bytes = 4
    elif length >= 7:
        num_bytes = 5
    else:
        num_bytes = 3
        
    num = int.from_bytes(h[:num_bytes], 'big')
    short_hash = encode_base36(num, length)
    
    return f"{prefix}-{short_hash}"

if __name__ == "__main__":
    import sys
    if len(sys.argv) < 5:
        print("Usage: python id_gen.py <prefix> <title> <description> <creator> [length] [nonce]")
        print("Note: Recommended prefix for Kontext is 'kx'")
        sys.exit(1)
        
    prefix = sys.argv[1]
    title = sys.argv[2]
    description = sys.argv[3]
    creator = sys.argv[4]
    length = int(sys.argv[5]) if len(sys.argv) > 5 else 4
    nonce = int(sys.argv[6]) if len(sys.argv) > 6 else 0
    
    print(generate_hash_id(prefix, title, description, creator, length, nonce))
