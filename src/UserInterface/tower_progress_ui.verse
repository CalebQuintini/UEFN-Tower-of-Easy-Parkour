using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Playspaces }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { Utility }

level_data := struct:
    Bottom : float
    Top : float
    UIPixelBottom  : float

# ===============================
# UI WIDGET CONTAINER
# ===============================
tower_progress_ui_widgets := class:
    Canvas<public>:canvas
    # Tower Levels
    TowerLevel0_UIWidget<public>:color_block
    TowerLevel1_UIWidget<public>:color_block
    TowerLevel2_UIWidget<public>:color_block
    TowerLevel3_UIWidget<public>:color_block
    TowerLevel4_UIWidget<public>:color_block
    TowerLevel5_UIWidget<public>:color_block
    TowerLevel6_UIWidget<public>:color_block
    TowerLevel7_UIWidget<public>:color_block
    # Player Marker
    var PlayerMarker_UIWidget<public>:color_block

tower_progress_ui := class(creative_device):

    @editable L0Top : creative_prop = creative_prop{}
    @editable L0Bottom : creative_prop = creative_prop{}

    @editable L1Top : creative_prop = creative_prop{}
    @editable L1Bottom : creative_prop = creative_prop{}

    @editable L2Top : creative_prop = creative_prop{}
    @editable L2Bottom : creative_prop = creative_prop{}

    @editable L3Top : creative_prop = creative_prop{}
    @editable L3Bottom : creative_prop = creative_prop{}

    @editable L4Top : creative_prop = creative_prop{}
    @editable L4Bottom : creative_prop = creative_prop{}

    @editable L5Top : creative_prop = creative_prop{}
    @editable L5Bottom : creative_prop = creative_prop{}

    @editable L6Top : creative_prop = creative_prop{}
    @editable L6Bottom : creative_prop = creative_prop{}

    @editable L7Top : creative_prop = creative_prop{}
    @editable L7Bottom : creative_prop = creative_prop{}


    var UIMap : [player]tower_progress_ui_widgets = map{}
    var MarkerWidgetMap : [player]color_block = map{}

    PlayerAdded(Player:player):void =
        UI := CreateUI()
        if:
            set UIMap[Player] = UI
            set MarkerWidgetMap[Player] = UI.PlayerMarker_UIWidget

    PlayerRemoved(Player:player):void =
        if:
            NewUIMap := UIMap.RemoveKey[Player]
            NewMarkerWidgetMap := MarkerWidgetMap.RemoveKey[Player]
        then:
            set UIMap = NewUIMap
            set MarkerWidgetMap = NewMarkerWidgetMap

    UpdateAllPlayers() : void =
        for (P : GetPlayspace().GetPlayers()):
            UpdatePlayerMarker(P)

    # Create the UI.
    CreateUI():tower_progress_ui_widgets=
        # Tower Levels
        TowerLevel0_UIWidget := color_block:
            DefaultColor := MakeColorFromHex("F0F0F000")
        TowerLevel1_UIWidget := color_block:
            DefaultColor := MakeColorFromHex("F0F0F000")
        TowerLevel2_UIWidget := color_block:
            DefaultColor := MakeColorFromHex("F0F0F000")
        TowerLevel3_UIWidget := color_block:
            DefaultColor := MakeColorFromHex("F0F0F000")
        TowerLevel4_UIWidget := color_block:
            DefaultColor := MakeColorFromHex("F0F0F000")
        TowerLevel5_UIWidget := color_block:
            DefaultColor := MakeColorFromHex("F0F0F000")
        TowerLevel6_UIWidget := color_block:
            DefaultColor := MakeColorFromHex("F0F0F000")
        TowerLevel7_UIWidget := color_block:
            DefaultColor := MakeColorFromHex("F0F0F000")
        # Player Marker
        PlayerMarker_UIWidget := color_block:
            DefaultColor:= NamedColors.Black

        Canvas := canvas:
            Slots := array:
                # Vertical background bar
                # L0
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X:=1.0, Y:=0.5}, Maximum := vector2{X:=1.0, Y:=0.5}}
                    Offsets := margin{Left := -108.413712, Top := 379.71167, Right := 50.0, Bottom := 119.0}
                    Alignment := vector2{X:=0.0, Y:=0.0}
                    SizeToContent := false
                    ZOrder := 0
                    Widget := TowerLevel0_UIWidget
                # L1
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X:=1.0, Y:=0.5}, Maximum := vector2{X:=1.0, Y:=0.5}}
                    Offsets := margin{Left := -108.413712, Top := 261.0, Right := 50.0, Bottom := 119.0}
                    Alignment := vector2{X:=0.0, Y:=0.0}
                    SizeToContent := false
                    ZOrder := 0
                    Widget := TowerLevel1_UIWidget
                # L2
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X:=1.0, Y:=0.5}, Maximum := vector2{X:=1.0, Y:=0.5}}
                    Offsets := margin{Left := -108.413712, Top := 142.0, Right := 50.0, Bottom := 119.0}
                    Alignment := vector2{X:=0.0, Y:=0.0}
                    SizeToContent := false
                    ZOrder := 0
                    Widget := TowerLevel2_UIWidget
                # L3
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X:=1.0, Y:=0.5}, Maximum := vector2{X:=1.0, Y:=0.5}}
                    Offsets := margin{Left := -108.413712, Top := 23.0, Right := 50.0, Bottom := 119.0}
                    Alignment := vector2{X:=0.0, Y:=0.0}
                    SizeToContent := false
                    ZOrder := 0
                    Widget := TowerLevel3_UIWidget
                # L4
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X:=1.0, Y:=0.5}, Maximum := vector2{X:=1.0, Y:=0.5}}
                    Offsets := margin{Left := -108.413712, Top := -96.0, Right := 50.0, Bottom := 119.0}
                    Alignment := vector2{X:=0.0, Y:=0.0}
                    SizeToContent := false
                    ZOrder := 0
                    Widget := TowerLevel4_UIWidget
                # L5
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X:=1.0, Y:=0.5}, Maximum := vector2{X:=1.0, Y:=0.5}}
                    Offsets := margin{Left := -108.413712, Top := -215.0, Right := 50.0, Bottom := 119.0}
                    Alignment := vector2{X:=0.0, Y:=0.0}
                    SizeToContent := false
                    ZOrder := 0
                    Widget := TowerLevel5_UIWidget
                # L6
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X:=1.0, Y:=0.5}, Maximum := vector2{X:=1.0, Y:=0.5}}
                    Offsets := margin{Left := -108.413712, Top := -334.0, Right := 50.0, Bottom := 119.0}
                    Alignment := vector2{X:=0.0, Y:=0.0}
                    SizeToContent := false
                    ZOrder := 0
                    Widget := TowerLevel6_UIWidget
                # L7
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X:=1.0, Y:=0.5}, Maximum := vector2{X:=1.0, Y:=0.5}}
                    Offsets := margin{Left := -108.413712, Top := -453.0, Right := 50.0, Bottom := 119.0}
                    Alignment := vector2{X:=0.0, Y:=0.0}
                    SizeToContent := false
                    ZOrder := 0
                    Widget := TowerLevel7_UIWidget   
                # Player Marker
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X:=0.95, Y:=0.9}, Maximum := vector2{X:=0.97, Y:=0.95}}
                    Offsets := margin{}
                    Alignment := vector2{X:=0.5, Y:=0.5}
                    SizeToContent := false
                    ZOrder := 1
                    Widget := PlayerMarker_UIWidget

        return tower_progress_ui_widgets:
            Canvas := Canvas
            TowerLevel0_UIWidget := TowerLevel0_UIWidget
            TowerLevel1_UIWidget := TowerLevel1_UIWidget
            TowerLevel2_UIWidget := TowerLevel2_UIWidget
            TowerLevel3_UIWidget := TowerLevel3_UIWidget
            TowerLevel4_UIWidget := TowerLevel4_UIWidget
            TowerLevel5_UIWidget := TowerLevel5_UIWidget
            TowerLevel6_UIWidget := TowerLevel6_UIWidget
            TowerLevel7_UIWidget := TowerLevel7_UIWidget
            PlayerMarker_UIWidget := PlayerMarker_UIWidget

    ShowUI<public>(Player:player):void =
        if:
            UI := UIMap[Player]
            PlayerUI := GetPlayerUI[Player]
        then:  
            PlayerUI.AddWidget(UI.Canvas, player_ui_slot{ZOrder := 10, InputMode := ui_input_mode.None})

    ChangeTowerBarColor(Player : player, CourseColors:obstacle_course_colors) : void =
        if:
            UI := UIMap[Player]
        then:
            UI.TowerLevel1_UIWidget.SetColor(MakeColorFromHex(CourseColors.Level1_ColorString))
            UI.TowerLevel2_UIWidget.SetColor(MakeColorFromHex(CourseColors.Level2_ColorString))
            UI.TowerLevel3_UIWidget.SetColor(MakeColorFromHex(CourseColors.Level3_ColorString))
            UI.TowerLevel4_UIWidget.SetColor(MakeColorFromHex(CourseColors.Level4_ColorString))
            UI.TowerLevel5_UIWidget.SetColor(MakeColorFromHex(CourseColors.Level5_ColorString))
            UI.TowerLevel6_UIWidget.SetColor(MakeColorFromHex(CourseColors.Level6_ColorString))
            UI.TowerLevel7_UIWidget.SetColor(MakeColorFromHex(CourseColors.Level7_ColorString))

    UpdatePlayerMarker(Player : player) : void =
        if:
            Char := Player.GetFortCharacter[]
            Char.IsActive[]
            UI := UIMap[Player]
        then:
            PlayerZ := Char.GetTransform().Translation.Z

            LevelWorld := array{
                level_data{Bottom := L0Bottom.GetTransform().Translation.Z, Top := L0Top.GetTransform().Translation.Z, UIPixelBottom := 498.700012},
                level_data{Bottom := L1Bottom.GetTransform().Translation.Z, Top := L1Top.GetTransform().Translation.Z, UIPixelBottom := 379.299988},
                level_data{Bottom := L2Bottom.GetTransform().Translation.Z, Top := L2Top.GetTransform().Translation.Z, UIPixelBottom := 260.624756},
                level_data{Bottom := L3Bottom.GetTransform().Translation.Z, Top := L3Top.GetTransform().Translation.Z, UIPixelBottom := 141.484207},
                level_data{Bottom := L4Bottom.GetTransform().Translation.Z, Top := L4Top.GetTransform().Translation.Z, UIPixelBottom := 22.661196},
                level_data{Bottom := L5Bottom.GetTransform().Translation.Z, Top := L5Top.GetTransform().Translation.Z, UIPixelBottom := -96.599998},
                level_data{Bottom := L6Bottom.GetTransform().Translation.Z, Top := L6Top.GetTransform().Translation.Z, UIPixelBottom := -215.370743},
                level_data{Bottom := L7Bottom.GetTransform().Translation.Z, Top := L7Top.GetTransform().Translation.Z, UIPixelBottom := -334.5}
            }

            var MarkerTop : float = 0.0

            if:
                Lowest := LevelWorld[0]
                Highest := LevelWorld[LevelWorld.Length - 1]
            then:
                # ✅ BELOW tower
                if (PlayerZ < Lowest.Bottom):
                    set MarkerTop = Lowest.UIPixelBottom

                # ✅ ABOVE tower
                else if (PlayerZ >= Highest.Top):
                    if (Prev := LevelWorld[LevelWorld.Length - 2]):
                        LevelPixelHeight := Prev.UIPixelBottom - Highest.UIPixelBottom
                        set MarkerTop = Highest.UIPixelBottom - LevelPixelHeight

                # ✅ NORMAL CASE
                else:
                    for (i := 0..LevelWorld.Length - 1):
                        if (Level := LevelWorld[i]):
                            if (PlayerZ >= Level.Bottom and PlayerZ < Level.Top):

                                LevelHeight := Level.Top - Level.Bottom
                                if (LevelHeight <= 0.0):
                                    return

                                LocalProgress := (PlayerZ - Level.Bottom) / LevelHeight

                                if (NextLevel := LevelWorld[i + 1]):
                                    LevelPixelHeight := Level.UIPixelBottom - NextLevel.UIPixelBottom
                                    set MarkerTop = Level.UIPixelBottom - (LocalProgress * LevelPixelHeight)
                                else:
                                    if (Prev := LevelWorld[i - 1]):
                                        LevelPixelHeight := Prev.UIPixelBottom - Level.UIPixelBottom
                                        set MarkerTop = Level.UIPixelBottom - (LocalProgress * LevelPixelHeight)

            UI.Canvas.RemoveWidget(UI.PlayerMarker_UIWidget)

            NewSlot := canvas_slot:
                Anchors := anchors{Minimum := vector2{X:=1.0, Y:=0.5}, Maximum := vector2{X:=1.0, Y:=0.5}}
                Offsets := margin{
                    Left := -143.578568,
                    Top := MarkerTop,
                    Right := 85.063187,
                    Bottom := 8.0
                }
                Alignment := vector2{X:=0.0, Y:=0.0}
                SizeToContent := false
                ZOrder := 1
                Widget := UI.PlayerMarker_UIWidget

            UI.Canvas.AddWidget(NewSlot)
        
    # Close the UI for the player.
    CloseUI<public>(Player:player):void=
        if:
            UI := UIMap[Player]
            PlayerUI := GetPlayerUI[Player]
        then:
            PlayerUI.RemoveWidget(UI.Canvas)




