import numpy as np

if __name__ == '__main__':
    size = 8
    a = np.arange(size*size).reshape(size, size)
    b = np.arange(size*size).reshape(size, size)
    
    c = (a @ b) 
    d = c // 2**8
    
    print(a)
    print(b)
    print(c)
    print(d)
    
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
            
    print('----d----')
    for i in range(size):
        for j in range(size):
            number = bin(d[i,j] & 0xff)[2:]
            # padding to 8 bits
            if len(number) < 8:
                number = '0' * (8 - len(number)) + number
            print(number)
    