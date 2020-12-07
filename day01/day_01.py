import itertools


def one():
    with open("input_01_1.txt", "r") as f:
        nums = [int(l) for l in f.readlines()]

    for a in nums:
        for b in nums:
            if a+b == 2020:
                print(f"{a} + {b} == {a*b} --> Result = {a * b}")
                return

def two():
    with open("input_01_1.txt", "r") as f:
        nums = [int(l) for l in f.readlines()]

    for a in nums:
        for b in nums:
            for c in nums:
                if a+b+c == 2020:
                    print(f"{a} + {b} + {c} == {a+b+c} --> Result = {a * b * c}")
                    return

if __name__ == "__main__":
    one()
    two()