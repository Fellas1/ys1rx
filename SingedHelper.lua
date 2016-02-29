--#                                                        #--
--#            basic Singed Helper 1.0                     #--
--#           											                       #--
--##########################################################--


local version = 0.1
local author = 'HoxHud'
local lSequence = {1,3,1,2,1,4,1,3,1,3,4,3,3,2,2,4,2,2}
local ts
ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1000, DAMAGE_PHYSICAL, true)
local eRange = 125
local Ignite = nil


function OnLoad()
	SummonerSpell()
	Menu = scriptConfig ('Singed Helper', 'Singed')
	Menu:addParam("info", "Version:", SCRIPT_PARAM_INFO, ""..version.."")
        Menu:addParam("info2", "Author:", SCRIPT_PARAM_INFO, ""..author.."")
	Menu:addSubMenu('[' ..myHero.charName..'] - R Settings', 'rSets')
	Menu:addSubMenu('[' ..myHero.charName.. ']- KS Settings', 'ksSets')
	Menu:addSubMenu('[' ..myHero.charName.. ']- Interrupt', 'interSets')
	Menu:addSubMenu('[' ..myHero.charName.. ']- Sky Attack', 'skySets')
	Menu:addSubMenu('[' ..myHero.charName.. ']- W / E Combo', 'WandEcomp')
	Menu:addSubMenu('[' ..myHero.charName.. ']- Auto Level Spell', 'autolvl')
	Menu.rSets:addParam('rUse', 'Use R if low HP', SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte 'K')
	Menu.rSets:addParam('pSets', 'Ult when % HP', SCRIPT_PARAM_SLICE, 26, 0, 100, 0)
	Menu.rSets:permaShow('rUse')
	Menu.ksSets:addParam('igniteUse', 'Use Ignite for Kill', SCRIPT_PARAM_ONOFF, true)
	Menu.ksSets:addParam('ksEuse', 'Use E for Kill', SCRIPT_PARAM_ONOFF, true)
	Menu.interSets:addParam('interCC', 'Interrupt with E', SCRIPT_PARAM_ONOFF, true)
	Menu.interSets:permaShow('interCC')
	Menu.skySets:addParam('skyaa', 'Sky Attack', SCRIPT_PARAM_ONOFF, true)
	Menu.WandEcomp:addParam('wecomp', 'Use W E Combo', SCRIPT_PARAM_ONOFF, true)
	Menu.autolvl:addParam('autolll', 'Auto Level Spells', SCRIPT_PARAM_ONOFF, false)
	print("<font color='#FF999'>[Singed Helper] Active")
end

function SummonerSpell()
	if myHero:GetSpellData(SUMMONER_1).name:find('summonerdot') then
		ignite = SUMMONER_1
		elseif myHero:GetSpellData(SUMMONER_2).name:find('summonerdot') then
			ignite = SUMMONER_2
		end
end

function OnTick()
	ts:update()
	Ignite()
	levelSett()
	autoUltt()
end

function Ignite()
	local iDmg = (50 + (20 * myHero.level))
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if GetDistance(enemy, myHero) < 600 and ValidTarget(enemy, 600) and Menu.ksSets.igniteUse then
			if myHero:CanUseSpell(ignite) == READY then
				if enemy.health < iDmg then
					CastSpell(ignite, enemy)
				end
			end
		end
	end
end

function levelSett()
	if Menu.autolvl.autolll then
		autoLevelSetSequence(lSequence) end
end


function autoUltt()
	if ValidTarget(ts.target, 1075) then
	if not player.dead and ((player.health * 100 ) / player.maxHealth) <= Menu.rSets.pSets and player:CanUseSpell(_R) == READY then
       CastSpell(_R)
 end
end
end
