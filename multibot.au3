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
Global Const $Map_ID_Saint_Anjeka = 349
Global Const $Map_ID_Drazack = 195
Global $curGold = 0
Global $botRunning = False
Global $charName = ""
Global $botInitialized = False
Global $Vaettirfarm = False
Global $Mossfarm = False
Global $GoldiesFarmed = 0
Global $TotalRuns = 0
Global $GoldGained = 0
Global $PconsFarmed = 0
Global $FailedRuns = 0
Global $MossfarmBuildCode = "OgcTcZ88ZSn5A65Q4gucCCBK0BA"
Global $VaettirfarmBuildCode = "OwVUI2h5lPP8Id2BkAiAvpLBTAA"

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
Global Const $hos = 7
Global Const $soh = 8

#Region ### START Koda GUI section ###
Global $Select_Farm = "Mossfarm|Vaettirfarm"
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
	If $botRunning == False Then
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
		Out("Bot started")
		GUICtrlSetData($StartStopBtn, "Pause")
		$botRunning = True
	Else
		Out("Bot paused")
		GUICtrlSetData($StartStopBtn, "Start")
		$botRunning = False
	EndIf
	If  @GUI_CtrlId == $GUI_Event_Close Then
		Exit
	EndIf
EndFunc

Global $StartGold = GetGoldCharacter()

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
		EndSwitch
		Sleep(1000)
		ContinueLoop
	EndIf
	InitializeOverlay()
	If $botRunning Then
		If $Mossfarm == True Then
			Mossfarm()
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
EndFunc

Func Mossfarm()
	If GetMapID() <> $Map_ID_Saint_Anjeka Then
		MoveMap($Map_ID_Saint_Anjeka, 2, 0, 0)
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
	Sleep(10000)
	CustomPickUpLootMossfarm()
	If GetIsDead(-2) Then
		$FailedRuns += 1
	Else 
		$TotalRuns += 1
	EndIf
	Resign()
	Sleep(3500+GetPing())
	ReturnToOutpost()
	WaitMapLoading($Map_ID_Saint_Anjeka)
EndFunc

;~ Description: standard pickup function, only modified to increment a custom counter when taking stuff with a particular ModelID
Func CustomPickUpLootMossfarm()
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
	GUICtrlSetData($GoldGainedLabel, "Gold gained: " & $GoldGained)
	GUICtrlSetData($PconsFarmedLabel, "Pcons farmed: " & $PconsFarmed)
	GUICtrlSetData($FailRunLabel, "Failed runs: " & $FailedRuns)
EndFunc

Func IsChecked($idControlID)
	Out("Checking")
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc		;===>IsChecked
