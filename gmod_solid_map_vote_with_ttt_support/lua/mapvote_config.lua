-- Time in seconds until the mapvote is over from
-- when it starts.
SolidMapVote[ 'Config' ][ 'Length' ] = 25

-- The time in seconds that the vote will stay on the screen
-- after the winning map has been chosen.
SolidMapVote[ 'Config' ][ 'Post Vote Length' ] = 5

-- This option controls the size of the map vote buttons.
-- This will effect how the images look. If your switching from tall to
-- the square option, then the images should look fine. Vice Versa you'll
-- need to get some new pictures because up scaling small images up looks like butt.
-- 1 = Tall and skinny vote buttons
-- 2 = Square vote buttons
SolidMapVote[ 'Config' ][ 'Map Button Size' ] = 0.5

-- This option allows you to set a time for when the map vote will
-- appear after. The first option must be set to true, then the second
-- option controls how long before it comes up in seconds. Simply math
-- can be used to control the length. The last option sets how long before
-- the vote pops up to show a reminder that it is going to happen.
SolidMapVote[ 'Config' ][ 'Enable Vote Autostart' ] = false
SolidMapVote[ 'Config' ][ 'Vote Autostart Delay' ] = 5*60 + 30  -- 5 minutes 30 seconds
SolidMapVote[ 'Config' ][ 'Autostart Reminder' ] = 1*60 -- 1 minute
SolidMapVote[ 'Config' ][ 'Time Left Commands' ] = {
    '!timeleft', '/timeleft', '.timeleft'
}

-- This it the prefix for maps you want to unclude into
-- the possible maps for the mapvote.
-- List of typical gamemodes prefixes.
-- ttt  = Trouble in Terrorist Town
-- bhop = Bunny Hop
-- surf = Surf
-- rp   = Role Play
SolidMapVote[ 'Config' ][ 'Map Prefix' ] = {
    'ttt',
    'rp',
    'gm',
    'mu',
    'blockh',
    'zs',
    'freeway',
    'hmcd'
}

local namecolor = {
   default = COLOR_WHITE,
   superadmin = Color(212,175,55),
   admin = Color(0,191,255),
   veteran = Color(255,20,147),
   moderator = Color(124,252,0),
   supporter = Color(124,252,0),
   servertreuer = Color(178,34,34),
   nutzer = Color(65,105,225),
   user = Color(230,230,250)
};

-- Use this function to give specific players or groups different colored
-- avatar borders on the map vote.
SolidMapVote[ 'Config' ][ 'Avatar Border Color' ] = function( ply )

  if ply:IsUserGroup("superadmin") then
	return HSVToColor( math.sin( 0.3*RealTime() )*128 + 127, 1, 1 )
  end

  if ply:IsUserGroup("servertreuer") then
	return namecolor.servertreuer
  end
    -- This is the default color
    return color_white
end

-- Use this function to give players more vote power than others.
-- I would personally keep all players at the same power because
-- I beleive in equal vote power, but this is up to you.
SolidMapVote[ 'Config' ][ 'Vote Power' ] = function( ply )
    if ply:IsAdmin() then
        return 1
    end

    -- Default vote power
    -- Would keep this at 1, unless you know what your doing (you're*)
    return 1
end

-- Enabling this option will give greater a chance to maps
-- that are played less often to be selected in the vote.
-- Disabling it will let the map vote randomly choose maps for the vote.
SolidMapVote[ 'Config' ][ 'Fair Map Recycling' ] = true

-- Setting this to true will display on the map vote button how many
-- times the map was played in the past.
SolidMapVote[ 'Config' ][ 'Show Map Play Count' ] = true

-- Setting the option below to true will allow you to manually set the
-- map pool using the table below. Only the maps inside the table will
-- be able to be chosen for the vote.
SolidMapVote[ 'Config' ][ 'Manual Map Pool' ] = false
SolidMapVote[ 'Config' ][ 'Map Pool' ] = {

}

-- Allow players to use their mics while in the mapvote
SolidMapVote[ 'Config' ][ 'Enable Voice' ] = true

-- Allow players to use the chat box while in the mapvote
SolidMapVote[ 'Config' ][ 'Enable Chat' ] = true

-- Here you can specify what players can force the mapvote to appear.
SolidMapVote[ 'Config' ][ 'Force Vote Permission' ] = function( ply )
    return ply:IsAdmin()
end

-- These commands can be used by players specified above to
-- start the mapvote regarless of the amount of players that rtv
SolidMapVote[ 'Config' ][ 'Force Vote Commands' ] = {
    '!forcertv', '/forcertv', '.forcertv'
}

-- This is the percentage of players that need to rtv in order for the vote
-- to come up
SolidMapVote[ 'Config' ][ 'RTV Percentage' ] = 0.6

-- This is the time in seconds that must pass before players can begin to RTV
SolidMapVote[ 'Config' ][ 'RTV Delay' ] = 300

-- If this is set to true, players will be able to remove their RTV
-- by typing the RTV command again.
SolidMapVote[ 'Config' ][ 'Enable UnVote' ] = true

-- These commands will add to rocking the vote.
SolidMapVote[ 'Config' ][ 'Vote Commands' ] = {
    '!rtv', '/rtv', '.rtv'
}

-- Set this option to true if you want to ignore the
-- prefix and just use all the maps in your maps folder.
SolidMapVote[ 'Config' ][ 'Ignore Prefix' ] = false

-- These commands will open the nomination menu
SolidMapVote[ 'Config' ][ 'Nomination Commands' ] = {
    '!nominate', '/nominate', '.nominate'
}

-- Set this option to true if you want players to be able to
-- nominate maps.
SolidMapVote[ 'Config' ][ 'Allow Nominations' ] = false

-- You can use this function to only allow certain players to be able to
-- use the nomination system. Open a support ticket if you need assistance
-- setting this up.
SolidMapVote[ 'Config' ][ 'Nomination Permissions' ] = function( ply )
    return true
end

-- Set this to true if you want the option to extend the map on the vote
-- Set to false to disable
SolidMapVote[ 'Config' ][ 'Enable Extend' ] = true
SolidMapVote[ 'Config' ][ 'Extend Image' ] = 'http://i.imgur.com/zzBeMid.png'

-- Set this to true if you want the option to choose a random map
-- Set to false to disable
SolidMapVote[ 'Config' ][ 'Enable Random' ] = true
-- This option controls how the random button works
-- 1 = Random map will be selected from the maps on the vote menu
-- 2 = Random map will be selected from the entire map pool
SolidMapVote[ 'Config' ][ 'Random Mode' ] = 2
SolidMapVote[ 'Config' ][ 'Random Image' ] = 'http://i.imgur.com/oqeqWhl.png'

-- This is the image for maps that are missing an image
SolidMapVote[ 'Config' ][ 'Missing Image' ] = ''
SolidMapVote[ 'Config' ][ 'Missing Image Size' ] = { width = 1920, height = 1080 }

-- In this table you can add information for the map to make it more
-- appealing on the mapvote.
SolidMapVote[ 'Config' ][ 'Specific Maps' ] = {
    { filename = 'ttt_minecraft_b5', displayname = 'Minecraft B5', image = 'https://i.imgur.com/K8Mmm3e.png', width = 1920, height = 1080 },
    { filename = 'ttt_mw2_terminal', displayname = 'MW2 Terminal', image = 'https://i.imgur.com/zE4QsjI.jpeg', width = 1920, height = 1080 },
    { filename = 'mu_smallotown_v2_13', displayname = 'SmalloTown', image = 'https://i.imgur.com/kjlPyQk.png', width = 1920, height = 1080 },
    { filename = 'mu_smallotown_v2_13_night', displayname = 'SmalloTown Night', image = 'https://i.imgur.com/JzO3FKp.png', width = 1920, height = 1080 },
    { filename = 'ttt_submarine', displayname = 'Submarine', image = 'https://i.imgur.com/Xge7zrQ.png', width = 1920, height = 1080 },
    { filename = 'ttt_community_pool_2017_b19', displayname = 'Community Pool 2017', image = 'https://i.imgur.com/ForTGbU.png', width = 1920, height = 1080 },
    { filename = 'gm_asylum', displayname = 'Asylum', image = 'https://i.imgur.com/ejIzs88.png', width = 1920, height = 1080 },
    { filename = 'etazhi', displayname = 'Ethazi', image = 'https://i.imgur.com/vvOhYFA.jpeg', width = 1920, height = 1080 },
    { filename = 'ttt_forest_final', displayname = 'Forest', image = 'https://i.imgur.com/bj3hvnh.jpeg', width = 1920, height = 1080 },
    { filename = 'ttt_casino_b2', displayname = 'Casino', image = 'https://i.imgur.com/KBbMseJ.jpeg', width = 1920, height = 1080 },
    { filename = 'ttt_skyscraper', displayname = 'Skyscraper', image = 'https://i.imgur.com/E3xMlaX.jpeg', width = 1920, height = 1080 },
    { filename = 'gm_motelshootout', displayname = 'Motel Shootout', image = 'https://i.imgur.com/3PTxkaV.png', width = 1920, height = 1080 },
    { filename = 'gm_kleinercomcenter', displayname = 'Kleiner Community Center', image = 'https://i.imgur.com/yueypUm.jpeg', width = 1920, height = 1080 },
    { filename = 'ttt_community_bowling_v5a', displayname = 'Community Bowling', image = 'https://i.imgur.com/BXmmMUp.jpeg', width = 1920, height = 1080 },
    { filename = 'ttt_minecraftcity_v4', displayname = 'Minecraft City', image = 'https://i.imgur.com/WxcJwEg.jpeg', width = 1920, height = 1080 },
    { filename = 'ttt_island_2013', displayname = 'Island 2013', image = 'https://i.imgur.com/P8jBhN0.jpeg', width = 1920, height = 1080 },
    { filename = 'gm_haevon', displayname = 'Haevon', image = 'https://i.imgur.com/DIZSgjN.png', width = 1920, height = 1080 },
    { filename = 'mu_powerhermit', displayname = 'Powerhermit', image = 'https://i.imgur.com/ooqCPz7.jpeg', width = 1920, height = 1080 },
    { filename = 'ttt_airbus_b3', displayname = 'Airbus', image = 'https://i.imgur.com/5AQ7itT.jpeg', width = 1920, height = 1080 },
    { filename = 'gm_house3v3', displayname = 'House 3v3', image = 'https://i.imgur.com/x4pDPDR.png', width = 1920, height = 1080 },
    { filename = 'ttt_clue_se', displayname = 'Clue SE', image = 'https://i.imgur.com/4ql9OFh.jpeg', width = 1920, height = 1080 },
    { filename = 'gm_htbank', displayname = 'HTBank', image = 'https://i.imgur.com/31WJr5m.png', width = 1920, height = 1080 },
    { filename = 'mu_silence', displayname = 'Silence', image = 'https://i.imgur.com/6mKDeQB.jpeg', width = 1920, height = 1080 },
    { filename = 'ttt_silence_v3', displayname = 'Silence', image = 'https://i.imgur.com/6mKDeQB.jpeg', width = 1920, height = 1080 },
    { filename = 'ttt_rooftops_2016', displayname = 'Rooftops 2016', image = 'https://i.imgur.com/sm1xxdf.jpeg', width = 1920, height = 1080 },
    { filename = 'ttt_coder', displayname = 'Coder', image = 'https://i.imgur.com/me7zfpt.jpeg', width = 1920, height = 1080 },
    { filename = 'ttt_mcdonalds_mds_v2', displayname = 'McDonalds', image = 'https://i.imgur.com/las0jVW.jpeg', width = 1920, height = 1080 },
    { filename = 'ttt_grovestreet_a13', displayname = 'Grove Street', image = 'https://i.imgur.com/Mft32op.jpeg', width = 1920, height = 1080 },
    { filename = 'ttt_bikinibottom_v1c', displayname = 'Bikini Bottom', image = 'https://i.imgur.com/U4fVuk0.jpeg', width = 1920, height = 1080 },
    { filename = 'gm_chapel', displayname = 'Chapel', image = 'https://i.imgur.com/SRbCBtJ.jpeg', width = 1920, height = 1080 },
    { filename = 'gm_crazyrooms', displayname = 'Crazyrooms', image = 'https://i.imgur.com/JafsjDV.jpeg', width = 1920, height = 1080 },
    { filename = 'gm_mcvillage', displayname = 'Minecraft Village', image = 'https://i.imgur.com/mIdiALr.jpeg', width = 1920, height = 1080 },
    { filename = 'gm_mcvillage_new', displayname = 'Minecraft Village', image = 'https://i.imgur.com/mIdiALr.jpeg', width = 1920, height = 1080 },
    { filename = 'ttt_minecraft_clue', displayname = 'Minecraft Clue', image = 'https://i.imgur.com/bbLBXeN.jpeg', width = 1920, height = 1080 },
    { filename = 'ttt_terrortrain_2020_b5', displayname = 'Terror Train', image = 'https://i.imgur.com/Mw6z9tZ.jpeg', width = 1920, height = 1080 },
    { filename = 'mu_harrison', displayname = 'Harrison', image = 'https://i.imgur.com/66XixD6.jpeg', width = 1920, height = 1080 },
    { filename = 'blockh_final_01', displayname = 'BlockH', image = 'https://i.imgur.com/e65uGfd.jpeg', width = 1920, height = 1080 },
    { filename = 'gm_rblx_haunted_mansion', displayname = 'Haunted Mansion', image = 'https://i.imgur.com/JyZL8ro.jpeg', width = 1920, height = 1080 },
    { filename = 'ttt_surface', displayname = 'Surface', image = 'https://i.imgur.com/e2BJbHB.jpeg', width = 1920, height = 1080 },
    { filename = 'mu_smallotown_v2_snow', displayname = 'SmalloTown XMAS', image = 'https://i.imgur.com/uik1dKu.png', width = 1920, height = 1080 },
    { filename = 'gm_oxxo_redux', displayname = 'Oxxo', image = 'https://i.imgur.com/2l1qDCn.jpeg', width = 1920, height = 1080 },
    { filename = 'ttt_community_bowling_xmas_gfl', displayname = 'Community Bowling XMAS', image = 'https://i.imgur.com/3hnjmYT.jpeg', width = 1920, height = 1080 },
    { filename = 'ttt_clue_xmas', displayname = 'Clue XMAS', image = 'https://i.imgur.com/m29WJfI.png', width = 1920, height = 1080 },
    { filename = 'gm_bbicotka_hmcd', displayname = 'BbiCOTKA', image = 'https://i.imgur.com/Hmxzjg0.jpeg', width = 1920, height = 1080 },
    { filename = 'gm_hmcd_rooftops', displayname = 'Rooftops', image = 'https://i.imgur.com/iypuQGm.png', width = 1920, height = 1080 },
    { filename = 'hmcd_rooftops', displayname = 'Rooftops', image = 'https://i.imgur.com/iypuQGm.png', width = 1920, height = 1080 },
    { filename = 'hmcd_rooftops_snow', displayname = 'Rooftops Snow', image = 'https://i.imgur.com/yab1uil.png', width = 1920, height = 1080 },
    { filename = 'zs_zomboidstripmall_v1b', displayname = 'Zomboid Stripmall', image = 'https://i.imgur.com/SYM2b29.png', width = 1920, height = 1080 },
    { filename = 'ttt_waterworld_tropical', displayname = 'Tropical Waterworld', image = 'https://i.imgur.com/6j2aL5c.png', width = 1920, height = 1080 },
    { filename = 'gm_mental_hospital', displayname = 'Mental Hospital', image = 'https://i.imgur.com/ZQMevq4.png', width = 1920, height = 1080 },
    { filename = 'ttt_paradise_resort', displayname = 'Paradise Resort', image = 'https://i.imgur.com/QYqXu3d.png', width = 1920, height = 1080 },
    { filename = 'gm_denizen', displayname = 'Denizen', image = 'https://i.imgur.com/Oc5UrOm.jpeg', width = 1920, height = 1080 },
    { filename = 'ttt_denizen', displayname = 'Denizen', image = 'https://i.imgur.com/Oc5UrOm.jpeg', width = 1920, height = 1080 },
    { filename = 'gm_weekend_disable_shadow', displayname = 'Weekend House (No Shadow)', image = 'https://i.imgur.com/G2ZZptO.jpeg', width = 1920, height = 1080 },
    { filename = 'gm_weekend_house_day', displayname = 'Weekend House', image = 'https://i.imgur.com/G2ZZptO.jpeg', width = 1920, height = 1080 },
    { filename = 'gm_weekend_house_night', displayname = 'Weekend House Night', image = 'https://i.imgur.com/G2ZZptO.jpeg', width = 1920, height = 1080 },
    { filename = 'gm_brutalist_mcdonalds', displayname = 'Brutalist Mcdonalds', image = 'https://i.imgur.com/ZbamNIz.jpeg', width = 1920, height = 1080 },
    { filename = 'ttt_pizzeria', displayname = 'Pizzeria', image = 'https://i.imgur.com/h1JyzXV.png', width = 1920, height = 1080 },
    { filename = 'gm_sentimental98v1', displayname = 'Sentimental', image = 'https://i.imgur.com/mqomvPg.png', width = 1920, height = 1080 },
    { filename = 'gm_pizzaplace2014', displayname = 'Pizza Place 2014', image = 'https://i.imgur.com/NZiYpwU.jpeg', width = 1920, height = 1080 },
    { filename = 'gm_tiny_town', displayname = 'Tiny Town', image = 'https://i.imgur.com/kxC3FKh.png', width = 1920, height = 1080 },
    { filename = 'freeway_thicc_v3', displayname = 'Freeway Thick', image = 'https://i.imgur.com/7uKxmyo.jpeg', width = 1920, height = 1080 },
    { filename = 'gm_trainride_bloodshed', displayname = 'Trainride', image = 'https://i.imgur.com/Fzb2Ddw.png', width = 1920, height = 1080 },
    { filename = 'gm_rats_kitchen2', displayname = 'Rats Kitchen', image = 'https://i.imgur.com/smtb6LQ.jpeg', width = 1920, height = 1080 },
}