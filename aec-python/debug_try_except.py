import random

denoms = list(range(10))
random.shuffle(denoms)

for i in range(10):
    denom = denoms[i]
    try:
        result = 100 / denom
    except:
        import pdb; pdb.set_trace()