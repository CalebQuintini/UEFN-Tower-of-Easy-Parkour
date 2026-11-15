using { /Verse.org/SceneGraph }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Verse.org/SpatialMath }
using { /Fortnite.com/Playspaces }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/Game }
using { /Fortnite.com/UI }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Characters }
using { /Verse.org/Random }
using { /Fortnite.com/FortPlayerUtilities }
using { Utility }
using { UserInterface }

obstacle_course_prefab_manager_component<public> := class<final_super>(component):

    var PlayerPositions : [player](/Verse.org/SpatialMath:)vector3 = map{}

    @editable
    EliManager:elimination_manager_device=elimination_manager_device{}

    @editable
    CourseArray:[]obstacle_course_prefab=array{}

    
    var CourseAsrray:obstacle_course_prefab=obstacle_course_prefab{}

    var sddfd : obstacle_course_prefab=obstacle_course_prefab{}

    @editable
    FinalPlatformMutatorZone:mutator_zone_device=mutator_zone_device{}

    @editable
    NewCourseTeleporter:teleporter_device=teleporter_device{}

    @editable
    TopReachedAudio:audio_player_device=audio_player_device{}

    @editable
    TimeMultiplerActivatedAudio:audio_player_device=audio_player_device{}

    @editable
    Coins:[]collectible_object_device = array{}

    @editable
    LevelCoins:[]collectible_object_device = array{}

    @editable
    StageMutatorZones:[]mutator_zone_device = array{}

    @editable
    GroundMutatorZone:mutator_zone_device = mutator_zone_device{}

    @editable
    CoinAccoladeDevice:accolades_device=accolades_device{}
    @editable
    TopFloorAccolades:accolades_device=accolades_device{}
    @editable
    StageAccoladeDevice:accolades_device=accolades_device{}

    var CurrentCourseIndex<private> : int = 0

    var TopReachedUI: TestUI.UI_TopReached = TestUI.UI_TopReached{}
    var MapCodeUi: TestUI.UI_MapCode = TestUI.UI_MapCode{}

    # Tracks the currently active course entity so we know what to remove.
    var CurrentCourseEntity<private> : ?entity = false
    # Tracks which course is active to alternate between them.
    var IsCourse1Active<private> : logic = true

    var HasPlayerReachedTop<private> : logic = false
    var FinishedPlayersCount<private> : int = 0
    var TimeMultiplier<private> : float = 1.0
    var PlayersFinished<private> : [player]logic = map{}
    var MaxMultiplier<private> : float = 9.0
    var RecentCourses<private> : []int = array{}

    OnBeginSimulation<override>():void =
        (super:)OnBeginSimulation()

        set sddfd = ObstacleCourse0{}
 
        FinalPlatformMutatorZone.AgentEntersEvent.Subscribe(PlayerEnteredFinalPlatform)
        EliManager.EliminatedEvent.Subscribe(OnPlayerEliminated)
        GroundMutatorZone.AgentEntersEvent.Subscribe(PlayerEntersMutatorZone)
        for (StageMutatorZone : StageMutatorZones):
            StageMutatorZone.AgentEntersEvent.Subscribe(PlayerEnteredStageMutatorZone)
        for (Coin : Coins):
            Coin.CollectedEvent.Subscribe(CoinCollected)
        for (LevelCoin : LevelCoins):
            LevelCoin.CollectedEvent.Subscribe(CoinCollected)

        if(RoundManager := Entity.GetFortRoundManager[]):
            RoundManager.SubscribeRoundStarted(StartGame)

    OnPlayerAdded(Player:player):void=
        if:
            UIManager := GlobalUI_Manager[GetSession()]
        then:
            UIManager.PlayerAdded(Player)
            UIManager.ShowGlobalCountdownUI(Player)
            UIManager.ShowTowerProgressBarUI(Player)

    OnPlayerRemoved(Player:player):void=
        if:
            UIManager := GlobalUI_Manager[GetSession()]
            PlayerUI := GetPlayerUI[Player]
        then:
            PlayerUI.RemoveWidget(MapCodeUi)
            UIManager.PlayerRemoved(Player)
            ResetPlayerCheckpoint(Player)

    UpdatePlayersUi(UI : ui_manager)<suspends>:void=
        loop:
            Sleep(0.05)
            UI.UpdatePlayersTowerProgressBarUI()

    StartGame():void=
        SpawnRandomCourse()
        spawn { LateStart() }
        spawn { RunTimerLoop() }

    LateStart()<suspends>:void=
        Sleep(0.1)
        if (Playspace := Entity.GetPlayspaceForEntity[]):
                Playspace.PlayerAddedEvent().Subscribe(OnPlayerAdded)
                Playspace.PlayerRemovedEvent().Subscribe(OnPlayerRemoved)
                Players := Playspace.GetPlayers()
                for (Player : Players, PlayerUI := GetPlayerUI[Player]):
                    OnPlayerAdded(Player)
                    PlayerUI.AddWidget(MapCodeUi)
        if:
            UIManager := GlobalUI_Manager[GetSession()]
        then:
            spawn. UpdatePlayersUi(UIManager)
            if (Playspace := Entity.GetPlayspaceForEntity[]):
                Players := Playspace.GetPlayers()
                for (Player : Players):
                    UpdateUIForCourse(Player, CurrentCourseIndex)

    OnEndSimulation<override>():void =
        (super:)OnEndSimulation()
        if (ActiveCourse := CurrentCourseEntity?):
            ActiveCourse.RemoveFromParent()
        set CurrentCourseEntity = false

    PlayerEnteredStageMutatorZone(Agent:agent):void =
        if:
            Player := player[Agent]
        then:
            StageAccoladeDevice.Award(Player)

    PlayerEnteredFinalPlatform(Agent:agent):void =
        if:
            Player := player[Agent]
        then:
            TopFloorAccolades.Award(Player)
            # Prevent duplicate triggers
            if (PlayersFinished[Player]):
                return

            if (set PlayersFinished[Player] = true){}

            spawn. ShowTopReachedUI(Player)
            TopReachedAudio.Play(Player)

            if (HasPlayerReachedTop = false):
                set HasPlayerReachedTop = true

            set FinishedPlayersCount += 1

            if (Playspace := Entity.GetPlayspaceForEntity[]):
                Playerz := Playspace.GetPlayers()
                PlayerCount := Playspace.GetPlayers().Length

                var BaseIncrease : float = 0.5

                if (PlayerCount = 1):
                    set BaseIncrease = 5.0
                else if (PlayerCount = 2):
                    set BaseIncrease = 3.0
                else:
                    set BaseIncrease = 0.5

                # 🔥 Calculate multiplier
                NewMultiplier := 1.0 + (FinishedPlayersCount * BaseIncrease)
                for (P : Playerz):
                    TimeMultiplerActivatedAudio.Play(P)

                # 🔥 Clamp to max
                if (NewMultiplier > MaxMultiplier):
                    set TimeMultiplier = MaxMultiplier
                else:
                    set TimeMultiplier = NewMultiplier

    ShowTopReachedUI(Player:player)<suspends>:void=
        if:
            PlayerUI := GetPlayerUI[Player]
        then:
            PlayerUI.AddWidget(TopReachedUI)
            Sleep(1.2)
            PlayerUI.RemoveWidget(TopReachedUI)

    RunTimerLoop()<suspends>:void =
        loop:
            var TimeRemaining : float = 600.0
            loop:
                if (TimeRemaining <= 0.0):
                    break
                if:
                    UIManager := GlobalUI_Manager[GetSession()]
                then:
                    UIManager.UpdatePlayersGlobalCountdownUI(TimeRemaining, HasPlayerReachedTop, TimeMultiplier)
                Sleep(1.0)
                if (HasPlayerReachedTop = false):
                    set TimeRemaining -= 1.0
                else:
                    set TimeRemaining -= (1.0 * TimeMultiplier)
            SwapCourse()

    GetNextCourseIndex():int=
        if (CourseArray.Length = 0):
            return 0
        var RandomIndex : int = 0
        loop:
            set RandomIndex = GetRandomInt(0, CourseArray.Length - 1)
            # ✅ Allow if:
            # - not in recent history
            # - OR not enough courses to avoid repeats
            if (CourseArray.Length <= 2):
                break
            var IsRecent : logic = false
            for (Recent : RecentCourses):
                if (Recent = RandomIndex):
                    set IsRecent = true
            if (not IsRecent?):
                break
        # 🔥 Update history
        set RecentCourses += array{RandomIndex}
        # Keep only last 2
        if (RecentCourses.Length = CourseArray.Length):
            set RecentCourses = array{}
        return RandomIndex

    SpawnRandomCourse():void=
        if (CourseArray.Length = 0):
            return
        RandomIndex := GetNextCourseIndex()
        set CurrentCourseIndex = RandomIndex

        if (SelectedCourse := CourseArray[CurrentCourseIndex]):
            SpawnCourse(SelectedCourse)

    UpdateUIForCourse(Player:player, CourseNumber:int):void=
        if (UIManager := GlobalUI_Manager[GetSession()]):
            if (CourseNumber = 0):
                UIManager.UpdatedTowerProgressBar(Player, ObstacleCourse0_Colors{})
            else if (CourseNumber = 1):
                UIManager.UpdatedTowerProgressBar(Player, ObstacleCourse1_Colors{})
            else if (CourseNumber = 2):
                UIManager.UpdatedTowerProgressBar(Player, ObstacleCourse2_Colors{})
            else if (CourseNumber = 3):
                UIManager.UpdatedTowerProgressBar(Player, ObstacleCourse3_Colors{})
            else if (CourseNumber = 4):
                UIManager.UpdatedTowerProgressBar(Player, ObstacleCourse4_Colors{})
 
    # Helper method to spawn a course entity with a reset scale to avoid distortion.
    SpawnCourse(Course : obstacle_course_prefab, ?SpawnTransform : ?(/Verse.org/SpatialMath:)transform = false):void =
        if (SimEntity := Entity.GetSimulationEntity[]):
            if (NewCourse := Course.ConstructObstacleCoursePrefab()?):
                # 1. Determine the base transform (from manager or previous course).
                var BaseTransform : (/Verse.org/SpatialMath:)transform = Entity.GetGlobalTransform()
                if (OverrideTransform := SpawnTransform?):
                    set BaseTransform = OverrideTransform

                # 2. CREATE A NEW TRANSFORM
                # This uses the Translation and Rotation from the manager,
                # but FORCES the Scale to be 1.0 so it isn't squashed by the manager's 0.2 scale.
                FinalTransform := (/Verse.org/SpatialMath:)transform{
                    Translation := BaseTransform.Translation,
                    Rotation    := BaseTransform.Rotation,
                    Scale       := (/Verse.org/SpatialMath:)vector3{Left := 1.0, Up := 1.0, Forward := 1.0}
                }

                # 3. Apply the clean transform.
                NewCourse.SetGlobalTransform(FinalTransform)

                SimEntity.AddEntities(array{NewCourse})
                set CurrentCourseEntity = option{NewCourse}

                FindPlayerComponents(NewCourse)

    SwapCourse():void=
        if (OldCourse := CurrentCourseEntity?):
            set HasPlayerReachedTop = false
            set FinishedPlayersCount = 0
            set TimeMultiplier = 1.0
            set PlayersFinished = map{}
            if (Playspace := Entity.GetPlayspaceForEntity[]):
                Players := Playspace.GetPlayers()
                for (Player : Players):
                    ResetPlayerCheckpoint(Player)
                    NewCourseTeleporter.Teleport(Player)
            CapturedTransform := OldCourse.GetGlobalTransform()
            OldCourse.RemoveFromParent()
            set CurrentCourseEntity = false
            SpawnRandomCourseAtTransform(CapturedTransform)
    SpawnRandomCourseAtTransform(SpawnTransform:(/Verse.org/SpatialMath:)transform):void=
        if (CourseArray.Length = 0):
            return
        RandomIndex := GetNextCourseIndex()
        set CurrentCourseIndex = RandomIndex
        if (SelectedCourse := CourseArray[CurrentCourseIndex]):
            SpawnCourse(SelectedCourse, ?SpawnTransform := option{SpawnTransform})
            if (Playspace := Entity.GetPlayspaceForEntity[]):
                Players := Playspace.GetPlayers()
                for (Player : Players):
                    UpdateUIForCourse(Player, RandomIndex)
                    for (Coin : Coins):
                        Coin.Respawn(Player) 
                    for (LevelCoin : LevelCoins):
                        LevelCoin.Respawn(Player)

    CoinCollected(Agent:agent) : void=
        if (Player := player[Agent]):
            CoinAccoladeDevice.Award(Player)

    FindPlayerComponents(ObbyEntity:entity):void=
        PlayerSpawnComponents := ObbyEntity.FindDescendantEntitiesWithComponent(player_spawn_component)
        for (PlayerSpawnComponent : PlayerSpawnComponents, Mesh := PlayerSpawnComponent.GetComponent[mesh_component]):
            Mesh.EntityEnteredEvent.SubscribeEntity(OnEntityEntered, PlayerSpawnComponent)

    OnEntityEntered(EnteredEntity : entity, TheEntity : entity):void =
        for:
            Component : EnteredEntity.GetComponents()
            ComponentFortCharacter := fort_character[Component]
        do:
            if:
                Agent := ComponentFortCharacter.GetAgent[]
                FortCharacter := Agent.GetFortCharacter[]
                EnteringPlayer := player[Agent]
            then:
                CheckpointPosition := TheEntity.GetGlobalTransform().Translation + (/Verse.org/SpatialMath:)vector3{Up := 150.0}
                if (set PlayerPositions[EnteringPlayer] = CheckpointPosition){}

    ResetPlayerCheckpoint(PlayerToReset : player) : void =
        var NewMap : [player](/Verse.org/SpatialMath:)vector3 = map{}
        for (Key -> Value : PlayerPositions, Key <> PlayerToReset):
            if (set NewMap[Key] = Value) {}
        set PlayerPositions = NewMap

    OnPlayerEliminated(Agent : agent) : void =
        if:
            EliminatedPlayer := player[Agent]
            StoredPositionLUF := PlayerPositions[EliminatedPlayer]
        then:
            spawn { HandleRespawn(Agent, StoredPositionLUF) }

    HandleRespawn(Agent : agent, PositionLUF : (/Verse.org/SpatialMath:)vector3)<suspends> : void =
        Sleep(1.0)
        BasePositionXYZ := FromVector3(PositionLUF)
        RespawnPositionXYZ := (/UnrealEngine.com/Temporary/SpatialMath:)vector3{
            X := BasePositionXYZ.X,
            Y := BasePositionXYZ.Y,
            Z := BasePositionXYZ.Z 
        }
        RespawnRotation := (/UnrealEngine.com/Temporary/SpatialMath:)MakeRotationFromYawPitchRollDegrees(90.0, 0.0, 0.0)
        Agent.Respawn(RespawnPositionXYZ, RespawnRotation)

    PlayerEntersMutatorZone(Agent : agent) : void =
        if:
            EliminatedPlayer := player[Agent]
            StoredPositionLUF := PlayerPositions[EliminatedPlayer]
        then:
            spawn { HandleTeleport(Agent, StoredPositionLUF) }

    HandleTeleport(Agent : agent, PositionLUF : (/Verse.org/SpatialMath:)vector3)<suspends> : void =
        BasePositionXYZ := FromVector3(PositionLUF)
        RespawnPositionXYZ := (/UnrealEngine.com/Temporary/SpatialMath:)vector3{
            X := BasePositionXYZ.X,
            Y := BasePositionXYZ.Y,
            Z := BasePositionXYZ.Z 
        }
        RespawnRotation := (/UnrealEngine.com/Temporary/SpatialMath:)rotation{}
        Agent.Respawn(RespawnPositionXYZ, RespawnRotation)
