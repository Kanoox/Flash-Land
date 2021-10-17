DP = {}

DP.Expressions = {
   ["Blessé"] = {"Expression", "mood_injured_1"},
   ["Bouder"] = {"Expression", "mood_sulk_1"},
   ["Bizarre"] = {"Expression", "effort_2"},
   ["Bizarre 2"] = {"Expression", "effort_3"},
   ["Électrocuté"] = {"Expression", "electrocuted_1"},
   ["En train de dormir"] = {"Expression", "mood_sleeping_1"},
   ["En train de dormir 2"] = {"Expression", "dead_1"},
   ["En train de dormir 3"] = {"Expression", "dead_2"},
   ["En colère"] = {"Expression", "mood_angry_1"},
   ["Fermer qu'un seul oeil"] = {"Expression", "pose_aiming_1"},
   ["Gêner"] = {"Expression", "mood_smug_1"},
   ["Grincheux"] = {"Expression", "effort_1"},
   ["Grincheux 2"] = {"Expression", "mood_drivefast_1"},
   ["Grincheux 3"] = {"Expression", "pose_angry_1"},
   ["Heureux"] = {"Expression", "mood_happy_1"},
   ["Ivre"] = {"Expression", "mood_drunk_1"},
   ["Joyeux"] = {"Expression", "mood_dancing_low_1"},
   ["Sous le choc"] = {"Expression", "shocked_1"},
   ["Sous le choc 2"] = {"Expression", "shocked_2"},
   ["Stressé"] = {"Expression", "mood_stressed_1"},
   ["Stupide"] = {"Expression", "pose_injured_1"},
   ["?Mouthbreather"] = {"Expression", "smoking_hold_1"},
   ["?Speculative"] = {"Expression", "mood_aiming_1"},
}

DP.Walks = {
  ["Extraterrestre"] = {"move_m@alien"},
  ["Blindé"] = {"anim_group_move_ballistic"},
  ["Arrogant"] = {"move_f@arrogant@a"},
  ["Courageux"] = {"move_m@brave"},
  ["Décontracté"] = {"move_m@casual@a"},
  ["Un peu pressé"] = {"move_m@casual@b"},
  ["Très pressé"] = {"move_m@casual@c"},
  ["Sur de soi"] = {"move_m@casual@d"},
  ["Bras relâché"] = {"move_m@casual@e"},
  ["Pressé"] = {"move_m@casual@f"},
  ["Chichi"] = {"move_f@chichi"},
  ["Dos bien droit"] = {"move_m@confident"},
  ["Flic détendu"] = {"move_m@business@a"},
  ["Flic relax"] = {"move_m@business@b"},
  ["Flic sur de soi"] = {"move_m@business@c"},
  ["Femme par défaut"] = {"move_f@multiplayer"},
  ["Homme par défaut"] = {"move_m@multiplayer"},
  ["Ivre"] = {"move_m@drunk@a"},
  ["Ivre"] = {"move_m@drunk@slightlydrunk"},
  ["Jambe cassé"] = {"move_m@buzzed"},
  ["Ivre à ne plus tenir debout"] = {"move_m@drunk@verydrunk"},
  ["Femme"] = {"move_f@femme@"},
  ["Travailleur"] = {"move_characters@franklin@fire"},
  ["Travailleur 2"] = {"move_characters@michael@fire"},
  ["Travailleur 3"] = {"move_m@fire"},
  ["Fuir"] = {"move_f@flee@a"},
  ["Franklin"] = {"move_p_m_one"},
  ["Gangster"] = {"move_m@gangster@generic"},
  ["Gangster sur de soi"] = {"move_m@gangster@ng"},
  ["Gangster lent"] = {"move_m@gangster@var_e"},
  ["Gangster tête baisse"] = {"move_m@gangster@var_f"},
  ["Gangster pressé"] = {"move_m@gangster@var_i"},
  ["Marcher avec écouteur"] = {"anim@move_m@grooving@"},
  ["Garde armé"] = {"move_m@prison_gaurd"},
  ["Menotté"] = {"move_m@prisoner_cuffed"},
  ["Talons"] = {"move_f@heels@c"},
  ["Talons 2"] = {"move_f@heels@d"},
  ["Randonnée"] = {"move_m@hiking"},
  ["Hipster"] = {"move_m@hipster@a"},
  ["Bourée"] = {"move_m@hobo@a"},
  ["Se dépêcher"] = {"move_f@hurry@a"},
  ["Déterminer"] = {"move_p_m_zero_janitor"},
  ["Prendre son temps"] = {"move_p_m_zero_slow"},
  ["Faire du jogging"] = {"move_m@jog@"},
  ["Lemar"] = {"anim_group_move_lemar_alley"},
  ["Lester"] = {"move_heist_lester"},
  ["Lester 2"] = {"move_lester_caneup"},
  ["?Maneater"] = {"move_f@maneater"},
  ["Michael"] = {"move_ped_bucket"},
  ["Bandit"] = {"move_m@money"},
  ["Musclée"] = {"move_m@muscle@a"},
  ["Chic"] = {"move_m@posh@"},
  ["Chic 2"] = {"move_f@posh@"},
  ["Rapide"] = {"move_m@quick"},
  ["Coureuse"] = {"female_fast_runner"},
  ["Triste"] = {"move_m@sad@a"},
  ["Impertinent"] = {"move_m@sassy"},
  ["Pupute"] = {"move_f@sassy"},
  ["Effrayé"] = {"move_f@scared"},
  ["Sexy"] = {"move_f@sexy@a"},
  ["Sombre"] = {"move_m@shadyped@a"},
  ["Lent"] = {"move_characters@jimmy@slow@"},
  ["Swag"] = {"move_m@swagger"},
  ["Dur"] = {"move_m@tough_guy@"},
  ["Roulé du cul"] = {"move_f@tough_guy@"},
  ["Tenir quelque chose"] = {"clipset@move@trash_fast_turn"},
  ["Tenir quelque chose2"] = {"missfbi4prepp1_garbageman"},
  ["Trevor"] = {"move_p_m_two"},
  ["Large"] = {"move_m@bag"},
  -- I cant get these to work for some reason, if anyone knows a fix lmk
  --["Caution"] = {"move_m@caution"},
  --["Chubby"] = {"anim@move_m@chubby@a"},
  --["Crazy"] = {"move_m@crazy"},
  --["Joy"] = {"move_m@joy@a"},
  --["Power"] = {"move_m@power"},
  --["Sad2"] = {"anim@move_m@depression@a"},
  --["Sad3"] = {"move_m@depression@b"},
  --["Sad4"] = {"move_m@depression@d"},
  --["Wading"] = {"move_m@wading"},
}

DP.Shared = {
   --[emotename] = {dictionary, animation, displayname, targetemotename, additionalanimationoptions}
   -- you dont have to specify targetemoteanem, if you do dont it will just play the same animation on both.
   -- targetemote is used for animations that have a corresponding animation to the other player.
   ["Poignée de main"] = {"mp_ped_interaction", "handshake_guy_b", "Poignée de main", "Poignée de main", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 3000
   }},
   ["Câlin"] = {"mp_ped_interaction", "kisses_guy_b", "Câlin", "Câlin", AnimationOptions =
   {
       EmoteMoving = false,
       EmoteDuration = 5000,
       SyncOffsetFront = 1.13
   }},
   ["Frérot"] = {"mp_ped_interaction", "hugs_guy_b", "Frérot", "Frérot", AnimationOptions =
   {
        SyncOffsetFront = 1.14
   }},
   ["Donner"] = {"mp_common", "givetake1_b", "Donner", "Donner", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 2000
   }},
   ["stickup"] = {"random@countryside_gang_fight", "biker_02_stickup_loop", "Braquer", "stickupscared", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["stickupscared"] = {"missminuteman_1ig_2", "handsup_base", "Se faire Braquer", "stickup", AnimationOptions =
   {
      EmoteMoving = true,
      EmoteLoop = true,
   }},
   ["slap2"] = {"melee@unarmed@streamed_variations", "plyr_takedown_front_backslap", "Mettre une gifle 2", "slapped2", AnimationOptions =
{
       EmoteLoop = true,
       EmoteMoving = true,
       EmoteDuration = 2000,
   }},
   ["slap"] = {"melee@unarmed@streamed_variations", "plyr_takedown_front_slap", "Mettre une gifle", "slapped", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
       EmoteDuration = 2000,
   }},
   ["slapped"] = {"melee@unarmed@streamed_variations", "victim_takedown_front_slap", "Prendre Gifle", "slap"},
   ["slapped2"] = {"melee@unarmed@streamed_variations", "victim_takedown_front_backslap", "Prendre Gifle 2", "slap2"},
}

DP.Dances = {
   ["dancef"] = {"anim@amb@nightclub@dancers@solomun_entourage@", "mi_dance_facedj_17_v1_female^1", "Dance F", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["dancef2"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "high_center", "Dance F2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["dancef3"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "high_center_up", "Dance F3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["dancef4"] = {"anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", "hi_dance_facedj_09_v2_female^1", "Dance F4", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["dancef5"] = {"anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", "hi_dance_facedj_09_v2_female^3", "Dance F5", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["dancef6"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "high_center_up", "Dance F6", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["danceslow2"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "low_center", "Dance Slow 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["danceslow3"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "low_center_down", "Dance Slow 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["danceslow4"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "low_center", "Dance Slow 4", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["dance"] = {"anim@amb@nightclub@dancers@podium_dancers@", "hi_dance_facedj_17_v2_male^5", "Dance", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["dance2"] = {"anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "high_center_down", "Dance 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["dance3"] = {"anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "high_center", "Dance 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["dance4"] = {"anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "high_center_up", "Dance 4", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["danceupper"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "high_center", "Dance Upper", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["danceupper2"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "high_center_up", "Dance Upper 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["danceshy"] = {"anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "low_center", "Dance Shy", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["danceshy2"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "low_center_down", "Dance Shy 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["danceslow"] = {"anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "low_center", "Dance Slow", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["dancesilly9"] = {"rcmnigel1bnmt_1b", "dance_loop_tyler", "Dance Silly 9", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["dance6"] = {"misschinese2_crystalmazemcs1_cs", "dance_loop_tao", "Dance 6", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["dance7"] = {"misschinese2_crystalmazemcs1_ig", "dance_loop_tao", "Dance 7", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["dance8"] = {"missfbi3_sniping", "dance_m_default", "Dance 8", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["dancesilly"] = {"special_ped@mountain_dancer@monologue_3@monologue_3a", "mnt_dnc_buttwag", "Dance Silly", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["dancesilly2"] = {"move_clown@p_m_zero_idles@", "fidget_short_dance", "Dance Silly 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["dancesilly3"] = {"move_clown@p_m_two_idles@", "fidget_short_dance", "Dance Silly 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["dancesilly4"] = {"anim@amb@nightclub@lazlow@hi_podium@", "danceidle_hi_11_buttwiggle_b_laz", "Dance Silly 4", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["dancesilly5"] = {"timetable@tracy@ig_5@idle_a", "idle_a", "Dance Silly 5", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["dancesilly6"] = {"timetable@tracy@ig_8@idle_b", "idle_d", "Dance Silly 6", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["dance9"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "med_center_up", "Dance 9", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["dancesilly8"] = {"anim@mp_player_intcelebrationfemale@the_woogie", "the_woogie", "Dance Silly 8", AnimationOptions =
   {
       EmoteLoop = true
   }},
   ["dancesilly7"] = {"anim@amb@casino@mini@dance@dance_solo@female@var_b@", "high_center", "Dance Silly 7", AnimationOptions =
   {
       EmoteLoop = true
   }},
   ["dance5"] = {"anim@amb@casino@mini@dance@dance_solo@female@var_a@", "med_center", "Dance 5", AnimationOptions =
   {
       EmoteLoop = true
   }},
   ["danceglowstick"] = {"anim@amb@nightclub@lazlow@hi_railing@", "ambclub_13_mi_hi_sexualgriding_laz", "Dance Glowsticks", AnimationOptions =
   {
       Prop = 'ba_prop_battle_glowstick_01',
       PropBone = 28422,
       PropPlacement = {0.0700,0.1400,0.0,-80.0,20.0},
       SecondProp = 'ba_prop_battle_glowstick_01',
       SecondPropBone = 60309,
       SecondPropPlacement = {0.0700,0.0900,0.0,-120.0,-20.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["danceglowstick2"] = {"anim@amb@nightclub@lazlow@hi_railing@", "ambclub_12_mi_hi_bootyshake_laz", "Dance Glowsticks 2", AnimationOptions =
   {
       Prop = 'ba_prop_battle_glowstick_01',
       PropBone = 28422,
       PropPlacement = {0.0700,0.1400,0.0,-80.0,20.0},
       SecondProp = 'ba_prop_battle_glowstick_01',
       SecondPropBone = 60309,
       SecondPropPlacement = {0.0700,0.0900,0.0,-120.0,-20.0},
       EmoteLoop = true,
   }},
   ["danceglowstick3"] = {"anim@amb@nightclub@lazlow@hi_railing@", "ambclub_09_mi_hi_bellydancer_laz", "Dance Glowsticks 3", AnimationOptions =
   {
       Prop = 'ba_prop_battle_glowstick_01',
       PropBone = 28422,
       PropPlacement = {0.0700,0.1400,0.0,-80.0,20.0},
       SecondProp = 'ba_prop_battle_glowstick_01',
       SecondPropBone = 60309,
       SecondPropPlacement = {0.0700,0.0900,0.0,-120.0,-20.0},
       EmoteLoop = true,
   }},
   ["dancehorse"] = {"anim@amb@nightclub@lazlow@hi_dancefloor@", "dancecrowd_li_15_handup_laz", "Dance Horse", AnimationOptions =
   {
       Prop = "ba_prop_battle_hobby_horse",
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["dancehorse2"] = {"anim@amb@nightclub@lazlow@hi_dancefloor@", "crowddance_hi_11_handup_laz", "Dance Horse 2", AnimationOptions =
   {
       Prop = "ba_prop_battle_hobby_horse",
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
   }},
   ["dancehorse3"] = {"anim@amb@nightclub@lazlow@hi_dancefloor@", "dancecrowd_li_11_hu_shimmy_laz", "Dance Horse 3", AnimationOptions =
   {
       Prop = "ba_prop_battle_hobby_horse",
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
   }},
}

DP.AllMenu = {
  ["sport"] = {
    Label = "⚽ Sports",
  },
  ["gesture"] = {
    Label = "✌️ Gestes",
  },
  ["activity"] = {
    Label = "🔨 Activité",
  },
  ["position"] = {
    Label = "🧍 Position",
  },
  ["health"] = {
    Label = "🏥 Santé",
  },
  ["other"] = {
    Label = "❓ Autre",
  },
}

DP.Emotes = {
   ["drink"] = {"mp_player_inteat@pnq", "loop", "Boire", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 2500,
   }, Menu = "activity"},
   ["beast"] = {"anim@mp_fm_event@intro", "beast_transform", "Fou", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 5000,
   }, Menu = "other"},
   ["chill"] = {"switch@trevor@scares_tramp", "trev_scares_tramp_idle_tramp", "Allongé relax", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["cloudgaze"] = {"switch@trevor@annoys_sunbathers", "trev_annoys_sunbathers_loop_girl", "Allongé dos au sol", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["cloudgaze2"] = {"switch@trevor@annoys_sunbathers", "trev_annoys_sunbathers_loop_guy", "Allongé dos au sol détendu", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["prone"] = {"missfbi3_sniping", "prone_dave", "Torse au sol au téléphone", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["pullover"] = {"misscarsteal3pullover", "pull_over_right", "Hé toi !", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 1300,
   }, Menu = "gesture"},
   ["idle"] = {"anim@heists@heist_corona@team_idles@male_a", "idle", "Se regarder dans le mirroir", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["idle8"] = {"amb@world_human_hang_out_street@male_b@idle_a", "idle_b", "Se regarder dans le mirroir 8", Menu = "position"},
   ["idle9"] = {"friends@fra@ig_1", "base_idle", "Attendre en se regardant la main", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["idle10"] = {"mp_move@prostitute@m@french", "idle", "Se regarder dans le mirroir 10", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["idle11"] = {"random@countrysiderobbery", "idle_a", "Se regarder dans le mirroir 11", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["idle2"] = {"anim@heists@heist_corona@team_idles@female_a", "idle", "Se regarder dans le mirroir 2", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["idle3"] = {"anim@heists@humane_labs@finale@strip_club", "ped_b_celebrate_loop", "Se regarder dans le mirroir 3", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["idle4"] = {"anim@mp_celebration@idles@female", "celebration_idle_f_a", "Se regarder dans le mirroir 4", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["idle5"] = {"anim@mp_corona_idles@female_b@idle_a", "idle_a", "Se regarder dans le mirroir 5", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["idle6"] = {"anim@mp_corona_idles@male_c@idle_a", "idle_a", "Se regarder dans le mirroir 6", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["idle7"] = {"anim@mp_corona_idles@male_d@idle_a", "idle_a", "Se regarder dans le mirroir 7", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["wait3"] = {"amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", "Aguicheuse", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["idledrunk"] = {"random@drunk_driver_1", "drunk_driver_stand_loop_dd1", "Bourré sur place", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["idledrunk2"] = {"random@drunk_driver_1", "drunk_driver_stand_loop_dd2", "Bourré sur place 2", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["idledrunk3"] = {"missarmenian2", "standing_idle_loop_drunk", "Bourré sur place 3", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["airguitar"] = {"anim@mp_player_intcelebrationfemale@air_guitar", "air_guitar", "Guitare dans le vent", Menu = "activity"},
   ["airsynth"] = {"anim@mp_player_intcelebrationfemale@air_synth", "air_synth", "Piano dans le vent", Menu = "activity"},
   ["argue"] = {"misscarsteal4@actor", "actor_berating_loop", "Disputer", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["argue2"] = {"oddjobs@assassinate@vice@hooker", "argue_a", "Toi là ! Je vais t'éclater !", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["bartender"] = {"anim@amb@clubhouse@bar@drink@idle_a", "idle_a_bartender", "Les mains sur le comptoir", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["blowkiss"] = {"anim@mp_player_intcelebrationfemale@blow_kiss", "blow_kiss", "Plein de bisous", Menu = "other"},
   ["blowkiss2"] = {"anim@mp_player_intselfieblow_kiss", "exit", "Blow Kiss 2", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 2000

   }, Menu = "other"},
   ["curtsy"] = {"anim@mp_player_intcelebrationpaired@f_f_sarcastic", "sarcastic_left", "Danseuse étoile", Menu = "other"},
   ["bringiton"] = {"misscommon@response", "bring_it_on", "Bring It On", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 3000
   }, Menu = "other"},
   ["comeatmebro"] = {"mini@triathlon", "want_some_of_this", "C'est mon frère sa !", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 2000
   }, Menu = "gesture"},
   ["cop2"] = {"anim@amb@nightclub@peds@", "rcmme_amanda1_stand_loop_cop", "Flic bras croisé", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["cop3"] = {"amb@code_human_police_investigate@idle_a", "idle_b", "Flic appel radio", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["crossarms"] = {"amb@world_human_hang_out_street@female_arms_crossed@idle_a", "idle_a", "Croiser les bras", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["crossarms2"] = {"amb@world_human_hang_out_street@male_c@idle_a", "idle_b", "Croiser les bras en s'exprimant", AnimationOptions =
   {
       EmoteMoving = true,
   }, Menu = "position"},
   ["crossarms3"] = {"anim@heists@heist_corona@single_team", "single_team_loop_boss", "Croiser les bras d'un air sérieux", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["crossarms4"] = {"random@street_race", "_car_b_lookout", "Croiser les bras main visible", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["crossarms5"] = {"anim@amb@nightclub@peds@", "rcmme_amanda1_stand_loop_cop", "Croiser les bras énervé", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["foldarms2"] = {"anim@amb@nightclub@peds@", "rcmme_amanda1_stand_loop_cop", "Croiser les bras énervé 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["crossarms6"] = {"random@shop_gunstore", "_idle", "Croiser les bras pour danser russe", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["foldarms"] = {"anim@amb@business@bgen@bgen_no_work@", "stand_phone_phoneputdown_idle_nowork", "Croiser les bras en mode videur", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["crossarmsside"] = {"rcmnigel1a_band_groupies", "base_m2", "Croiser les bras avec tête sur le côté", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["damn"] = {"gestures@m@standing@casual", "gesture_damn", "Ah merde !", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 1000
   }, Menu = "gesture"},
   ["damn2"] = {"anim@am_hold_up@male", "shoplift_mid", "Put*** !", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 1000
   }, Menu = "gesture"},
   ["pointdown"] = {"gestures@f@standing@casual", "gesture_hand_down", "Tu reste ici", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 1000
   }, Menu = "gesture"},
   ["surrender"] = {"random@arrests@busted", "idle_a", "A genoux main sur la tête", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["facepalm2"] = {"anim@mp_player_intcelebrationfemale@face_palm", "face_palm", "Hein ? Pas possible..", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 8000
   }, Menu = "gesture"},
   ["facepalm"] = {"random@car_thief@agitated@idle_a", "agitated_idle_a", "Oh lala..", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 8000
   }, Menu = "gesture"},
   ["facepalm3"] = {"missminuteman_1ig_2", "tasered_2", "Quel malheur..", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 8000
   }, Menu = "gesture"},
   ["facepalm4"] = {"anim@mp_player_intupperface_palm", "idle_a", "Quel idiot..", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteLoop = true,
   }, Menu = "gesture"},
   ["fallover"] = {"random@drunk_driver_1", "drunk_fall_over", "Ivre à en tomber", Menu = "activity"},
   ["fallover2"] = {"mp_suicide", "pistol", "Se tirer une balle dans la tête", Menu = "activity"},
   ["fallover3"] = {"mp_suicide", "pill", "Prendre du poison", Menu = "activity"},
   ["fallover4"] = {"friends@frf@ig_2", "knockout_plyr", "Se prend une balle en pleine tête", Menu = "activity"},
   ["fallover5"] = {"anim@gangops@hostage@", "victim_fail", "Se prendre une droite", Menu = "activity"},
   ["fallasleep"] = {"mp_sleep", "sleep_loop", "Dormir debout", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteLoop = true,
   }, Menu = "position"},
   ["fightme"] = {"anim@deathmatch_intros@unarmed", "intro_male_unarmed_c", "Se mettre en position de combat", Menu = "sport"},
   ["fightme2"] = {"anim@deathmatch_intros@unarmed", "intro_male_unarmed_e", "S'étirer avant un combat", Menu = "sport"},
   ["finger"] = {"anim@mp_player_intselfiethe_bird", "idle_a", "Faire un fuck", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["finger2"] = {"anim@mp_player_intupperfinger", "idle_a_fp", "Faire un double fuck", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["handshake"] = {"mp_ped_interaction", "handshake_guy_a", "Tsheck moi sa", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 3000
   }, Menu = "gesture"},
   ["handshake2"] = {"mp_ped_interaction", "handshake_guy_b", "Tscheck mon pote !", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 3000
   }, Menu = "gesture"},
   ["wait4"] = {"amb@world_human_hang_out_street@Female_arm_side@idle_a", "idle_a", "Aguicheuse 2", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["wait5"] = {"missclothing", "idle_storeclerk", "Se tenir les mains", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["wait6"] = {"timetable@amanda@ig_2", "ig_2_base_amanda", "Mains sur les côtes", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["wait7"] = {"rcmnigel1cnmt_1c", "base", "Main seul sur une hanche", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["wait8"] = {"rcmjosh1", "idle", "Mains sur les hanches", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["wait9"] = {"rcmjosh2", "josh_2_intp1_base", "Tenir en demi câlin", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["wait10"] = {"timetable@amanda@ig_3", "ig_3_base_tracy", "Mains sur les hanches 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["wait11"] = {"misshair_shop@hair_dressers", "keeper_base", "Poignée sur les hanches", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["hiking"] = {"move_m@hiking", "idle", "Tenir son sac", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "activity"},
   ["hug"] = {"mp_ped_interaction", "kisses_guy_a", "Câlin", Menu = "gesture"},
   ["hug2"] = {"mp_ped_interaction", "kisses_guy_b", "Câlin 2", Menu = "gesture"},
   ["hug3"] = {"mp_ped_interaction", "hugs_guy_a", "Tsheck gangster", Menu = "position"},
   ["inspect"] = {"random@train_tracks", "idle_e", "Inspecter", Menu = "activity"},
   ["jazzhands"] = {"anim@mp_player_intcelebrationfemale@jazz_hands", "jazz_hands", "Clown", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 6000,
   }, Menu = "gesture"},
   ["jog2"] = {"amb@world_human_jog_standing@male@idle_a", "idle_a", "Faire son jogging", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "sport"},
   ["jog3"] = {"amb@world_human_jog_standing@female@idle_a", "idle_a", "Faire son jogging heureux", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "sport"},
   ["jog4"] = {"amb@world_human_power_walker@female@idle_a", "idle_a", "Faire son jogging bras tendu", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "sport"},
   ["jog5"] = {"move_m@joy@a", "walk", "Faire son jogging comme un robot", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "sport"},
   ["jumpingjacks"] = {"timetable@reunited@ig_2", "jimmy_getknocked", "Faire des sauts de sport", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "sport"},
   ["kneel2"] = {"rcmextreme3", "idle", "S'agenouiller", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["kneel3"] = {"amb@world_human_bum_wash@male@low@idle_a", "idle_a", "S'agenouiller avec bras sur le genou", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["knock"] = {"timetable@jimmy@doorknock@", "knockdoor_idle", "Toquer à une porte", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteLoop = true,
   }, Menu = "gesture"},
   ["knock2"] = {"missheistfbi3b_ig7", "lift_fibagent_loop", "Toquer fort à la porte", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "gesture"},
   ["knucklecrunch"] = {"anim@mp_player_intcelebrationfemale@knuckle_crunch", "knuckle_crunch", "Se craquer les doigts", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["lapdance"] = {"mp_safehouse", "lap_dance_girl", "Lapdance", Menu = "activity"},
   ["lean2"] = {"amb@world_human_leaning@female@wall@back@hand_up@idle_a", "idle_a", "Poser sur le mur en fumant", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["lean3"] = {"amb@world_human_leaning@female@wall@back@holding_elbow@idle_a", "idle_a", "Poser sur le mur détendu", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["lean4"] = {"amb@world_human_leaning@male@wall@back@foot_up@idle_a", "idle_a", "Poser sur le mur mains croisés", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["lean5"] = {"amb@world_human_leaning@male@wall@back@hands_together@idle_b", "idle_b", "ZLean 5", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["leanflirt"] = {"random@street_race", "_car_a_flirt_girl", "Tenir ses genoux", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["leanbar2"] = {"amb@prop_human_bum_shopping_cart@male@idle_a", "idle_c", "S'appuyer sur un bar", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["leanbar3"] = {"anim@amb@nightclub@lazlow@ig1_vip@", "clubvip_base_laz", "S'appuyer sur un bar 2", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["leanbar4"] = {"anim@heists@prison_heist", "ped_b_loop_a", "S'appuyer sur un bar 3", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["leanhigh"] = {"anim@mp_ferris_wheel", "idle_a_player_one", "Tendre les bras", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["leanhigh2"] = {"anim@mp_ferris_wheel", "idle_a_player_two", "Tendre les bras dos tordu", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["leanside"] = {"timetable@mime@01_gc", "idle_a", "S'accouder", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["leanside2"] = {"misscarstealfinale", "packer_idle_1_trevor", "Se tenir à un mur", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["leanside3"] = {"misscarstealfinalecar_5_ig_1", "waitloop_lamar", "S'accouder 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["leanside4"] = {"misscarstealfinalecar_5_ig_1", "waitloop_lamar", "S'accouder jambe croisée", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = false,
   }, Menu = "position"},
   ["leanside5"] = {"rcmjosh2", "josh_2_intp1_base", "S'aggriper à quelqu'un", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = false,
   }, Menu = "gesture"},
   ["me"] = {"gestures@f@standing@casual", "gesture_me_hard", "Moi ?", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 1000
   }, Menu = "gesture"},
   ["mechanic"] = {"mini@repair", "fixing_a_ped", "Réparer un moteur", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "activity"},
   ["mechanic2"] = {"amb@world_human_vehicle_mechanic@male@base", "base", "Sous le véhicule", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "activity"},
   ["mechanic3"] = {"anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", "Réparer l'avant du véhicule", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "activity"},
   ["mechanic4"] = {"anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", "Réparer un moteur 2", AnimationOptions =
   {

       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "activity"},
   ["medic2"] = {"amb@medic@standing@tendtodead@base", "base", "Médecin inspectant un blessé", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "health"},
   ["meditate"] = {"rcmcollect_paperleadinout@", "meditiate_idle", "Méditer", AnimationOptions = -- CHANGE ME
   {
       EmoteLoop = true,
   }, Menu = "activity"},
   ["meditate2"] = {"rcmepsilonism3", "ep_3_rcm_marnie_meditating", "Méditer 2", AnimationOptions = -- CHANGE ME
   {
       EmoteLoop = true,
   }, Menu = "activity"},
   ["meditate3"] = {"rcmepsilonism3", "base_loop", "Méditer 3", AnimationOptions = -- CHANGE ME
   {
       EmoteLoop = true,
   }, Menu = "activity"},
   ["metal"] = {"anim@mp_player_intincarrockstd@ps@", "idle_a", "Signe métal", AnimationOptions = -- CHANGE ME
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["no"] = {"anim@heists@ornate_bank@chat_manager", "fail", "Non pas du tout !", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["no2"] = {"mp_player_int_upper_nod", "mp_player_int_nod_no", "Non de la tête", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["nosepick"] = {"anim@mp_player_intcelebrationfemale@nose_pick", "nose_pick", "Se décrotter le nez", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["noway"] = {"gestures@m@standing@casual", "gesture_no_way", "Absolument pas", AnimationOptions =
   {
       EmoteDuration = 1500,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["ok"] = {"anim@mp_player_intselfiedock", "idle_a", "OK", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["outofbreath"] = {"re@construction", "out_of_breath", "Fatigué après une course", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "sport"},
   ["pickup"] = {"random@domestic", "pickup_low", "Ramasser", Menu = "gesture"},
   ["push"] = {"missfinale_c2ig_11", "pushcar_offcliff_f", "Pousser", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["push2"] = {"missfinale_c2ig_11", "pushcar_offcliff_m", "Pousser 2", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["point"] = {"gestures@f@standing@casual", "gesture_point", "Hé toi là !", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["pushup"] = {"amb@world_human_push_ups@male@idle_a", "idle_d", "Faire des pompes", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "sport"},
   ["countdown"] = {"random@street_race", "grid_girl_race_start", "Applaudissement", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["pointright"] = {"mp_gun_shop_tut", "indicate_right", "Pointe vers la droite", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["salute"] = {"anim@mp_player_intincarsalutestd@ds@", "idle_a", "Salut de l'armée", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["salute2"] = {"anim@mp_player_intincarsalutestd@ps@", "idle_a", "Salut de l'armée 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["salute3"] = {"anim@mp_player_intuppersalute", "idle_a", "Salut de l'armée 3", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["scared"] = {"random@domestic", "f_distressed_loop", "Avoir peur", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["scared2"] = {"random@homelandsecurity", "knees_loop_girl", "Avoir peur 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["screwyou"] = {"misscommon@response", "screw_you", "Bras d'honneur", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["shakeoff"] = {"move_m@_idles@shake_off", "shakeoff_1", "Enlever la poussière sur soi", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 3500,
   }, Menu = "gesture"},
   ["shot"] = {"random@dealgonewrong", "idle_a", "Blessé par balle au sol", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "health"},
   ["sleep"] = {"timetable@tracy@sleep@", "idle_c", "Dormir", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["shrug"] = {"gestures@f@standing@casual", "gesture_shrug_hard", "Hein ?", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 1000,
   }, Menu = "gesture"},
   ["shrug2"] = {"gestures@m@standing@casual", "gesture_shrug_hard", "Quoi ?", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 1000,
   }, Menu = "gesture"},
   ["sit"] = {"anim@amb@business@bgen@bgen_no_work@", "sit_phone_phoneputdown_idle_nowork", "Assis par terre", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["sit2"] = {"rcm_barry3", "barry_3_sit_loop", "Assis par terre 2", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["sit3"] = {"amb@world_human_picnic@male@idle_a", "idle_a", "Assis par terre 3", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["sit4"] = {"amb@world_human_picnic@female@idle_a", "idle_a", "Assis par terre 4", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["sit5"] = {"anim@heists@fleeca_bank@ig_7_jetski_owner", "owner_idle", "Assis par terre 5", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["sit6"] = {"timetable@jimmy@mics3_ig_15@", "idle_a_jimmy", "Assis par terre 6", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["sit7"] = {"anim@amb@nightclub@lazlow@lo_alone@", "lowalone_base_laz", "Assis par terre 7", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["sit8"] = {"timetable@jimmy@mics3_ig_15@", "mics3_15_base_jimmy", "Assis par terre 8", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["sit9"] = {"amb@world_human_stupor@male@idle_a", "idle_a", "Assis par terre 9", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["sitlean"] = {"timetable@tracy@ig_14@", "ig_14_base_tracy", "Assis sur un muret", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["sitsad"] = {"anim@amb@business@bgen@bgen_no_work@", "sit_phone_phoneputdown_sleeping-noworkfemale", "Assis par terre 10", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["sitscared"] = {"anim@heists@ornate_bank@hostages@hit", "hit_loop_ped_b", "Assis par terre apeuré", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["sitscared2"] = {"anim@heists@ornate_bank@hostages@ped_c@", "flinch_loop", "Assis par terre apeuré 2", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["sitscared3"] = {"anim@heists@ornate_bank@hostages@ped_e@", "flinch_loop", "Assis par terre apeuré 3", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["sitdrunk"] = {"timetable@amanda@drunk@base", "base", "Assis ivre", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["sitchair2"] = {"timetable@ron@ig_5_p3", "ig_5_p3_base", "Assis sur une chaise 2", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["sitchair3"] = {"timetable@reunited@ig_10", "base_amanda", "Assis sur une chaise 3", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["sitchair4"] = {"timetable@ron@ig_3_couch", "base", "Assis sur une chaise 4", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["sitchair5"] = {"timetable@jimmy@mics3_ig_15@", "mics3_15_base_tracy", "Assis sur une chaise 5", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["sitchair6"] = {"timetable@maid@couch@", "base", "Assis sur une chaise 6", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["sitchairside"] = {"timetable@ron@ron_ig_2_alt1", "ig_2_alt1_base", "Assis sur une chaise 7", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["situp"] = {"amb@world_human_sit_ups@male@idle_a", "idle_a", "Faire des abdos", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "sport"},
   ["clapangry"] = {"anim@arena@celeb@flat@solo@no_props@", "angry_clap_a_player_a", "Applaudir comme un débile", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "gesture"},
   ["slowclap3"] = {"anim@mp_player_intupperslow_clap", "idle_a", "Applaudir au ralentir", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["clap"] = {"amb@world_human_cheering@male_a", "base", "Applaudir joyeusement", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["slowclap"] = {"anim@mp_player_intcelebrationfemale@slow_clap", "slow_clap", "Applaudir doucement", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["slowclap2"] = {"anim@mp_player_intcelebrationmale@slow_clap", "slow_clap", "Applaudir doucement 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["smell"] = {"move_p_m_two_idles@generic", "fidget_sniff_fingers", "Sentir sa main", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["stickup"] = {"random@countryside_gang_fight", "biker_02_stickup_loop", "Pointer avec son arme", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "other"},
   ["stumble"] = {"misscarsteal4@actor", "stumble", "Gros mal de tête", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["stunned"] = {"stungun@standing", "damage", "Électrocuté", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["sunbathe"] = {"amb@world_human_sunbathe@male@back@base", "base", "Allongé au soleil", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["sunbathe2"] = {"amb@world_human_sunbathe@female@back@base", "base", "Allongé au soleil 2", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["t"] = {"missfam5_yoga", "a2_pose", "T", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["t2"] = {"mp_sleep", "bind_pose_180", "T 2", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["think5"] = {"mp_cp_welcome_tutthink", "b_think", "Se gratter la tête", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 2000,
   }, Menu = "gesture"},
   ["think"] = {"misscarsteal4@aliens", "rehearsal_base_idle_director", "Hm..", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["think3"] = {"timetable@tracy@ig_8@base", "base", "Se gratter l'oeil", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},

   ["think2"] = {"missheist_jewelleadinout", "jh_int_outro_loop_a", "Se tenir le menton", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["thumbsup3"] = {"anim@mp_player_intincarthumbs_uplow@ds@", "enter", "Pouce en l'air", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 3000,
   }, Menu = "gesture"},
   ["thumbsup2"] = {"anim@mp_player_intselfiethumbs_up", "idle_a", "Pouce en l'air en souriant", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["thumbsup"] = {"anim@mp_player_intupperthumbs_up", "idle_a", "Double pouce en l'air", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["type"] = {"anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", "Tapé sur un clavier", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "activity"},
   ["type2"] = {"anim@heists@prison_heistig1_p1_guard_checks_bus", "loop", "Tapé sur un clavier 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "activity"},
   ["type3"] = {"mp_prison_break", "hack_loop", "Tapé sur un clavier 3", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "activity"},
   ["type4"] = {"mp_fbi_heist", "loop", "Tapé sur un clavier 4", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "activity"},
   ["warmth"] = {"amb@world_human_stand_fire@male@idle_a", "idle_a", "Se chauffer les mains autour du feu", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "activity"},
   ["wave4"] = {"random@mugging5", "001445_01_gangintimidation_1_female_idle_b", "Agiter les bras en l'air", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 3000,
   }, Menu = "activity"},
   ["wave2"] = {"anim@mp_player_intcelebrationfemale@wave", "wave", "Salut de reine", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["wave3"] = {"friends@fra@ig_1", "over_here_idle_a", "Lever un bras comme une star", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["wave"] = {"friends@frj@ig_1", "wave_a", "Coucou !", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["wave5"] = {"friends@frj@ig_1", "wave_b", "Hé c'est moi !", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["wave6"] = {"friends@frj@ig_1", "wave_c", "Je suis là", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["wave7"] = {"friends@frj@ig_1", "wave_d", "Hé oh", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["wave8"] = {"friends@frj@ig_1", "wave_e", "Salut !", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["wave9"] = {"gestures@m@standing@casual", "gesture_hello", "Hey !", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["whistle"] = {"taxi_hail", "hail_taxi", "Sifflé", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 1300,
   }, Menu = "gesture"},
   ["whistle2"] = {"rcmnigel1c", "hailing_whistle_waive_a", "Sifflé 2", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 2000,
   }, Menu = "gesture"},
   ["yeah"] = {"anim@mp_player_intupperair_shagging", "idle_a", "Yeah", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["lift"] = {"random@hitch_lift", "idle_f", "Faire du stop", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["lol"] = {"anim@arena@celeb@flat@paired@no_props@", "laugh_a_player_b", "Mort de rire", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["lol2"] = {"anim@arena@celeb@flat@solo@no_props@", "giggle_a_player_b", "Mort de rire 2", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["statue2"] = {"fra_0_int-1", "cs_lamardavis_dual-1", "Statue 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["statue3"] = {"club_intro2-0", "csb_englishdave_dual-0", "Statue 3", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "position"},
   ["gangsign"] = {"mp_player_int_uppergang_sign_a", "mp_player_int_gang_sign_a", "Signe Mara", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["gangsign2"] = {"mp_player_int_uppergang_sign_b", "mp_player_int_gang_sign_b", "Signe Ballas", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["gangsign3"] = {"amb@code_human_in_car_mp_actions@gang_sign_b@low@ps@base", "idle_a", "Signe F4L", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
       EmoteDuration = 3000,
   }, Menu = "gesture"},


   ["gangsign4"] = {"amb@code_human_in_car_mp_actions@v_sign@std@rds@base", "idle_a", "Signe Vagos", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
       EmoteDuration = 3000,
   }, Menu = "gesture"},

   ["gangsign5"] = {"mp_player_int_upperv_sign", "mp_player_int_v_sign", "Signe Vagos 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},

   ["passout"] = {"missarmenian2", "drunk_loop", "Perdre connaissance", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "health"},
   ["passout2"] = {"missarmenian2", "corpse_search_exit_ped", "Perdre connaissance 2", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "health"},
   ["passout3"] = {"anim@gangops@morgue@table@", "body_search", "Perdre connaissance 3", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "health"},
   ["passout4"] = {"mini@cpr@char_b@cpr_def", "cpr_pumpchest_idle", "Perdre connaissance 4", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "health"},
   ["passout5"] = {"random@mugging4", "flee_backward_loop_shopkeeper", "Perdre connaissance 5", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "health"},
   ["petting"] = {"creatures@rottweiler@tricks@", "petting_franklin", "Jardinage", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "activity"},
   ["crawl"] = {"move_injured_ground", "front_loop", "Ramper au sol blessé", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "health"},
   ["flip2"] = {"anim@arena@celeb@flat@solo@no_props@", "cap_a_player_a", "Demi salto", Menu = "sport"},
   ["flip"] = {"anim@arena@celeb@flat@solo@no_props@", "flip_a_player_a", "Salto", Menu = "sport"},
   ["slide"] = {"anim@arena@celeb@flat@solo@no_props@", "slide_a_player_a", "Glissade sur les genoux", Menu = "sport"},
   ["slide2"] = {"anim@arena@celeb@flat@solo@no_props@", "slide_b_player_a", "Glissade sur les genoux 2", Menu = "sport"},
   ["slide3"] = {"anim@arena@celeb@flat@solo@no_props@", "slide_c_player_a", "Glissade sur les genoux 3", Menu = "sport"},
   ["slugger"] = {"anim@arena@celeb@flat@solo@no_props@", "slugger_a_player_a", "Tir à la batte", Menu = "sport"},
   ["flipoff"] = {"anim@arena@celeb@podium@no_prop@", "flip_off_a_1st", "Faire un fuck à l'horizon", AnimationOptions =
   {
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["flipoff2"] = {"anim@arena@celeb@podium@no_prop@", "flip_off_c_1st", "Faire un double fuck à l'horizon", AnimationOptions =
   {
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["bow"] = {"anim@arena@celeb@podium@no_prop@", "regal_c_1st", "Merci de fin de spectacle", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "activity"},
   ["bow2"] = {"anim@arena@celeb@podium@no_prop@", "regal_a_1st", "Merci de fin de spectacle 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "activity"},
   ["keyfob"] = {"anim@mp_player_intmenu@key_fob@", "fob_click", "Utiliser une clée", AnimationOptions =
   {
       EmoteLoop = false,
       EmoteMoving = true,
       EmoteDuration = 1000,
   }, Menu = "gesture"},
   ["golfswing"] = {"rcmnigel1d", "swing_a_mark", "Jouer au golf", Menu = "sport"},
   ["eat"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Manger", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 3000,
   }, Menu = "gesture"},
   ["reaching"] = {"move_m@intimidation@cop@unarmed", "idle", "Main sur le holster", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["wait"] = {"random@shop_tattoo", "_idle_a", "Attendre", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["wait2"] = {"missbigscore2aig_3", "wait_for_van_c", "Attendre en se tenant les mains", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["wait12"] = {"rcmjosh1", "idle", "Main sur les hanches déterminer", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["wait13"] = {"rcmnigel1a", "base", "Attendre en se tenant le poignet", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "position"},
   ["lapdance2"] = {"mini@strip_club@private_dance@idle", "priv_dance_idle", "Dance privée", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["lapdance3"] = {"mini@strip_club@private_dance@part2", "priv_dance_p2", "Dance privée 2", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["lapdance3"] = {"mini@strip_club@private_dance@part3", "priv_dance_p3", "Dance privée 2", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["twerk"] = {"switch@trevor@mocks_lapdance", "001443_01_trvs_28_idle_stripper", "Twerk", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["slap"] = {"melee@unarmed@streamed_variations", "plyr_takedown_front_slap", "Giflé", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
       EmoteDuration = 2000,
   }, Menu = "gesture"},
   ["headbutt"] = {"melee@unarmed@streamed_variations", "plyr_takedown_front_headbutt", "Coup de boule", Menu = "gesture"},
   ["fishdance"] = {"anim@mp_player_intupperfind_the_fish", "idle_a", "Dance du poisson", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "other"},
   ["peace"] = {"mp_player_int_upperpeace_sign", "mp_player_int_peace_sign", "Peace and love", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["peace2"] = {"anim@mp_player_intupperpeace", "idle_a", "Peace and love 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["cpr"] = {"mini@cpr@char_a@cpr_str", "cpr_pumpchest", "Massage cardiaque au sol", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "health"},
   ["cpr2"] = {"mini@cpr@char_a@cpr_str", "cpr_pumpchest", "Massage cardiaque sur une table", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "health"},
   ["ledge"] = {"missfbi1", "ledge_loop", "Superman", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["airplane"] = {"missfbi1", "ledge_loop", "Se prendre pour un avion", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "other"},
   ["peek"] = {"random@paparazzi@peek", "left_peek_a", "Pousser sur le côté", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["cough"] = {"timetable@gardener@smoking_joint", "idle_cough", "Tousser", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["stretch"] = {"mini@triathlon", "idle_e", "S'échauffer en s'étirant", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "sport"},
   ["stretch2"] = {"mini@triathlon", "idle_f", "S'échauffer en s'étirant 2", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "sport"},
   ["stretch3"] = {"mini@triathlon", "idle_d", "S'échauffer en s'étirant 3", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "sport"},
   ["stretch4"] = {"rcmfanatic1maryann_stretchidle_b", "idle_e", "S'échauffer en s'étirant 4", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "sport"},
   ["celebrate"] = {"rcmfanatic1celebrate", "celebrate", "Célébrer", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["punching"] = {"rcmextreme2", "loop_punching", "Tapé dans le ventre", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "sport"},
   ["superhero"] = {"rcmbarry", "base", "Super héro", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["superhero2"] = {"rcmbarry", "base", "Super héro 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "other"},
   ["mindcontrol"] = {"rcmbarry", "mind_control_b_loop", "Contrôle de la pensée", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["mindcontrol2"] = {"rcmbarry", "bar_1_attack_idle_aln", "Contrôle de la pensée 2", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["clown2"] = {"rcm_barry2", "clown_idle_0", "Clown 2", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["clown3"] = {"rcm_barry2", "clown_idle_1", "Clown 3", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["clown4"] = {"rcm_barry2", "clown_idle_2", "Clown 4", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["clown5"] = {"rcm_barry2", "clown_idle_3", "Clown 5", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "other"},
   ["clown6"] = {"rcm_barry2", "clown_idle_6", "Clown 6", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["tryclothes"] = {"mp_clothing@female@trousers", "try_trousers_neutral_a", "Se regarder dans le miroir", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["tryclothes2"] = {"mp_clothing@female@shirt", "try_shirt_positive_a", "Se regarder dans le miroirs 2", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["tryclothes3"] = {"mp_clothing@female@shoes", "try_shoes_positive_a", "Se regarder dans le miroir 3", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["nervous2"] = {"mp_missheist_countrybank@nervous", "nervous_idle", "Méfiant 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "other"},
   ["nervous"] = {"amb@world_human_bum_standing@twitchy@idle_a", "idle_c", "Méfiant", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "other"},
   ["nervous3"] = {"rcmme_tracey1", "nervous_loop", "Méfiant 3", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "other"},
   ["uncuff"] = {"mp_arresting", "a_uncuff", "Se gratter la main", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "other"},
   ["namaste"] = {"timetable@amanda@ig_4", "ig_4_base", "Namaste", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "other"},
   ["dj"] = {"anim@amb@nightclub@djs@dixon@", "dixn_dance_cntr_open_dix", "DJ", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "other"},
   ["threaten"] = {"random@atmrobberygen", "b_atm_mugging", "Pointé une arme comme un gangster", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "other"},
   ["radio"] = {"random@arrests", "generic_radio_chatter", "Radio", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "other"},
   ["pull"] = {"random@mugging4", "struggle_loop_b_thief", "Tiré le maillot de quelqu'un", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "other"},
   ["bird"] = {"random@peyote@bird", "wakeup", "Faire l'oiseau", Menu = "other"},
   ["chicken"] = {"random@peyote@chicken", "wakeup", "Faire la poule", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "other"},
   ["bark"] = {"random@peyote@dog", "wakeup", "Faire le chien par terre", Menu = "other"},
   ["rabbit"] = {"random@peyote@rabbit", "wakeup", "Faire le lapin", Menu = "other"},
   ["spiderman"] = {"missexile3", "ex03_train_roof_idle", "Spiderman", AnimationOptions =
   {
       EmoteLoop = true,
   }, Menu = "other"},
   ["boi"] = {"special_ped@jane@monologue_5@monologue_5c", "brotheradrianhasshown_2", "Toi je vais te gifler", AnimationOptions =
   {
      EmoteMoving = true,
      EmoteDuration = 3000,
   }, Menu = "gesture"},
   ["adjust"] = {"missmic4", "michael_tux_fidget", "Ajustez sa chemise", AnimationOptions =
   {
      EmoteMoving = true,
      EmoteDuration = 4000,
   }, Menu = "gesture"},
   ["handsup"] = {"missminuteman_1ig_2", "handsup_base", "Lever les mains en l'air", AnimationOptions =
   {
      EmoteMoving = true,
      EmoteLoop = true,
   }, Menu = "gesture"},
   ["pee"] = {"misscarsteal2peeing", "peeing_loop", "Faire pipi", AnimationOptions =
   {
       EmoteStuck = true,
       PtfxAsset = "scr_amb_chop",
       PtfxName = "ent_anim_dog_peeing",
       PtfxNoProp = true,
       PtfxPlacement = {-0.05, 0.3, 0.0, 0.0, 90.0, 90.0, 1.0},
       PtfxInfo = Config.Languages[Config.MenuLanguage]['pee'],
       PtfxWait = 3000,
   }, Menu = "other"},

-----------------------------------------------------------------------------------------------------------
------ These are Scenarios, some of these dont work on women and some other issues, but still good to have.
-----------------------------------------------------------------------------------------------------------

   ["atm"] = {"Scenario", "PROP_HUMAN_ATM", "ATM", Menu = "activity"},
   ["bbq"] = {"MaleScenario", "PROP_HUMAN_BBQ", "BBQ", Menu = "activity"},
   ["bumbin"] = {"Scenario", "PROP_HUMAN_BUM_BIN", "Fouiller une poubelle", Menu = "activity"},
   ["bumsleep"] = {"Scenario", "WORLD_HUMAN_BUM_SLUMPED", "Grosse sieste", Menu = "position"},
   ["cheer"] = {"Scenario", "WORLD_HUMAN_CHEERING", "Félicitation", Menu = "activity"},
   ["chinup"] = {"Scenario", "PROP_HUMAN_MUSCLE_CHIN_UPS", "Faire des tractions", Menu = "sport"},
   ["clipboard2"] = {"MaleScenario", "WORLD_HUMAN_CLIPBOARD", "Vérifier la liste", Menu = "position"},
   ["cop"] = {"Scenario", "WORLD_HUMAN_COP_IDLES", "Les mains sur la ceinture", Menu = "position"},
   ["copbeacon"] = {"MaleScenario", "WORLD_HUMAN_CAR_PARK_ATTENDANT", "Donnez des ordres d'attérissage", Menu = "activity"},
   ["filmshocking"] = {"Scenario", "WORLD_HUMAN_MOBILE_FILM_SHOCKING", "Filmer avec son téléphone", Menu = "activity"},
   ["flex"] = {"Scenario", "WORLD_HUMAN_MUSCLE_FLEX", "Montrer ses muscles", Menu = "gesture"},
   ["guard"] = {"Scenario", "WORLD_HUMAN_GUARD_STAND", "Pose de videur", Menu = "position"},
   ["hammer"] = {"Scenario", "WORLD_HUMAN_HAMMERING", "Taper au marteau", Menu = "activity"},
   ["hangout"] = {"Scenario", "WORLD_HUMAN_HANG_OUT_STREET", "Attendre un client", Menu = "position"},
   ["impatient"] = {"Scenario", "WORLD_HUMAN_STAND_IMPATIENT", "Impatient", Menu = "activity"},
   ["janitor"] = {"Scenario", "WORLD_HUMAN_JANITOR", "Tenir un balai", Menu = "activity"},
   ["jog"] = {"Scenario", "WORLD_HUMAN_JOG_STANDING", "S'échauffer pour son jogging", Menu = "sport"},
   ["kneel"] = {"Scenario", "CODE_HUMAN_MEDIC_KNEEL", "Jetez un coup d'oeil", Menu = "activity"},
   ["leafblower"] = {"MaleScenario", "WORLD_HUMAN_GARDENER_LEAF_BLOWER", "Souffler des feuilles", Menu = "activity"},
   ["lean"] = {"Scenario", "WORLD_HUMAN_LEANING", "Attendre posé contre un mur", Menu = "position"},
   ["leanbar"] = {"Scenario", "PROP_HUMAN_BUM_SHOPPING_CART", "Attendre posé sur un bar", Menu = "position"},
   ["lookout"] = {"Scenario", "CODE_HUMAN_CROSS_ROAD_WAIT", "Attention", Menu = "activity"},
   ["maid"] = {"Scenario", "WORLD_HUMAN_MAID_CLEAN", "Essuyer une vitre", Menu = "activity"},
   ["medic"] = {"Scenario", "CODE_HUMAN_MEDIC_TEND_TO_DEAD", "Médecin inspéctant une personne", Menu = "health"},
   ["musician"] = {"MaleScenario", "WORLD_HUMAN_MUSICIAN", "Jouer un instrument musical", Menu = "activity"},
   ["notepad2"] = {"Scenario", "CODE_HUMAN_MEDIC_TIME_OF_DEATH", "Sortir son notepad", Menu = "activity"},
   ["parkingmeter"] = {"Scenario", "PROP_HUMAN_PARKING_METER", "Payer au à la borne parking", Menu = "activity"},
   ["party"] = {"Scenario", "WORLD_HUMAN_PARTYING", "Boire une bière en dansant", Menu = "activity"},
   ["texting"] = {"Scenario", "WORLD_HUMAN_STAND_MOBILE", "Envoyer un message", Menu = "activity"},
   ["prosthigh"] = {"Scenario", "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS", "Prostitué classe", Menu = "activity"},
   ["prostlow"] = {"Scenario", "WORLD_HUMAN_PROSTITUTE_LOW_CLASS", "Prostitué bas de gamme", Menu = "activity"},
   ["puddle"] = {"Scenario", "WORLD_HUMAN_BUM_WASH", "Se nettoyer avec de l'eau", Menu = "activity"},
   ["record"] = {"Scenario", "WORLD_HUMAN_MOBILE_FILM_SHOCKING", "Filmer une scène", Menu = "activity"},
   -- Sitchair is a litte special, since you want the player to be seated correctly.
   -- So we set it as "ScenarioObject" and do TaskStartScenarioAtPosition() instead of "AtPlace"
   ["sitchair"] = {"ScenarioObject", "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", "Assis sur une chaise", Menu = "position"},
   ["sitchairt1"] = {"ScenarioObject", "PROP_HUMAN_SEAT_ARMCHAIR", "Assis à un bar", Menu = "other"},
   ["sitchairt2"] = {"ScenarioObject", "PROP_HUMAN_SEAT_BAR", "Assis 1", Menu = "other"},
   ["sitchairt3"] = {"ScenarioObject", "PROP_HUMAN_SEAT_BENCH", "Assis 2", Menu = "other"},
   ["sitchairt4"] = {"ScenarioObject", "PROP_HUMAN_SEAT_BENCH_FACILITY", "Assis 3", Menu = "other"},
   ["sitchairt5"] = {"ScenarioObject", "PROP_HUMAN_SEAT_BENCH_DRINK", "Assis 4", Menu = "other"},
   ["sitchairt6"] = {"ScenarioObject", "PROP_HUMAN_SEAT_BENCH_DRINK_FACILITY", "Assis 5", Menu = "other"},
   ["sitchairt7"] = {"ScenarioObject", "PROP_HUMAN_SEAT_BENCH_DRINK_BEER", "Assis 6", Menu = "other"},
   ["sitchairt8"] = {"ScenarioObject", "PROP_HUMAN_SEAT_BENCH_FOOD", "Assis 7", Menu = "other"},
   ["sitchairt9"] = {"ScenarioObject", "PROP_HUMAN_SEAT_BENCH_FOOD_FACILITY", "Assis 8", Menu = "position"},
   ["sitchairt10"] = {"ScenarioObject", "PROP_HUMAN_SEAT_BUS_STOP_WAIT", "Assis 9", Menu = "other"},
   ["sitchairt11"] = {"ScenarioObject", "PROP_HUMAN_SEAT_CHAIR_DRINK", "Assis 10", Menu = "other"},
   ["sitchairt13"] = {"ScenarioObject", "PROP_HUMAN_SEAT_CHAIR_DRINK_BEER", "Assis 11", Menu = "other"},
   ["sitchairt14"] = {"ScenarioObject", "PROP_HUMAN_SEAT_CHAIR_FOOD", "Assis 12", Menu = "other"},
   ["sitchairt15"] = {"ScenarioObject", "PROP_HUMAN_SEAT_CHAIR_UPRIGHT", "Assis 13", Menu = "other"},
   ["sitchairt16"] = {"ScenarioObject", "PROP_HUMAN_SEAT_COMPUTER", "Assis 14", Menu = "other"},
   ["sitchairt17"] = {"ScenarioObject", "PROP_HUMAN_SEAT_COMPUTER_LOW", "Assis 15", Menu = "other"},
   ["sitchairt18"] = {"ScenarioObject", "PROP_HUMAN_SEAT_DECKCHAIR", "Assis 16", Menu = "other"},
   ["sitchairt19"] = {"ScenarioObject", "PROP_HUMAN_SEAT_DECKCHAIR_DRINK", "Assis 17", Menu = "other"},
   ["sitchairt22"] = {"ScenarioObject", "PROP_HUMAN_SEAT_SEWING", "Assis 18", Menu = "other"},
   ["sitchairt23"] = {"ScenarioObject", "PROP_HUMAN_SEAT_STRIP_WATCH", "Assis 19", Menu = "other"},
   ["sitchairt24"] = {"ScenarioObject", "PROP_HUMAN_SEAT_SUNLOUNGER", "Assis 20", Menu = "other"},
   ["smoke"] = {"Scenario", "WORLD_HUMAN_SMOKING", "Fumer une cigarette", Menu = "activity"},
   ["smokeweed"] = {"MaleScenario", "WORLD_HUMAN_DRUG_DEALER", "Fumer de la weed", Menu = "activity"},
   ["statue"] = {"Scenario", "WORLD_HUMAN_HUMAN_STATUE", "Statue", Menu = "position"},
   ["sunbathe3"] = {"Scenario", "WORLD_HUMAN_SUNBATHE", "Allonger au soleil 3", Menu = "position"},
   ["sunbatheback"] = {"Scenario", "WORLD_HUMAN_SUNBATHE_BACK", "Allonger au soleil 4", Menu = "position"},
   ["weld"] = {"Scenario", "WORLD_HUMAN_WELDING", "Outil de soudure", Menu = "activity"},
   ["windowshop"] = {"Scenario", "WORLD_HUMAN_WINDOW_SHOP_BROWSE", "Regarder un article à la vitrine", Menu = "other"},
   ["yoga"] = {"Scenario", "WORLD_HUMAN_YOGA", "Yoga", Menu = "sport"},
   -- CASINO DLC EMOTES (STREAMED)
   ["karate"] = {"anim@mp_player_intcelebrationfemale@karate_chops", "karate_chops", "Karate", Menu = "sport"},
   ["karate2"] = {"anim@mp_player_intcelebrationmale@karate_chops", "karate_chops", "Karate 2", Menu = "sport"},
   ["cutthroat"] = {"anim@mp_player_intcelebrationmale@cut_throat", "cut_throat", "Toi là ! Je vais te crever !", Menu = "gesture"},
   ["cutthroat2"] = {"anim@mp_player_intcelebrationfemale@cut_throat", "cut_throat", "Je vais te trancher la gorge", Menu = "gesture"},
   ["mindblown"] = {"anim@mp_player_intcelebrationmale@mind_blown", "mind_blown", "Ravi de toi voir !", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 4000
   }, Menu = "gesture"},
   ["mindblown2"] = {"anim@mp_player_intcelebrationfemale@mind_blown", "mind_blown", "Damn", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 4000
   }, Menu = "gesture"},
   ["boxing"] = {"anim@mp_player_intcelebrationmale@shadow_boxing", "shadow_boxing", "Entraînement de boxe", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 4000
   }, Menu = "sport"},
   ["boxing2"] = {"anim@mp_player_intcelebrationfemale@shadow_boxing", "shadow_boxing", "Entraînement de boxe 2", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 4000
   }, Menu = "sport"},
   ["stink"] = {"anim@mp_player_intcelebrationfemale@stinker", "stinker", "Sa pue", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteLoop = true
   }, Menu = "gesture"},
   ["think4"] = {"anim@amb@casino@hangout@ped_male@stand@02b@idles", "idle_a", "Croiser les bras en ce tenant le menton", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "gesture"},
   ["adjusttie"] = {"clothingtie", "try_tie_positive_a", "Se ré-habillez correctement", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 5000
   }, Menu = "other"},
}

DP.PropEmotes = {
   ["pallet1"] = {"anim@mp_ferris_wheel", "idle_a_player_two", "Charriot 1", AnimationOptions =
   {
       Prop = "prop_pallettruck_01",
       PropBone = -1,
       PropPlacement = {0.0, 1.6, -1.15, 0.0, 0.0, 180.0},
       WeightCapacitor = 'pallet',
       --
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["pallet2"] = {"anim@mp_ferris_wheel", "idle_a_player_two", "Charriot 2", AnimationOptions =
   {
       Prop = "prop_pallettruck_02",
       PropBone = -1,
       PropPlacement = {0.0, 1.6, -1.15, 0.0, 0.0, 180.0},
       WeightCapacitor = 'pallet',
       --
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["pallet3"] = {"anim@mp_ferris_wheel", "idle_a_player_one", "Charriot 3", AnimationOptions =
   {
       Prop = "prop_sacktruck_02b",
       PropBone = -1,
       PropPlacement = {0.0, 1.45, -0.8, -30.0, 0.0, 180.0},
       WeightCapacitor = 'pallet',
       --
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["pallet4"] = {"anim@mp_ferris_wheel", "idle_a_player_two", "Charriot 4", AnimationOptions =
   {
       Prop = "prop_flattruck_01c",
       PropBone = -1,
       PropPlacement = {0.0, 1.3, -0.97, 0.0, 0.0, 180.0},
       WeightCapacitor = 'pallet',
       --
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["pallet5"] = {"anim@mp_ferris_wheel", "idle_a_player_two", "Charriot 5", AnimationOptions =
   {
       Prop = "prop_flattruck_01d",
       PropBone = -1,
       PropPlacement = {0.0, 1.3, -0.97, 0.0, 0.0, 180.0},
       WeightCapacitor = 'pallet',
       --
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["pallet6"] = {"anim@mp_ferris_wheel", "idle_a_player_two", "Charriot 6", AnimationOptions =
   {
       Prop = "prop_flattruck_01a",
       PropBone = -1,
       PropPlacement = {0.0, 1.3, -0.97, 0.0, 0.0, 180.0},
       WeightCapacitor = 'pallet',
       --
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["pallet7"] = {"anim@mp_ferris_wheel", "idle_a_player_two", "Charriot 7", AnimationOptions =
   {
       Prop = "prop_rub_trolley01a",
       PropBone = -1,
       PropPlacement = {0.0, 1.1, -0.4, 0.0, 0.0, 180.0},
       WeightCapacitor = 'pallet',
       --
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["palletc1"] = {"anim@mp_ferris_wheel", "idle_a_player_two", "Charriot avec poids 1", AnimationOptions =
   {
       Prop = "prop_pallettruck_01",
       PropBone = -1,
       PropPlacement = {0.0, 1.6, -1.15, 0.0, 0.0, 180.0},
       WeightCapacitor = 'pallet',
       --
       SecondProp = 'ex_prop_crate_closed_bc',
       SecondPropBone = -1,
       SecondPropPlacement = {0.0, 2.0, -1.0, 0.0, 0.0, 180.0},
       --
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["palletc2"] = {"anim@mp_ferris_wheel", "idle_a_player_two", "Charriot avec poids 2", AnimationOptions =
   {
       Prop = "prop_pallettruck_01",
       PropBone = -1,
       PropPlacement = {0.0, 1.6, -1.15, 0.0, 0.0, 180.0},
       WeightCapacitor = 'pallet',
       --
       SecondProp = 'ex_prop_crate_jewels_racks_sc',
       SecondPropBone = -1,
       SecondPropPlacement = {0.0, 2.0, -1.0, 0.0, 0.0, 180.0},
       --
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["palletc3"] = {"anim@mp_ferris_wheel", "idle_a_player_two", "Charriot avec poids 3", AnimationOptions =
   {
       Prop = "prop_pallettruck_01",
       PropBone = -1,
       PropPlacement = {0.0, 1.6, -1.15, 0.0, 0.0, 180.0},
       WeightCapacitor = 'pallet',
       --
       SecondProp = 'ex_prop_crate_money_sc',
       SecondPropBone = -1,
       SecondPropPlacement = {0.0, 2.0, -1.0, 0.0, 0.0, 180.0},
       --
       EmoteLoop = true,
       EmoteMoving = true,
   }},

-- OTHER

   ["umbrella"] = {"amb@world_human_drinking@coffee@male@base", "base", "Parapluie", AnimationOptions =
   {
       Prop = "p_amb_brolly_01",
       PropBone = 57005,
       PropPlacement = {0.15, 0.005, 0.0, 87.0, -20.0, 180.0},
       --
       EmoteLoop = true,
       EmoteMoving = true,
   }},

-----------------------------------------------------------------------------------------------------
------ This is an example of an emote with 2 props, pretty simple! ----------------------------------
-----------------------------------------------------------------------------------------------------

   ["notepad"] = {"missheistdockssetup1clipboard@base", "base", "Bloc Note écrit", AnimationOptions =
   {
       Prop = 'prop_notepad_01',
       PropBone = 18905,
       PropPlacement = {0.1, 0.02, 0.05, 10.0, 0.0, 0.0},
       SecondProp = 'prop_pencil_01',
       SecondPropBone = 58866,
       SecondPropPlacement = {0.11, -0.02, 0.001, -120.0, 0.0, 0.0},
       -- EmoteLoop is used for emotes that should loop, its as simple as that.
       -- Then EmoteMoving is used for emotes that should only play on the upperbody.
       -- The code then checks both values and sets the MovementType to the correct one
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["box"] = {"anim@heists@box_carry@", "idle", "Boîte", AnimationOptions =
   {
       Prop = "hei_prop_heist_box",
       PropBone = 60309,
       PropPlacement = {0.025, 0.08, 0.255, -145.0, 290.0, 0.0},
       WeightCapacitor = 'box',
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["rose"] = {"anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Rose", AnimationOptions =
   {
       Prop = "prop_single_rose",
       PropBone = 18905,
       PropPlacement = {0.13, 0.15, 0.0, -100.0, 0.0, -20.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["smoke2"] = {"amb@world_human_aa_smoke@male@idle_a", "idle_c", "Fumer une clope", AnimationOptions =
   {
       Prop = 'prop_cs_ciggy_01',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "smoke"},
   ["smoke3"] = {"amb@world_human_aa_smoke@male@idle_a", "idle_b", "Fumer une clope relax", AnimationOptions =
   {
       Prop = 'prop_cs_ciggy_01',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "smoke"},
   ["smoke4"] = {"amb@world_human_smoking@female@idle_a", "idle_b", "Fumer une clope femme", AnimationOptions =
   {
       Prop = 'prop_cs_ciggy_01',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }, Menu = "smoke"},
   ["bong"] = {"anim@safehouse@bong", "bong_stage3", "Bang", AnimationOptions =
   {
       Prop = 'hei_heist_sh_bong_01',
       PropBone = 18905,
       PropPlacement = {0.10,-0.25,0.0,95.0,190.0,180.0},
   }},
   ["suitcase"] = {"missheistdocksprep1hold_cellphone", "static", "Valise", AnimationOptions =
   {
       Prop = "prop_ld_suitcase_01",
       PropBone = 57005,
       PropPlacement = {0.39, 0.0, 0.0, 0.0, 266.0, 60.0},
       WeightCapacitor = 'box',
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["suitcase2"] = {"missheistdocksprep1hold_cellphone", "static", "Malette", AnimationOptions =
   {
       Prop = "prop_security_case_01",
       PropBone = 57005,
       PropPlacement = {0.10, 0.0, 0.0, 0.0, 280.0, 53.0},
       WeightCapacitor = 'box',
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["mugshot"] = {"mp_character_creation@customise@male_a", "loop", "Montrer une tablette", AnimationOptions =
   {
       Prop = 'prop_police_id_board',
       PropBone = 58868,
       PropPlacement = {0.12, 0.24, 0.0, 5.0, 0.0, 70.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["coffee"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Café", AnimationOptions =
   {
       Prop = 'p_amb_coffeecup_01',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["whiskey"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Whiskey", AnimationOptions =
   {
       Prop = 'prop_drink_whisky',
       PropBone = 28422,
       PropPlacement = {0.01, -0.01, -0.06, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["beer"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Bière", AnimationOptions =
   {
       Prop = 'prop_amb_beer_bottle',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["cup"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Verre", AnimationOptions =
   {
       Prop = 'prop_plastic_cup_02',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["donut"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Donut", AnimationOptions =
   {
       Prop = 'prop_amb_donut',
       PropBone = 18905,
       PropPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0},
       EmoteMoving = true,
   }},
   ["burger"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Burger", AnimationOptions =
   {
       Prop = 'prop_cs_burger_01',
       PropBone = 18905,
       PropPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0},
       EmoteMoving = true,
   }},
   ["sandwich"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Sandwich", AnimationOptions =
   {
       Prop = 'prop_sandwich_01',
       PropBone = 18905,
       PropPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0},
       EmoteMoving = true,
   }},
   ["soda"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Soda", AnimationOptions =
   {
       Prop = 'prop_ecola_can',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 130.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["egobar"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Barre énergisante", AnimationOptions =
   {
       Prop = 'prop_choc_ego',
       PropBone = 60309,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteMoving = true,
   }},
   ["wine"] = {"anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Verre de vin", AnimationOptions =
   {
       Prop = 'prop_drink_redwine',
       PropBone = 18905,
       PropPlacement = {0.10, -0.03, 0.03, -100.0, 0.0, -10.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["flute"] = {"anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Flute de champagne", AnimationOptions =
   {
       Prop = 'prop_champ_flute',
       PropBone = 18905,
       PropPlacement = {0.10, -0.03, 0.03, -100.0, 0.0, -10.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["champagne"] = {"anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Bouteille de champagne", AnimationOptions =
   {
       Prop = 'prop_drink_champ',
       PropBone = 18905,
       PropPlacement = {0.10, -0.03, 0.03, -100.0, 0.0, -10.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["cigar"] = {"amb@world_human_smoking@male@male_a@enter", "enter", "Cigare", AnimationOptions =
   {
       Prop = 'prop_cigar_02',
       PropBone = 47419,
       PropPlacement = {0.010, 0.0, 0.0, 50.0, 0.0, -80.0},
       EmoteMoving = true,
       EmoteDuration = 2600
   }},
   ["cigar2"] = {"amb@world_human_smoking@male@male_a@enter", "enter", "Cigare 2", AnimationOptions =
   {
       Prop = 'prop_cigar_01',
       PropBone = 47419,
       PropPlacement = {0.010, 0.0, 0.0, 50.0, 0.0, -80.0},
       EmoteMoving = true,
       EmoteDuration = 2600
   }},
   ["guitar"] = {"amb@world_human_musician@guitar@male@idle_a", "idle_b", "Guitare", AnimationOptions =
   {
       Prop = 'prop_acc_guitar_01',
       PropBone = 24818,
       PropPlacement = {-0.1, 0.31, 0.1, 0.0, 20.0, 150.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["guitar2"] = {"switch@trevor@guitar_beatdown", "001370_02_trvs_8_guitar_beatdown_idle_busker", "Guitare en dansant", AnimationOptions =
   {
       Prop = 'prop_acc_guitar_01',
       PropBone = 24818,
       PropPlacement = {-0.05, 0.31, 0.1, 0.0, 20.0, 150.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["guitarelectric"] = {"amb@world_human_musician@guitar@male@idle_a", "idle_b", "Guitare Electrique", AnimationOptions =
   {
       Prop = 'prop_el_guitar_01',
       PropBone = 24818,
       PropPlacement = {-0.1, 0.31, 0.1, 0.0, 20.0, 150.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["guitarelectric2"] = {"amb@world_human_musician@guitar@male@idle_a", "idle_b", "Guitare Electrique 2", AnimationOptions =
   {
       Prop = 'prop_el_guitar_03',
       PropBone = 24818,
       PropPlacement = {-0.1, 0.31, 0.1, 0.0, 20.0, 150.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["book"] = {"cellphone@", "cellphone_text_read_base", "Livre", AnimationOptions =
   {
       Prop = 'prop_novel_01',
       PropBone = 6286,
       PropPlacement = {0.15, 0.03, -0.065, 0.0, 180.0, 90.0}, -- This positioning isnt too great, was to much of a hassle
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["bouquet"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Bouquet de fleur", AnimationOptions =
   {
       Prop = 'prop_snow_flower_02',
       PropBone = 24817,
       PropPlacement = {-0.29, 0.40, -0.02, -90.0, -90.0, 0.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["teddy"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Teddy l'ourson", AnimationOptions =
   {
       Prop = 'v_ilev_mr_rasberryclean',
       PropBone = 24817,
       PropPlacement = {-0.20, 0.46, -0.016, -180.0, -90.0, 0.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["backpack"] = {"move_p_m_zero_rucksack", "idle", "Sac à dos", AnimationOptions =
   {
       Prop = 'p_michael_backpack_s',
       PropBone = 24818,
       PropPlacement = {0.07, -0.11, -0.05, 0.0, 90.0, 175.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["clipboard"] = {"missfam4", "base", "Regardez son bloc-note", AnimationOptions =
   {
       Prop = 'p_amb_clipboard_01',
       PropBone = 36029,
       PropPlacement = {0.16, 0.08, 0.1, -130.0, -50.0, 0.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["map"] = {"amb@world_human_tourist_map@male@base", "base", "Regardez une carte", AnimationOptions =
   {
       Prop = 'prop_tourist_map_01',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["beg"] = {"amb@world_human_bum_freeway@male@base", "base", "Pancarte de SDF", AnimationOptions =
   {
       Prop = 'prop_beggers_sign_03',
       PropBone = 58868,
       PropPlacement = {0.19, 0.18, 0.0, 5.0, 0.0, 40.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["makeitrain"] = {"anim@mp_player_intupperraining_cash", "idle_a", "Jet d'argent", AnimationOptions =
   {
       Prop = 'prop_anim_cash_pile_01',
       PropBone = 60309,
       PropPlacement = {0.0, 0.0, 0.0, 180.0, 0.0, 70.0},
       EmoteMoving = true,
       EmoteLoop = true,
       PtfxAsset = "scr_xs_celebration",
       PtfxName = "scr_xs_money_rain",
       PtfxPlacement = {0.0, 0.0, -0.09, -80.0, 0.0, 0.0, 1.0},
       PtfxInfo = Config.Languages[Config.MenuLanguage]['makeitrain'],
       PtfxWait = 500,
   }},
   ["camera"] = {"amb@world_human_paparazzi@male@base", "base", "Appareil photo", AnimationOptions =
   {
       Prop = 'prop_pap_camera_01',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
       PtfxAsset = "scr_bike_business",
       PtfxName = "scr_bike_cfid_camera_flash",
       PtfxPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0},
       PtfxInfo = Config.Languages[Config.MenuLanguage]['camera'],
       PtfxWait = 200,
   }},
   ["champagnespray"] = {"anim@mp_player_intupperspray_champagne", "idle_a", "Spray de champagne", AnimationOptions =
   {
       Prop = 'ba_prop_battle_champ_open',
       PropBone = 28422,
       PropPlacement = {0.0,0.0,0.0,0.0,0.0,0.0},
       EmoteMoving = true,
       EmoteLoop = true,
       PtfxAsset = "scr_ba_club",
       PtfxName = "scr_ba_club_champagne_spray",
       PtfxPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       PtfxInfo = Config.Languages[Config.MenuLanguage]['spraychamp'],
       PtfxWait = 500,
   }},
   ["joint"] = {"amb@world_human_smoking@male@male_a@enter", "enter", "Joint à la bouche", AnimationOptions =
   {
       Prop = 'p_cs_joint_02',
       PropBone = 47419,
       PropPlacement = {0.015, -0.009, 0.003, 55.0, 0.0, 110.0},
       EmoteMoving = true,
       EmoteDuration = 2600
   }},
   ["cig"] = {"amb@world_human_smoking@male@male_a@enter", "enter", "Cigarette à la bouche", AnimationOptions =
   {
       Prop = 'prop_amb_ciggy_01',
       PropBone = 47419,
       PropPlacement = {0.015, -0.009, 0.003, 55.0, 0.0, 110.0},
       EmoteMoving = true,
       EmoteDuration = 2600
   }},
   ["brief3"] = {"missheistdocksprep1hold_cellphone", "static", "Malette à tenir", AnimationOptions =
   {
       Prop = "prop_ld_case_01",
       PropBone = 57005,
       PropPlacement = {0.10, 0.0, 0.0, 0.0, 280.0, 53.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["tablet"] = {"amb@world_human_tourist_map@male@base", "base", "Tablette", AnimationOptions =
   {
       Prop = "prop_cs_tablet",
       PropBone = 28422,
       PropPlacement = {0.0, -0.03, 0.0, 20.0, -90.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["tablet2"] = {"amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a", "Tablette 2", AnimationOptions =
   {
       Prop = "prop_cs_tablet",
       PropBone = 28422,
       PropPlacement = {-0.05, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["phonecall"] = {"cellphone@", "cellphone_call_listen_base", "Etre au téléphone", AnimationOptions =
   {
       Prop = "prop_npc_phone_02",
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["phone"] = {"cellphone@", "cellphone_text_read_base", "Téléphone", AnimationOptions =
   {
       Prop = "prop_npc_phone_02",
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["clean"] = {"timetable@floyd@clean_kitchen@base", "base", "Nettoyer le capot", AnimationOptions =
   {
       Prop = "prop_sponge_01",
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, -0.01, 90.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["clean2"] = {"amb@world_human_maid_clean@", "base", "Nettoyer une vitre", AnimationOptions =
   {
       Prop = "prop_sponge_01",
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, -0.01, 90.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
}