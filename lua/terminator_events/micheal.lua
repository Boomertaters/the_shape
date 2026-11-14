
local newEvent = {
    defaultPercentChancePerMin = 0.3,
    secret = {
        keyword = "you cant kill the boogeyman", -- for those who peep the code... i know you're here
        chanceIncrease = 4,
    },

    doesDedicationProgression = true,
    navmeshEvent = true,
    variants = {
        {
            variantName = "chanceMichealMeeting",
            getIsReadyFunc = nil,
            minDedication = 0,
            maxDedication = 4,
            overrideChance = 40, -- chance to override other events, this goes from top to bottom
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_the_shape",
                    spawnAlgo = "steppedRandomRadius",
                    deleteAfterMeet = false,
                    timeout = false,

                }
            },
            thinkInterval = nil, -- makes it default to terminator_Extras.activeEventThinkInterval
            concludeOnMeet = true,
        },
    }
}

terminator_Extras.RegisterEvent( newEvent, "micheal" )

