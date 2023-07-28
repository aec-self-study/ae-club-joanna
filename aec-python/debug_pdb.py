import random

denoms = list(range(10))
random.shuffle(denoms)

for i in range(10):
    import pdb; pdb.set_trace()
    print(f'i: {i}')
    denom = denoms[i]
    print(f'denom: {denom}')
    result = 100 / denom