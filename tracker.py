import subprocess, time, io, sys

arg = []
if __name__ == "__main__":
    lenght = len(sys.argv) - 1
    for o in range(lenght):
        o = o + 1
        arg.append(sys.argv[o])
# then use like this,
    #if len(arg) >= 2:
    #        if arg[1] == "0":
    #            c = int(c)
    #        elif arg[1] == "1":
    #            c = f"{c:.3f}"

start = None
end = None
tracked = None
def track(app):
    global start, end, tracked
    clock = subprocess.Popen("python /home/luqtas/Desktop/projects/system/clock.py 1 1| grep -o '^[^ ]*'", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    stdout, stderr = clock.communicate()
    clock = stdout.strip()
    clock = float(clock)

    if last_app_lock:
        end = clock

        time = round((end - start), 3) # FINALLY SOME TELEMETRY!
        print(time, "in", tracked)

    else:
        start = clock

        if app == "org.kde.konsole":
            tracked = "terminal"
        elif app == "org.kde.kate":
            tracked = "kate"
        else:
            tracked = app


last_app_lock = True
last_app = None
while True:
    app = subprocess.Popen("kdotool getactivewindow getwindowclassname", stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, shell=True)
    app = (app.stdout.readline()).strip()

    if last_app_lock:
        last_app = app
        last_app_lock = False
        track(app)

    if last_app != app:
        last_app_lock = True
        track(app)

    time.sleep(1.425)
