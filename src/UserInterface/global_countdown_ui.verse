using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/UI }
using { /Fortnite.com/Devices }
using { Utility }

global_countdown_ui_widgets := class:
    Canvas<public>:canvas
    BackgroundBlock<public>:color_block
    CountdownText<public>:text_block
    TimeMultiplierText<public>:text_block

global_countdown_ui := class(creative_device):

    # Stores the created UI for each player.
    var UIMap:[player]global_countdown_ui_widgets = map{}

    var TestUIMap:[player]TestUI.UI_RoundCountdown = map{}

    var WidgetTimerTest : TestUI.UI_RoundCountdown = TestUI.UI_RoundCountdown{}

    # When a player is added, create the countdown UI.
    PlayerAdded(Player:player):void=
        UIResult := WidgetTimerTest
        if:
            PlayerUI := GetPlayerUI[Player]
            set TestUIMap[Player] = UIResult

    # When a player is removed, remove the stored data.
    PlayerRemoved(Player:player):void=
        if:
            NewTestUIMap := TestUIMap.RemoveKey[Player]
        then:
            set TestUIMap = NewTestUIMap

    # Show the UI to the player. The UI will show the countdown for the selected player.
    ShowUI(Player:player):void=
        if:
            # UI := UIMap[Player]
            UI := TestUIMap[Player]
            PlayerUI := GetPlayerUI[Player]
        then:
            PlayerUI.AddWidget(UI)

    UpdateUI(Player:player, Time:float, HasPlayerReachedTop:logic, TimeMultiplier:float):void=
        if:
            UI := TestUIMap[Player]
        then:
            if(HasPlayerReachedTop = false):
                set UI.multipliervar = PlainText("")
            else:
                set UI.multipliervar = SpeedMultiplier(TimeMultiplier)
            set UI.CountdownVar = PlainText(FormatCountdownTime(Time))

    # Close the UI for the player.
    CloseUI<public>(Player:player):void=
        if:
            UI := UIMap[Player]
            PlayerUI := GetPlayerUI[Player]
        then:
            PlayerUI.RemoveWidget(UI.Canvas)
