# Chap04/facebook_post_time_stats.py
import json
from argparse import ArgumentParser
import dateutil.parser
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime, timedelta

def get_parser():
    parser = ArgumentParser()
    parser.add_argument('--file', '-f', required=True, help='The .jsonl file with all the posts')
    return parser

if __name__ == '__main__':
    parser = get_parser()
    args = parser.parse_args()

    with open(args.file) as f:
        posts = []
        for line in f:
            post = json.loads(line)
            created_time = dateutil.parser.parse(post['created_time'])
            posts.append(created_time.strftime('%H:%M:%S'))

    ones = np.ones(len(posts))
    idx = pd.DatetimeIndex(posts)
    my_series = pd.Series(ones, index=idx)

    # Resampling into 1-hour buckets
    per_hour = my_series.resample('1h').agg('sum').fillna(0)

    # Ensure we have a complete index of 24 hours
    full_range = pd.date_range(start="00:00:00", end="23:00:00", freq='1H').time
    per_hour = per_hour.reindex(full_range, fill_value=0)

    # Plotting
    fig, ax = plt.subplots()
    ax.grid(True)
    ax.set_title("Post Frequencies")
    width = 0.8
    ind = np.arange(len(per_hour))
    plt.bar(ind, per_hour, width=width)

    # Generate hourly labels for the x-axis
    tick_pos = ind + width / 2
    labels = [datetime.strptime(f"{i:02}:00", "%H:%M").strftime('%H:%M') for i in range(24)]

    plt.xticks(tick_pos, labels, rotation=90)
    plt.xlabel('Hour of the Day')
    plt.ylabel('Number of Posts')
    plt.tight_layout()
    plt.savefig('posts_per_hour.png')
    plt.show()
