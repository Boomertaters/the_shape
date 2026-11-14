AddCSLuaFile()

SWEP.Base = "weapon_crowbar_term"
DEFINE_BASECLASS( SWEP.Base )

SWEP.PrintName = "Myers Knife"
SWEP.Spawnable = false
SWEP.Author = "Boomertaters"
SWEP.Purpose = "Should only be used internally by term nextbots!"

sound.Add( {
	name = "Myers.KnifeSlash",
	channel = CHAN_WEAPON,
	level = 75,
	sound = {
		"weapons/knife/knife_slash1.wav",
		"weapons/knife/knife_slash2.wav",
	},
} )

sound.Add( {
	name = "Myers.KnifeHit",
	channel = CHAN_WEAPON,
	level = 75,
	sound = {
		"weapons/knife/knife_hit1.wav",
		"weapons/knife/knife_hit2.wav",
		"weapons/knife/knife_hit3.wav",
		"weapons/knife/knife_hit4.wav",
	},
} )

SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.HoldType = "knife"
SWEP.PickupSound = "weapons/knife/knife_deploy1.wav"
SWEP.SpawningOffset = 90
SWEP.SmackDamage = 55
SWEP.SmackSwingSound = "Myers.KnifeSlash" -- idk what the knife sounds were
SWEP.SmackHitSound = "Myers.KnifeHit"
SWEP.SmackDelay = 1

SWEP.MeleeHoldTypeRange = 150

-- never throw it, always stab
function SWEP:Swing()
	self:Smack()

end

function SWEP:Equip()
	BaseClass.Equip( self )

	if not SERVER then return end

	local timerName = "myers_knife_holdtype_" .. self:GetCreationID()

	timer.Create( timerName, 0.1, 0, function()
		if not IsValid( self ) or not IsValid( self:GetOwner() ) then timer.Remove( timerName ) return end

		local owner = self:GetOwner()
		local holdType = "knife"

		if IsValid( owner:GetEnemy() ) and owner.DistToEnemy < self.MeleeHoldTypeRange then
			holdType = "melee"

		end

		if self.oldHoldType == holdType then return end

		self.oldHoldType = holdType
		self:SetHoldType( holdType )

	end )
end

if not CLIENT then return end

function SWEP:DrawWorldModel()
	self:DrawModel()

end