import sys
import re
import argparse
import numpy as np
from datetime import datetime, timedelta
from statistics import mean
import csv
import pandas as pd

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--input_file', type=str, required=True)
    parser.add_argument('--index', type=int, default=0, required=False)
    parser.add_argument('--replica', type=int, default=1, required=False)
    args = parser.parse_args()

    df = pd.read_csv(args.input_file)
    net_total=df["recv"]+df["send"]

    if args.replica == 1:
        print("Replica server {}: max CPU utilization: % {} , max network rate: {} MBps" .format(args.index, df["usr"].max(),net_total.max()/1000000.0 ))
    else:
        print("Client server {}: max CPU utilization: % {} , max network rate: {} MBps" .format(args.index, df["usr"].max(),net_total.max()/1000000.0 ))
