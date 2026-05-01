#NoTrayIcon

#Region AutoIt3Wrapper directives section
#AutoIt3Wrapper_Icon=IDM.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=Y
#EndRegion AutoIt3Wrapper directives section

#Region Includes
#include <core.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>
#EndRegion Includes

_Singleton(@ScriptName)

#Region Options
Opt('MustDeclareVars', 1)
Opt('GUICloseOnESC', 0)
Opt('TrayMenuMode', 1)
#EndRegion Options

; Script Start - Add your code below here
If $CmdLine[0] = 0 Then
	GUI()
Else
	Switch $CmdLine[1]
		Case '/trial'
			TrialSilent()
			clearTemp()
		Case Else
			GUI()
	EndSwitch
EndIf

Func GUI()
	Local $lang = "English"

	#Region ### START Koda GUI section ###
	Local $GUI = GUICreate('IDM Trial Reset', 350, 180)
	GUISetBkColor(0x222222) ; Dark mode background

	; Language Selector
	Local $lblLang = GUICtrlCreateLabel("Language:", 20, 15, 60, 20)
	GUICtrlSetColor(-1, 0xFFFFFF)
	Local $cbLang = GUICtrlCreateCombo("English", 90, 10, 100, 25)
	GUICtrlSetData($cbLang, "বাংলা")

	; Buttons
	Local $btReset = GUICtrlCreateButton('Reset IDM Trial', 20, 50, 150, 35)
	GUICtrlSetBkColor(-1, 0x333333)
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetCursor(-1, 0)

	Local $btReg = GUICtrlCreateButton('Register IDM', 180, 50, 150, 35)
	GUICtrlSetBkColor(-1, 0x333333)
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetCursor(-1, 0)

	Local $btClean = GUICtrlCreateButton('Deep Cleanup', 20, 95, 150, 35)
	GUICtrlSetBkColor(-1, 0x333333)
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetCursor(-1, 0)

	Local $cbAutorun = GUICtrlCreateCheckbox('Auto Reset Trial', 180, 102, 150, 20)
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetState($cbAutorun, $isAuto ? 1 : 4)

	Local $lbStatus = GUICtrlCreateLabel('Status: Ready', 20, 145, 310, 20)
	GUICtrlSetColor(-1, 0xAAAAAA)

	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While 1
		Local $nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				clearTemp()
				GUIDelete($GUI)
				Exit
			Case $cbLang
				$lang = GUICtrlRead($cbLang)
				If $lang = "বাংলা" Then
					GUICtrlSetData($lblLang, "ভাষা:")
					GUICtrlSetData($btReset, 'ট্রায়াল রিসেট করুন')
					GUICtrlSetData($btReg, 'রেজিস্টার করুন')
					GUICtrlSetData($btClean, 'ডিপ ক্লিনআপ')
					GUICtrlSetData($cbAutorun, 'অটো রিসেট')
					GUICtrlSetData($lbStatus, 'স্ট্যাটাস: রেডি')
				Else
					GUICtrlSetData($lblLang, "Language:")
					GUICtrlSetData($btReset, 'Reset IDM Trial')
					GUICtrlSetData($btReg, 'Register IDM')
					GUICtrlSetData($btClean, 'Deep Cleanup')
					GUICtrlSetData($cbAutorun, 'Auto Reset Trial')
					GUICtrlSetData($lbStatus, 'Status: Ready')
				EndIf
			Case $btReset
				GUICtrlSetData($lbStatus, $lang = "বাংলা" ? 'স্ট্যাটাস: কাজ চলছে...' : 'Status: Please wait...')
				Trial()
				GUICtrlSetData($lbStatus, $lang = "বাংলা" ? 'স্ট্যাটাস: ট্রায়াল রিসেট সম্পন্ন!' : 'Status: Trial reset completed!')
				MsgBox(262144, 'Reset IDM trial', $lang = "বাংলা" ? 'আপনার এখন ৩০ দিনের ট্রায়াল আছে!' : 'You have 30 day trial now!')
			Case $btReg
				Local $Name = InputBox('Register IDM', $lang = "বাংলা" ? 'আপনার নাম লিখুন:' : 'Type your name here:', 'Rasel muntasir', '', '', '130')
				If @error <> 1 Then
					If StringLen($Name) = 0 Then $Name = 'Rasel muntasir'
					GUICtrlSetData($lbStatus, $lang = "বাংলা" ? 'স্ট্যাটাস: রেজিস্টার করা হচ্ছে...' : 'Status: Registering...')
					Register($Name)
					GUICtrlSetState($cbAutorun, 4)
					GUICtrlSetData($lbStatus, $lang = "বাংলা" ? 'স্ট্যাটাস: রেজিস্টার সফল!' : 'Status: Registered successfully!')
					MsgBox(262144, 'Register IDM', $lang = "বাংলা" ? 'IDM এখন রেজিস্টার করা হয়েছে!' : 'IDM is registered now!')
				EndIf
			Case $btClean
				GUICtrlSetData($lbStatus, $lang = "বাংলা" ? 'স্ট্যাটাস: ক্লিন করা হচ্ছে...' : 'Status: Cleaning...')
				DeepCleanup()
				GUICtrlSetData($lbStatus, $lang = "বাংলা" ? 'স্ট্যাটাস: ক্লিনআপ সফল!' : 'Status: Cleanup completed!')
				MsgBox(262144, 'Deep Cleanup', $lang = "বাংলা" ? 'IDM এর পুরোনো ডেটা মোছা হয়েছে!' : 'Old IDM data has been cleaned!')
			Case $cbAutorun
				If GUICtrlRead($cbAutorun) = 1 Then
					GUICtrlSetData($lbStatus, $lang = "বাংলা" ? 'স্ট্যাটাস: কাজ চলছে...' : 'Status: Please wait...')
					Trial()
					autorun('trial')
					GUICtrlSetData($lbStatus, $lang = "বাংলা" ? 'স্ট্যাটাস: অটো-রিসেট চালু' : 'Status: Auto reset enabled')
					MsgBox(262144, 'Auto reset', $lang = "বাংলা" ? 'ট্রায়াল নিজে নিজেই রিসেট হবে।' : 'The IDM trial will be reset automatically.')
				Else
					autorun('off')
					GUICtrlSetData($lbStatus, $lang = "বাংলা" ? 'স্ট্যাটাস: অটো-রিসেট বন্ধ' : 'Status: Auto reset disabled')
					MsgBox(262144, 'Auto reset', $lang = "বাংলা" ? 'অটো রিসেট বন্ধ করা হয়েছে।' : 'Auto reset disabled.')
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>GUI
