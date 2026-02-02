import bcrypt

password = "123".encode("utf-8")
hashed = bcrypt.hashpw(password, bcrypt.gensalt(rounds=10))
print(hashed.decode("utf-8"))