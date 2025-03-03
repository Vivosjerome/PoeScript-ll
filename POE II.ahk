#NoEnv
#Include, classMemory.ahk

SysGet, MonitorWidth, 78 ; Récupere la résolution X de l'écran
Middle := Floor(MonitorWidth / 2) ; Divise par deux pour avoir le millieu

pourcentage_seuil_vie := 40
pourcentage_seuil_mana := 30

staticAdress := 0x3CBAF78 
; staticAdressReservation := 0x32E3A08

staticOffsetAll := [0x0, 0x428, 0x10, 0x8, 0x40, 0x0]
reservationOffset := [0x90, 0x90, 0x30, 0x30, 0x1B8, 0x48, 0x2B0]

manaMaxOffset := 0x214

manaOffset := 0x218

lifeMaxOffset := 0x1C4

lifeOffset := 0x1C8

; CheckForUpdates()

Loop{

    mem := new _ClassMemory("ahk_exe PathOfExileSteam.exe", "", hProcessCopy) 
    if !isObject(mem)
        msgbox Erreur ouverture du handle
    if !hProcessCopy
        msgbox Erreur ouverture du. Error Code = %hProcessCopy%

    manaMaxResult := mem.read(mem.BaseAddress + staticAdress, "UInt", staticOffsetAll[1], staticOffsetAll[2], staticOffsetAll[3], staticOffsetAll[4], staticOffsetAll[5], staticOffsetAll[6], manaMaxOffset)
    manaMax := manaMaxResult + 0 ; Conversion explicite en nombre entier

    manaResult := mem.read(mem.BaseAddress + staticAdress, "UInt", staticOffsetAll[1], staticOffsetAll[2], staticOffsetAll[3], staticOffsetAll[4], staticOffsetAll[5], staticOffsetAll[6], manaOffset)
    mana := manaResult + 0 ; Conversion explicite en nombre entier

    lifeMaxResult := mem.read(mem.BaseAddress + staticAdress, "UInt", staticOffsetAll[1], staticOffsetAll[2], staticOffsetAll[3], staticOffsetAll[4], staticOffsetAll[5], staticOffsetAll[6], lifeMaxOffset)
    lifeMax := lifeMaxResult + 0 ; Conversion explicite en nombre entier

    lifeResult := mem.read(mem.BaseAddress + staticAdress, "UInt", staticOffsetAll[1], staticOffsetAll[2], staticOffsetAll[3], staticOffsetAll[4], staticOffsetAll[5], staticOffsetAll[6], lifeOffset)
    life := lifeResult + 0 ; Conversion explicite en nombre entier

    reservManaResult := mem.read(mem.BaseAddress + staticAdressReservation, "UInt", reservationOffset[1], reservationOffset[2], reservationOffset[3], reservationOffset[4], reservationOffset[5], reservationOffset[6], reservationOffset[7])
    reservMana := reservManaResult + 0 ; Conversion explicite en nombre entier

    ; if (!manaMax) {
    ; Msgbox, Les adresses statiques ont change!
    ; ExitApp
    ; }

    manaMax -= reservMana

    ; Calculer les seuils en fonction des pourcentages
    seuil_vie := (pourcentage_seuil_vie / 100) * lifeMax
    seuil_mana := (pourcentage_seuil_mana / 100) * manaMax

    ; Vérifier si la vie est inférieure au seuil
    if (life < seuil_vie) {
        takeLife()
    }
    
    if ( mana < seuil_mana) {
        takeMana()
    }
}
return

F1::Infos()
F2::reload

XButton2::
    Suspend
    Pause ,,1
    if A_IsPaused {
        ToolTip, PAUSED, %Middle%, 1,
    } else {
        ToolTip, RUNNING, %Middle%, 1,
        SetTimer RemoveToolTip,
    }
return

RemoveToolTip:
    ToolTip
    SetTimer, RemoveToolTip, Off
return

#Include, Function.ahk
