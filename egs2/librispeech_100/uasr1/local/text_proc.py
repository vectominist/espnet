#!/usr/bin/env python3

import argparse


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("file")
    parser.add_argument("out")
    args = parser.parse_args()
    
    with open(args.file, "r") as fp:
        out_list = []
        for line in fp:
            words = line.strip().split(" ")
            words = [w for w in words if w != "<SIL>"]
            if words[-1].startswith("<SIL>"):
                words[-1] = words[-1][5:]
            out_list.append(" ".join(words))
    
    with open(args.out, "w") as fp:
        for i, line in enumerate(out_list):
            if i != len(out_list) - 1:
                fp.write(line + "\n")
            else:
                fp.write(line)


if __name__ == "__main__":
    main()
