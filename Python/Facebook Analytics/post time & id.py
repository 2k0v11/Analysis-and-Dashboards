import os
import json
import facebook
import requests


def getTokenFromFile(fileName):
    with open(fileName, encoding='utf-8') as fp:
        return fp.readline()


if __name__ == '__main__':
    token = getTokenFromFile('token_my.txt')
    graph = facebook.GraphAPI(token)
    posts = graph.get_connections('me', 'posts')
    while True:  # keep paginating
        try:
            with open('my_posts.jsonl', 'a') as f:
                for post in posts['data']:
                    f.write(json.dumps(post) + "\n")
                # get next page
                posts = requests.get(posts['paging']['next']).json()
        except KeyError:
            # no more pages, break the loop
            break
