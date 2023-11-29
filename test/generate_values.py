import numpy as np

if __name__ == '__main__':
    size = 8
    a = np.random.randint(-8, 8, (size, size), dtype=np.int8)
    b = np.random.randint(-8, 8, (size, size), dtype=np.int8)
    
    c = a @ b
    
    print(a)
    print(b)
    print(c)
    
    # print the binary representation of the values(8 bit signed)
    print('----a----')
    for i in range(size):
        for j in range(size):
            number = bin(a[i,j] & 0xff)[2:]
            # padding to 8 bits
            if len(number) < 8:
                number = '0' * (8 - len(number)) + number
            print(number)
    
    print('----b----')
    for i in range(size):
        for j in range(size):
            number = bin(b[i,j] & 0xff)[2:]
            # padding to 8 bits
            if len(number) < 8:
                number = '0' * (8 - len(number)) + number
            print(number)
    
    print('----c----')
    for i in range(size):
        for j in range(size):
            number = bin(c[i,j] & 0xff)[2:]
            # padding to 8 bits
            if len(number) < 8:
                number = '0' * (8 - len(number)) + number
            print(number)
    