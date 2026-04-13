local I = require("openmw.interfaces")
local anim = require("openmw.animation")

local function onScribPetted()
        I.AnimationController.playBlendedAnimation("petit",
        {
            startKey = 'start',
            stopKey = 'stop',
            ---@diagnostic disable-next-line: assign-type-mismatch
            priority = {
                [anim.BONE_GROUP.LeftArm] = anim.PRIORITY.Scripted,
            },
            autoDisable = true,
            blendMask = anim.BLEND_MASK.LeftArm,
            speed = 1
        })
end

return{
    eventHandlers = {
        PetTheScribs_ScribPetted = onScribPetted,
    }
}