using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { /Fortnite.com/Characters }

# Stores a global reference to the component.
var GlobalUI_Manager<public>:weak_map (session, ui_manager) = map{}

ui_manager<public> := class(creative_device):
    @editable
    TowerProgressBarUI:tower_progress_ui=tower_progress_ui{}
    @editable
    GlobalCountdownUI:global_countdown_ui=global_countdown_ui{}

    OnBegin<override>()<suspends>:void=
        if(set GlobalUI_Manager[GetSession()] = Self):

    # ------ ADD & REMOVE PLAYER LOGIC------
    PlayerAdded<public>(Player:player):void=
        TowerProgressBarUI.PlayerAdded(Player)
        GlobalCountdownUI.PlayerAdded(Player)
    PlayerRemoved<public>(Player:player):void=
        TowerProgressBarUI.PlayerRemoved(Player)
        GlobalCountdownUI.PlayerRemoved(Player)
    # ----------------------------

    # ------ SHOW LOGIC------
    ShowTowerProgressBarUI<public>(Player:player):void=
        TowerProgressBarUI.ShowUI(Player)
    ShowGlobalCountdownUI<public>(Player:player):void=
        GlobalCountdownUI.ShowUI(Player)
    # ----------------------------
    
    # ------ UPDATE LOGIC------
    UpdatePlayersTowerProgressBarUI<public>():void=
        for(ThePlayer : GetPlayspace().GetPlayers()):
            TowerProgressBarUI.UpdatePlayerMarker(ThePlayer)
    UpdatedTowerProgressBar<public>(Player : player, CourseColors:obstacle_course_colors):void=
        TowerProgressBarUI.ChangeTowerBarColor(Player, CourseColors)
    UpdatePlayersGlobalCountdownUI<public>(Time:float, HasPlayerReachedTop:logic, TimeMultiplier:float):void=
        for(ThePlayer : GetPlayspace().GetPlayers()):
            GlobalCountdownUI.UpdateUI(ThePlayer, Time, HasPlayerReachedTop, TimeMultiplier)
    # ----------------------------

    # ------ CLOSE LOGIC------
    ClosePlayersUI<public>(Player:player):void=
        TowerProgressBarUI.CloseUI(Player)
        GlobalCountdownUI.CloseUI(Player)
    # ----------------------------





