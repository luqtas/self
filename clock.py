from datetime import datetime, timezone, timedelta, time
import calendar, sys, subprocess, pickle, getpass

birthday = 1996
username = getpass.getuser()

arg = []
if __name__ == "__main__":
    lenght = len(sys.argv) - 1
    for o in range(lenght):
        o = o + 1
        arg.append(sys.argv[o])

def clock():
    year = datetime.now().year
    o = datetime.strptime(('01.01.%s' % year),'%d.%m.%Y')
    x = datetime.now()

    # how much % of the year has passed
    y = ((x - o).days * 100) / (365 + calendar.isleap(year))
    z = int(y)
    if len(arg) >= 3:
        if arg[2] == "0":
            z = int(y)
        elif arg[2] == "1":
            z = f"{y:.2f}"

    # % of an increment on z
    #e = int((float(f"{y:.2f}") - z) * 100)
    #print(e)

    # how much % passed from the day
    d = x + timedelta(days=1)
    e = datetime.combine(d, time.min) - x
    f = 100 - ((e.seconds * 100) / 86400)

    # how much % passed from the day based on user's waking time
    with open('/home/%s/Desktop/cloud/self/woke.pkl' % (username), 'rb') as f:
        woke = pickle.load(f)
    zzz = 8 # how much hours do you sleep?
    zzz = 24 - zzz
    if x.hour >= woke.hour:
        a = woke + timedelta(hours=zzz)
    else:
        a = woke - timedelta(hours=zzz)
    b = a - x
    c = 100 - ((b.seconds * 100) / (zzz * 60 * 60))
    o = (x - a).days
    
    if o > -1: # logic for going past 100%, based on how much days passed from woke time
        c = c + ((o + 1) * 100)
    
    if len(arg) >= 2:
        if arg[1] == "0":
            c = int(c)
        elif arg[1] == "1":
            c = f"{c:.3f}"

    # how old are you sweetheart?
    age = year - birthday
    
    # getting the time
    if arg[0] == "1":
        if c >= 10001:
            print("    💤    ")
        else:
            print(str(str(c) + "  " + str(z) + "  " + str(age)))
    
    # opening the log document based on year% + age
    elif arg[0] == "2":
        if arg[1] == "1": # ~/logs
            action = "/home/luqtas/logs/" + str(z) + "-" + str(age) + ".org"
            subprocess.Popen(["/usr/local/bin/run-or-raise 'emacsclient %s' 'emacsclient %s'" % (action, action)], shell=True)
        elif arg[1] == "2": # qob
            action = "/home/luqtas/Desktop/qob/Emacs/logs/" + str(z) + "-" + str(age) + ".org"
            subprocess.Popen(["/usr/local/bin/run-or-raise 'emacsclient %s' 'emacsclient %s'" % (action, action)], shell=True)
        elif arg[1] == "3": # silver-ball
            action = "/home/luqtas/Desktop/projects/silver-ball/logs/" + str(z) + "-" + str(age) + ".org"
            subprocess.Popen(["/usr/local/bin/run-or-raise 'emacsclient %s' 'emacsclient %s'" % (action, action)], shell=True)

clock()

# TODO
# icons for indicating stuff to do... ideally this routine is organized based on user marking if they did or not?
 # how about an "register phase" where the app takes into consideration user's activity registers to set a routine?
    # ☀ (day)
    # 🌙 (night)
    # 💤 (sleep)
    # 🔧 (work)
    # 🍴 (eat)
    # 🏋️ (exercise)
    # 📎 (hobby)
