# TheWall
 hi if youre seeing this, this wall macro is gonna be a next gen macro that is (hopefully), better than any macro that exists out there. it is not finished yet. so check back later! :)

# Testers Guide on how to setup
You wanna test out the early features?, sure. But ill warn you right now that this process is **NOT User Friendly**. So proceed at your own risk!
## OBS Setup
 Prerequisites

* Python 3.6 (
<https://www.python.org/downloads/release/python-368/>)
* An already Working Wall OBS Scene Setup with Source Record

Actual Tutorial
 1. In your OBS Windows Click on tools
 2. Now click on Scripts (It will open up a window)
 3. In the window, Click python settings Tab and point to to your Python (3.6) location when prompted **(NOTE: OBS DOES NOT SUPPORT PYTHON 3.6+)**
 4. Now go back to the Scripts Tab and click on the Plus button
 5. After that, navigate to `*/TheWall/scripts` and select the `OBSController.py` and import it
 6. Now go back to into `*/TheWall/scripts` Directory and find obsConfig.py
 7. Open it in any text editor you want, and go modify some settings (I already documented it there)

## Macro Setup
its the same thing like specnr's lmao (for now)
# Macro Usage
Theres a few things that i added and also removed, so i will document it here, The big features will be at the top, the other ones would be at the bottom

## **Dual Monitor Background Resetting**
This will allow you to do Backround resetting if you have a dual monitor setup.

How to do it:
1. Just Launch the Wall Scene as a Windowed screen projector
2. Right click on it and press the `Always on Top` option
3. Put it somewhere in your second monitor that isnt disruptive, you could also scale the window as you like!

How does it work:
* Its the same thing like the Fullscreen Projector, but it doesnt have mouse controls, so you'll have to control it with your keyboard (Keybinds can be viewed and modified from `hotkeys.ahk`)
* You can lock, and Reset (With reset All) in the Windowed Projector!

## **Advanced Affinity Management**
 When you look into the `settings.ahk` folder, you might have noticed that Affinity mode is missing, its because that in this macro, it is now forced to use that Advaced Option. This also have a different Thread Scheduler that is still being tested!.

 Feedbacks are really wanted for this feature, i would like to know if it does actually improve performance even further than spec's
