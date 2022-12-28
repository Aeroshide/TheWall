from array import array
from cgitb import text
import os
from time import sleep
from tracemalloc import start

mmc = r"C:\Users\Aeroshide\Documents\MultiMC" # Change this to match your mmc location (Required)

# If you dont want any of this to launch, just basically delete the propgram path, dont delete the var lol
obs = r"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\OBS Studio\OBS Studio (64bit).lnk" # Change this to match your obs location (Optional)
ninjabot = r"C:\Users\Aeroshide\Documents\Ninjabrain-Bot-1.2.0.jar" # Change this to match your ninjabot location (Optional)

doStartPeripherals = False

instance_format = "instance" # Change this to match your instance naming convention (example, inst1, inst2.. etc)
instance_count = 9 # Change to match instance count

wait = 20 # basically how fast is the script gonna wait until it launches the next little command (seconds)
longwait = 60 # basically the time you give to your instances to properlly load up for the wall (seconds)
# if your pc isnt good enough, increase this number, or else some instances might be skipped

nextScript = r".\settingStartup.ahk"
wall = r".\TheWall.ahk"

def startPeripherals():
    print("Done starting instaces, starting other stuffs if available")
    sleep(longwait)
    os.startfile(ninjabot)
    sleep(wait)
    os.startfile(obs)
    print("Done starting peripherals, now starting THE WALL")
    sleep(longwait)
    os.startfile(wall)

for i in range(1, instance_count+1):
    print(f"Starting instance {i} with codename {instance_format}")
    os.system(f"{mmc}\MultiMC.exe -l {instance_format}{i}")
    sleep(wait)
    if (i == instance_count & doStartPeripherals):
       startPeripherals()
