# calc.py

import argparse

parser = argparse.ArgumentParser(description = "CLI calculator")

subparsers = parser.add_subparsers(help = "sub-command help", dest = "command")

# Add a parser for adding
add = subparsers.add_parser("add", help = "add integers")
add.add_argument("ints_to_add", nargs='*', type=int)


# Add a parser for subtracting
sub = subparsers.add_parser("sub", help = "subtract integers")
sub.add_argument("ints_to_sub", nargs=2, type=int)

# Add a parser for multiplying
multi = subparsers.add_parser("multi", help = "multiply integers")
multi.add_argument("ints_to_multi", nargs=2, type=int)

# Add a parser for dividing
div = subparsers.add_parser("div", help = "divide integers")
div.add_argument("ints_to_div", nargs=2, type=int)

args = parser.parse_args()

if args.command == "add":
    our_sum = sum(args.ints_to_add)
    print(f"The sum of values is {our_sum}.")

if args.command == "sub":
    our_diff = args.ints_to_sub[0] - args.ints_to_sub[1]
    print(f"The difference of values is {our_diff}.")

if args.command == "multi":
    our_prod = args.ints_to_multi[0] * args.ints_to_multi[1]
    print(f"The product of values is {our_prod}.")

if args.command == "div":
    if args.ints_to_div[1] != 0:
        our_quot = args.ints_to_div[0] / args.ints_to_div[1]
        print(f"The quotient of values is {our_quot}.")
    else:
        print("Cannot divide by 0.")