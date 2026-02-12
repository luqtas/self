from datetime import datetime
import pickle, getpass

username = getpass.getuser()
woke = None

def init():
    global woke
    woke = datetime.now()
    save()

def save():
    with open('/storage/emulated/0/cloud/self/woke.pkl', 'wb') as f:
        pickle.dump(woke, f)

init()
