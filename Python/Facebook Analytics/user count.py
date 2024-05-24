import os
import json
import facebook


def getTokenFromFile(fileName):
    with open(fileName, encoding='utf-8') as fp:
        return fp.readline()


if __name__ == '__main__':
    token = getTokenFromFile("token_my.txt")
    graph = facebook.GraphAPI(token)
    user = graph.get_object("me")
    friends = graph.get_connections(user["id"],"friends")
    print(json.dumps(friends, indent=4))
