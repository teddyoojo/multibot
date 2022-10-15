########### Multifarm by teddyoojo ###########

#RequireAdmin
##NoTrayIcon
#include "GWA2_Headers.au3"
#include "GWA2.au3"
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <GuiEdit.au3>
Opt("GUIOnEventMode", True)

### Global Variables ###
Global $timer = TimerInit()
Global $ChatStuckTimer = TimerInit()
Global Enum $RANGE_ADJACENT=156, $RANGE_NEARBY=240, $RANGE_AREA=312, $RANGE_EARSHOT=1000, $RANGE_SPELLCAST = 1085, $RANGE_SPIRIT = 2500, $RANGE_COMPASS = 5000
Global Enum $Range_Adjacent_2=156^2, $Range_Nearby_2=240^2, $Range_Area_2=312^2, $Range_Earshot_2=1000^2, $Range_Spellcast_2=1085^2, $Range_Spirit_2=2500^2, $Range_Compass_2=5000^2
Global Const $Map_ID_Saint_Anjeka = 349
Global Const $Map_ID_Drazack = 195
Global Const $Map_ID_Bjora = 482
Global Const $Map_ID_Jaga = 546
Global Const $Town_ID_Longeye = 650
Global Const $Town_ID_Kaineng = 194
Global Const $Map_ID_ChanceEncounter = 861
Global $VaettirInitialized = False
Global $curGold = 0
Global $botRunning = False
Global $charName = ""
Global $botInitialized = False
Global $Vaettirfarm = False
Global $Mossfarm = False
Global $ChanceEncounterfarm = False
Global $GoldiesFarmed = 0
Global $TotalRuns = 0
Global $PconsFarmed = 0
Global $FailedRuns = 0
Global $MossfarmBuildCode = "OgcTcZ88ZSn5A65Q4gucCCBK0BA"
Global $VaettirfarmBuildCode = "OQdVACxOMv85hHpzOgEQE4NdJYCA"
Global $ChanceEncounterfarmBuildCode = "OgGkQpVqaueUfxOIPxVRuY3HBWAA"

#Region Global Items
Global Const $PickUpAll = False
Global Const $RARITY_Gold = 2624
Global Const $RARITY_Purple = 2626
Global Const $RARITY_Blue = 2623
Global Const $RARITY_White = 2621

Global Const $ITEM_ID_Dyes = 146
Global Const $ITEM_ExtraID_BlackDye = 10
Global Const $ITEM_ID_Lockpicks = 22751

Global $Array_pscon[39]=[910, 5585, 6366, 6375, 22190, 24593, 28435, 30855, 31145, 35124, 36682, 6376, 21809, 21810, 21813, 36683, 21492, 21812, 22269, 22644, 22752, 28436,15837, 21490, 30648, 31020, 6370, 21488, 21489, 22191, 26784, 28433, 5656, 18345, 21491, 37765, 21833, 28433, 28434]
Global $Rare_Materials_Array[25] = [922, 923, 926, 927, 928, 930, 931, 932, 935, 936, 937, 938, 939, 941, 942, 943, 944, 945, 949, 950, 951, 952, 956, 6532, 6533]
Global $All_Materials_Array[36] = [921, 922, 923, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 943, 944, 945, 946, 948, 949, 950, 951, 952, 953, 954, 955, 956, 6532, 6533]

; ==== MossBuild ====
Global Const $sf = 1
Global Const $shroud = 2
Global Const $winno = 3
Global Const $whirling = 4
Global Const $ee = 5
Global Const $dash = 6
Global Const $snowstorm = 7
Global Const $soh = 8

; ==== VaettirBuild ====
Global Const $VaettirParadox = 1
Global Const $VaettirSf = 2
Global Const $VaettirShroud = 3
Global Const $VaettirWayofperf = 4
Global Const $VaettirHos = 5
Global Const $VaettirWastrel = 6
Global Const $VaettirEcho = 7
Global Const $VaettirChanneling = 8

; ==== ChanceEncounterBuild ====
Global Const $CEHundredblades = 1
Global Const $CEWhirlwind = 2
Global Const $CEToTheLimit = 3
Global Const $CEForGreaterJustice = 4
Global Const $CEEbsoh = 5
Global Const $CEGrenths = 6
Global Const $CEPiety = 7
Global Const $CEHealsig = 8

; Store skills energy cost
Global $skillCost[9]
$skillCost[$VaettirParadox] = 15
$skillCost[$VaettirSf] = 5
$skillCost[$VaettirShroud] = 10
$skillCost[$VaettirWayofperf] = 5
$skillCost[$VaettirHos] = 5
$skillCost[$VaettirWastrel] = 5
$skillCost[$VaettirEcho] = 15
$skillCost[$VaettirChanneling] = 5
;~ Skill IDs
Global Const $SKILL_ID_SHROUD = 1031
Global Const $SKILL_ID_CHANNELING = 38
Global Const $SKILL_ID_ARCHANE_ECHO = 75
Global Const $SKILL_ID_WASTREL_DEMISE = 1335


#Region ### START Koda GUI section ###
Global $Select_Farm = "Mossfarm|Vaettirfarm|ChanceEncounterfarm"
$Multibot_by_teddyoojo = GUICreate("Multibot_by_teddyoojo", 615, 437, 740, 302)
$ConsoleField = GUICtrlCreateEdit("", 416, 8, 177, 193)
GUICtrlSetData(-1, "")
Out("Multibot by teddyoojo")
GUICtrlSetFont(-1, 12, 400, 0, "MS UI Gothic")
GUICtrlSetBkColor(-1, 0xA6CAF0)
$CharNameLabel = GUICtrlCreateLabel("Select Character", 16, 8, 150, 17)
$Input = GUICtrlCreateCombo("", 16, 28, 200, 25)
    GUICtrlSetData(-1, GetLoggedCharNames())
$FarmSelectLabel = GUICtrlCreateLabel("Select Farm", 16, 100, 150, 17)
$Farm = GUICtrlCreateCombo("", 16, 120, 200, 25)
    GUICtrlSetData(-1, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
$RunsLabel = GUICtrlCreateLabel("", 16, 336, 180, 17)
$FailRunLabel = GUICtrlCreateLabel("", 16, 368, 180, 17)
$GoldiesFarmedLabel = GUICtrlCreateLabel("", 16, 400, 180, 17)
$PconsFarmedLabel = GUICtrlCreateLabel("", 224, 336, 180, 17)
$GoldGainedLabel = GUICtrlCreateLabel("", 224, 368, 180, 17)
$TomeCheckbox = GUICtrlCreateCheckbox("Pickup Tomes", 432, 336, 113, 17)
$GoldiesCheckbox = GUICtrlCreateCheckbox("Pickup Goldies", 432, 360, 113, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
$BuildCodeLabel = GUICtrlCreateLabel("BuildCodeLabel", 224, 400, 350, 17)
$StartStopBtn = GUICtrlCreateButton("Start", 416, 208, 179, 41)
	GUICtrlSetOnEvent($StartStopBtn, "GuiButtonHandler")
GUICtrlSetData($Farm, $Select_Farm)
GUISetState(@SW_SHOW)
GUISetOnEvent($GUI_Event_Close, "GuiButtonHandler")
#EndRegion ### END Koda GUI section ###

Func GuiButtonHandler()
	If $botInitialized == False Then
		Local $CharName = GUICtrlRead($Input)
		If $CharName=="" Then
			If Initialize(ProcessExists("gw.exe")) = False Then
				MsgBox(0, "Error", "Guild Wars is not running.")
				Exit
			EndIf
		Else
			If Initialize($CharName) = False Then
				MsgBox(0, "Error", "Could not find a Guild Wars client with a character named '"&$CharName&"'")
				Exit
			EndIf
		EndIf
		WinSetTitle($Multibot_by_teddyoojo, "", "Multibot-" & GetCharname())
		$botInitialized = True
	EndIf
	If $botRunning == False Then
		Out("Bot started")
		GUICtrlSetData($StartStopBtn, "Pause")
		$botRunning = True
	Else
		Out("Bot paused")
		GUICtrlSetData($StartStopBtn, "Pausing after run...")
		GUICtrlSetState($StartStopBtn, $GUI_DISABLE)
		$botRunning = False
	EndIf
	If  @GUI_CtrlId == $GUI_Event_Close Then
		Exit
	EndIf
EndFunc


While True
	If $botRunning == False Then
		switch GUICtrlRead($Farm)
				Case "Vaettirfarm"
					Out("Vaettirfarm")
					GUICtrlSetData($BuildCodeLabel, "Build: " & $VaettirfarmBuildCode)
					SetAllFarmsFalse()
					$Vaettirfarm = True
				Case "Mossfarm"
					SetAllFarmsFalse()
					$Mossfarm = True
					Out("Mossfarm")
					GUICtrlSetData($BuildCodeLabel, "Build: " & $MossfarmBuildCode)
				Case "ChanceEncounterfarm"
					Out("ChanceEncounterfarm")
					GUICtrlSetData($BuildCodeLabel, "Build: " & $ChanceEncounterfarmBuildCode)
					SetAllFarmsFalse()
					$ChanceEncounterfarm = True
		EndSwitch
		Sleep(1000)
		ContinueLoop
	EndIf
	InitializeOverlay()
	If $botRunning Then
		If $Mossfarm == True Then
			Mossfarm()
		ElseIf $Vaettirfarm == True Then
			Vaettirfarm()
		ElseIf $ChanceEncounterfarm == True Then
			ChanceEncounterfarm()
		EndIf
	EndIf
WEnd

;~ Description: Print to console with timestamp
Func Out($TEXT)
    GUICtrlSetData($ConsoleField, GUICtrlRead($ConsoleField) & @HOUR & ":" & @MIN & " - " & $TEXT & @CRLF)
EndFunc   ;==>OUT#

Func SetAllFarmsFalse()
	$Vaettirfarm = False
	$Mossfarm = False
	$ChanceEncounterfarm = False
EndFunc

Func ChanceEncounterfarm()
	If GetMapID() <> $Town_ID_Kaineng Then
		MoveMap($Town_ID_Kaineng, 2, 0, 0)
		WaitMapLoading($Town_ID_Kaineng)
	EndIf
	SwitchMode(1)
	GoNearestNPCToCoords(2200, -1200)
	Dialog(0x856005)
	Sleep(50+GetPing())
	Dialog(0x84)
	WaitMapLoading($Map_ID_ChanceEncounter)
	CommandAll(-5778, -4939)
	MoveTo(-6300, -5266)
	Sleep(25000)
	UseHeroSkill(4, 2)
	Sleep(1500)
	UseHeroSkill(4,3)
	Sleep(1500)
	UseHeroSkill(4,4)
	Sleep(4000)
	KillFirstGroup()
	Sleep(500)
	MoveTo(-4717, -3223)

EndFunc

Func Mossfarm()
	If GetMapID() <> $Map_ID_Saint_Anjeka Then
		MoveMap($Map_ID_Saint_Anjeka, 2, 0, 0)
		WaitMapLoading($Map_ID_Saint_Anjeka)
	EndIf
	SwitchMode(1)
	Out("moving outside")
	MoveTo(-11200, -23300)
	WaitMapLoading($Map_ID_Drazack)
	UseSkillEx($dash)
	Out("done moving")
	MoveTo(-9248, 19113)
	TargetNearestAlly()
	RndSleep(GetPing()+50)
	UseSkill($ee, GetCurrentTargetID())
	MoveTo(-7805, 18186)
	UseSkillEx($sf)
	UseSkillEx($shroud)
	MoveTo(-6453, 16850)
	UseSkillEx($dash)
	MoveTo(-5237, 15654)
	MoveTo(-6225, 17411)
	Sleep(GetPing() + 50)
	UseSkillEx($soh)
	MoveTo(-6816, 18779)
	UseSkillEx($winno)
	While IsRecharged($sf) == False 
		Sleep(200)
	WEnd	
	UseSkillEx($sf)
	Sleep(GetPing()+ 100)
	UseSkillEx($whirling)
	Sleep(200+GetPing())
	TargetNearestEnemy()
	Sleep(GetPing() + 50)
	UseSkill($snowstorm, GetCurrentTargetID())
	Sleep(6500)
	CustomPickUpLoot()
	If GetIsDead(-2) Then
		$FailedRuns += 1
	Else 
		$TotalRuns += 1
	EndIf
	Resign()
	Sleep(3500+GetPing())
	ReturnToOutpost()
	WaitMapLoading($Map_ID_Saint_Anjeka)
	If GUICtrlRead($StartStopBtn, "Pausing after run...") Then
		GUICtrlSetData($StartStopBtn, "Start")
		GUICtrlSetState($StartStopBtn, $GUI_ENABLE)
	EndIf
EndFunc

Func Vaettirfarm()
	If $VaettirInitialized == False Then
		MapL()
		RunThereLongeyes()
		$VaettirInitialized = True
	EndIf
	If (GetIsDead(-2) == True) Then Return
	CombatLoop()
	If GUICtrlRead($StartStopBtn, "Pausing after run...") Then
		GUICtrlSetData($StartStopBtn, "Start")
		GUICtrlSetState($StartStopBtn, $GUI_ENABLE)
	EndIf
EndFunc


Func MapL()
;~ Checks if you are already in Longeye's Ledge, if not then you travel to Longeye's Ledge
	If GetMapID() <> $Town_ID_Longeye Then
		Out("Travelling to longeye")
		RndTravel($Town_ID_Longeye)
	EndIf

;~ Hardmode
	SwitchMode(1)

	Out("Exiting Outpost")
	MoveTo(-25333, 15793)
	Move(-26472, 16217)
	WaitMapLoading(482)

;~ Scans your bags for Cupcakes and uses one to make the run faster.
	;pconsScanInventory()
	;Sleep(GetPing()+500)
	;UseCupcake()
	;Sleep(GetPing()+500)
	Sleep(GetPing()+500)
EndFunc

; Description: This is pretty much all, take bounty, do left, do right, kill, rezone
Func CombatLoop()

    Local $lTimer = TimerInit()

    Local $norntitle = GetNornTitle()

	If $norntitle > 100 and $norntitle < 160000 Then
		Out("Taking Blessing")
		GoNearestNPCToCoords(13318, -20826)
		Dialog(132)
	EndIf
	SendChat("")

	Sleep(GetPing()+2000)

	Out("Moving to aggro left")
	MoveTo(13501, -20925)
	MoveTo(13172, -22137)
	TargetNearestEnemy()
	MoveAggroing(12496, -22600, 150)
	MoveAggroing(11375, -22761, 150)
	MoveAggroing(10925, -23466, 150)
	MoveAggroing(10917, -24311, 150)
	MoveAggroing(9910, -24599, 150)
	MoveAggroing(8995, -23177, 150)
	MoveAggroing(8307, -23187, 150)
	MoveAggroing(8213, -22829, 150)
	MoveAggroing(8307, -23187, 150)
	MoveAggroing(8213, -22829, 150)
	MoveAggroing(8740, -22475, 150)
	MoveAggroing(8880, -21384, 150)
	MoveAggroing(8684, -20833, 150)
	MoveAggroing(8982, -20576, 150)

	Out("Waiting for left ball")
	WaitFor(12*1000)

	If GetDistance()<1000 Then
		UseSkillEx($VaettirHos, -1)
	Else
		UseSkillEx($VaettirHos, -2)
	EndIf

	WaitFor(6000)

	TargetNearestEnemy()

	Out("Moving to aggro right")
	MoveAggroing(10196, -20124, 150)
	MoveAggroing(9976, -18338, 150)
	MoveAggroing(11316, -18056, 150)
	MoveAggroing(10392, -17512, 150)
	MoveAggroing(10114, -16948, 150)
	MoveAggroing(10729, -16273, 150)
	MoveAggroing(10810, -15058, 150)
	MoveAggroing(11120, -15105, 150)
	MoveAggroing(11670, -15457, 150)
	MoveAggroing(12604, -15320, 150)
	TargetNearestEnemy()
	MoveAggroing(12476, -16157)

	;Out("Waiting for right ball")
	WaitFor(15*1000)

	If GetDistance()<1000 Then
		UseSkillEx($VaettirHos, -1)
	Else
		UseSkillEx($VaettirHos, -2)
	EndIf

	WaitFor(5000)

	;Out("Blocking enemies in spot")
	MoveAggroing(12920, -17032, 30)
	MoveAggroing(12847, -17136, 30)
	MoveAggroing(12720, -17222, 30)
	WaitFor(300)
	MoveAggroing(12617, -17273, 30)
	WaitFor(300)
	MoveAggroing(12518, -17305, 20)
	WaitFor(300)
	MoveAggroing(12445, -17327, 10)


   ;Avoids a rare-ish occurence where the bot starts the kill sequence just before SF runs out. Most noticeable on non Assassin primary Professions.
   Out("Waiting for Shadow Form")
   Local $lDeadlock_2 = TimerInit()
   $Skill_ShadowForm_Time = TimerDiff($timer)
   Out($Skill_ShadowForm_Time)
   Do
	  WaitFor(100)
	  If GetIsDead(-2) = 1 Then Return
   Until (TimerDiff($timer)) < $Skill_ShadowForm_Time Or (TimerDiff($lDeadlock_2) > 20000)

   UseSF(True)
   Out("Shadow Form casted")

   Kill()

	WaitFor(1200)
    Out("Looting")
    CustomPickUpLoot()

  ;===> Test Start ===>
;  Out("Pausing")
  ;GUICtrlSetData($Button, "Paused")
;  Sleep(500)
;  Do
  ;  Sleep(100)
  ;Until GUICtrlRead($Button) <> "Paused"

  ;<=== Test End# <===

	If GetIsDead(-2) Then
		$FailCount += 1
		GUICtrlSetData($FailRunLabel, "Fails: " & $FailCount)
		; StoreRun(GetCharname(), TimerDiff($lTimer), 0)
	Else
		$TotalRuns += 1
		GUICtrlSetData($RunsLabel, "Runs: " & $TotalRuns)
		; StoreRun(GetCharname(), TimerDiff($lTimer), 1)
	EndIf

	Out("Zoning")
	MoveAggroing(12289, -17700)
	MoveAggroing(15318, -20351)

    Local $tDeadLock = TimerInit()
	While GetIsDead(-2)
		Out("Waiting for res")
		Sleep(1000)
        If TimerDiff($tDeadLock) > 60000 Then
            $Deadlocked = True
            Return
        EndIf
	WEnd
   Out("Zoning to Bjora")
	Move(15865, -20531)
	WaitMapLoading($Map_ID_BJORA)
   Out("Zoning to Jaga Moraine")
	MoveTo(-19968, 5564)
	Move(-20076,  5580, 30)

	WaitMapLoading($Map_ID_JAGA)

	ClearMemory()
	; _PurgeHook()
EndFunc

Func RunThereLongeyes()
	Out("Running to farm spot")
	DIM $Array_Longeyes[31][3] = [ _
										[1, 15003.8, -16598.1], _
										[1, 15003.8, -16598.1], _
										[1, 12699.5, -14589.8], _
										[1, 11628,   -13867.9], _
										[1, 10891.5, -12989.5], _
										[1, 10517.5, -11229.5], _
										[1, 10209.1, -9973.1], _
										[1, 9296.5,  -8811.5], _
										[1, 7815.6,  -7967.1], _
										[1, 6266.7,  -6328.5], _
										[1, 4940,    -4655.4], _
										[1, 3867.8,  -2397.6], _
										[1, 2279.6,  -1331.9], _
										[1, 7.2,     -1072.6], _
										[1, 7.2,     -1072.6], _
										[1, -1752.7, -1209], _
										[1, -3596.9, -1671.8], _
										[1, -5386.6, -1526.4], _
										[1, -6904.2, -283.2], _
										[1, -7711.6, 364.9], _
										[1, -9537.8, 1265.4], _
										[1, -11141.2,857.4], _
										[1, -12730.7,371.5], _
										[1, -13379,  40.5], _
										[1, -14925.7,1099.6], _
										[1, -16183.3,2753], _
										[1, -17803.8,4439.4], _
										[1, -18852.2,5290.9], _
										[1, -19250,  5431], _
										[1, -19968, 5564], _
										[2, -20076,  5580]]
	Out("Running to Jaga")
	For $i = 0 To (UBound($Array_Longeyes) -1)
		If ($Array_Longeyes[$i][0]==1) Then
			If Not MoveRunning($Array_Longeyes[$i][1], $Array_Longeyes[$i][2]) Then ExitLoop
		EndIf
		If ($Array_Longeyes[$i][0]==2) Then
			Move($Array_Longeyes[$i][1], $Array_Longeyes[$i][2], 30)
			WaitMapLoading($Map_ID_JAGA)
		EndIf
	Next
EndFunc

Func KillFirstGroup()
	Local $lAgentArray
	Local $Fight = True
	Local $EnemyCount
	Sleep(200)
	While $Fight
		$lAgentArray = GetAgentArray(0xDB)
		$EnemyCount = 0
		For $i=1 To $lAgentArray[0]
			If DllStructGetData($lAgentArray[$i], "Allegiance") <> 0x3 Then ContinueLoop
			If DllStructGetData($lAgentArray[$i], "HP") <= 0 Then ContinueLoop
			If GetIsDead(-2) Then Return
			TargetNearestEnemy()
			Sleep(50+GetPing())
			Local $lTargetID = GetCurrentTargetID()
			Attack($lTargetID)
			If IsRecharged($CEEbsoh) Then
				UseSkillEx($CEEbsoh)
			EndIf
			If IsRecharged($CEHundredblades) Then
				UseSkillEx($CEHundredblades)
			EndIf
			$EnemyCount += 1
		Next
		Out($EnemyCount)
		If $EnemyCount <= 1 Then
			$Fight = False
		EndIf
		Sleep(500)
	WEnd
EndFunc


;~ Description: BOOOOOOOOOOOOOOOOOM
Func Kill()
	If GetIsDead(-2) Then Return

	Local $lAgentArray
	Local $lDeadlock = TimerInit()

	TargetNearestEnemy()
	Sleep(100)
	Local $lTarGetID = GetCurrentTarGetID()

	While GetAgentExists($lTarGetID) And DllStructGetData(GetAgentByID($lTarGetID), "HP") > 0
		Sleep(50)
		If GetIsDead(-2) Then Return
		$lAgentArray = GetAgentArray(0xDB)
		StayAlive($lAgentArray)

		; Use echo if possible
		If GetSkillbarSkillRecharge($VaettirSf) > 5000 And GetSkillbarSkillID($VaettirEcho)==$SKILL_ID_ARCHANE_ECHO Then
			If IsRecharged($VaettirWastrel) And IsRecharged($VaettirEcho) Then
				UseSkillEx($VaettirEcho)
				UseSkillEx($VaettirWastrel, GetGoodTarGet($lAgentArray))
				$lAgentArray = GetAgentArray(0xDB)
			EndIf
		EndIf

		UseSF(True)

		; Use wastrel if possible
		If IsRecharged($VaettirWastrel) Then
			UseSkillEx($VaettirWastrel, GetGoodTarGet($lAgentArray))
			$lAgentArray = GetAgentArray(0xDB)
		EndIf

		UseSF(True)

		; Use echoed wastrel if possible
		If IsRecharged($VaettirEcho) And GetSkillbarSkillID($VaettirEcho)==$SKILL_ID_WASTREL_DEMISE Then
			UseSkillEx($VaettirEcho, GetGoodTarGet($lAgentArray))
		EndIf

		; Check if tarGet has ran away
		If GetDistance(-2, $lTarGetID) > $Range_Earshot Then
			TargetNearestEnemy()
			Sleep(GetPing()+100)
			If GetAgentExists(-1) And DllStructGetData(GetAgentByID(-1), "HP") > 0 And GetDistance(-2, -1) < $Range_Area Then
				$lTarGetID = GetCurrentTarGetID()
			Else
				ExitLoop
			EndIf
		EndIf

		If TimerDiff($lDeadlock) > 60 * 1000 Then ExitLoop
	WEnd
EndFunc

;~ Description: Move to destX, destY. This is to be used in the run from across Bjora
Func MoveRunning($lDestX, $lDestY)
	If GetIsDead(-2) Then Return False

	Local $lMe, $lTgt
	Local $lBlocked

	Move($lDestX, $lDestY)

	Do
		RndSleep(500)

		TargetNearestEnemy()
		$lMe = GetAgentByID(-2)
		$lTgt = GetAgentByID(-1)

		If GetIsDead($lMe) Then Return False

		If GetDistance($lMe, $lTgt) < 1300 And GetEnergy($lMe)>20 And IsRecharged($VaettirParadox) And IsRecharged($VaettirSf) Then
			UseSkillEx($VaettirParadox)
			UseSkillEx($VaettirSf)
			$timer = TimerInit()
		EndIf

		;If DllStructGetData($lMe, "HP") < 0.9 And GetEnergy($lMe) > 10 And IsRecharged($Skill_Shroud) Then UseSkillEx($Skill_Shroud)
		If DllStructGetData($lMe, "HP") < 0.9 And GetEnergy($lMe) > 10 And IsRecharged($VaettirShroud) And TimerDiff($timer) < 15000 Then UseSkillEx($VaettirShroud)

		If DllStructGetData($lMe, "HP") < 0.5 And GetDistance($lMe, $lTgt) < 500 And GetEnergy($lMe) > 5 And IsRecharged($VaettirHos) Then UseSkillEx($VaettirHos, -1)

		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
			$lBlocked += 1
			Move($lDestX, $lDestY)
		EndIf

	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < 250
	Return True
EndFunc

;~ Description: standard pickup function, only modified to increment a custom counter when taking stuff with a particular ModelID
Func CustomPickUpLoot()
	Local $lAgent
	Local $lItem
	Local $lDeadlock
	For $i = 1 To GetMaxAgents()
		If CountSlots() < 1 Then Return ;full inventory dont try to pick up
		If GetIsDead(-2) Then Return
		$lAgent = GetAgentByID($i)
		If DllStructGetData($lAgent, 'Type') <> 0x400 Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		If CustomCanPickup($lItem) Then
			PickUpItem($lItem)
			$lDeadlock = TimerInit()
			While GetAgentExists($i)
				Sleep(100)
				If GetIsDead(-2) Then Return
				If TimerDiff($lDeadlock) > 10000 Then ExitLoop
			WEnd
		EndIf
	Next
EndFunc   ;==>PickUpLoot

; Checks if should pick up the given item. Returns True or False
Func CustomCanPickUp($aItem)
	Local $lModelID = DllStructGetData(($aItem), 'ModelId')
	Local $aExtraID = DllStructGetData($aItem, 'ExtraId')
	Local $lRarity = GetRarity($aItem)
	Local $Requirement = GetItemReq($aItem)
	If ($lModelID == 2511) Then
		If (GetGoldCharacter() < 99000) Then
			Return True	; gold coins (only pick if character has less than 99k in inventory)
		Else
			Return False
		EndIf
	ElseIf ($lModelID == $ITEM_ID_Dyes) Then	; if dye
		If ($aExtraID == $ITEM_ExtraID_BlackDye) Then ; only pick white and black ones
			Return True
		EndIf
	ElseIf ($lRarity == $RARITY_Gold) And IsChecked($GoldiesCheckbox) Then ; gold items^
		$GoldiesFarmed += 1
		Return True
	ElseIf($lModelID == $ITEM_ID_Lockpicks) Then
		Return True ; Lockpicks
	ElseIf CheckArrayPscon($lModelID) Then ; ==== Pcons ==== or all event items
		Return True
	ElseIf ($lRarity == $RARITY_White) And $PickUpAll Then ; White items
		Return False
	ElseIf CheckArrayRareMats($lModelID) Then
		Return True
	ElseIf CheckArrayNormalMats($lModelID) Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>CustomCanPickUp


Func CountSlots()
	Local $bag
	Local $temp = 0
	$bag = GetBag(1)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(2)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(3)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(4)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	Return $temp
EndFunc ; Counts open slots in your Imventory


#Region Arrays
Func CheckArrayPscon($lModelID)
	For $p = 0 To (UBound($Array_pscon) -1)
		If ($lModelID == $Array_pscon[$p]) Then Return True
	Next
EndFunc

Func CheckArrayRareMats($lModelID)
	For $p = 0 To (UBound($Rare_Materials_Array) -1)
		If($lModelID == $Rare_Materials_Array[$p]) THen Return True
	Next
EndFunc

Func CheckArrayNormalMats($lModelID)
	For $p = 0 To (UBound($All_Materials_Array) -1)
		If($lModelID == $All_Materials_Array[$p]) THen Return True
	Next
EndFunc

Func InitializeOverlay()
	GUICtrlSetData($GoldiesFarmedLabel, "Goldies farmed: " & $GoldiesFarmed)
	GUICtrlSetData($RunsLabel, "Runs made: " & $TotalRuns)
	GUICtrlSetData($GoldGainedLabel, "Gold total: " & GetGoldCharacter())
	GUICtrlSetData($PconsFarmedLabel, "Pcons farmed: " & $PconsFarmed)
	GUICtrlSetData($FailRunLabel, "Failed runs: " & $FailedRuns)
EndFunc

Func IsChecked($idControlID)
	Out("Checking")
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc		;===>IsChecked


;~ Description: Wait and stay alive at the same time (like Sleep(..), but without the letting yourself die part)
Func WaitFor($lMs)
	If GetIsDead(-2) Then Return
	Local $lAgentArray
	Local $lTimer = TimerInit()
	Do
		Sleep(100)
		If GetIsDead(-2) Then Return
		$lAgentArray = GetAgentArray(0xDB)
		StayAlive($lAgentArray)
	Until TimerDiff($lTimer) > $lMs
EndFunc

Func GoNearestNPCToCoords($x, $y)
	Local $guy, $Me
	Do
		RndSleep(250)
		$guy = GetNearestNPCToCoords($x, $y)
	Until DllStructGetData($guy, 'Id') <> 0
	ChanGetarGet($guy)
	RndSleep(250)
	GoNPC($guy)
	RndSleep(250)
	Do
		RndSleep(500)
		Move(DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y'), 40)
		RndSleep(500)
		GoNPC($guy)
		RndSleep(250)
		$Me = GetAgentByID(-2)
	Until ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y')) < 250
	RndSleep(1000)
EndFunc   ;==>GoNearestNPCToCoords

Func MoveAggroing($lDestX, $lDestY, $lRandom = 150)
	If GetIsDead(-2) Then Return

	Local $lMe, $lAgentArray
	Local $lBlocked
	Local $lHosCount
	Local $lAngle
	Local $stuckTimer = TimerInit()

	Move($lDestX, $lDestY, $lRandom)

	Do
		RndSleep(50)

		$lMe = GetAgentByID(-2)

		$lAgentArray = GetAgentArray(0xDB)

		If GetIsDead($lMe) Then Return False

		StayAlive($lAgentArray)

		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
			If $lHosCount > 6 Then
				Do	; suicide
					Sleep(100)
				Until GetIsDead(-2)
				Return False
			EndIf

			$lBlocked += 1
			If $lBlocked < 5 Then
				Move($lDestX, $lDestY, $lRandom)
			ElseIf $lBlocked < 10 Then
				$lAngle += 40
				Move(DllStructGetData($lMe, 'X')+300*sin($lAngle), DllStructGetData($lMe, 'Y')+300*cos($lAngle))
			ElseIf IsRecharged($VaettirHos) Then
				If $lHosCount==0 And GetDistance() < 1000 Then
					UseSkillEx($VaettirHos, -1)
				Else
					UseSkillEx($VaettirHos, -2)
				EndIf
				$lBlocked = 0
				$lHosCount += 1
			EndIf
		Else
			If $lBlocked > 0 Then
				If TimerDiff($ChatStuckTimer) > 3000 Then	; use a timer to avoid spamming /stuck
					SendChat("stuck", "/")
					$ChatStuckTimer = TimerInit()
				EndIf
				$lBlocked = 0
				$lHosCount = 0
			EndIf

			If GetDistance() > 1100 Then ; tarGet is far, we probably got stuck.
				If TimerDiff($ChatStuckTimer) > 3000 Then ; dont spam
					SendChat("stuck", "/")
					$ChatStuckTimer = TimerInit()
					RndSleep(GetPing())
					If GetDistance() > 1100 Then ; we werent stuck, but tarGet broke aggro. select a new one.
						TargetNearestEnemy()
					EndIf
				EndIf
			EndIf
		EndIf

	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < $lRandom*1.5
	Return True
EndFunc

Func GetGoodTarGet(Const ByRef $lAgentArray)
	Local $lMe = GetAgentByID(-2)
	For $i=1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], "Allegiance") <> 0x3 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], "HP") <= 0 Then ContinueLoop
		If GetDistance($lMe, $lAgentArray[$i]) > $Range_Nearby Then ContinueLoop
		If GetHasHex($lAgentArray[$i]) Then ContinueLoop
		If Not GetIsEnchanted($lAgentArray[$i]) Then ContinueLoop
		Return DllStructGetData($lAgentArray[$i], "ID")
	Next
EndFunc

Func UseSF($lProximityCount)
	If IsRecharged($VaettirSf) And $lProximityCount > 0 Then
		UseSkillEx($VaettirParadox)
		UseSkillEx($VaettirSf)
		$timer = TimerInit()
	EndIf
EndFunc

Func StayAlive(Const ByRef $lAgentArray)
	If IsRecharged($VaettirSf) Then
		UseSkillEx($VaettirParadox)
		UseSkillEx($VaettirSf)
	EndIf

	Local $lMe = GetAgentByID(-2)
	Local $lEnergy = GetEnergy($lMe)
	Local $lAdjCount, $lAreaCount, $lSpellCastCount, $lProximityCount
	Local $lDistance
	For $i=1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], "Allegiance") <> 0x3 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], "HP") <= 0 Then ContinueLoop
		$lDistance = GetPseudoDistance($lMe, $lAgentArray[$i])
		If $lDistance < 1200*1200 Then
			$lProximityCount += 1
			If $lDistance < $RANGE_SPELLCAST_2 Then
				$lSpellCastCount += 1
				If $lDistance < $RANGE_AREA_2 Then
					$lAreaCount += 1
					If $lDistance < $RANGE_ADJACENT_2 Then
						$lAdjCount += 1
					EndIf
				EndIf
			EndIf
		EndIf
	Next

	UseSF($lProximityCount)

	If IsRecharged($VaettirShroud) Then
		If $lSpellCastCount > 0 And DllStructGetData(GetEffect($SKILL_ID_SHROUD), "SkillID") == 0 Then
			UseSkillEx($VaettirShroud)
		ElseIf DllStructGetData($lMe, "HP") < 0.6 Then
			UseSkillEx($VaettirShroud)
		ElseIf $lAdjCount > 20 Then
			UseSkillEx($VaettirShroud)
		EndIf
	EndIf

	UseSF($lProximityCount)

	If IsRecharged($VaettirWayofperf) Then
		If DllStructGetData($lMe, "HP") < 0.5 Then
			UseSkillEx($VaettirWayofperf)
		ElseIf $lAdjCount > 20 Then
			UseSkillEx($VaettirWayofperf)
		EndIf
	EndIf

	UseSF($lProximityCount)

	If IsRecharged($VaettirChanneling) Then
		If $lAreaCount > 5 And GetEffectTimeRemaining($SKILL_ID_CHANNELING) < 2000 Then
			UseSkillEx($VaettirChanneling)
		EndIf
	EndIf

	UseSF($lProximityCount)
EndFunc


Func RndTravel($aMapID)
	Local $UseDistricts = 7 ; 7=eu, 8=eu+int, 11=all(incl. asia)
	; Region/Language order: eu-en, eu-fr, eu-ge, eu-it, eu-sp, eu-po, eu-ru, int, asia-ko, asia-ch, asia-ja
	Local $Region[11] = [2, 2, 2, 2, 2, 2, 2, -2, 1, 3, 4]
	Local $Language[11] = [0, 2, 3, 4, 5, 9, 10, 0, 0, 0, 0]
	Local $Random = Random(0, $UseDistricts - 1, 1)
	MoveMap($aMapID, $Region[$Random], 0, $Language[$Random])
	WaitMapLoading($aMapID, 30000)
	Sleep(GetPing()+3000)
EndFunc   ;==>RndTravel