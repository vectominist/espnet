import argparse

from sklearn.metrics import classification_report


def main(args):
    txt_path = f"{args.dir}/lid.trn"
    with open(txt_path, "r", encoding="utf-8") as f:
        correct, total = 0, 0
        y_true, y_pred = [], []
        for line in f:
            if line == "\n":
                continue
            [pred, gt, name] = line.strip().split("\t")
            gt = f"[{gt}]"
            y_true.append(gt)
            y_pred.append(pred)
            if pred == gt:
                correct += 1
            total += 1

        # lid_report = classification_report(y_true, y_pred)
        # # write lid report to file
        # with open(f"{args.dir}/scores.txt", "w") as f:
        #     f.write(lid_report)

        with open(f"{args.dir}/scores.txt", "w") as f:
            f.write(f"Acc: {correct / total * 100:.2f}%")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--dir", type=str)

    args = parser.parse_args()
    main(args)
