#! /usr/bin/env python3

import glob
import os
import re
import shutil
import sys

import cv2
import numpy as np


class YoloViz:
    def __init__(self):
        self.color = (50, 255, 50)
        self.black = (0, 0, 0)

        self.thick = 4
        self.thicker = int(self.thick + 1)

        self.font = cv2.FONT_HERSHEY_SIMPLEX
        self.fontScale = 2

        self.dump_dir = "/tmp/yoloviz/"

        # Clean up temporary dir
        shutil.rmtree(self.dump_dir, ignore_errors=True)
        os.makedirs(self.dump_dir)

    def _find_label(self, img_path):
        img_path = os.path.abspath(img_path)
        candidates = [
            re.sub(r"\.[^.]+$", ".txt", img_path),
            re.sub("images", "labels", re.sub(r"\.[^.]+$", ".txt", img_path)),
        ]

        for candidate in candidates:
            if os.path.isfile(candidate):
                return candidate
        return None

    def _draw_img(self, img_path):
        pic = cv2.imread(img_path)
        if pic is None:
            print("Ignoring bad input file %s" % img_path)
            return None

        lab_path = self._find_label(img_path)
        if not lab_path:
            print("Could not find a label for %s" % img_path)
            return None

        with open(lab_path, "r") as file:
            for label in file.readlines():
                cls, x, y, w, h = [float(k) for k in label.split()]

                x1 = int((x - w / 2) * pic.shape[1])
                y1 = int((y - h / 2) * pic.shape[0])

                x2 = int(x1 + w * pic.shape[1])
                y2 = int(y1 + h * pic.shape[0])

                pic = cv2.rectangle(pic, (x1, y1), (x2, y2), self.black, self.thicker)
                pic = cv2.rectangle(pic, (x1, y1), (x2, y2), self.color, self.thick)

                pic = cv2.putText(
                    pic,
                    str(int(cls)),
                    (x1, y1),
                    self.font,
                    self.fontScale,
                    self.black,
                    self.thicker,
                )
                pic = cv2.putText(
                    pic,
                    str(int(cls)),
                    (x1, y1),
                    self.font,
                    self.fontScale,
                    self.color,
                    self.thick,
                )

        outfile = "/tmp/yoloviz/%s" % os.path.basename(img_path)
        cv2.imwrite(outfile, pic)
        return outfile

    def entrypoint(self, *images):

        xdg_open_done = False

        for img in images:
            outfile = self._draw_img(img)
            if outfile and not xdg_open_done:
                os.system("xdg-open %s &" % outfile)
                xdg_open_done = True


if __name__ == "__main__":
    viz = YoloViz()
    viz.entrypoint(*sys.argv[1:])
