-- ideas

-- simple teleport system to be closer to you when you can't see it. or teleport to the corner you're about to round
-- go invisible when they cant see it and camp a corner, wait til they round the corner to uninvis and scare them.
-- stalking from a distance. watch the player then walk out of sight then teleport for a scare
-- make him taller
-- throw his knife maybe(?)
-- have music from the movie play from him & stinger sound when you come across him.


AddCSLuaFile()

ENT.Base = "terminator_nextbot"
DEFINE_BASECLASS( ENT.Base )
ENT.PrintName = "The Shape"
ENT.Author = "Boomertaters"
terminator_Extras.RegisterNPC( "terminator_nextbot_the_shape", ENT, {
	AdminOnly = true,
} )

ENT.MyWorkshopContentIds = {
    "3831303319", -- bot
    
}

if CLIENT then return end

ENT.WalkSpeed = 135
ENT.MoveSpeed = 145
ENT.RunSpeed = 210
ENT.AccelerationSpeed = 2000
ENT.DeccelerationSpeed = 4000
ENT.JumpHeight = 70 * 2

ENT.TERM_FISTS = "weapon_myers_knife"

ENT.TakesFallDamage = true
ENT.DeathDropHeight = 4000
ENT.DoMetallicDamage = false -- terminator damage logic, bullet resistance, shock immunity, etc
ENT.MetallicMoveSounds = false
ENT.FootstepClomping = false -- second, heavier sound on every step

ENT.isTerminatorHunterChummy = "michaelmyers"
ENT.ExtraSpawnHealthPerPlayer = 1000 -- set to 1000 so he doesn't get 1 shot by a ar2 ball

ENT.CanFindWeaponsOnTheGround = false
ENT.Term_FOV = math.huge -- so he isn't stupid and walks away and actually focuses on the enemy that he can see
ENT.CloseEnemyDistance = 0 -- will ignore low priority enemies and focus on players, unless they're blocking his path

ENT.Models = {
	"models/player/michaelrz.mdl",
}

function ENT:canDoRun()
	return false

end

function ENT:IsAngry()
	return true

end

function ENT:IsReallyAngry()
	return true -- always angry

end

function ENT:EnemyIsLethalInMelee()
	return -- no fear

end

function ENT:inSeriousDanger()
	return false -- no fear

end

function ENT:EnemyIsUnkillable()
	return false

end

local function addUndo( ent, ply )
	if not IsValid( ply ) then return end

	undo.Create( "The Shape" )
		undo.SetPlayer( ply )
		undo.AddEntity( ent )
	undo.Finish( "The Shape" )

end

function ENT:OnKilled( dmginfo )
	local class = self:GetClass()
	local creator = self:GetCreator()
	local spawnEntry = self.glee_SpawnEntry or { class = class, isBoss = true }
	spawnEntry.name = spawnEntry.name or "The Shape"
	
	self:SetShouldServerRagdoll( true )
	local ragdoll = self:BecomeRagdoll( dmginfo )
	if not IsValid( ragdoll ) then return end

	ragdoll.glee_isTheShapeRagdoll = true -- for glee, so it doesn't spawn another shape
	ragdoll:AddEFlags( EFL_NO_DISSOLVE )
	addUndo( ragdoll, creator )

	local function getUp()
		if not IsValid( ragdoll ) then return end

		local phys = ragdoll:GetPhysicsObject()
		local tr = util.QuickTrace( ragdoll:GetPos(), Vector( 0, 0, -100 ), ragdoll )

		-- wait while in the air, moving (shot, falling), or burning
		local moving = IsValid( phys ) and phys:GetVelocity():LengthSqr() > 100
		local waiting = not tr.Hit or moving or ragdoll:IsOnFire() or ragdoll:IsPlayerHolding()
		if waiting then return timer.Simple( 2, getUp ) end

		local spawnPos = tr.HitPos + Vector( 0, 0, 5 )
		local spawnAng = Angle( 0, IsValid( phys ) and phys:GetAngles().y or 0, 0 )
		local shape

		if GAMEMODE.IsReallyHuntersGlee and GAMEMODE.SpawnAndSetupSpawnEntry then
			shape = GAMEMODE:SpawnAndSetupSpawnEntry( spawnEntry, { spawnPos = spawnPos, spawnAng = spawnAng } )

		else
			shape = ents.Create( class )
			shape:SetPos( spawnPos )
			shape:SetAngles( spawnAng )
			shape:Spawn()

		end

		if not IsValid( shape ) then return end

		shape:SetCreator( creator )
		addUndo( shape, creator )

		timer.Simple( 0, function()
			if IsValid( shape ) then
				shape:DoGesture( ACT_HL2MP_ZOMBIE_SLUMP_RISE, 1, true )

			end
		end )

		ragdoll:Remove()

	end

	timer.Simple( math.Rand( 6, 14 ), getUp )

end
