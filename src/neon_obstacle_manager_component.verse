using { /Fortnite.com/Characters }
using { /Verse.org/SceneGraph }
using { /Verse.org/Simulation }

neon_obstacle_manager_component := class<final_super>(component):
 
    OnBeginSimulation<override>():void =
        (super:)OnBeginSimulation()
        NeonComponents := Entity.FindDescendantEntitiesWithComponent(neon_component)
        for (NeonComponent : NeonComponents, Mesh := NeonComponent.GetComponent[mesh_component]):
            Mesh.EntityEnteredEvent.Subscribe(OnEntityEntered)
        
    OnEntityEntered(EnteredEntity : entity):void =
        for:
            Component : EnteredEntity.GetComponents()
            ComponentFortCharacter := fort_character[Component]
        do:
            if:
                Agent := ComponentFortCharacter.GetAgent[]
                FortCharacter := Agent.GetFortCharacter[]
            then:
                FortCharacter.Damage(1000.0)

# Represents the neon entity that eliminates the player.
neon_component<public> := class<final_super>(component):
    OnBeginSimulation<override>():void =
        (super:)OnBeginSimulation()

player_spawn_component := class<final_super>(component):
    OnBeginSimulation<override>():void =
        (super:)OnBeginSimulation()
