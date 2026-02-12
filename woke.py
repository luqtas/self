from datetime import datetime
import pickle, getpass

username = getpass.getuser()
woke = None

def init():
    global woke
    woke = datetime.now()
    save()

def save():
    with open('/home/%s/Desktop/cloud/self/woke.pkl' % (username), 'wb') as f:
        pickle.dump(woke, f)

init()
