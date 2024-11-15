
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }

Timer := class():
    var TimerCanvas : canvas = canvas{}
    var TimerText : text_block = text_block{}
    var TimerImage : texture_block = texture_block{DefaultImage := T_22}
    var Hours : int = 0
    var Minutes : int = 8
    var Seconds : int = 0

    SetUpCanvas() : void=
        set TimerCanvas = canvas:
         Slots := array:
            canvas_slot:
                Widget := TimerText
                Anchors := anchors{Minimum := vector2{X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5}}
                Offsets := margin{Left := -93.0, Top := 56.0, Right := 193.0, Bottom := 58.0}
                Alignment := vector2{X := 0.0, Y := 0.0}
                SizeToContent := false
                ZOrder := 1


            canvas_slot:
               Widget := TimerImage
               Anchors := anchors{Minimum := vector2{X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5}}
               Offsets := margin{Left := -173.0, Top := -140.0, Right := 340.0, Bottom := 414.0}
               Alignment := vector2{X := 0.0, Y := 0.0}
               SizeToContent := false
               ZOrder := 0

    StringToMessage<localize>(String : string) : message = "{String}"

    HandleTimer()<suspends> : void=
        loop:
            Sleep(1.0)
            set Seconds -= 1
            if(Seconds <=0):
                if(Minutes <= 0):
                    if(Hours <= 0):
                        break
                    else:
                        set Hours -= 1
                        set Minutes = 59
                        set Seconds = 60

                else: 
                    set Minutes -= 1
                    set Seconds = 60
        TimerText.SetText(StringToMessage("{Hours}:{Minutes}:{Seconds}" ))




            





UITimerManager := class(creative_device):

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        for(Player : GetPlayspace().GetPlayers()):
            InitalizeTimer(Player)

        GetPlayspace().PlayerAddedEvent().Subscribe(InitalizeTimer)

    InitalizeTimer(Agent:agent) : void=
        Newtimer : Timer = Timer{}
        Newtimer.SetUpCanvas()
        if(Player := player[Agent],PlayerUI := GetPlayerUI[Player]):
           PlayerUI.AddWidget(NewPlayerCanvas : canvas = canvas:
              Slots := array:
                  canvas_slot:
                      Widget := Newtimer.TimerCanvas
                      Widget := TimerText
                      Anchors := anchors{Minimum := vector2{X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5}}
                      Offsets := margin{Left := 812.0, Top := 20.0, Right := 275.0, Bottom := 148.0}
                      Alignment := vector2{X := 0.0, Y := 0.0}
                      SizeToContent := false
                      ZOrder := 1
            )
            
        spawn:
            NewTimer.HandleTimer()
