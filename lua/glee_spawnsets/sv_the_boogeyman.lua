
local set = {
    name = "the_boogeyman", -- unique name
    prettyName = "Evil on Two Legs",
    description = "Even hell wouldn't have him.", -- those who know :skull:
    difficultyPerMin = "default", -- difficulty per minute
    waveInterval = "default", -- time between spawn waves
    diffBumpWhenWaveKilled = "default", -- when there's <= 1 hunter left, the difficulty is permanently bumped by this amount
    startingBudget = "default", -- so budget isnt 0
    spawnCountPerDifficulty = "default", -- max of ten at 10 minutes
    startingSpawnCount = 1,
    maxSpawnCount = 1,
    maxSpawnDist = { 1800, 2400 }, -- CLOSE!
    roundEndSound = "default",
    roundStartSound = "default",
    roundEarlyStartSound = "default",
    roundEndSound = "the_shape/music/boogeymanend.wav",
    roundStartSound = "the_shape/music/boogeymanstart.wav",
    roundEarlyStartSound = "",
    chanceToBeVotable = 1,
    chanceToBeVotableWhenHard = 7,
    spawns = {
        {
            hardRandomChance = nil,
            name = "theShape",
            prettyName = "The Shape",
            class = "terminator_nextbot_the_shape",
            spawnType = "hunter",
            difficultyCost = 1,
            maxCount = 1,
            countClass = "terminator_nextbot_the_shape",
            postSpawnedFuncs = nil,
            isBoss = true,
        },
    }
}

function set:Activate()
    self:Hook( "huntersglee_spawnwavegeneration_block", function()
        for _, ragdoll in ipairs( ents.FindByClass( "prop_ragdoll" ) ) do
            if IsValid( ragdoll ) and ragdoll.glee_isTheShapeRagdoll then
                return true
            end
        end
    end )
end

table.insert( GLEE_SPAWNSETS, set )