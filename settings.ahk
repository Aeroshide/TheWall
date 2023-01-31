; v0.8

; General settings
global rows := 3 ; Number of row on the wall scene (the one that goes down)
global cols := 3 ; Number of columns on the wall scene (the one that goes left)
global mode := "B" ; W = Normal wall, B = Wall bypass (skip to next locked), M = Modern multi (send to wall when none loaded), C = Classic original multi (always force to next instance)
global windowMode := "B" ; W = windowed mode, F = fullscreen mode, B = borderless windowed

; Extra features
global widthMultiplier := 2.5 ; How wide your instances go to maximize visibility :) (set to 0 for no width change)
global coop := False ; Automatically opens to LAN when you load in a world
global unpauseOnSwitch := False ; added this back because apparently people use it

; Sounds
global audioGui := False ; A simple GUI so the OBS application audio plugin can capture sounds
global disableTTS := False
global resetSounds := True ; Make a sound when you reset an instance
global lockSounds := True ; Make a sound when you lock an instance

; Delays (Defaults are probably fine)
global spawnProtection := 100 ; Prevent a new instance from being reset for this many milliseconds after the preview is visible
global fullScreenDelay := 100 ; increse if fullscreening issues
global obsDelay := 50 ; increase if not changing scenes in obs
global tinderCheckBuffer := 5 ; When all instances cant reset, how often it checks for an instance in seconds

; Super advanced settings (Do not change unless you know exactly absolutely what you are doing

; CPU Thread scheduling affinity
; -1 == use macro math to determine thread counts
global playThreadsOverride := -1 ; Thread count dedicated to the instance you are playing
global lockThreadsOverride := -1 ; Thread count dedicated to locked instances while on wall
global highThreadsOverride := -1 ; Thread count dedicated to instances that have just been reset but not previewing
global midThreadsOverride := -1 ; Thread count dedicated to loading preview instances on wall
global lowThreadsOverride := -1 ; Thread count dedicated to loading bg instances and idle wall instances
global superLowThreadsOverride := -1 ; Thread count dedicated to idle bg instances
global loadBurstLength := 75 ; How many milliseconds the prior thread count stays dedicated to an instance before switching to the next stage while ACTIVELY LOADING INSTANCES (less important for basic affinity)

; OBS
global obsSceneControlType := "C" ; C = Controller Script (infinite), N = Numpad hotkeys (up to 9 instances), F = Function hotkeys f13-f24 (up to 12 instances), A = advanced key array (too many instances)
global obsWallSceneKey := "F12" ; All obs scene control types use wallSceneKey
global obsCustomKeyArray := [] ; Must be used with advanced key array control type. Add keys in quotes separated by commas. The index in the array corresponds to the scene
global obsResetMediaKey := "" ; Key pressed on any instance reset with sound (used for playing reset media file in obs for recordable/streamable resets and requires addition setup to work)
global obsLockMediaKey := "" ; Key pressed on any lock instance with sound (used for playing lock media file in obs for recordable/streamable lock sounds and requires addition setup to work)
global obsUnlockMediaKey := "" ; Key pressed on any unlock instance with sound (used for playing unlock media file in obs for recordable/streamable unlock sounds and requires addition setup to work)

; Reset Management
global resetManagementTimeout := -1 ; Time that pass before reset manager gives up (in seconds). Too high may leave unresetable instances, too low will leave instances unpaused. leave it be for no timeout
global manageResetAfter := 300 ; Delay before starting reset management log reading loop. Default (300) likely fine
global resetManagementLoopDelay := 70 ; Buffer time between log lines check in reset management loop. Lowering will decrease possible pause latencies but increase cpu usage of reset managers. Default (70) likely fine

; Attempts
global overallAttemptsFile := "data/ATTEMPTS.txt" ; File to write overall attempt count to
global dailyAttemptsFile := "data/ATTEMPTS_DAY.txt" ; File to write daily attempt count to