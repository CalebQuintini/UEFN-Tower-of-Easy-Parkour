using { /Fortnite.com/Characters }
using { /Verse.org/SceneGraph }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Verse.org/SceneGraph/KeyframedMovement }

parkour_animation_component := class<final_super>(component):

    @editable
    KeyFrames : []keyframed_movement_delta = array{}
    @editable
    KeyFrameMode : keyframed_movement_playback_mode = pingpong_keyframed_movement_playback_mode{}
 
    OnSimulate<override>()<suspends>:void =
        spawn. AnimateEntity()

    AnimateEntity()<suspends>:void=
        if(AnimComp := Entity.GetComponent[keyframed_movement_component]):
            AnimComp.SetKeyframes(KeyFrames, KeyFrameMode)
            AnimComp.Play()
            AnimComp.FinishedEvent.Await()


        





    
    
