#! /usr/bin/env python3

import torch
import torchaudio
import torchvision
from ultralytics import YOLO

print("Cuda available:", torch.cuda.is_available())
print("Tensor to cuda:", torch.zeros(1).cuda())
print("Attempting inference")
YOLO("yolov8n.pt").cuda().predict()

print("Finished OK")
