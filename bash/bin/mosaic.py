#! /usr/bin/env python3

import argparse
import math
import os
import random
import shutil
import subprocess
import tempfile
from concurrent.futures import ThreadPoolExecutor, as_completed

from PIL import Image
from tqdm import tqdm

IMAGE_FORMATS = {".jpg", ".jpeg", ".png", ".bmp", ".gif"}


def get_image_paths_from_inputs(inputs):
    image_paths = []
    for inp in inputs:
        if os.path.isdir(inp):
            for root, _, files in os.walk(inp):
                for f in files:
                    if os.path.splitext(f.lower())[1] in IMAGE_FORMATS:
                        image_paths.append(os.path.join(root, f))
        elif os.path.isfile(inp) and os.path.splitext(inp.lower())[1] in IMAGE_FORMATS:
            image_paths.append(inp)
        else:
            print(f"Warning: Ignored unsupported path: {inp}")
    return image_paths


def load_and_resize_image(path, size):
    try:
        with Image.open(path) as img:
            img = img.convert("RGB")
            img.thumbnail(size, Image.Resampling.LANCZOS)
            return img
    except Exception as e:
        print(f"Error processing {path}: {e}")
        return None


def create_mosaic(image_paths, max_size, max_images, num_threads):
    if len(image_paths) == 0:
        raise ValueError("No valid images found.")

    if len(image_paths) > max_images:
        image_paths = random.sample(image_paths, max_images)

    num_images = len(image_paths)
    grid_size = math.ceil(math.sqrt(num_images))
    thumb_size = (max_size // grid_size, max_size // grid_size)

    thumbnails = []
    with ThreadPoolExecutor(max_workers=num_threads) as executor:
        futures = {
            executor.submit(load_and_resize_image, path, thumb_size): path
            for path in image_paths
        }
        for future in tqdm(
            as_completed(futures), total=len(futures), desc="Processing images"
        ):
            img = future.result()
            if img:
                thumbnails.append(img)

    grid_size = math.ceil(math.sqrt(len(thumbnails)))
    thumb_w, thumb_h = thumb_size
    mosaic = Image.new(
        "RGB", (thumb_w * grid_size, thumb_h * grid_size), (255, 255, 255)
    )

    for i, img in enumerate(tqdm(thumbnails, desc="Building mosaic")):
        x = (i % grid_size) * thumb_w
        y = (i // grid_size) * thumb_h
        mosaic.paste(img, (x, y))

    return mosaic


def run_command(template, image_path):
    if "{}" not in template:
        print("Warning: --exec command does not include `{}` placeholder. Skipping.")
        return
    command = template.replace("{}", f'"{image_path}"')
    print(f"Executing: {command}")
    try:
        subprocess.run(command, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Command failed: {e}")


def main():
    # fmt: off
    parser = argparse.ArgumentParser(
        description="Create a mosaic from image files and/or directories."
    )
    parser.add_argument("inputs", nargs="+", help="Input image files and/or directories")
    parser.add_argument("-o", "--output-file", help="Mosaic destination")
    parser.add_argument("-s", "--max-size", type=int, default=2000, help="Maximum width/height of the mosaic")
    parser.add_argument("-n", "--max-images", type=int, default=2500, help="Maximum number of images to include")
    parser.add_argument("-t", "--threads", type=int, default=min(32, (os.cpu_count() or 4) * 2), help="Number of threads to use")
    parser.add_argument("-e", "--exec", nargs="+", help="Shell command to run on result image. Use `{}` as placeholder for image path.")
    args = parser.parse_args()
    # fmt: off

    tmp_dir = tempfile.mkdtemp(prefix="mosaic_", dir="/tmp")
    tmp_output_path = os.path.join(tmp_dir, "mosaic.jpg")

    print(f"Temporary output path: {tmp_output_path}")
    print("Collecting images...")

    image_paths = get_image_paths_from_inputs(args.inputs)
    print(f"Found {len(image_paths)} image(s).")

    try:
        mosaic = create_mosaic(
            image_paths=image_paths,
            max_size=args.max_size,
            max_images=args.max_images,
            num_threads=args.threads,
        )
        mosaic.save(tmp_output_path)

        if args.output_file:
            shutil.copy(tmp_output_path, args.output_file)
            print(f"Copied mosaic to: {args.output_file}")
        else:
            print(f"Mosaic saved to temporary location: {tmp_output_path}")

        if args.exec:
            run_command(" ".join(args.exec), tmp_output_path)

    finally:
        pass
        # Optionally clean up:
        # shutil.rmtree(tmp_dir)


if __name__ == "__main__":
    main()
