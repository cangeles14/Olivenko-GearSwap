--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- __________.__                                ________                          __               .__.__  __      __  .__    .__           _____.__.__              
-- \______   |  |   ____ _____    ______ ____   \______ \   ____     ____   _____/  |_    ____   __| _|___/  |_  _/  |_|  |__ |__| ______ _/ ____|__|  |   ____      
--  |     ___|  | _/ __ \\__  \  /  ____/ __ \   |    |  \ /  _ \   /    \ /  _ \   __\ _/ __ \ / __ ||  \   __\ \   __|  |  \|  |/  ___/ \   __\|  |  | _/ __ \     
--  |    |   |  |_\  ___/ / __ \_\___ \\  ___/   |    `   (  <_> ) |   |  (  <_> |  |   \  ___// /_/ ||  ||  |    |  | |   Y  |  |\___ \   |  |  |  |  |_\  ___/     
--  |____|   |____/\___  (____  /____  >\___  > /_______  /\____/  |___|  /\____/|__|    \___  \____ ||__||__|    |__| |___|  |__/____  >  |__|  |__|____/\___  > /\ 
--                     \/     \/     \/     \/          \/              \/                   \/     \/                      \/        \/                      \/  \/ 
--
--	Please do not edit this file!							Please do not edit this file!							Please do not edit this file!
--
--	Editing this file will cause you to be unable to use Github Desktop to update!
--
--	Any changes you wish to make in this file you should be able to make by overloading. That is Re-Defining the same variables or functions in another file, by copying and
--	pasting them to a file that is loaded after the original file, all of my library files, and then job files are loaded first.
--	The last files to load are the ones unique to you. User-Globals, Charactername-Globals, Charactername_Job_Gear, in that order, so these changes will take precedence.
--
--	You may wish to "hook" into existing functions, to add functionality without losing access to updates or fixes I make, for example, instead of copying and editing
--	status_change(), you can instead use the function user_status_change() in the same manner, which is called by status_change() if it exists, most of the important 
--  gearswap functions work like this in my files, and if it's unique to a specific job, user_job_status_change() would be appropriate instead.
--
--  Variables and tables can be easily redefined just by defining them in one of the later loaded files: autofood = 'Miso Ramen' for example.
--  States can be redefined as well: state.HybridMode:options('Normal','PDT') though most of these are already redefined in the gear files for editing there.
--	Commands can be added easily with: user_self_command(commandArgs, eventArgs) or user_job_self_command(commandArgs, eventArgs)
--
--	If you're not sure where is appropriate to copy and paste variables, tables and functions to make changes or add them:
--		User-Globals.lua - 			This file loads with all characters, all jobs, so it's ideal for settings and rules you want to be the same no matter what.
--		Charactername-Globals.lua -	This file loads with one character, all jobs, so it's ideal for gear settings that are usable on all jobs, but unique to this character.
--		Charactername_Job_Gear.lua-	This file loads only on one character, one job, so it's ideal for things that are specific only to that job and character.
--
--
--	If you still need help, feel free to contact me on discord or ask in my chat for help: https://discord.gg/ug6xtvQ
--  !Please do NOT message me in game about anything third party related, though you're welcome to message me there and ask me to talk on another medium.
--
--  Please do not edit this file!							Please do not edit this file!							Please do not edit this file!
-- __________.__                                ________                          __               .__.__  __      __  .__    .__           _____.__.__              
-- \______   |  |   ____ _____    ______ ____   \______ \   ____     ____   _____/  |_    ____   __| _|___/  |_  _/  |_|  |__ |__| ______ _/ ____|__|  |   ____      
--  |     ___|  | _/ __ \\__  \  /  ____/ __ \   |    |  \ /  _ \   /    \ /  _ \   __\ _/ __ \ / __ ||  \   __\ \   __|  |  \|  |/  ___/ \   __\|  |  | _/ __ \     
--  |    |   |  |_\  ___/ / __ \_\___ \\  ___/   |    `   (  <_> ) |   |  (  <_> |  |   \  ___// /_/ ||  ||  |    |  | |   Y  |  |\___ \   |  |  |  |  |_\  ___/     
--  |____|   |____/\___  (____  /____  >\___  > /_______  /\____/  |___|  /\____/|__|    \___  \____ ||__||__|    |__| |___|  |__/____  >  |__|  |__|____/\___  > /\ 
--                     \/     \/     \/     \/          \/              \/                   \/     \/                      \/        \/                      \/  \/ 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    gs c toggle LuzafRing -- Toggles use of Luzaf Ring on and off
    
    Offense mode is melee or ranged.  Used ranged offense mode if you are engaged
    for ranged weaponskills, but not actually meleeing.
    
    Weaponskill mode, if set to 'Normal', is handled separately for melee and ranged weaponskills.
--]]


-- Initialization function for this job file.
function get_sets()
    -- Load and initialize the include file.
    include('Sel-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
	-- Whether to use Compensator under a certain threshhold even when weapons are locked.
	state.CompensatorMode = M{'Never','300','1000','Always'}
	-- Whether to automatically generate bullets.
	state.AutoAmmoMode = M(true,'Auto Ammo Mode')
	state.UseDefaultAmmo = M(true,'Use Default Ammo')
	state.Buff['Triple Shot'] = buffactive['Triple Shot'] or false

	-- Whether to use Luzaf's Ring
	state.LuzafRing = M(true, "Luzaf's Ring")
    -- Whether a warning has been given for low ammo
	
	autows = 'Leaden Salute'
	rangedautows = 'Last Stand'
	autofood = 'Sublime Sushi'
	ammostock = 198

    define_roll_values()
	
	init_job_states({"Capacity","AutoRuneMode","AutoTrustMode","AutoWSMode","AutoShadowMode","AutoFoodMode","RngHelper","AutoStunMode","AutoDefenseMode","LuzafRing",},{"AutoBuffMode","AutoSambaMode","Weapons","OffenseMode","RangedMode","WeaponskillMode","ElementalMode","IdleMode","Passive","RuneElement","CompensatorMode","TreasureMode",})
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.

function job_filtered_action(spell, eventArgs)
	if spell.type == 'WeaponSkill' then
		local available_ws = S(windower.ffxi.get_abilities().weapon_skills)
		-- WS 112 is Double Thrust, meaning a Spear is equipped.
		if available_ws:contains(16) then
            if spell.english == "Savage Blade" then
				windower.chat.input('/ws "Evisceration" '..spell.target.raw)
                cancel_spell()
				eventArgs.cancel = true
            elseif spell.english == "Circle Blade" then
                windower.chat.input('/ws "Aeolian Edge" '..spell.target.raw)
                cancel_spell()
				eventArgs.cancel = true
			end
        end
	end
end

function job_pretarget(spell, spellMap, eventArgs)

end

function job_precast(spell, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' then
		state.CombatWeapon:set(player.equipment.range)
    -- Check that proper ammo is available if we're using ranged attacks or similar.
    elseif spell.type == 'CorsairShot' then
		if not player.inventory['Trump Card'] and player.satchel['Trump Card'] then
			send_command('get "Trump Card" satchel')
			eventArgs.cancel = true
			windower.chat.input:schedule(1,'/ja "'..spell.english..'" '..spell.target.raw..'')
			return
		end
    end
	
    if spell.action_type == 'Ranged Attack' or spell.type == 'CorsairShot' or spell.name == 'Shadowbind' or (spell.type == 'WeaponSkill' and spell.skill == 'Marksmanship') then
        do_bullet_checks(spell, spellMap, eventArgs)
    end
end

function job_post_midcast(spell, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' then
		if state.Buff['Triple Shot'] and sets.buff['Triple Shot'] then
			if sets.buff['Triple Shot'][state.RangedMode.value] then
				equip(sets.buff['Triple Shot'][state.RangedMode.value])
			else
				equip(sets.buff['Triple Shot'])
			end
		end

		if state.Buff.Barrage and sets.buff.Barrage then
			equip(sets.buff.Barrage)
		end
	end
end

function job_self_command(commandArgs, eventArgs)
	if commandArgs[1]:lower() == 'elemental' and commandArgs[2]:lower() == 'quickdraw' then
		windower.chat.input('/ja "'..data.elements.quickdraw_of[state.ElementalMode.Value]..' Shot" <t>')
		eventArgs.handled = true			
	end
end

function job_midcast(spell, action, spellMap, eventArgs)
	--Probably overkill but better safe than sorry.
	if spell.action_type == 'Ranged Attack' then
		if player.equipment.ammo:startswith('Hauksbok') or player.equipment.ammo == "Animikii Bullet" then
			enable('ammo')
			equip({ammo=empty})
			add_to_chat(123,"Abort Ranged Attack: Don't shoot your good ammo!")
			return
		end
	end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, spellMap, eventArgs)
    if spell.type == 'CorsairRoll' and not spell.interrupted then
		if state.CompensatorMode.value ~= 'Never' then
			if (player.equipment.range and player.equipment.range == 'Compensator') and sets.weapons[state.Weapons.value] and sets.weapons[state.Weapons.value].range then
				equip({range=sets.weapons[state.Weapons.value].range})
				disable('range')
			end
			if sets.precast.CorsairRoll.main and sets.weapons[state.Weapons.value] and sets.weapons[state.Weapons.value].main then
				equip({main=sets.weapons[state.Weapons.value].main})
				disable('main')
			end
		end
        display_roll_info(spell)
	end
	
	if state.UseDefaultAmmo.value then
		equip({ammo=gear.RAbullet})
	end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_buff_change(buff, gain)
	if player.equipment.Ranged and buff:contains('Aftermath') then
		classes.CustomRangedGroups:clear()
		if (player.equipment.Ranged == 'Death Penalty' and buffactive['Aftermath: Lv.3']) then
			classes.CustomRangedGroups:append('AM')
		end
	end
end

-- Modify the default melee set after it was constructed.
function job_customize_melee_set(meleeSet)
    return meleeSet
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
end

function job_post_precast(spell, spellMap, eventArgs)
	if spell.type == 'WeaponSkill' then
		local WSset = standardize_set(get_precast_set(spell, spellMap))
		local wsacc = check_ws_acc()
		
		if (WSset.ear1 == "Moonshade Earring" or WSset.ear2 == "Moonshade Earring") then
			-- Replace Moonshade Earring if we're at cap TP
			if get_effective_player_tp(spell, WSset) > 3200 then
				if data.weaponskills.elemental:contains(spell.english) then
					if wsacc:contains('Acc') and sets.MagicalAccMaxTP then
						equip(sets.MagicalAccMaxTP[spell.english] or sets.MagicalAccMaxTP)
					elseif sets.MagicalMaxTP then
						equip(sets.MagicalMaxTP[spell.english] or sets.MagicalMaxTP)
					else
					end
				elseif spell.skill == 26 then
					if wsacc:contains('Acc') and sets.RangedAccMaxTP then
						equip(sets.RangedAccMaxTP[spell.english] or sets.RangedAccMaxTP)
					elseif sets.RangedMaxTP then
						equip(sets.RangedMaxTP[spell.english] or sets.RangedMaxTP)
					else
					end
				else
					if wsacc:contains('Acc') and not buffactive['Sneak Attack'] and sets.AccMaxTP then
						equip(sets.AccMaxTP[spell.english] or sets.AccMaxTP)
					elseif sets.MaxTP then
						equip(sets.MaxTP[spell.english] or sets.MaxTP)
					else
					end
				end
			end
		end
	elseif spell.type == 'CorsairShot' and not (spell.english == 'Light Shot' or spell.english == 'Dark Shot') then
		if (state.WeaponskillMode.value == "Proc" or state.CastingMode.value == "Proc") and sets.precast.CorsairShot.Proc then
			equip(sets.precast.CorsairShot.Proc)
		elseif state.CastingMode.value == 'Fodder' and sets.precast.CorsairShot.Damage then
			equip(sets.precast.CorsairShot.Damage)
		end
	elseif spell.action_type == 'Ranged Attack' then
		if buffactive.Flurry then
			if sets.precast.RA.Flurry and lastflurry == 1 then
				equip(sets.precast.RA.Flurry)
			elseif sets.precast.RA.Flurry2 and lastflurry == 2 then
				equip(sets.precast.RA.Flurry2)
			end
		end
	elseif spell.type == 'CorsairRoll' or spell.english == "Double-Up" then
		if state.LuzafRing.value and item_available("Luzaf's Ring") then
			equip(sets.precast.LuzafRing)
		end
		if spell.type == 'CorsairRoll' and state.CompensatorMode.value ~= 'Never' and (state.CompensatorMode.value == 'Always' or tonumber(state.CompensatorMode.value) > player.tp) then
			if item_available("Compensator") then
				enable('range')
				equip({range="Compensator"})
			end
			if sets.precast.CorsairRoll.main and sets.precast.CorsairRoll.main ~= player.equipment.main then
				enable('main')
				equip({main=sets.precast.CorsairRoll.main})
			end
		end
    elseif spell.english == 'Fold' and buffactive['Bust'] == 2 and sets.precast.FoldDoubleBust then
		equip(sets.precast.FoldDoubleBust)
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function define_roll_values()
    rolls = {
        ["Corsair's Roll"]   = {lucky=5, unlucky=9, bonus="Experience Points"},
        ["Ninja Roll"]       = {lucky=4, unlucky=8, bonus="Evasion"},
        ["Hunter's Roll"]    = {lucky=4, unlucky=8, bonus="Accuracy"},
        ["Chaos Roll"]       = {lucky=4, unlucky=8, bonus="Attack"},
        ["Magus's Roll"]     = {lucky=2, unlucky=6, bonus="Magic Defense"},
        ["Healer's Roll"]    = {lucky=3, unlucky=7, bonus="Cure Potency Received"},
        ["Puppet Roll"]      = {lucky=3, unlucky=7, bonus="Pet Magic Accuracy/Attack"},
        ["Choral Roll"]      = {lucky=2, unlucky=6, bonus="Spell Interruption Rate"},
        ["Monk's Roll"]      = {lucky=3, unlucky=7, bonus="Subtle Blow"},
        ["Beast Roll"]       = {lucky=4, unlucky=8, bonus="Pet Attack"},
        ["Samurai Roll"]     = {lucky=2, unlucky=6, bonus="Store TP"},
        ["Evoker's Roll"]    = {lucky=5, unlucky=9, bonus="Refresh"},
        ["Rogue's Roll"]     = {lucky=5, unlucky=9, bonus="Critical Hit Rate"},
        ["Warlock's Roll"]   = {lucky=4, unlucky=8, bonus="Magic Accuracy"},
        ["Fighter's Roll"]   = {lucky=5, unlucky=9, bonus="Double Attack Rate"},
        ["Drachen Roll"]     = {lucky=4, unlucky=8, bonus="Pet Accuracy"},
        ["Gallant's Roll"]   = {lucky=3, unlucky=7, bonus="Defense"},
        ["Wizard's Roll"]    = {lucky=5, unlucky=9, bonus="Magic Attack"},
        ["Dancer's Roll"]    = {lucky=3, unlucky=7, bonus="Regen"},
        ["Scholar's Roll"]   = {lucky=2, unlucky=6, bonus="Conserve MP"},
        ["Bolter's Roll"]    = {lucky=3, unlucky=9, bonus="Movement Speed"},
        ["Caster's Roll"]    = {lucky=2, unlucky=7, bonus="Fast Cast"},
        ["Courser's Roll"]   = {lucky=3, unlucky=9, bonus="Snapshot"},
        ["Blitzer's Roll"]   = {lucky=4, unlucky=9, bonus="Attack Delay"},
        ["Tactician's Roll"] = {lucky=5, unlucky=8, bonus="Regain"},
        ["Allies' Roll"]    = {lucky=3, unlucky=10, bonus="Skillchain Damage"},
        ["Miser's Roll"]     = {lucky=5, unlucky=7, bonus="Save TP"},
        ["Companion's Roll"] = {lucky=2, unlucky=10, bonus="Pet Regain and Regen"},
        ["Avenger's Roll"]   = {lucky=4, unlucky=8, bonus="Counter Rate"},
		["Naturalist's Roll"]   = {lucky=3, unlucky=7, bonus="Enhancing Duration"},
		["Runeist's Roll"]   = {lucky=4, unlucky=8, bonus="Magic Evasion"},
    }
end

function display_roll_info(spell)
    rollinfo = rolls[spell.english]
    local rollsize = (state.LuzafRing.value and 'Large') or 'Small'

    if rollinfo then
        add_to_chat(217, spell.english..' provides a bonus to '..rollinfo.bonus..'.  Roll size: '..rollsize)
        add_to_chat(217, 'Lucky roll is '..tostring(rollinfo.lucky)..', Unlucky roll is '..tostring(rollinfo.unlucky)..'.')
    end
end


-- Determine whether we have sufficient ammo for the action being attempted.
function do_bullet_checks(spell, spellMap, eventArgs)

    if (player.equipment.ammo == 'Animikii Bullet' or player.equipment.ammo == 'Hauksbok Bullet') then
		cancel_spell()
		eventArgs.cancel = true
		enable('ammo')

		if sets.weapons[state.Weapons.value].ammo and item_available(sets.weapons[state.Weapons.value].ammo) then
			equip({ammo=sets.weapons[state.Weapons.value].ammo})
			disable('ammo')
		elseif item_available(gear.RAbullet) then
			equip({ammo=gear.RAbullet})
		else
			equip({ammo=empty})
		end

		add_to_chat(123,"Abort: Don't shoot your good ammo!")
		return
    end

    local bullet_name
    local bullet_min_count = 1
    
    if spell.type == 'WeaponSkill' then
        if spell.skill == "Marksmanship" then
            if data.weaponskills.elemental:contains(spell.english) then
                -- magical weaponskills
                bullet_name = gear.MAbullet
            else
				-- physical weaponskills
				bullet_name = gear.WSbullet
            end
        else
            -- Ignore non-ranged weaponskills
            return
        end
    elseif spell.type == 'CorsairShot' then
        bullet_name = gear.QDbullet
    elseif spell.action_type == 'Ranged Attack' then
        bullet_name = gear.RAbullet
        if state.Buff['Triple Shot'] then
            bullet_min_count = 3
        end
    end
  
	local available_bullets = count_available_ammo(bullet_name)
	
  -- If no ammo is available, give appropriate warning and cancel.
    if not (available_bullets > 0) then
        if spell.type == 'CorsairShot' and player.equipment.ammo ~= 'empty' then
            add_to_chat(217, 'No Quick Draw ammo available, using equipped ammo: ('..player.equipment.ammo..')')
            return
        elseif spell.type == 'WeaponSkill' and (player.equipment.ammo == gear.RAbullet or player.equipment.ammo == gear.WSbullet or player.equipment.ammo == gear.MAbullet) then
            add_to_chat(217, 'No weaponskill ammo available, using equipped ammo: ('..player.equipment.ammo..')')
            return
        else
            add_to_chat(217, 'No ammo ('..tostring(bullet_name)..') available for that action.')
            eventArgs.cancel = true
            return
        end
    end
    
    -- Don't allow shooting or weaponskilling with ammo reserved for quick draw.
    if spell.type ~= 'CorsairShot' and bullet_name == gear.QDbullet and (available_bullets <= bullet_min_count) then
        add_to_chat(217, 'No ammo will be left for Quick Draw.  Cancelling.')
        eventArgs.cancel = true
        return
    end
    
    -- Low ammo warning.
    if spell.type ~= 'CorsairShot' and (available_bullets > 0) and (available_bullets <= options.ammo_warning_limit) then
        local msg = '****  LOW AMMO WARNING: '..bullet_name..' ****'
        --local border = string.repeat("*", #msg)
        local border = ""
        for i = 1, #msg do
            border = border .. "*"
        end
        
        add_to_chat(217, border)
        add_to_chat(217, msg)
        add_to_chat(217, border)
    end
end

function job_tick()
	if check_ammo() then return true end
	return false
end