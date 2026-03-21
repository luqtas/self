import subprocess, time, io

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
        print('%.3f'%(end - start), "in", tracked)
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

    time.sleep(1.25)
