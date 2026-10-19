extends Node2D
## PLOPQUAKE! — Native v0.9 Curated UI Asset Integration.
## Offline and earnable-only: no external store, ads, accounts or telemetry.

const WIDTH := 720.0
const HEIGHT := 1280.0
const LEFT := 55.0
const RIGHT := 665.0
const TOP := 295.0
const FLOOR := 1023.0
const DANGER := 420.0
const SAVE_PATH := "user://plopquake_native_v1.json"
const SAVE_BACKUP := "user://plopquake_native_backup.json"
const SAVE_RECOVERY := "user://plopquake_native_recovery.json"
const SAVE_IMPORT_BACKUP := "user://plopquake_native_before_manual_restore.json"
const MAX_PARTICLES := 150
const ACHIEVEMENT_TITLES := ["100 MERGES", "300 DROPS", "20 BOOMS", "FIND LEVEL 8"]
const ACHIEVEMENT_GOALS := [100, 300, 20, 8]
const FACTORY_RANK_NAMES := ["NEW HIRE", "SPARK STARTER", "FUSION FAN", "BOOM TECH", "CHAOS ENGINEER", "MASTER MIXER", "FACTORY LEGEND"]
const FACTORY_RANK_TARGETS := [0, 25, 100, 300, 750, 1800, 4000]
const QUEST_GOALS := [10, 35, 2]
const QUEST_REWARDS := [35, 55, 70]
const WEEKLY_NAMES := ["MERGE 75 BLOBS", "DROP 125 BLOBS", "TRIGGER 6 BOOMS"]
const WEEKLY_GOALS := [75, 125, 6]
const WEEKLY_REWARDS := [170, 155, 210]
const GHOUL_TITLES := ["GHOST HUNTER", "MONSTER MAKER", "BOOM RITUAL", "NIGHT SHIFT"]
const GHOUL_GOALS := [35, 10, 4, 25000]
const GHOUL_REWARDS := [45, 65, 80, 110]
const SKIN_NAMES := ["Classic", "Night Glow", "Candy Pop", "Ghostfire", "Comet Trail", "Crown Spark", "Aurora Flux", "Pumpkin Pop", "Prism Pop", "Inkstorm", "Solar Flare", "Nebula", "Voltage", "Frostbite", "Rose Gold", "Void Royal"]
const SKIN_COSTS := [0, 90, 125, 90, 170, 240, 300, 150, 450, 550, 900, 1400, 2300, 3600, 5500, 8500]
const BOARD_NAMES := ["Factory", "Midnight", "Candy Lab", "Ghoulfall", "After Hours", "Molten Core", "Icebox"]
const BOARD_COSTS := [0, 155, 180, 120, 600, 1250, 2200]
const NAMES := ["PIP", "BOOP", "MIMO", "GOB", "CHONK", "WOMP", "HONK", "HUGE", "ABSURD", "MYTHIC"]
const RADII := [23.0, 29.0, 37.0, 47.0, 60.0, 76.0, 96.0, 120.0, 146.0, 166.0]
const CANDY_DATE_START := 10
const CANDY_DATE_END := 10
const HOLD_DROP_COOLDOWN := 0.15
const MAX_HOLD_DROPS := 10
const MERGE_SQUASH_DURATION := 0.18
const MERGE_SQUASH_SCALE := 0.65
const DROP_ANTICIPATION_TIME := 0.08
const COMBO_WINDOW := 1.2
const BOOM_CHARGE_PER_TIER := 2.5
const BASE_BOOM_CHARGE := 12.0

var palette: Array[Color] = [
    Color("46dd98"), Color("68b8ff"), Color("ffd06d"), Color("f4779c"),
    Color("b77bec"), Color("ff8c62"), Color("60d1ca"), Color("e6a9e7"),
    Color("f3d96c"), Color("9eeeff")
]
var font: Font
var rng := RandomNumberGenerator.new()
var mode := "normal"
var screen := "home"
var back_screen := "home"
var settings_tab := 0
var shop_tab := 0
var score := 0
var best := 0
var biggest := 0
var drops := 0
var merges := 0
var charge := 0.0
var aim_x := 360.0
var next_tier := 0
var deck_tier := 0
var danger_seconds := 0.0
var gameover := false
var blobs: Array[Dictionary] = []
var bursts: Array[Dictionary] = []
var impact_rings: Array[Dictionary] = []
var buttons: Array[Dictionary] = []
var aiming := false
var elapsed := 0.0
var notice := "MATCH TWO BLOBS TO EVOLVE!"
var notice_timer := 4.0
var totals: Dictionary = {"merges": 0, "booms": 0, "drops": 0, "biggest": 0}
var tickets := 0
var sweets := 0
var equipped := "Classic"
var unlocked: Array = ["Classic"]
var claimed: Array = []
var sound_on := true
var low_motion := false
var high_contrast := false
var show_guide := true
var day_key := ""
var slots: Dictionary = {}
var event_count := 0
var mission_goal := 4
var mission_progress := 0
var quest_today := ""
var quest_stats: Array = [0, 0, 0]
var quest_claimed: Array = [false, false, false]
var board_owned: Array = ["Factory"]
var board_equipped := "Factory"
var achievements_claimed: Array = []
var low_power := false
var music_on := true
var seasonal_art := true
var sound_volume := 0.8
var music_volume := 0.6
var haptics := true
var popup_scale := 0.0
var boom_pulse := 0.0
var shake_amount := 0.0
var visual_sparks: Array[Dictionary] = []
var featured_shop := "looks"
var logo_texture: Texture2D
var creature_textures: Array[Texture2D] = []
var menu_texture: Texture2D
var board_textures: Dictionary = {}
var saved_event_month := -1
var soundtrack: AudioStreamPlayer
var music_player: AudioStreamPlayer
var sfx: Dictionary = {}
var draw_scale := 1.0
var draw_origin := Vector2.ZERO
var save_dirty := false
var save_timer := 0.0
var pressed_button := ""
var pressed_rect := Rect2()
var active_pointer := -999
var combo_count := 0
var combo_timer := 0.0
var top_chain := 0
var ghoul_year := 0
var ghoul_stats: Array = [0, 0, 0, 0]
var ghoul_claimed: Array = [false, false, false, false]
var total_evolutions := 0
var shop_page := 0
var merge_voice := 0
var score_milestone := 0
var weekly_key := ""
var weekly_stats: Array = [0, 0, 0]
var weekly_claimed: Array = [false, false, false]
var goals_tab := 0
var first_help_seen := false
var restore_armed := false
var recent_pb := false
var long_session_drops := 0
# v0.7 — gameplay-safe visual scale/rail integration and native save backup repair.
var neon_logo: Texture2D
var menu_cards: Dictionary = {}
var seasonal_portraits: Dictionary = {}
var accessory_textures: Dictionary = {}
var banner_texture: Texture2D
var boom_burst_texture: Texture2D
var button_chrome: Texture2D
var green_button_chrome: Texture2D
var green_button_pressed: Texture2D
var ui_glint_phase := 0.0
var ui_tap_rings: Array[Dictionary] = []
var production_creatures: Array[Texture2D] = []
var frame_parts: Dictionary = {}
# v1.0 — hold-to-drop, improved merge feedback, particle effects
var hold_drop_timer := 0.0
var hold_drop_count := 0
var merge_effects: Array[Dictionary] = []
var kenney_particles: Array[Texture2D] = []
var kenney_ui_sounds: Dictionary = {}
var particle_textures: Array[Texture2D] = []
# v1.1 — Quality overhaul: improved physics, animation, audio, UI
var drop_anticipation_timer := 0.0
var drop_anticipating := false
var pending_drop_x := 0.0
var last_merge_time := 0.0
var merge_chain_count := 0
var screen_shake_offset := Vector2.ZERO
var ui_scale := 1.0
var background_parallax := 0.0
var combo_popup_scale := 0.0
var combo_popup_text := ""
var perfect_drop_window := false
var perfect_drop_timer := 0.0
var blob_wobble_phase := 0.0

func _ready() -> void:
    font = ThemeDB.fallback_font
    logo_texture = load("res://art/logo_title.png")
    menu_texture = load("res://art/menu_background.png")
    board_textures = {"Factory": load("res://art/board_classic.png"), "Midnight": load("res://art/board_night.png"), "Candy Lab": load("res://art/board_candy.png"), "Ghoulfall": load("res://art/board_ghoul.png"), "After Hours": load("res://art/board_after_hours.png"), "Molten Core": load("res://art/board_molten.png"), "Icebox": load("res://art/board_icebox.png")}
    neon_logo = load("res://art/integrated/neon_logo.png")
    banner_texture = load("res://art/integrated/ui/spooky_strip.png")
    boom_burst_texture = load("res://art/integrated/ui/boom_burst.png")
    button_chrome = load("res://art/integrated/ui/industrial_panel.png")
    green_button_chrome = load("res://art/third_party/wenrexa_green_action.png")
    green_button_pressed = load("res://art/third_party/wenrexa_green_action_pressed.png")
    # Prefer the finished artwork; load the older portrait ONLY if an upgraded
    # resource is missing. This avoids keeping two complete image sets in VRAM.
    for i in range(NAMES.size()):
        var piece := str(NAMES[i]).to_lower()
        var upgraded := load("res://art/production/blobs/%02d_%s.png" % [i, piece]) as Texture2D
        if upgraded == null:
            upgraded = load("res://art/blobs/%02d_%s.png" % [i, piece]) as Texture2D
        production_creatures.append(upgraded)
        creature_textures.append(upgraded)
    for piece in ["rail_top", "rail_left", "rail_right", "rail_floor"]:
        frame_parts[piece] = load("res://art/production/frame/%s.png" % piece)
    for k in ["pumpkin", "ghost", "black_cat", "franken"]:
        seasonal_portraits[k] = load("res://art/integrated/blobs/season_%s.png" % k)
    for k in ["pumpkin_hat", "crown", "witch_hat", "cat_ears", "headphones", "ghost_sheet"]:
        accessory_textures[k] = load("res://art/integrated/accessories/%s.png" % k)
    for k in ["play", "daily", "event", "goals"]:
        menu_cards[k] = load("res://art/integrated/ui/card_%s.png" % k)
    
    # Load Kenney particle pack textures
    _load_kenney_particles()
    
    # Load Kenney UI sounds
    _load_kenney_ui_sounds()
    
    rng.randomize()
    _make_audio()
    _backup_previous_native_save()
    _load_all()
    _ensure_current_day()
    _ensure_weekly()
    _ensure_ghoul_year()
    saved_event_month = int(Time.get_date_dict_from_system().month)
    if blobs.is_empty() and score == 0:
        _new_game(false)
        screen = "home"
    queue_redraw()

func _load_kenney_particles() -> void:
    # Load particle textures from Kenney Particle Pack (PNG/Transparent)
    var particle_names := [
        "circle_01", "circle_02", "circle_03", "circle_04", "circle_05",
        "flare_01",
        "spark_01", "spark_02", "spark_03", "spark_04", "spark_05", "spark_06", "spark_07",
        "star_01", "star_02", "star_03", "star_04", "star_05", "star_06", "star_07", "star_08", "star_09",
        "magic_01", "magic_02", "magic_03", "magic_04", "magic_05",
        "light_01", "light_02", "light_03",
        "fire_01", "fire_02",
        "flame_01", "flame_02", "flame_03", "flame_04", "flame_05", "flame_06",
        "smoke_01", "smoke_02", "smoke_03", "smoke_04", "smoke_05", "smoke_06", "smoke_07", "smoke_08", "smoke_09", "smoke_10",
        "twirl_01", "twirl_02", "twirl_03",
        "trace_01", "trace_02", "trace_03", "trace_04", "trace_05", "trace_06", "trace_07"
    ]
    for name in particle_names:
        if ResourceLoader.exists("res://art/kenney_particles/%s.png" % name):
            var tex := load("res://art/kenney_particles/%s.png" % name) as Texture2D
            if tex != null:
                particle_textures.append(tex)
    # Fallback: create simple circle particles if Kenney assets not available
    if particle_textures.is_empty():
        var img := Image.create(32, 32, false, Image.FORMAT_RGBA8)
        img.fill(Color(0, 0, 0, 0))
        for x in range(32):
            for y in range(32):
                var dx := x - 16
                var dy := y - 16
                var dist := sqrt(float(dx * dx + dy * dy))
                if dist <= 16:
                    var alpha := 1.0 - dist / 16.0
                    img.set_pixel(x, y, Color(1, 1, 1, alpha))
        var tex := ImageTexture.create_from_image(img)
        for i in range(8):
            particle_textures.append(tex)

func _load_kenney_ui_sounds() -> void:
    # Load Kenney interface sounds (OGG format from interface sounds pack)
    var ui_sound_names := [
        "click_001", "click_002", "click_003", "click_004", "click_005",
        "select_001", "select_002", "select_003", "select_004", "select_005", "select_006", "select_007", "select_008",
        "confirmation_001", "confirmation_002", "confirmation_003", "confirmation_004",
        "back_001", "back_002", "back_003", "back_004",
        "open_001", "open_002", "open_003", "open_004",
        "close_001", "close_002", "close_003", "close_004",
        "error_001", "error_002", "error_003", "error_004", "error_005", "error_006", "error_007", "error_008",
        "switch_001", "switch_002", "switch_003", "switch_004", "switch_005", "switch_006", "switch_007",
        "toggle_001", "toggle_002", "toggle_003", "toggle_004",
        "drop_001", "drop_002", "drop_003", "drop_004",
        "pluck_001", "pluck_002",
        "tick_001", "tick_002", "tick_004"
    ]
    for name in ui_sound_names:
        var stream := load("res://audio/kenney_ui/%s.ogg" % name) as AudioStream
        if stream != null:
            kenney_ui_sounds[name] = stream

func _backup_previous_native_save() -> void:
    # Preserve the previous native save as it was, before any migrated state is written.
    # Do not generate game events, score, or save writes from a backup operation.
    if not FileAccess.file_exists(SAVE_PATH) or FileAccess.file_exists(SAVE_BACKUP):
        return
    var original := _read_saved_dictionary(SAVE_PATH)
    if original.is_empty():
        return
    var backup_file := FileAccess.open(SAVE_BACKUP, FileAccess.WRITE)
    if backup_file == null:
        return
    backup_file.store_string(JSON.stringify(original))
    backup_file.flush()
    backup_file.close()

func _make_audio() -> void:
    # Main soundtrack
    soundtrack = AudioStreamPlayer.new()
    soundtrack.stream = load("res://audio/factory_loop.wav")
    soundtrack.volume_db = linear_to_db(maxf(0.02, music_volume)) - 20.0
    if soundtrack.stream is AudioStreamWAV:
        soundtrack.stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
    add_child(soundtrack)
    
    # Dedicated music player for jingles and special tracks
    music_player = AudioStreamPlayer.new()
    music_player.volume_db = linear_to_db(maxf(0.02, music_volume)) - 6.0
    add_child(music_player)
    
    for name in ["plop", "boom", "reward"]:
        var player := AudioStreamPlayer.new()
        player.stream = load("res://audio/%s.wav" % name)
        player.volume_db = linear_to_db(maxf(0.02, sound_volume)) - (10.0 if name in ["plop", "merge"] else 8.0)
        add_child(player)
        sfx[name] = player
    for i in range(3):
        var voice := AudioStreamPlayer.new()
        voice.stream = load("res://audio/merge.wav")
        voice.volume_db = linear_to_db(maxf(0.02, sound_volume)) - 10.0
        add_child(voice)
        sfx["merge_%d" % i] = voice
    # Nathan Gibson's CC BY 4.0 UI cues. Attribution in Third-party credits.
    for cue in ["ui_tap", "ui_open", "ui_back", "ui_error", "ui_switch", "ui_confirm"]:
        var click_player := AudioStreamPlayer.new()
        click_player.stream = load("res://audio/ui/%s.ogg" % cue)
        click_player.volume_db = linear_to_db(maxf(0.02, sound_volume)) - 13.0
        add_child(click_player)
        sfx[cue] = click_player
    
    # Kenney Impact Sounds for gameplay (blob landings, collisions, BOOM)
    var impact_sounds := [
        "impactSoft_light_001", "impactSoft_light_002", "impactSoft_light_003", "impactSoft_light_004",
        "impactSoft_medium_001", "impactSoft_medium_002", "impactSoft_medium_003", "impactSoft_medium_004",
        "impactGeneric_light_001", "impactGeneric_light_002", "impactGeneric_light_003", "impactGeneric_light_004",
        "impactWood_light_001", "impactWood_light_002", "impactWood_light_003", "impactWood_light_004",
    ]
    for name in impact_sounds:
        if ResourceLoader.exists("res://audio/kenney_ui/%s.ogg" % name):
            var player := AudioStreamPlayer.new()
            player.stream = load("res://audio/kenney_ui/%s.ogg" % name)
            player.volume_db = linear_to_db(maxf(0.02, sound_volume)) - 10.0
            add_child(player)
            sfx[name] = player
    
    # Kenney Music Jingles for special moments
    var jingle_names := [
        "jingles_NES00", "jingles_NES01", "jingles_NES02", "jingles_NES03",
        "jingles_NES04", "jingles_NES05", "jingles_NES06", "jingles_NES07",
        "jingles_NES08", "jingles_NES09", "jingles_NES10", "jingles_NES11",
        "jingles_NES12", "jingles_NES13", "jingles_NES14", "jingles_NES15", "jingles_NES16"
    ]
    for name in jingle_names:
        if ResourceLoader.exists("res://audio/kenney_music/%s.ogg" % name):
            var player := AudioStreamPlayer.new()
            player.stream = load("res://audio/kenney_music/%s.ogg" % name)
            player.volume_db = linear_to_db(maxf(0.02, music_volume)) - 6.0
            add_child(player)
            sfx[name] = player

func _play_sfx(name: String) -> void:
    if not sound_on:
        return
    var key := name
    if name == "merge":
        key = "merge_%d" % merge_voice
        merge_voice = (merge_voice + 1) % 3
    if not sfx.has(key):
        return
    var player: AudioStreamPlayer = sfx[key]
    # UI cues are intentionally quieter than merge/BOOM, to avoid ear fatigue.
    var ui_cue := name.begins_with("ui_")
    player.volume_db = linear_to_db(maxf(0.02, sound_volume)) - (13.0 if ui_cue else (10.0 if name in ["plop", "merge"] else 5.0))
    player.pitch_scale = rng.randf_range(0.97, 1.035) if name in ["merge", "ui_tap"] else 1.0
    player.play()

func _play_kenney_ui(category: String) -> void:
    # Play a random Kenney UI sound from the given category
    if not sound_on or kenney_ui_sounds.is_empty():
        return
    var matching: Array = []
    for k in kenney_ui_sounds:
        if k.begins_with(category):
            matching.append(k)
    if matching.is_empty():
        return
    var chosen: String = matching[rng.randi_range(0, matching.size() - 1)]
    var player := AudioStreamPlayer.new()
    player.stream = kenney_ui_sounds[chosen]
    player.volume_db = linear_to_db(maxf(0.02, sound_volume)) - 13.0
    add_child(player)
    player.play()
    # Clean up after playing
    player.queue_free.call_deferred()

func _play_impact(tier: int = 0) -> void:
    if not sound_on:
        return
    # Pick a random soft impact sound based on tier
    var sounds: Array = [
        "impactSoft_light_001", "impactSoft_light_002", "impactSoft_light_003", "impactSoft_light_004",
        "impactSoft_medium_001", "impactSoft_medium_002", "impactSoft_medium_003", "impactSoft_medium_004",
    ]
    if tier >= 5:
        sounds = [
            "impactGeneric_light_001", "impactGeneric_light_002", "impactGeneric_light_003", "impactGeneric_light_004",
            "impactWood_light_001", "impactWood_light_002", "impactWood_light_003", "impactWood_light_004",
        ]
    var available: Array[String] = []
    for s in sounds:
        if sfx.has(s):
            available.append(s)
    if available.is_empty():
        return
    var chosen: String = available[rng.randi_range(0, available.size() - 1)]
    var player: AudioStreamPlayer = sfx[chosen]
    player.volume_db = linear_to_db(maxf(0.02, sound_volume)) - 10.0
    player.pitch_scale = rng.randf_range(0.85, 1.15)
    player.play()

func _play_jingle(tier: int = 0) -> void:
    if not music_on or not sound_on:
        return
    var jingles: Array = []
    if tier >= 8:
        jingles = ["jingles_NES13", "jingles_NES14", "jingles_NES15", "jingles_NES16"]
    elif tier >= 5:
        jingles = ["jingles_NES08", "jingles_NES09", "jingles_NES10", "jingles_NES11", "jingles_NES12"]
    elif tier >= 3:
        jingles = ["jingles_NES04", "jingles_NES05", "jingles_NES06", "jingles_NES07"]
    else:
        jingles = ["jingles_NES01", "jingles_NES02", "jingles_NES03"]
    var available: Array[String] = []
    for j in jingles:
        if sfx.has(j):
            available.append(j)
    if available.is_empty():
        return
    var chosen: String = available[rng.randi_range(0, available.size() - 1)]
    music_player.stream = sfx[chosen]
    music_player.volume_db = linear_to_db(maxf(0.02, music_volume)) - 6.0
    music_player.play()

func _today() -> String:
    var d := Time.get_date_dict_from_system()
    return "%04d-%02d-%02d" % [int(d.year), int(d.month), int(d.day)]

func _is_halloween() -> bool:
    return int(Time.get_date_dict_from_system().month) == 10

func _week_start_key() -> String:
    # Deterministic local Monday boundary, independent of app restart and UTC offset.
    var d := Time.get_date_dict_from_system()
    var midnight := {"year": int(d.year), "month": int(d.month), "day": int(d.day), "hour": 0, "minute": 0, "second": 0}
    var day_number := int(Time.get_unix_time_from_datetime_dict(midnight) / 86400.0)
    var weekday: int = int(d.weekday) # Sunday=0 in Godot
    return str(day_number - ((weekday + 6) % 7))

func _ensure_weekly() -> void:
    var current := _week_start_key()
    if current == weekly_key:
        return
    weekly_key = current
    weekly_stats = [0, 0, 0]
    weekly_claimed = [false, false, false]
    _save_all()

func _score_text(value: int) -> String:
    # Prevent multi-million scores spilling into the neighbouring HUD panel.
    if value >= 1000000000:
        return "%.2fB" % (float(value) / 1000000000.0)
    if value >= 1000000:
        return "%.2fM" % (float(value) / 1000000.0)
    if value >= 100000:
        return "%.1fK" % (float(value) / 1000.0)
    return str(value)

func _ensure_current_day() -> void:
    var current := _today()
    if quest_today != current:
        quest_today = current
        quest_stats = [0, 0, 0]
        quest_claimed = [false, false, false]
    # Even if the current mode is Normal, the Daily slot must remain associated
    # with the date it started on, never be written into the next day's slot.
    if day_key == current:
        return
    if mode == "daily" and day_key != "" and not gameover:
        slots["daily:" + day_key] = _pack_run()
    day_key = current
    if mode == "daily":
        if slots.has("daily:" + current):
            _unpack_run(slots["daily:" + current])
        else:
            _new_game(false)
    _save_all()

func _new_game(store_previous: bool = true) -> void:
    if store_previous and not gameover:
        _save_slot()
    score = 0
    drops = 0
    merges = 0
    charge = 0.0
    biggest = 0
    danger_seconds = 0.0
    gameover = false
    combo_count = 0
    combo_timer = 0.0
    recent_pb = false
    long_session_drops = 0
    event_count = 0
    score_milestone = 0
    impact_rings.clear()
    mission_goal = 4
    mission_progress = 0
    aim_x = 360.0
    blobs.clear()
    bursts.clear()
    if mode == "daily":
        rng.seed = int(day_key.replace("-", ""))
    else:
        rng.randomize()
    # Guaranteed fast opening merge.
    _spawn_blob(0, Vector2(360.0, FLOOR - RADII[0] - 2.0), true)
    next_tier = 0
    deck_tier = rng.randi_range(0, 1)
    notice = "DROP A PIP ON THE PIP BELOW!"
    notice_timer = 6.0
    _save_all()

func _save_slot() -> void:
    slots[_slot_name()] = _pack_run()

func _slot_name() -> String:
    return "normal" if mode == "normal" else "daily:" + day_key

func _pack_run() -> Dictionary:
    var data: Array = []
    for b in blobs:
        data.append({"t": int(b.t), "x": float(b.x), "y": float(b.y), "vx": float(b.vx), "vy": float(b.vy)})
    return {"score": score, "best": best, "biggest": biggest, "drops": drops,
        "merges": merges, "charge": charge, "next": next_tier, "deck": deck_tier,
        "mission_goal": mission_goal, "mission_progress": mission_progress,
        "gameover": gameover, "blobs": data, "rng_state": str(rng.state)}

func _unpack_run(data: Dictionary) -> void:
    score = maxi(0, int(data.get("score", 0)))
    best = maxi(best, int(data.get("best", 0)))
    biggest = clampi(int(data.get("biggest", 0)), 0, 9)
    drops = maxi(0, int(data.get("drops", 0)))
    merges = maxi(0, int(data.get("merges", 0)))
    charge = clampf(float(data.get("charge", 0.0)), 0.0, 100.0)
    next_tier = clampi(int(data.get("next", 0)), 0, 2)
    deck_tier = clampi(int(data.get("deck", 0)), 0, 2)
    mission_goal = maxi(3, int(data.get("mission_goal", 4)))
    mission_progress = clampi(int(data.get("mission_progress", 0)), 0, mission_goal)
    gameover = bool(data.get("gameover", false))
    danger_seconds = 0.0
    blobs.clear()
    var saved_blobs = data.get("blobs", [])
    if saved_blobs is Array:
        for b in saved_blobs:
            if blobs.size() >= 95:
                break
            if b is Dictionary:
                var tier := clampi(int(b.get("t", 0)), 0, 9)
                var radius: float = RADII[tier]
                blobs.append({"t": tier,
                    "x": clampf(float(b.get("x", 360.0)), LEFT + radius, RIGHT - radius),
                    "y": clampf(float(b.get("y", 700.0)), TOP + radius, FLOOR - radius),
                    "vx": clampf(float(b.get("vx", 0.0)), -1600.0, 1600.0),
                    "vy": clampf(float(b.get("vy", 0.0)), -1600.0, 1600.0), "age": 4.0})
    # Resuming Daily must continue the seeded RNG rather than branch to another
    # random drop sequence after an app restart.
    if data.has("rng_state"):
        rng.state = int(str(data["rng_state"]))
    score_milestone = int(score / 10000)
    if blobs.is_empty() and not gameover:
        _spawn_blob(0, Vector2(360.0, FLOOR - 25.0), true)

func _save_all() -> void:
    # Batch busy chain reactions so a five-merge combo does not write five JSON files.
    _save_slot()
    save_dirty = true

func _flush_save() -> void:
    if not save_dirty:
        return
    var state := {"format": 2, "day": day_key, "mode": mode, "slots": slots,
        "best": best, "tickets": tickets, "sweets": sweets, "equipped": equipped,
        "unlocked": unlocked, "claimed": claimed, "totals": totals,
        "sound": sound_on, "low_motion": low_motion, "contrast": high_contrast, "guide": show_guide,
        "quest_today": quest_today, "quest_stats": quest_stats, "quest_claimed": quest_claimed, "boards": board_owned,
        "board_equipped": board_equipped, "achievements_claimed": achievements_claimed, "low_power": low_power,
        "sound_volume": sound_volume, "haptics": haptics, "music_on": music_on, "seasonal_art": seasonal_art,
        "ghoul_year": ghoul_year, "ghoul_stats": ghoul_stats, "ghoul_claimed": ghoul_claimed,
        "top_chain": top_chain, "week": weekly_key, "weekly_stats": weekly_stats,
        "weekly_claimed": weekly_claimed, "first_help_seen": first_help_seen}
    var json := JSON.stringify(state)
    var temp_path := SAVE_PATH + ".tmp"
    var f := FileAccess.open(temp_path, FileAccess.WRITE)
    if f == null:
        return
    f.store_string(json)
    f.flush()
    f.close()
    # On Android/Linux this rename replaces the old file atomically. If a platform
    # disallows replacing an existing file, retain the valid old file and a temp copy.
    var err := DirAccess.rename_absolute(ProjectSettings.globalize_path(temp_path), ProjectSettings.globalize_path(SAVE_PATH))
    if err == OK:
        save_dirty = false
    else:
        # Keep a verified previous save BEFORE attempting a non-atomic fallback.
        var old_data := _read_saved_dictionary(SAVE_PATH)
        if not old_data.is_empty():
            var restore_copy := FileAccess.open(SAVE_RECOVERY, FileAccess.WRITE)
            if restore_copy != null:
                restore_copy.store_string(JSON.stringify(old_data))
                restore_copy.flush()
                restore_copy.close()
        var fallback := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
        if fallback != null:
            fallback.store_string(json)
            fallback.flush()
            fallback.close()
            if not _read_saved_dictionary(SAVE_PATH).is_empty():
                save_dirty = false

func _exit_tree() -> void:
    _save_all()
    _flush_save()

func _copy_save_to_clipboard() -> void:
    _save_all()
    _flush_save()
    var d := _read_saved_dictionary(SAVE_PATH)
    if d.is_empty():
        notice = "SAVE EXPORT FAILED — ORIGINAL UNCHANGED"
        notice_timer = 3.5
        return
    DisplayServer.clipboard_set("PLOPQUAKE_SAVE_V1\n" + JSON.stringify(d))
    notice = "SAVE COPIED! PASTE INTO NEW GAME DATA TAB"
    notice_timer = 4.0

func _restore_save_from_clipboard() -> void:
    var text_value := DisplayServer.clipboard_get()
    var prefix := "PLOPQUAKE_SAVE_V1\n"
    if not text_value.begins_with(prefix) or text_value.length() > 1000000:
        notice = "NO PLOPQUAKE BACKUP FOUND IN CLIPBOARD"
        notice_timer = 4.0
        restore_armed = false
        return
    var incoming = JSON.parse_string(text_value.substr(prefix.length()))
    if not (incoming is Dictionary) or not incoming.has("slots") or not (incoming["slots"] is Dictionary):
        notice = "INVALID SAVE — NOTHING CHANGED"
        notice_timer = 4.0
        restore_armed = false
        return
    _save_all()
    _flush_save()
    var old_data := _read_saved_dictionary(SAVE_PATH)
    if not old_data.is_empty():
        var backup := FileAccess.open(SAVE_IMPORT_BACKUP, FileAccess.WRITE)
        if backup == null:
            notice = "CANNOT BACK UP OLD SAVE — RESTORE CANCELLED"
            restore_armed = false
            return
        backup.store_string(JSON.stringify(old_data))
        backup.flush()
        backup.close()
    var temp_path := SAVE_PATH + ".import"
    var out_file := FileAccess.open(temp_path, FileAccess.WRITE)
    if out_file == null:
        notice = "CANNOT WRITE RESTORED SAVE"
        restore_armed = false
        return
    out_file.store_string(JSON.stringify(incoming))
    out_file.flush()
    out_file.close()
    if _read_saved_dictionary(temp_path).is_empty():
        notice = "SAVE VERIFICATION FAILED — NOTHING CHANGED"
        restore_armed = false
        return
    var moved := DirAccess.rename_absolute(ProjectSettings.globalize_path(temp_path),ProjectSettings.globalize_path(SAVE_PATH))
    if moved != OK:
        # Android may not replace an existing file with rename. The verified
        # original is already safely copied to SAVE_IMPORT_BACKUP.
        var replacement := FileAccess.open(SAVE_PATH,FileAccess.WRITE)
        if replacement == null:
            notice = "RESTORE FAILED — ORIGINAL BACKUP PRESERVED"
            restore_armed = false
            return
        replacement.store_string(JSON.stringify(incoming))
        replacement.flush()
        replacement.close()
    if _read_saved_dictionary(SAVE_PATH).is_empty():
        notice = "RESTORE FAILED — BACKUP STILL AVAILABLE"
        restore_armed = false
        return
    _load_all()
    _ensure_current_day()
    _ensure_weekly()
    _ensure_ghoul_year()
    restore_armed = false
    screen = "home"
    back_screen = "home"
    notice = "SAVE RESTORED! WELCOME BACK!"
    notice_timer = 4.0

func _ensure_ghoul_year() -> void:
    var d := Time.get_date_dict_from_system()
    if int(d.month) != 10:
        return
    if ghoul_year == int(d.year):
        return
    ghoul_year = int(d.year)
    ghoul_stats = [0, 0, 0, 0]
    ghoul_claimed = [false, false, false, false]
    _save_all()

func _read_saved_dictionary(path: String) -> Dictionary:
    if not FileAccess.file_exists(path):
        return {}
    var f := FileAccess.open(path, FileAccess.READ)
    if f == null:
        return {}
    # Badly sized/corrupted files should not be loaded into memory indefinitely.
    if f.get_length() > 3000000 or f.get_length() < 2:
        f.close()
        return {}
    var parsed = JSON.parse_string(f.get_as_text())
    f.close()
    if not (parsed is Dictionary):
        return {}
    if not parsed.has("slots") or not (parsed["slots"] is Dictionary):
        return {}
    return parsed

func _load_all() -> void:
    var d := _read_saved_dictionary(SAVE_PATH)
    if d.is_empty():
        # Recover an interrupted file replacement first. The untouched v0.2
        # backup remains a last-resort migration source, not a normal overwrite.
        for path in [SAVE_PATH + ".tmp", SAVE_RECOVERY, SAVE_BACKUP]:
            d = _read_saved_dictionary(path)
            if not d.is_empty():
                save_dirty = true
                break
    if d.is_empty():
        day_key = _today()
        return
    day_key = str(d.get("day", _today()))
    mode = "daily" if str(d.get("mode", "normal")) == "daily" else "normal"
    best = maxi(0, int(d.get("best", 0)))
    tickets = maxi(0, int(d.get("tickets", 0)))
    sweets = maxi(0, int(d.get("sweets", 0)))
    equipped = str(d.get("equipped", "Classic"))
    unlocked = d.get("unlocked", ["Classic"])
    claimed = d.get("claimed", [])
    totals = d.get("totals", totals)
    sound_on = bool(d.get("sound", true))
    low_motion = bool(d.get("low_motion", false))
    high_contrast = bool(d.get("contrast", false))
    show_guide = bool(d.get("guide", true))
    quest_today = str(d.get("quest_today", _today()))
    quest_stats = d.get("quest_stats", [0, 0, 0])
    quest_claimed = d.get("quest_claimed", [false, false, false])
    if quest_stats.size() != 3:
        quest_stats = [0, 0, 0]
    if quest_claimed.size() != 3:
        quest_claimed = [false, false, false]
    board_owned = d.get("boards", ["Factory"])
    board_equipped = str(d.get("board_equipped", "Factory"))
    achievements_claimed = d.get("achievements_claimed", [])
    low_power = bool(d.get("low_power", false))
    sound_volume = clampf(float(d.get("sound_volume", 0.75)), 0.0, 1.0)
    haptics = bool(d.get("haptics", true))
    music_on = bool(d.get("music_on", false))
    seasonal_art = bool(d.get("seasonal_art", true))
    top_chain = maxi(0, int(d.get("top_chain", 0)))
    weekly_key = str(d.get("week", ""))
    weekly_stats = d.get("weekly_stats", [0, 0, 0])
    weekly_claimed = d.get("weekly_claimed", [false, false, false])
    first_help_seen = bool(d.get("first_help_seen", false))
    if weekly_stats.size() != 3:
        weekly_stats = [0, 0, 0]
    if weekly_claimed.size() != 3:
        weekly_claimed = [false, false, false]
    ghoul_year = int(d.get("ghoul_year", 0))
    ghoul_stats = d.get("ghoul_stats", [0, 0, 0, 0])
    ghoul_claimed = d.get("ghoul_claimed", [false, false, false, false])
    if ghoul_stats.size() != 4:
        ghoul_stats = [0, 0, 0, 0]
    if ghoul_claimed.size() != 4:
        ghoul_claimed = [false, false, false, false]
    if not board_owned.has(board_equipped):
        board_equipped = "Factory"
    slots = d.get("slots", {})
    if slots.has(_slot_name()):
        _unpack_run(slots[_slot_name()])
    # Temporary save recovery only if the regular save was missing or invalid.

func _factory_rank_index() -> int:
    var lifetime: int = maxi(0, int(totals.get("merges", 0)))
    var result := 0
    for i in range(FACTORY_RANK_TARGETS.size()):
        if lifetime >= FACTORY_RANK_TARGETS[i]:
            result = i
    return result

func _factory_rank_label() -> String:
    return FACTORY_RANK_NAMES[_factory_rank_index()]

func _pending_rewards() -> int:
    var found := 0
    for i in range(QUEST_GOALS.size()):
        if not bool(quest_claimed[i]) and int(quest_stats[i]) >= QUEST_GOALS[i]:
            found += 1
    for i in range(WEEKLY_GOALS.size()):
        if not bool(weekly_claimed[i]) and int(weekly_stats[i]) >= WEEKLY_GOALS[i]:
            found += 1
    for i in range(ACHIEVEMENT_GOALS.size()):
        if not achievements_claimed.has(i) and _achievement_progress(i) >= ACHIEVEMENT_GOALS[i]:
            found += 1
    if _is_halloween():
        for i in range(GHOUL_GOALS.size()):
            if not bool(ghoul_claimed[i]) and int(ghoul_stats[i]) >= GHOUL_GOALS[i]:
                found += 1
    return found

func _shockwave(at: Vector2, color: Color, tier: int = 1) -> void:
    if low_motion or low_power:
        return
    impact_rings.append({"pos": at, "age": 0.0, "life": 0.42, "radius": 12.0 + float(tier) * 4.0, "tint": color})
    while impact_rings.size() > 7:
        impact_rings.pop_front()

func _change_mode(target: String) -> void:
    if mode == target:
        screen = "game"
        return
    _save_slot()
    mode = target
    day_key = _today()
    if slots.has(_slot_name()):
        _unpack_run(slots[_slot_name()])
    else:
        _new_game(false)
    notice = "YOUR OTHER RUN IS SAVED!"
    notice_timer = 2.6
    screen = "game"
    _save_all()

func _spawn_blob(tier: int, where: Vector2, settled: bool = false) -> void:
    if blobs.size() >= 95:
        return
    blobs.append({"t": tier, "x": where.x, "y": where.y, "vx": 0.0,
        "vy": 0.0 if settled else 50.0, "age": 2.0 if settled else 0.0})

func _drop(x: float) -> void:
    if screen != "game" or gameover:
        return
    if blobs.size() >= 95:
        notice = "FACTORY OVERLOADED!"
        screen = "gameover"
        gameover = true
        _save_all()
        return
    var r: float = RADII[next_tier]
    _spawn_blob(next_tier, Vector2(clampf(x, LEFT + r + 1.0, RIGHT - r - 1.0), TOP + r + 2.0))
    drops += 1
    _play_kenney_ui("drop")  # Kenney drop sound
    if drops > 0 and drops % 100 == 0:
        tickets += 70
        notice = "100-DROP SURVIVOR! +70 TICKETS"
        notice_timer = 4.0
        _play_sfx("reward")
    if _is_halloween() and (drops == 13 or drops == 31):
        var secret_key := "oct%d-%d" % [Time.get_date_dict_from_system().year, drops]
        if not claimed.has(secret_key):
            claimed.append(secret_key)
            sweets += 13 if drops == 13 else 31
            tickets += 25 if drops == 13 else 75
            notice = "SECRET FOUND! GHOULFALL BONUS!"
            notice_timer = 3.0
            _play_sfx("reward")
    totals["drops"] = int(totals.get("drops", 0)) + 1
    if _is_halloween():
        _ensure_ghoul_year()
    next_tier = deck_tier
    deck_tier = rng.randi_range(0, mini(2, drops / 10 + 1))
    quest_stats[1] = int(quest_stats[1]) + 1
    weekly_stats[1] = int(weekly_stats[1]) + 1
    long_session_drops += 1
    _play_sfx("plop")
    _haptic(12)
    _save_all()

func _merge_at(i: int, j: int) -> void:
    if i >= blobs.size() or j >= blobs.size():
        return
    var a: Dictionary = blobs[i]
    var b: Dictionary = blobs[j]
    if int(a.t) != int(b.t):
        return
    var tier := mini(9, int(a.t) + 1)
    var first_discovery := tier > int(totals.get("biggest", 0))
    var old_rank := _factory_rank_index()
    var center := (Vector2(float(a.x), float(a.y)) + Vector2(float(b.x), float(b.y))) * 0.5
    
    # Add merge effect for squash/stretch animation
    if not low_motion:
        merge_effects.append({
            "pos": center,
            "tier": int(a.t),
            "timer": MERGE_SQUASH_DURATION,
            "scale": MERGE_SQUASH_SCALE,
            "color": palette[clampi(int(a.t), 0, 9)]
        })
    
    blobs.remove_at(j)
    blobs.remove_at(i)
    if int(a.t) < 9:
        _spawn_blob(tier, center)
    else:
        # Highest tier resets into two young blobs, to keep the game endless.
        _spawn_blob(1, center + Vector2(-20, 0))
        _spawn_blob(1, center + Vector2(20, 0))
    var points := int(25.0 * pow(2.0, float(tier)))
    score += points
    if score > best:
        recent_pb = true
    best = maxi(best, score)
    biggest = maxi(biggest, tier)
    merges += 1
    combo_count = combo_count + 1 if combo_timer > 0.0 else 1
    combo_timer = 1.1
    top_chain = maxi(top_chain, combo_count)
    totals["merges"] = int(totals.get("merges", 0)) + 1
    totals["biggest"] = maxi(int(totals.get("biggest", 0)), tier)
    charge = minf(100.0, charge + 11.0 + float(tier) * 2.0)
    mission_progress += 1
    quest_stats[0] = int(quest_stats[0]) + 1
    weekly_stats[0] = int(weekly_stats[0]) + 1
    if _is_halloween():
        _ensure_ghoul_year()
        sweets += 1 if tier < 4 else 3
        ghoul_stats[0] = int(ghoul_stats[0]) + 1
        if tier >= 5:
            ghoul_stats[1] = int(ghoul_stats[1]) + 1
        ghoul_stats[3] = maxi(int(ghoul_stats[3]), score)
    tickets += 1 if tier < 4 else 3
    _burst(center, "+%d  %s!" % [points, NAMES[tier]], palette[tier])
    if combo_count >= 3 and combo_count % 3 == 0:
        _burst(center + Vector2(0,-44), "CHAIN x%d" % combo_count, Color("ffda7b"))
    _spark_cloud(center, palette[tier], 8 + mini(17, tier * 2))
    if tier >= 3:
        _shockwave(center, palette[tier], tier)
    if int(score / 10000) > score_milestone:
        score_milestone = int(score / 10000)
        _burst(center + Vector2(0.0, -62.0), "SCORE MILESTONE!", Color("fff3ae"))
    if _factory_rank_index() > old_rank:
        _burst(center + Vector2(0.0, -82.0), "FACTORY RANK UP!", Color("d6ffb4"))
        notice = "NEW RANK: %s" % _factory_rank_label()
        notice_timer = 3.2
        _play_sfx("reward")
    shake_amount = 3.5 if low_motion else minf(11.0, 3.5 + float(tier) * 0.8)
    popup_scale = 0.18
    _play_sfx("merge")
    _haptic(22 if tier < 5 else 38)
    # Play jingle for significant merges
    if tier >= 3 or combo_count >= 3:
        _play_jingle(tier)
    if tier >= 5 and first_discovery:
        notice = "NEW EVOLUTION: %s!" % NAMES[tier]
        notice_timer = 2.6
    if mission_progress >= mission_goal:
        tickets += 30
        mission_progress = 0
        mission_goal = mini(12, mission_goal + 2)
        notice = "MISSION COMPLETE! +30 TICKETS"
        notice_timer = 3.0
        _play_sfx("reward")
    _save_all()

func _spark_cloud(at: Vector2, tint: Color, count: int) -> void:
    if low_power:
        count = maxi(3, count / 3)
    for i in range(count):
        var ang := rng.randf_range(0, TAU)
        var speed := rng.randf_range(50.0, 270.0)
        var use_kenney := not particle_textures.is_empty() and rng.randf() < 0.7
        var tex: Texture2D = null
        if use_kenney:
            tex = particle_textures[rng.randi_range(0, particle_textures.size() - 1)]
        visual_sparks.append({"x": at.x, "y": at.y, "vx": cos(ang) * speed, "vy": sin(ang) * speed, "t": rng.randf_range(0.36, 0.85), "max": 0.85, "c": tint, "r": rng.randf_range(2.5, 6.0), "tex": tex})
    while visual_sparks.size() > MAX_PARTICLES:
        visual_sparks.pop_front()

func _haptic(ms: int) -> void:
    if haptics and not low_motion:
        Input.vibrate_handheld(ms)

func _burst(at: Vector2, text_value: String, tint: Color) -> void:
    bursts.append({"x": at.x, "y": at.y, "life": 1.3, "text": text_value, "color": tint})
    if bursts.size() > 16:
        bursts.pop_front()

func _boom() -> void:
    if charge < 99.9 or gameover:
        return
    charge = 0.0
    totals["booms"] = int(totals.get("booms", 0)) + 1
    quest_stats[2] = int(quest_stats[2]) + 1
    weekly_stats[2] = int(weekly_stats[2]) + 1
    if _is_halloween():
        _ensure_ghoul_year()
        ghoul_stats[2] = int(ghoul_stats[2]) + 1
    var removed := 0
    for i in range(blobs.size() - 1, -1, -1):
        var b := blobs[i]
        if int(b.t) <= 1 and removed < 5:
            blobs.remove_at(i)
            removed += 1
        else:
            var away := (float(b.x) - 360.0) / 360.0
            b.vx = away * 510.0
            b.vy = -rng.randf_range(390.0, 690.0)
    var bonus := 150 + removed * 100
    score += bonus
    if score > best:
        recent_pb = true
    best = maxi(best, score)
    if _is_halloween():
        ghoul_stats[3] = maxi(int(ghoul_stats[3]), score)
    notice = "BOOOOM!  +%d" % bonus
    notice_timer = 2.5
    danger_seconds = 0.0
    _burst(Vector2(360, 720), "BOOM!", Color("ffd67a"))
    _spark_cloud(Vector2(360, 720), Color("ffb863"), 42)
    _shockwave(Vector2(360, 720), Color("ffdf86"), 9)
    shake_amount = 15.0 if not low_motion else 0.0
    boom_pulse = 0.65
    _play_sfx("boom")
    _play_jingle(9)  # Victory jingle for BOOM
    _haptic(55)
    _save_all()

func _physics_process(delta: float) -> void:
    elapsed += delta
    combo_timer = maxf(0.0, combo_timer - delta)
    
    # Hold-to-drop timer
    if aiming and hold_drop_count > 0:
        hold_drop_timer += delta
        if hold_drop_timer >= HOLD_DROP_COOLDOWN and hold_drop_count < MAX_HOLD_DROPS:
            hold_drop_timer = 0.0
            _drop(aim_x)
            hold_drop_count += 1
    
    for i in range(ui_tap_rings.size() - 1, -1, -1):
        ui_tap_rings[i]["age"] = float(ui_tap_rings[i]["age"]) + delta
        if float(ui_tap_rings[i]["age"]) > 0.30:
            ui_tap_rings.remove_at(i)
    if save_dirty:
        save_timer += delta
        if save_timer >= 0.4:
            save_timer = 0.0
            _flush_save()
    # Update soundtrack volume based on music_volume setting
    soundtrack.volume_db = linear_to_db(maxf(0.02, music_volume)) - 20.0
    music_player.volume_db = linear_to_db(maxf(0.02, music_volume)) - 6.0
    
    var play_music := music_on and screen in ["home", "game"] and not gameover
    if play_music and not soundtrack.playing:
        soundtrack.play()
    if soundtrack.playing:
        soundtrack.stream_paused = not play_music
    if low_power and Engine.get_physics_frames() % 2 == 1:
        # Physics still runs at 60 Hz. Only redraws can be throttled below.
        pass
    popup_scale = maxf(0.0, popup_scale - delta * 1.5)
    boom_pulse = maxf(0.0, boom_pulse - delta * 1.9)
    shake_amount = maxf(0.0, shake_amount - delta * 38.0)
    
    # Update merge effects (squash/stretch animations)
    for i in range(merge_effects.size() - 1, -1, -1):
        var eff: Dictionary = merge_effects[i]
        eff["timer"] = float(eff["timer"]) - delta
        if float(eff["timer"]) <= 0.0:
            merge_effects.remove_at(i)
    
    if Engine.get_physics_frames() % 180 == 0:
        _ensure_current_day()
        _ensure_weekly()
    var month_now := int(Time.get_date_dict_from_system().month)
    if month_now != saved_event_month:
        saved_event_month = month_now
        _ensure_ghoul_year()
        notice = "GHOULFALL IS LIVE!" if month_now == 10 else "SEASON COMPLETE — REWARDS KEPT!"
        notice_timer = 4.0
    for i in range(impact_rings.size() - 1, -1, -1):
        var ring: Dictionary = impact_rings[i]
        ring["age"] = float(ring["age"]) + delta
        if float(ring["age"]) >= float(ring["life"]):
            impact_rings.remove_at(i)
    for i in range(visual_sparks.size() - 1, -1, -1):
        var v: Dictionary = visual_sparks[i]
        v["t"] = float(v.t) - delta
        v["x"] = float(v.x) + float(v.vx) * delta
        v["y"] = float(v.y) + float(v.vy) * delta
        v["vy"] = float(v.vy) + 350.0 * delta
        if float(v.t) <= 0.0:
            visual_sparks.remove_at(i)
    if notice_timer > 0.0:
        notice_timer -= delta
    for i in range(bursts.size() - 1, -1, -1):
        bursts[i]["life"] = float(bursts[i].life) - delta
        if float(bursts[i].life) <= 0.0:
            bursts.remove_at(i)
    if screen != "game" or gameover:
        # Menus have no physical objects to simulate: render 30fps normally,
        # 15fps in battery saver. Touch/key events still redraw immediately.
        var menu_stride := 4 if low_power else 2
        if Engine.get_physics_frames() % menu_stride == 0:
            queue_redraw()
        return
    if int(elapsed) % 2 == 0 and Engine.get_physics_frames() % 45 == 0:
        _ensure_current_day()
    var dt := minf(delta, 0.035)
    for b in blobs:
        var r: float = RADII[int(b.t)]
        b.age = float(b.age) + dt
        b.vy = minf(1500.0, float(b.vy) + 1650.0 * dt)
        b.x = float(b.x) + float(b.vx) * dt
        b.y = float(b.y) + float(b.vy) * dt
        b.vx = float(b.vx) * 0.994
        if float(b.x) < LEFT + r:
            b.x = LEFT + r
            b.vx = absf(float(b.vx)) * 0.26
        elif float(b.x) > RIGHT - r:
            b.x = RIGHT - r
            b.vx = -absf(float(b.vx)) * 0.26
        # Play impact sound when blob hits floor (first time or significant bounce)
        if float(b.y) > FLOOR - r:
            if not b.has("landed") or absf(float(b.vy)) > 200.0:
                b.landed = true
                _play_impact(int(b.t))
            b.y = FLOOR - r
            b.vy = -absf(float(b.vy)) * 0.12
            b.vx = float(b.vx) * 0.94
    var merge_i := -1
    var merge_j := -1
    for i in range(blobs.size()):
        var a: Dictionary = blobs[i]
        for j in range(i + 1, blobs.size()):
            var b: Dictionary = blobs[j]
            var dx := float(b.x) - float(a.x)
            var dy := float(b.y) - float(a.y)
            var minimum: float = RADII[int(a.t)] + RADII[int(b.t)]
            if absf(dx) >= minimum or absf(dy) >= minimum:
                continue
            var d2 := dx * dx + dy * dy
            if d2 >= minimum * minimum:
                continue
            if int(a.t) == int(b.t) and int(a.t) <= 9 and float(a.age) > 0.12 and float(b.age) > 0.12:
                merge_i = i
                merge_j = j
                break
            var distance := maxf(0.01, sqrt(d2))
            var nx := dx / distance
            var ny := dy / distance
            # Improved separation with minimum movement to prevent jittering
            var separation := (minimum - distance) * 0.5
            if separation > 0.5:  # Only apply significant separation
                a.x = float(a.x) - nx * separation
                a.y = float(a.y) - ny * separation
                b.x = float(b.x) + nx * separation
                b.y = float(b.y) + ny * separation
            var rv := (float(b.vx) - float(a.vx)) * nx + (float(b.vy) - float(a.vy)) * ny
            if rv < 0:
                var impulse := -rv * 0.31
                a.vx = float(a.vx) - nx * impulse
                a.vy = float(a.vy) - ny * impulse
                b.vx = float(b.vx) + nx * impulse
                b.vy = float(b.vy) + ny * impulse
        if merge_i >= 0:
            break
    if merge_i >= 0:
        _merge_at(merge_i, merge_j)
    var danger := false
    for b in blobs:
        var r: float = RADII[int(b.t)]
        if float(b.y) - r < DANGER and float(b.age) > 2.5 and absf(float(b.vy)) < 95.0:
            danger = true
            break
    danger_seconds = minf(3.5, danger_seconds + dt) if danger else maxf(0.0, danger_seconds - dt * 2.0)
    if danger_seconds >= 3.45:
        gameover = true
        screen = "gameover"
        notice = "FACTORY OVERLOADED!"
        _save_all()
        _flush_save()
    if not low_power or Engine.get_physics_frames() % 2 == 0:
        queue_redraw()

func _ui_transform() -> void:
    var viewport_size := get_viewport_rect().size
    draw_scale = minf(viewport_size.x / WIDTH, viewport_size.y / HEIGHT)
    draw_origin = (viewport_size - Vector2(WIDTH, HEIGHT) * draw_scale) * 0.5
    draw_set_transform(draw_origin, 0.0, Vector2(draw_scale, draw_scale))

func _panel(r: Rect2, color: Color, border: Color = Color(0.30,0.40,0.56,0.95), radius: float = 18.0) -> void:
    _filled_round(Rect2(r.position + Vector2(0, 7), r.size), Color(0.01, 0.02, 0.08, 0.43), radius)
    _filled_round(r, border.lightened(.22) if high_contrast else border, radius)
    _filled_round(r.grow(-3), color, maxf(2.0, radius - 3.0))
    draw_line(r.position + Vector2(radius + 3, 5), Vector2(r.end.x - radius - 3, r.position.y + 5), Color(0.95, 0.99, 1.0, 0.19), 2.5)
    if not low_power:
        draw_line(r.position + Vector2(radius + 9, r.size.y - 5), Vector2(r.end.x - radius - 9, r.end.y - 5), Color(0.01, 0.01, 0.10, 0.20), 2.0)

func _filled_round(r: Rect2, color: Color, rad: float = 18.0) -> void:
    var rr := minf(rad, minf(r.size.x, r.size.y) / 2.0)
    draw_rect(Rect2(r.position + Vector2(rr, 0), r.size - Vector2(rr * 2.0, 0)), color)
    draw_rect(Rect2(r.position + Vector2(0, rr), r.size - Vector2(0, rr * 2.0)), color)
    for x in [r.position.x + rr, r.end.x - rr]:
        for y in [r.position.y + rr, r.end.y - rr]:
            draw_circle(Vector2(x, y), rr, color)

func _label(text_value: String, center_x: float, baseline_y: float, size: int = 25, color: Color = Color.WHITE, width: float = 630.0) -> void:
    if size >= 25 and not low_power:
        draw_string(font, Vector2(center_x - width * 0.5 + 1.5, baseline_y + 2.5), text_value,
            HORIZONTAL_ALIGNMENT_CENTER, width, size, Color(0.012, 0.026, 0.070, color.a * 0.72))
    draw_string(font, Vector2(center_x - width * 0.5, baseline_y), text_value,
        HORIZONTAL_ALIGNMENT_CENTER, width, size, color)

func _left(text_value: String, x: float, baseline_y: float, size: int = 23, color: Color = Color.WHITE) -> void:
    if size >= 25 and not low_power:
        draw_string(font, Vector2(x + 1.0, baseline_y + 2.0), text_value, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size, Color(0, 0, 0.09, color.a * 0.55))
    draw_string(font, Vector2(x, baseline_y), text_value, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size, color)

# Nine-patch keeps illustrated corners round, even on narrow or very wide buttons.
func _draw_nine_patch(tex: Texture2D, target: Rect2, tint: Color) -> void:
    if tex == null or target.size.x < 80.0 or target.size.y < 46.0:
        return
    var sz := tex.get_size()
    var sx := minf(31.0, sz.x * 0.22)
    var sy := minf(24.0, sz.y * 0.28)
    var dx := minf(sx, target.size.x * 0.24)
    var dy := minf(sy, target.size.y * 0.24)
    var src_x := [0.0, sx, sz.x - sx, sz.x]
    var src_y := [0.0, sy, sz.y - sy, sz.y]
    var dst_x := [target.position.x, target.position.x + dx, target.end.x - dx, target.end.x]
    var dst_y := [target.position.y, target.position.y + dy, target.end.y - dy, target.end.y]
    for yy in range(3):
        for xx in range(3):
            var dest := Rect2(dst_x[xx], dst_y[yy], dst_x[xx + 1] - dst_x[xx], dst_y[yy + 1] - dst_y[yy])
            var region := Rect2(src_x[xx], src_y[yy], src_x[xx + 1] - src_x[xx], src_y[yy + 1] - src_y[yy])
            draw_texture_rect_region(tex, dest, region, tint)

func _button(r: Rect2, id: String, title: String, accent: Color = Color("283b62"), txt: Color = Color("f2f5ff"), size: int = 26) -> void:
    var depressed := pressed_button == id
    var face := accent.darkened(0.16) if depressed else accent
    _panel(r, face, accent.lightened(0.42) if depressed else accent.lightened(0.28), 18.0)
    var green_action := accent.g > 0.73 and accent.g > accent.r * 1.13 and r.size.y >= 62.0
    if green_action and green_button_chrome != null:
        # Commercial-safe Wenrexa CC0 green panel: real active button, not a mockup.
        var chosen_green := green_button_pressed if depressed else green_button_chrome
        _draw_nine_patch(chosen_green, r.grow(-2.0), Color(1,1,1,0.82))
    elif button_chrome != null and not low_power and r.size.y >= 62.0:
        # Original PLOPQUAKE industrial panel 9-sliced for all other controls.
        _draw_nine_patch(button_chrome, r.grow(-2.0), Color(1,1,1,0.44 if depressed else 0.64))
    elif not low_power:
        # Use Kenney UI button textures for a polished look
        var btn_tex_name := "button_round_flat"
        if depressed:
            btn_tex_name = "button_round_gloss"
        elif r.size.y >= 62.0:
            btn_tex_name = "button_round_gradient"
        else:
            btn_tex_name = "button_round_flat"
        var kenney_btn := load("res://art/kenney_ui/%s.png" % btn_tex_name) as Texture2D
        if kenney_btn != null:
            _draw_nine_patch(kenney_btn, r.grow(-2.0), Color(1,1,1,0.7 if depressed else 0.9))
    if depressed:
        _filled_round(r.grow(-6.0), Color(0.98,0.99,1.0,0.11), 13.0)
    draw_line(r.position + Vector2(22, 6), r.position + Vector2(r.size.x - 22, 6), Color(1,1,1,0.12 if depressed else 0.29), 2.0)
    if not low_power and r.size.y > 50.0:
        draw_rect(Rect2(r.position + Vector2(15, r.size.y - 11), Vector2(r.size.x - 30, 3)), Color(0,0,0,0.15))
    if depressed:
        draw_rect(Rect2(r.position + Vector2(8, r.size.y - 8), Vector2(r.size.x - 16, 3)), Color(0,0,0,.13))
    _label(title, r.get_center().x, r.get_center().y + float(size) * 0.34, size, txt, r.size.x - 24)
    buttons.append({"rect": r, "id": id})

func _art_card(r: Rect2, id: String, caption: String, descriptor: String, tint: Color) -> void:
    var tex: Texture2D = menu_cards.get("event" if id == "events" else id)
    if tex != null:
        draw_texture_rect(tex,r,false)
    else:
        _panel(r, Color("25395e"), tint, 19)
    # Calendar and event date badges are rendered from live game time, not the mockup.
    if id == "daily":
        var day_rect := Rect2(r.position.x+r.size.x*.40,r.position.y+r.size.y*.24,r.size.x*.20,r.size.y*.24)
        _filled_round(day_rect,Color("e9ddff"),9.0)
        _label(str(Time.get_date_dict_from_system().day),day_rect.get_center().x,day_rect.get_center().y+13,30,Color("323464"),day_rect.size.x)
    # Cover baked titles in the concept art with actual accessible game text.
    draw_rect(Rect2(r.position.x + 8,r.position.y+r.size.y*0.51,r.size.x-16,r.size.y*0.46),Color(.035,.043,.14,.83))
    _label(caption,r.get_center().x,r.position.y+r.size.y*.74,27,Color("fff7d8"),r.size.x-24)
    _label(descriptor,r.get_center().x,r.position.y+r.size.y*.90,15,Color("e7eaff"),r.size.x-24)
    if pressed_button == id:
        draw_rect(r.grow(-4),Color(1,1,1,.11))
    buttons.append({"rect":r,"id":id})

func _background() -> void:
    draw_rect(Rect2(0, 0, WIDTH, HEIGHT), Color("080e1e") if high_contrast else Color("0c1631"))
    if menu_texture != null:
        draw_texture_rect(menu_texture, Rect2(0, 0, WIDTH, HEIGHT), false)
    draw_rect(Rect2(0, 0, WIDTH, 132), Color(0.045,0.07,0.16,0.35))

func _draw_portrait(pos: Vector2, tier: int, radius: float, fade: float, look: String) -> void:
    var safe_tier := clampi(tier, 0, 9)
    var art: Texture2D = creature_textures[safe_tier]
    if safe_tier < production_creatures.size() and production_creatures[safe_tier] != null:
        art = production_creatures[safe_tier]
    if art == null:
        return
    var breath := 1.0 if low_motion else 1.0 + sin(elapsed * 1.55 + float(tier) + pos.x * 0.012) * 0.010
    var size := radius * 2.20 * breath
    var tint := Color(1.0, 1.0, 1.0, fade)
    match look:
        "Night Glow": tint = Color(0.83, 0.90, 1.17, fade)
        "Candy Pop": tint = Color(1.13, 0.87, 1.03, fade)
        "Ghostfire": tint = Color(0.78, 1.13, 0.99, fade)
        "Comet Trail": tint = Color(0.92, 1.02, 1.15, fade)
        "Crown Spark": tint = Color(1.11, 1.04, 0.81, fade)
        "Aurora Flux": tint = Color(0.85, 1.14, 1.09, fade)
        "Pumpkin Pop": tint = Color(1.15, 0.91, 0.72, fade)
        "Prism Pop": tint = Color(1.04, 0.94, 1.12, fade)
        "Inkstorm": tint = Color(0.63, 0.68, 0.94, fade)
        "Solar Flare": tint = Color(1.18, 0.92, 0.62, fade)
        "Nebula": tint = Color(0.87, 0.69, 1.20, fade)
        "Voltage": tint = Color(0.68, 1.20, 1.06, fade)
        "Frostbite": tint = Color(0.72, 0.98, 1.19, fade)
        "Rose Gold": tint = Color(1.18, 0.82, 0.86, fade)
        "Void Royal": tint = Color(0.61, 0.61, 0.98, fade)
    if not low_power:
        var cc: Color = palette[clampi(tier, 0, 9)]
        draw_circle(pos + Vector2(0, radius * 0.14 + 10.0), radius * 1.02, Color(0.01, 0.02, 0.09, .18 * fade))
        if tier >= 5:
            draw_circle(pos, radius * 1.15, Color(cc.r, cc.g, cc.b, .035 * fade))
    # All ten sprites have centered alpha bounds. Their visible perimeter now follows
    # the physics collision radius rather than extending ~40% beyond it.
    var sprite_origin := pos - Vector2.ONE * (size * 0.5)
    draw_texture_rect(art, Rect2(sprite_origin, Vector2.ONE * size), false, tint)
    _draw_accessory(pos, radius, fade, look)
    if high_contrast:
        draw_arc(pos, radius * 0.99, 0.0, TAU, 40, Color(1.0, 1.0, 1.0, 0.9 * fade), maxf(2.0, radius * 0.042), true)
    if low_power:
        return
    if look in ["Night Glow", "Aurora Flux", "Inkstorm"]:
        var halo := Color("74f5ff") if look != "Inkstorm" else Color("b5a3ff")
        var a := 0.46 + (0.0 if low_motion else 0.12 * sin(elapsed * 2.6))
        draw_arc(pos, radius * 1.035, 0.15, 2.8, 32, Color(halo.r, halo.g, halo.b, a * fade), maxf(2.0, radius * 0.039), true)
    elif look == "Comet Trail":
        draw_arc(pos, radius * 1.04, -.6, 2.2, 25, Color(0.9, 1, 1, 0.64 * fade), maxf(2.0, radius * .045), true)
    elif look == "Prism Pop":
        draw_arc(pos, radius * 1.04, -2.0, 0.4, 22, Color(1.0, .60, .92, .64 * fade), maxf(2.0, radius * .05), true)
        draw_arc(pos, radius * 1.04, 0.5, 2.9, 22, Color(.5, 1, .88, .64 * fade), maxf(2.0, radius * .05), true)
    elif look == "Crown Spark":
        draw_circle(pos + Vector2(radius * 0.68, -radius * .75), maxf(2.0, radius*.065), Color(1, .98, .62, fade))
    elif look == "Pumpkin Pop":
        draw_circle(pos + Vector2(0, -radius*.90), maxf(2.0,radius*.065), Color(.68, 1, .39, fade))
    elif look in ["Solar Flare", "Nebula", "Voltage", "Frostbite", "Rose Gold", "Void Royal"]:
        var rim := Color("ffd181")
        match look:
            "Nebula": rim = Color("d2a1ff")
            "Voltage": rim = Color("7bffef")
            "Frostbite": rim = Color("b7f8ff")
            "Rose Gold": rim = Color("ffb3dc")
            "Void Royal": rim = Color("a387ff")
        var pulse := 0.64 if low_motion else 0.53 + 0.17 * sin(elapsed * 2.4)
        draw_arc(pos, radius * 1.06, 0.0, TAU, 36, Color(rim.r,rim.g,rim.b,pulse * fade), maxf(2.0,radius*.043), true)
        if look == "Void Royal":
            draw_arc(pos, radius * 1.13, 0.14, 3.05, 25, Color(.70,.46,1.0,.52*fade), maxf(2.0,radius*.03), true)

func _draw_accessory(pos: Vector2, radius: float, fade: float, look: String) -> void:
    # A purchased look changes actual gameplay sprites, not merely its shop preview.
    var accessory := ""
    match look:
        "Crown Spark": accessory = "crown"
        "Pumpkin Pop": accessory = "pumpkin_hat"
        "Candy Pop": accessory = "headphones"
        "Inkstorm": accessory = "witch_hat"
        "Prism Pop": accessory = "cat_ears"
    if accessory == "" or not accessory_textures.has(accessory):
        return
    var tex: Texture2D = accessory_textures[accessory]
    if tex == null:
        return
    var scale_factor := radius * (1.42 if accessory == "cat_ears" else 1.30)
    var center := pos + Vector2(0, -radius * (0.90 if accessory == "cat_ears" else 1.05))
    draw_texture_rect(tex, Rect2(center - Vector2(scale_factor,scale_factor)*0.5, Vector2.ONE * scale_factor),false, Color(1,1,1,fade))

func _blob(pos: Vector2, tier: int, radius: float, fade: float = 1.0, preview_skin: String = "") -> void:
    var portrait_look := equipped if preview_skin == "" else preview_skin
    if creature_textures.size() == NAMES.size() and creature_textures[clampi(tier, 0, 9)] != null:
        _draw_portrait(pos, tier, radius, fade, portrait_look)
        return
    var look := equipped if preview_skin == "" else preview_skin
    var c: Color = palette[clampi(tier, 0, 9)]
    if look == "Night Glow":
        c = c.lightened(0.16)
    elif look == "Candy Pop":
        c = c.lerp(Color("ffb1da"), 0.27)
    elif look == "Ghostfire":
        c = c.lerp(Color("66ffb8"), 0.27)
    elif look == "Crown Spark":
        c = c.lerp(Color("ffdd75"), 0.21)
    if look == "Aurora Flux":
        c = c.lerp(Color("79d5ff"), 0.35)
    elif look == "Pumpkin Pop":
        c = c.lerp(Color("ff983a"), 0.46)
    elif look == "Prism Pop":
        c = c.lerp(Color("a5deff"), 0.40)
    elif look == "Inkstorm":
        c = c.lerp(Color("202c55"), 0.70)
    var t := elapsed * (0.8 + float(tier) * 0.06) + pos.x * 0.013
    var breath := 1.0 + (0.0 if low_motion else sin(t) * 0.012)
    radius *= breath
    # Soft shadow and rimlight, drawn cheaply at any device resolution.
    draw_circle(pos + Vector2(2.0, radius * 0.12 + 7.0), radius * 1.06, Color(0,0.01,0.07,0.24 * fade))
    if not low_power:
        draw_circle(pos, radius * 1.09, Color(c.r,c.g,c.b,0.075 * fade))
    draw_circle(pos, radius, Color(c.r * .52,c.g * .62,c.b * .72,fade))
    draw_circle(pos + Vector2(-radius * .025,-radius * .055), radius * .91, Color(c.r,c.g,c.b,fade))
    if not low_power:
        draw_circle(pos + Vector2(-radius * .18,-radius * .24), radius * .67, Color(1,1,1,0.085 * fade))
    draw_arc(pos, radius - 1.3, 0.0, TAU, 28, Color(1,1,1,(1.0 if high_contrast else .83) * fade), maxf(1.7,radius * (0.045 if high_contrast else 0.033)), true)
    draw_circle(pos + Vector2(-radius * .35,-radius * .44), radius * .18, Color(1,1,1,0.36 * fade))
    draw_circle(pos + Vector2(-radius * .45,-radius * .51), radius * .045, Color(1,1,1,0.62 * fade))
    for side in [-1.0,1.0]:
        if tier in [3,4,5,6]:
            var ex := Vector2(side * radius * .60,-radius * .76)
            draw_colored_polygon(PackedVector2Array([pos + ex + Vector2(-radius*.20,0),pos + ex + Vector2(0,-radius*.30),pos + ex + Vector2(radius*.19,0)]), c.darkened(0.08))
        if tier == 7:
            draw_circle(pos + Vector2(side * radius * .50,-radius * .84),radius * .19,Color("ffd9ef"))
    if tier >= 8:
        var gold := Color("fff5aa")
        draw_line(pos + Vector2(-radius * .33,-radius *.95),pos + Vector2(-radius *.20,-radius *1.18),gold, maxf(2.0,radius*.035))
        draw_line(pos + Vector2(-radius *.20,-radius *1.18),pos + Vector2(0,-radius*1.03),gold,maxf(2.0,radius*.035))
        draw_line(pos + Vector2(0,-radius*1.03),pos + Vector2(radius*.20,-radius*1.18),gold,maxf(2.0,radius*.035))
        draw_line(pos + Vector2(radius*.20,-radius*1.18),pos + Vector2(radius*.33,-radius*.95),gold,maxf(2.0,radius*.035))
    var eye_radius := maxf(2.2,radius * .091)
    var blink := not low_motion and sin(elapsed * 1.9 + float(tier)*1.49) > 0.991
    for side in [-1.0,1.0]:
        var eye := pos + Vector2(side * radius * .235, -radius * .045)
        if blink:
            draw_line(eye - Vector2(eye_radius,0),eye + Vector2(eye_radius,0),Color("263047"),maxf(2.0,eye_radius * .6))
        else:
            draw_circle(eye,eye_radius,Color("21304d"))
            draw_circle(eye + Vector2(-eye_radius*.22,-eye_radius*.31),eye_radius*.32,Color.WHITE)
    draw_arc(pos + Vector2(0,radius*.155),radius*.23,.23,PI-.23,14,Color("483153"),maxf(1.7,radius*.057),true)
    if tier >= 3:
        for side in [-1.0,1.0]:
            draw_circle(pos + Vector2(side * radius * .48,radius*.22),radius*.105,Color(1,.42,.56,.32*fade))
    if look == "Comet Trail" and not low_power:
        draw_arc(pos,radius*1.06,0.24,2.4,17,Color("b4f8ff"),maxf(2.0,radius*.037))
    if look == "Crown Spark" and not low_power:
        draw_circle(pos + Vector2(radius*.40,-radius*.68),radius*.06,Color("fff3a0"))
    if look == "Aurora Flux" and not low_power:
        draw_arc(pos, radius * 1.13, -1.2, 1.9, 24, Color("a3ffea", 0.6 * fade), maxf(2.0, radius * .045))
    if look == "Pumpkin Pop":
        draw_circle(pos + Vector2(0, -radius * .93), radius * .10, Color("a7fc78", fade))
    if look == "Prism Pop" and not low_power:
        draw_arc(pos, radius * 1.10, -2.0, 0.4, 20, Color("ffc7ef", .73 * fade), maxf(2.0, radius * .054), true)
        draw_arc(pos, radius * 1.10, 0.5, 2.9, 20, Color("9cfff5", .73 * fade), maxf(2.0, radius * .054), true)
    if look == "Inkstorm":
        draw_arc(pos, radius * 1.055, 0.0, TAU, 26, Color("62ffe6", .86 * fade), maxf(2.0, radius * .037), true)

func _header() -> void:
    if neon_logo != null:
        draw_texture_rect(neon_logo, Rect2(48, 19, 624, 126), false)
    elif logo_texture != null:
        draw_texture_rect(logo_texture, Rect2(46, 22, 628, 115), false)
    else:
        _label("PLOPQUAKE!",360,102,52,Color("fff0c6"),640)

func _draw() -> void:
    buttons.clear()
    _ui_transform()
    _background()
    if screen == "home":
        _draw_home()
    elif screen == "game":
        _draw_game()
    elif screen == "pause":
        _draw_pause()
    elif screen == "settings":
        _draw_settings()
    elif screen == "collection":
        _draw_collection()
    elif screen == "locker":
        _draw_locker()
    elif screen == "events":
        _draw_events()
    elif screen == "goals":
        _draw_goals()
    elif screen == "gameover":
        _draw_gameover()
    elif screen == "help":
        _draw_help()
    elif screen == "credits":
        _draw_credits()
    # A subtle acknowledgement of successful finger taps, drawn above the UI.
    if not low_power and not low_motion:
        for ring in ui_tap_rings:
            var progress := clampf(float(ring["age"]) / 0.30, 0.0, 1.0)
            var spot: Vector2 = ring["pos"]
            draw_arc(spot, 8.0 + progress * 27.0, 0, TAU, 24, Color(0.75,0.97,1.0,0.48*(1.0-progress)),2.0,true)
    draw_set_transform(Vector2.ZERO,0.0,Vector2.ONE)

func _draw_home() -> void:
    _header()
    _panel(Rect2(42,154,637,155),Color("15254a",.95),Color("6b88d7"),26)
    _label("YOUR FACTORY",360,194,21,Color("e8b7fc"))
    _label("BEST  %s" % _score_text(best),205,259,33,Color("ffdb87"),302)
    _label("BIGGEST  %d / 10" % maxi(1,int(totals.get("biggest",0))+1),518,259,28,Color("c4f7ff"),275)
    _label("DRAG TO DROP  •  MATCH TWO  •  CHARGE BOOM",360,340,21,Color("dffca3"))
    _art_card(Rect2(45,365,306,202),"normal","PLAY NORMAL","Beat your best score",Color("ffc86e"))
    _art_card(Rect2(368,365,307,202),"daily","DAILY MODE","A fresh challenge every day",Color("bd8dff"))
    _art_card(Rect2(45,584,306,202),"events","GHOULFALL" if _is_halloween() else "SEASONAL EVENTS","Earn exclusive cosmetics",Color("ffab5b"))
    _art_card(Rect2(368,584,307,202),"goals","GOALS & REWARDS","Complete quests; earn tickets",Color("5ccaff"))
    _panel(Rect2(48,805,626,77),Color("233858"),Color("7b73bd"))
    _label("%d TICKETS   •   %d SWEETS" % [tickets,sweets],360,853,27,Color("ffe6aa"))
    _button(Rect2(45,904,306,76),"locker","FACTORY LOCKER",Color("583f94"),Color.WHITE,26)
    _button(Rect2(368,904,307,76),"collection","COLLECTION",Color("3d6490"),Color.WHITE,26)
    _button(Rect2(45,996,306,75),"settings","SETTINGS",Color("354c77"),Color.WHITE,25)
    _button(Rect2(368,996,307,75),"help","HOW TO PLAY",Color("426c82"),Color.WHITE,25)
    _button(Rect2(45,1088,630,75),"credits","CREDITS",Color("4a5d8a"),Color.WHITE,25)
    _label("RANK: %s • CHAIN x%d" % [_factory_rank_label(),top_chain],360,1192,23,Color("ccffa3"))
    _label("EARN YOUR COSMETICS  •  NO ADS  •  OFFLINE",360,1248,18,Color("bdd2e9"))
    _label("v1.0 ANDROID RELEASE",360,1298,15,Color("9daacc"))

func _draw_factory_rails() -> void:
    # Four small cropped textures: they sit UNDER the moving sprites, so the factory
    # never conceals the gameplay or creates a fake floor halfway up the arena.
    if not _is_halloween() or not seasonal_art or low_power:
        return
    var top_tex: Texture2D = frame_parts.get("rail_top")
    var left_tex: Texture2D = frame_parts.get("rail_left")
    var right_tex: Texture2D = frame_parts.get("rail_right")
    var floor_tex: Texture2D = frame_parts.get("rail_floor")
    if top_tex != null:
        draw_texture_rect(top_tex, Rect2(LEFT - 12, TOP - 53, RIGHT - LEFT + 24, 85), false, Color(1,1,1,0.86))
    if left_tex != null:
        draw_texture_rect(left_tex, Rect2(LEFT - 19, TOP + 19, 30, FLOOR - TOP - 22), false, Color(1,1,1,0.86))
    if right_tex != null:
        draw_texture_rect(right_tex, Rect2(RIGHT - 11, TOP + 19, 30, FLOOR - TOP - 22), false, Color(1,1,1,0.86))
    if floor_tex != null:
        draw_texture_rect(floor_tex, Rect2(LEFT - 10, FLOOR - 13, RIGHT - LEFT + 20, 38), false, Color(1,1,1,0.92))

func _draw_game() -> void:
    # Prioritize the actual playfield. Secondary progression stays in Goals/Locker.
    if neon_logo != null:
        draw_texture_rect(neon_logo, Rect2(45, 44, 380, 84), false)
    elif logo_texture != null:
        draw_texture_rect(logo_texture, Rect2(47, 54, 369, 72), false)
    else:
        _label("PLOPQUAKE!",220,91,38,Color("c5ff8c"),363)
    _button(Rect2(452,45,103,70),"goals","CLAIM!" if _pending_rewards() > 0 else "GOALS",Color("527c64") if _pending_rewards() > 0 else Color("354f7b"),Color.WHITE,18)
    _button(Rect2(565,45,112,70),"pause","II",Color("384b79"),Color.WHITE,31)
    _panel(Rect2(38,130,644,110),Color("17294b"),Color("647cb1"),24)
    _left("%s SCORE" % ("DAILY" if mode == "daily" else "NORMAL"),64,158,18,Color("a5b6db"))
    _left(_score_text(score),63,207,41,Color("cfff7c"))
    _left("BEST",341,158,18,Color("a5b6db"))
    _left(_score_text(best),337,207,35,Color("f2f6ff"))
    _left("LEVEL",552,158,18,Color("a5b6db"))
    _left("%d / 10" % (biggest+1),553,207,29,Color("ffd98b"))
    _panel(Rect2(LEFT-8,TOP-19,RIGHT-LEFT+16,FLOOR-TOP+37),Color("14264a"),Color("89a8d8"),27)
    var board_key := "Ghoulfall" if _is_halloween() and seasonal_art and board_equipped == "Factory" else board_equipped
    if board_textures.has(board_key):
        draw_texture_rect(board_textures[board_key],Rect2(LEFT,TOP-13,RIGHT-LEFT,FLOOR-TOP+25),false)
    _draw_factory_rails()
    draw_dashed_line(Vector2(LEFT+7,DANGER),Vector2(RIGHT-7,DANGER),Color("fb879a"),4.0,12.0)
    _left("DANGER = GAME OVER",LEFT+24,DANGER-18,19,Color("ffe1da"))
    if show_guide and not gameover:
        draw_dashed_line(Vector2(aim_x,TOP+52),Vector2(aim_x,FLOOR),Color(0.52,.9,1,.18),2.0,14)
    if danger_seconds > .05:
        draw_rect(Rect2(LEFT,TOP-12,RIGHT-LEFT,FLOOR-TOP+21),Color(.9,.14,.18, .025 + .05 * absf(sin(elapsed*8))))
    for b in blobs:
        _blob(Vector2(float(b.x),float(b.y)),int(b.t),RADII[int(b.t)])
    if not gameover:
        _blob(Vector2(aim_x,TOP+RADII[next_tier]+4),next_tier,RADII[next_tier],.89)
    for v in visual_sparks:
        var c: Color = v.c
        var p := Vector2(float(v.x), float(v.y))
        var rad := float(v.r)
        var alpha := clampf(float(v.t)/float(v.max),0,1)
        var tex: Texture2D = v.get("tex", null)
        if tex != null:
            var size := rad * 2.5
            draw_texture_rect(tex, Rect2(p - Vector2(size, size) * 0.5, Vector2(size, size)), false, Color(c.r, c.g, c.b, alpha))
        else:
            if rad > 4.0 and not low_power:
                draw_line(p - Vector2(rad * 1.35, 0), p + Vector2(rad * 1.35, 0), Color(c.r,c.g,c.b,alpha * 0.85),1.7)
                draw_line(p - Vector2(0,rad * 1.35), p + Vector2(0,rad * 1.35), Color(c.r,c.g,c.b,alpha * 0.85),1.7)
            draw_circle(p,rad * 0.72,Color(c.r,c.g,c.b,alpha))
    
    # Render merge effects (squash/stretch animation)
    if not low_motion:
        for eff in merge_effects:
            var progress := 1.0 - float(eff["timer"]) / MERGE_SQUASH_DURATION
            var scale_factor: float = lerp(1.0, float(eff["scale"]), sin(progress * PI))
            var radius: float = RADII[int(eff["tier"])] * scale_factor
            var alpha: float = 1.0 - progress
            var c: Color = eff["color"]
            draw_circle(eff["pos"], radius, Color(c.r, c.g, c.b, alpha * 0.6))
            # Add a bright flash at peak
            if progress > 0.4 and progress < 0.6:
                draw_circle(eff["pos"], radius * 1.3, Color(1, 1, 1, (1.0 - abs(progress - 0.5) * 4.0) * 0.4))
    
    for burst in bursts:
        var life := float(burst.life)
        var c: Color = burst.color
        _label(str(burst.text),float(burst.x),float(burst.y)-(1.3-life)*67.0,24,Color(c.r,c.g,c.b,clampf(life,0,1)),430)
    if not low_motion and not low_power:
        for ring in impact_rings:
            var life_fraction := 1.0 - float(ring.age) / float(ring.life)
            var cc: Color = ring.tint
            draw_arc(ring.pos, float(ring.radius) + (1.0 - life_fraction) * 86.0, 0.0, TAU, 34,
                Color(cc.r, cc.g, cc.b, life_fraction * 0.65), 2.0 + life_fraction * 5.0, true)
    if boom_pulse > .0 and not low_motion:
        draw_arc(Vector2(360,720),380.0*(1.0-boom_pulse),0,TAU,50,Color(.98,.84,.48,boom_pulse*.56),8.0)
    if danger_seconds > .05:
        _panel(Rect2(144,456,431,66),Color("ac3d5a"),Color("ffc3ad"))
        _label("SAVE IT!  %.1fs" % maxf(0,3.5-danger_seconds),360,499,32,Color.WHITE)
    # Position notices below the arena instead of covering the creatures.
    _panel(Rect2(45,1049,630,64),Color("253657"),Color("506c96"))
    if notice_timer > 0:
        _label(notice,360,1090,20,Color("e6fcad"),604)
    else:
        _label("MERGE %d MORE  •  %d TICKETS" % [maxi(0,mission_goal-mission_progress),tickets],360,1090,23,Color("e6fcad"))
    _panel(Rect2(40,1128,310,88),Color("283d64"),Color("647fad"))
    _blob(Vector2(93,1171),next_tier,24)
    _left("DROP  %s" % NAMES[next_tier],134,1162,23,Color("f9f4e9"))
    _left("ON DECK: %s" % NAMES[deck_tier],134,1194,19,Color("b2d9ff"))
    var boom_ready := charge >= 99.9
    _button(Rect2(361,1128,319,88),"boom","BOOM! READY" if boom_ready else "BOOM! %d%%" % int(charge),Color("f5698a") if boom_ready else Color("475576"),Color("281e3a") if boom_ready else Color.WHITE,28)
    if boom_ready and boom_burst_texture != null and not low_power:
        draw_texture_rect(boom_burst_texture,Rect2(366,1121,91,95),false,Color(1,1,1,.80))
    draw_rect(Rect2(376,1195,289 * charge / 100.0,7),Color("ffe47c"))
    _label("DRAG TO AIM  •  RELEASE TO DROP",360,1254,18,Color("c1d8ef"))
    if combo_timer > 0.0 and combo_count >= 3:
        _label("x%d CHAIN!" % combo_count,360,274,23,Color("ffe69b"))

func _draw_pause() -> void:
    _menu_frame("PAUSED", "Take a break. Your pile waits for you.")
    _label("%s POINTS • %d MERGES • CHAIN x%d" % [_score_text(score),merges,top_chain],360,401,23,Color("e8fca8"))
    _button(Rect2(93,472,534,90),"resume","RESUME GAME",Color("9eed6d"),Color("152b34"),34)
    _button(Rect2(93,583,534,77),"goals","GOALS & REWARDS")
    _button(Rect2(93,679,534,77),"locker","FACTORY LOCKER")
    _button(Rect2(93,773,534,77),"collection","COLLECTION")
    _button(Rect2(93,867,534,77),"settings","SETTINGS")
    _button(Rect2(93,961,259,77),"events","EVENTS",Color("465b7f"),Color.WHITE,24)
    _button(Rect2(370,961,257,77),"help","HOW TO PLAY",Color("465b7f"),Color.WHITE,22)
    _button(Rect2(93,1054,534,77),"home","MAIN MENU",Color("4c587a"))

func _menu_frame(title: String, subtitle: String) -> void:
    _header()
    _panel(Rect2(35,152,650,1071),Color("17274a"),Color("7998c7"),32)
    _label(title,340,237,46,Color("fdf0c9"),548)
    # Contextual feedback stays visible in menus after a reward or save action.
    var menu_tip := notice if notice_timer > 0 and (notice.find("SAVE") >= 0 or notice.find("RESTORE") >= 0 or notice.find("CLIPBOARD") >= 0 or notice.find("REWARD") >= 0 or notice.find("CLAIM") >= 0 or notice.find("NOT READY") >= 0) else subtitle
    _label(menu_tip,355,281,18,Color("dff6b7") if menu_tip != subtitle else Color("bacbe8"),600)
    _button(Rect2(571,172,78,66),"back","X",Color("465982"),Color.WHITE,29)

func _draw_help() -> void:
    _menu_frame("HOW TO PLAY", "Three moves. A million little disasters.")
    _panel(Rect2(74,321,573,180),Color("263b61"))
    _label("1  DROP A BLOB",360,370,30,Color("e1ff9d"))
    _blob(Vector2(211,437),0,30)
    _label("DRAG TO AIM  •  RELEASE TO DROP",438,446,18,Color("f3f5fc"),369)
    _panel(Rect2(74,521,573,209),Color("263b61"))
    _label("2  MATCH TWO OF A KIND",360,565,29,Color("e1ff9d"))
    _blob(Vector2(245,638),0,30)
    _blob(Vector2(328,638),0,30)
    _blob(Vector2(455,638),1,42)
    draw_line(Vector2(358,638),Vector2(397,638),Color("ffde88"),5)
    _label("THEY MERGE INTO A BIGGER CREATURE",360,709,18,Color("f4f1fc"))
    _panel(Rect2(74,750,573,205),Color("263b61"))
    _label("3  CHARGE BOOM!",360,793,30,Color("ffdda4"))
    _label("BIG MERGES CHARGE YOUR RESCUE.",360,845,21,Color("faf5e8"))
    _label("DON'T LET THE PILE REACH THE RED LINE.",360,890,19,Color("ffc9c4"))
    _panel(Rect2(74,977,573,94),Color("304267"))
    _label("EARN TICKETS  •  UNLOCK YOUR FACTORY",360,1014,19,Color("d0ffae"))
    _label("DAILY, WEEKLY & OCTOBER EVENTS AWAIT",360,1048,17,Color("d0eaff"))
    _button(Rect2(95,1094,531,83),"back","GOT IT — LET'S PLOP!",Color("a8ed73"),Color("163139"),28)

func _draw_credits() -> void:
    _menu_frame("CREDITS", "Made with love and free assets.")
    _panel(Rect2(74,321,573,180),Color("263b61"))
    _label("PLOPQUAKE DEVELOPMENT",360,370,26,Color("ffe69b"))
    _label("Game design, code & art direction",360,410,18,Color("d0e4ff"))
    _label("by the PLOPQUAKE Team",360,438,18,Color("d0e4ff"))
    
    _panel(Rect2(74,521,573,280),Color("263b61"))
    _label("THIRD-PARTY ASSETS (CC0 / CC BY 4.0)",360,565,22,Color("ffe69b"))
    _label("UI Soundpack — Nathan Gibson (CC BY 4.0)",360,605,17,Color("c4d8f0"))
    _label("Green Action Panels — Wenrexa (CC0)",360,630,17,Color("c4d8f0"))
    _label("UI Pack — Kenney (CC0)",360,655,17,Color("c4d8f0"))
    _label("Game Icons — Kenney (CC0)",360,680,17,Color("c4d8f0"))
    _label("Impact Sounds — Kenney (CC0)",360,705,17,Color("c4d8f0"))
    _label("Interface Sounds — Kenney (CC0)",360,730,17,Color("c4d8f0"))
    _label("Music Jingles — Kenney (CC0)",360,755,17,Color("c4d8f0"))
    _label("Particle Pack — Kenney (CC0)",360,780,17,Color("c4d8f0"))
    _label("Slime Pack — Rick Hoppmann (CC0)",360,805,17,Color("c4d8f0"))
    
    _panel(Rect2(74,821,573,150),Color("263b61"))
    _label("ENGINE & TOOLS",360,865,22,Color("ffe69b"))
    _label("Godot Engine 4.7.2 — MIT License",360,905,17,Color("c4d8f0"))
    _label("GDScript — Built-in",360,930,17,Color("c4d8f0"))
    
    _panel(Rect2(74,991,573,80),Color("304267"))
    _label("NO ADS • NO TRACKING • OFFLINE FIRST",360,1024,18,Color("d0ffae"))
    _label("Thank you for playing!",360,1052,17,Color("d0eaff"))
    _button(Rect2(95,1094,531,83),"back","BACK",Color("a8ed73"),Color("163139"),28)

func _draw_settings() -> void:
    _menu_frame("SETTINGS", "Comfortable on big and small screens.")
    _button(Rect2(68,320,180,70),"audio","SOUND",Color("4c6894") if settings_tab == 0 else Color("2d3f63"),Color.WHITE,22)
    _button(Rect2(265,320,180,70),"visual","VISUAL",Color("4c6894") if settings_tab == 1 else Color("2d3f63"),Color.WHITE,22)
    _button(Rect2(462,320,189,70),"data","DATA",Color("4c6894") if settings_tab == 2 else Color("2d3f63"),Color.WHITE,22)
    _panel(Rect2(68,423,585,502),Color("223658"))
    if settings_tab == 0:
        _label("GAME AUDIO",360,494,35,Color("d9ff9e"))
        _button(Rect2(96,537,528,82),"sound","SOUND EFFECTS: %s" % ("ON" if sound_on else "OFF"),Color("496c80"))
        _button(Rect2(96,635,528,80),"vol","SFX VOLUME: %d%%" % int(sound_volume * 100),Color("38517a"),Color.WHITE,23)
        _button(Rect2(96,723,528,74),"music_vol","MUSIC VOLUME: %d%%" % int(music_volume * 100),Color("38517a"),Color.WHITE,23)
        _button(Rect2(96,805,528,74),"haptic","PHONE VIBRATION: %s" % ("ON" if haptics else "OFF"),Color("38517a"),Color.WHITE,23)
        _button(Rect2(96,875,528,74),"music","BACKGROUND MUSIC: %s" % ("ON" if music_on else "OFF"),Color("38517a"),Color.WHITE,23)
        _label("UI SOUND: NATHAN GIBSON • CC BY 4.0",360,969,15,Color("c4d8f0"),544)
    elif settings_tab == 1:
        _label("VISUAL COMFORT",360,489,34,Color("d9ff9e"))
        _button(Rect2(96,520,528,77),"motion","REDUCED MOTION: %s" % ("ON" if low_motion else "OFF"),Color("38517a"),Color.WHITE,23)
        _button(Rect2(96,615,528,77),"power","BATTERY SAVER: %s" % ("ON" if low_power else "OFF"),Color("38517a"),Color.WHITE,23)
        _button(Rect2(96,710,528,77),"guide","AIMING GUIDE: %s" % ("ON" if show_guide else "OFF"),Color("38517a"),Color.WHITE,23)
        _button(Rect2(96,792,528,59),"contrast","HIGH CONTRAST: %s" % ("ON" if high_contrast else "OFF"),Color("38517a"),Color.WHITE,22)
        _button(Rect2(96,858,528,59),"seasonal","EVENT DECOR: %s" % ("ON" if seasonal_art else "OFF"),Color("38517a"),Color.WHITE,22)
    else:
        _label("SAVE & TRANSFER",360,489,34,Color("d9ff9e"))
        _label("Keep scores and unlocks when changing builds.",360,536,20,Color("d6e4ff"),544)
        _button(Rect2(96,582,528,88),"export_save","COPY SAVE TO CLIPBOARD",Color("436990"),Color.WHITE,24)
        _label("Paste it into a note before switching apps.",360,706,19,Color("d7e2f1"))
        _button(Rect2(96,748,528,88),"import_save","CONFIRM RESTORE?" if restore_armed else "RESTORE FROM CLIPBOARD",Color("aa6a56") if restore_armed else Color("50657f"),Color.WHITE,21)
        _label("Restore replaces this game's progress.",360,881,20,Color("ffd3b5"))
    _label("Your runs and unlocks save automatically.",360,984,22,Color("d7eab0"))
    _label("Native saves remain separate from older HTML progress.",360,1025,17,Color("c5b8cf"),580)
    _button(Rect2(93,1091,534,83),"back","BACK TO GAME",Color("99e46e"),Color("17313a"),29)

func _draw_collection() -> void:
    _menu_frame("BLOB COLLECTION", "Collect all ten strange little creatures.")
    _label("FOUND %d/10 • %d MERGES • BEST CHAIN x%d" % [maxi(1,int(totals.get("biggest",0))+1),int(totals.get("merges",0)), top_chain],360,337,19,Color("e5ff9c"))
    for i in range(10):
        var col := i % 2
        var row := i / 2
        var x := 71.0 + float(col)*295.0
        var y := 368.0 + float(row)*131.0
        _panel(Rect2(x,y,278,120),Color("293f64"))
        var known: bool = i <= int(totals.get("biggest",0))
        if known:
            _blob(Vector2(x+65,y+61),i,minf(RADII[i]*.62,43.0))
        else:
            _label("?",x+67,y+79,55,Color("8094be"),98)
        _left(NAMES[i] if known else "???",x+121,y+56,25,Color("fff6e1") if known else Color("98a7c2"))
        _left("EVOLUTION %d" % (i+1),x+121,y+92,17,Color("b7c9e6"))
    _button(Rect2(92,1066,536,92),"back","BACK",Color("9ae46b"),Color("182c37"),33)

func _draw_locker() -> void:
    _menu_frame("FACTORY LOCKER", "Every cosmetic earned through gameplay.")
    _panel(Rect2(76,315,568,72),Color("304262"))
    _label("TICKETS %d   •   OCTOBER SWEETS %d" % [tickets,sweets],360,362,24,Color("ffe5a6"))
    _button(Rect2(75,403,275,67),"tab:looks","BLOB LOOKS",Color("5272a4") if featured_shop == "looks" else Color("344565"),Color.WHITE,23)
    _button(Rect2(371,403,273,67),"tab:boards","FACTORY SKINS",Color("5272a4") if featured_shop == "boards" else Color("344565"),Color.WHITE,23)
    var entries := SKIN_NAMES if featured_shop == "looks" else BOARD_NAMES
    var costs := SKIN_COSTS if featured_shop == "looks" else BOARD_COSTS
    var owned := unlocked if featured_shop == "looks" else board_owned
    var current := equipped if featured_shop == "looks" else board_equipped
    var item_start := shop_page * 6
    for local_i in range(mini(6, maxi(0, entries.size() - item_start))):
        var i := item_start + local_i
        var col := local_i % 2
        var row := local_i / 2
        var x := 75.0 + float(col)*295.0
        var y := 489.0 + float(row)*177.0
        _panel(Rect2(x,y,278,165),Color("253958"))
        if featured_shop == "looks":
            _blob(Vector2(x+61,y+60),4 if i < 4 else 6,37,1.0,str(entries[i]))
        else:
            var color := Color("3a4776")
            if i == 1: color = Color("243562")
            elif i == 2: color = Color("b66c9c")
            elif i == 3: color = Color("725177")
            elif i == 4: color = Color("1e507d")
            elif i == 5: color = Color("a54f3a")
            elif i == 6: color = Color("28797d")
            _panel(Rect2(x+19,y+26,84,76),color,Color("b9c9ee"),11)
            if board_textures.has(str(entries[i])):
                draw_texture_rect(board_textures[str(entries[i])],Rect2(x+25,y+31,72,63),false)
        _label(str(entries[i]),x+192,y+45,18,Color("f2eccc"),167)
        var state := "EQUIPPED" if current == entries[i] else ("EQUIP" if owned.has(entries[i]) else ("%d SWEETS" % costs[i] if str(entries[i]) in ["Ghostfire", "Pumpkin Pop", "Ghoulfall"] else "%d TICKETS" % costs[i]))
        _button(Rect2(x+19,y+109,240,48),"buy:%d" % i,state,Color("527f67") if owned.has(entries[i]) else Color("765a83"),Color.WHITE,18)
    if entries.size() > 6:
        _button(Rect2(97,1026,527,58),"next_shop","NEXT PAGE (%d/%d)" % [shop_page + 1, int(ceil(float(entries.size()) / 6.0))],Color("506c9b"),Color.WHITE,21)
    _button(Rect2(97,1103,527,76),"back","BACK",Color("9be36e"),Color("182c37"),27)

func _draw_events() -> void:
    _menu_frame("GHOULFALL", "Every October. Unlocks stay yours forever.")
    _panel(Rect2(75,315,571,152),Color("493256") if _is_halloween() else Color("2c4260"))
    _label("HALLOWEEN  •  %s" % ("LIVE NOW" if _is_halloween() else "RETURNS IN OCTOBER"),360,371,26,Color("ffe8a0"))
    _label("SWEETS: %d    •    %d/4 CLAIMED" % [sweets, _claimed_ghoul_count()],360,418,27,Color("dcffc4"))
    _label("EARN SWEETS BY MERGING • SPEND IN LOCKER",360,451,17,Color("e9dfef"))
    if _is_halloween() and seasonal_art and not low_power:
        var ghost: Texture2D = seasonal_portraits.get("ghost")
        var pumpkin: Texture2D = seasonal_portraits.get("pumpkin")
        if ghost != null:
            draw_texture_rect(ghost,Rect2(82,330,105,105),false)
        if pumpkin != null:
            draw_texture_rect(pumpkin,Rect2(534,330,105,105),false)
    for i in range(4):
        var y := 490.0 + float(i)*137.0
        var value := mini(GHOUL_GOALS[i], int(ghoul_stats[i]))
        _panel(Rect2(75,y,571,127),Color("283d5f"))
        _left(str(GHOUL_TITLES[i]),94,y+34,24,Color("ffe2a0"))
        var sub := ["MERGE 35 BLOBS", "CREATE 10 BIG BLOBS", "USE BOOM 4 TIMES", "SCORE 25,000 IN A RUN"]
        _left(str(sub[i]),94,y+70,19,Color("d1dcef"))
        _left("%d / %d  •  +%d SWEETS" % [value,GHOUL_GOALS[i],GHOUL_REWARDS[i]],94,y+104,18,Color("b7f1bf"))
        var text_now := "CLAIM" if value >= GHOUL_GOALS[i] else "LOCKED"
        if bool(ghoul_claimed[i]): text_now = "CLAIMED"
        _button(Rect2(463,y+40,164,64),"ghoul:%d" % i,text_now,Color("5b8b6a") if text_now == "CLAIM" else Color("435474"),Color.WHITE,19)
    if _is_halloween() and banner_texture != null and seasonal_art and not low_power:
        draw_texture_rect(banner_texture, Rect2(170,1007,390,53),false,Color(1,1,1,.85))
    _label("SECRETS HIDE IN DROPS 13 & 31...",360,1071,20,Color("ffcfaa"))
    _button(Rect2(93,1121,534,72),"back","BACK TO THE CHAOS",Color("9ee671"),Color("173037"),28)

func _claimed_ghoul_count() -> int:
    var result := 0
    for c in ghoul_claimed:
        if bool(c): result += 1
    return result

func _draw_gameover() -> void:
    _menu_frame("BATCH OVERFLOWED!", "Damn. That was close. Another go?")
    _label("YOUR RUN",360,392,29,Color("b6c9e5"))
    _label(_score_text(score),360,499,80,Color("d5ff87"))
    _label("PERSONAL BEST %d" % best,360,559,27,Color("ffdb97"))
    _label("%d DROPS   /   %d MERGES   /   LEVEL %d" % [drops,merges,biggest+1],360,632,23)
    var tip := "MATCH IDENTICAL BLOBS TO CREATE BIGGER ONES!"
    if drops >= 8:
        tip = "SAVE YOUR BOOM FOR A CROWDED PILE!"
    if biggest >= 6:
        tip = "PLAN AHEAD WITH YOUR ON-DECK BLOB!"
    _label(tip,360,713,19,Color("cbdff0"),566)
    _button(Rect2(93,794,534,96),"retry","PLAY AGAIN",Color("9fed76"),Color("142c37"),37)
    _button(Rect2(93,923,534,82),"goals","CLAIM REWARDS")
    _button(Rect2(93,1028,259,82),"home","MAIN MENU")
    _button(Rect2(365,1028,262,82),"copy_score","COPY SCORE",Color("465c8b"),Color.WHITE,23)
    if notice_timer > 0 and notice.begins_with("SCORE COPIED"):
        _label("COPIED! SEND IT TO YOUR FRIENDS",360,1172,20,Color("d9ffab"))

func _achievement_progress(index: int) -> int:
    match index:
        0: return int(totals.get("merges",0))
        1: return int(totals.get("drops",0))
        2: return int(totals.get("booms",0))
        3: return int(totals.get("biggest",0))+1
    return 0

func _draw_goals() -> void:
    _menu_frame("GOALS & REWARDS", "Complete goals, claim tickets, customise your blobs.")
    _button(Rect2(66,312,185,70), "goaltab:0", "DAILY", Color("4a7790") if goals_tab == 0 else Color("283d62"), Color.WHITE,23)
    _button(Rect2(266,312,185,70), "goaltab:1", "WEEKLY", Color("4a7790") if goals_tab == 1 else Color("283d62"), Color.WHITE,23)
    _button(Rect2(466,312,185,70), "goaltab:2", "LIFETIME", Color("4a7790") if goals_tab == 2 else Color("283d62"), Color.WHITE,22)
    if goals_tab == 0:
        _label("FRESH REWARDS EVERY DAY", 360, 434, 29, Color("dcffad"))
        var titles := ["MERGE 10 BLOBS", "DROP 35 BLOBS", "USE BOOM TWICE"]
        for i in range(3):
            var y := 482.0 + float(i)*195.0
            _panel(Rect2(77,y,565,178),Color("253d63"))
            _left(titles[i],100,y+50,27,Color("fff5df"))
            var progress := mini(QUEST_GOALS[i],int(quest_stats[i]))
            _left("%d / %d   +%d TICKETS" % [progress, QUEST_GOALS[i], QUEST_REWARDS[i]],100,y+93,20,Color("d4e0f7"))
            draw_rect(Rect2(100,y+117,360,14),Color("15213c"))
            draw_rect(Rect2(100,y+117,360.0 * float(progress) / float(QUEST_GOALS[i]),14),Color("b1ed79"))
            var status := "CLAIM" if progress >= QUEST_GOALS[i] else "WORKING"
            if bool(quest_claimed[i]): status = "COLLECTED"
            _button(Rect2(474,y+103,147,58),"quest:%d" % i,status,Color("5a886a") if status=="CLAIM" else Color("3c4b70"),Color.WHITE,17)
    elif goals_tab == 1:
        _label("NEW CONTRACTS EACH MONDAY",360,434,28,Color("dcffad"))
        for i in range(3):
            var y := 482.0 + float(i)*195.0
            _panel(Rect2(77,y,565,178),Color("263c60"))
            _left(WEEKLY_NAMES[i],100,y+50,27,Color("fff5df"))
            var progress := mini(WEEKLY_GOALS[i],int(weekly_stats[i]))
            _left("%d / %d   +%d TICKETS" % [progress, WEEKLY_GOALS[i], WEEKLY_REWARDS[i]],100,y+93,20,Color("d4e0f7"))
            draw_rect(Rect2(100,y+117,360,14),Color("15213c"))
            draw_rect(Rect2(100,y+117,360.0 * float(progress) / float(WEEKLY_GOALS[i]),14),Color("ffd783"))
            var status := "CLAIM" if progress >= WEEKLY_GOALS[i] else "WORKING"
            if bool(weekly_claimed[i]): status = "COLLECTED"
            _button(Rect2(474,y+103,147,58),"weekly:%d" % i,status,Color("638762") if status=="CLAIM" else Color("3c4b70"),Color.WHITE,17)
    else:
        _label("EVERY MILESTONE IS YOURS TO KEEP",360,431,24,Color("dcffad"))
        var titles := ["100 MERGES", "300 DROPS", "20 BOOMS", "FIND LEVEL 8"]
        for i in range(4):
            var y := 465.0 + float(i)*151.0
            _panel(Rect2(77,y,565,135),Color("263c60"))
            _left(titles[i],100,y+47,27,Color("fff5df"))
            var progress := mini(ACHIEVEMENT_GOALS[i],_achievement_progress(i))
            _left("%d / %d" % [progress,ACHIEVEMENT_GOALS[i]],100,y+91,22,Color("d4e0f7"))
            var status := "CLAIM +%d" % (75+i*30) if progress >= ACHIEVEMENT_GOALS[i] else "LOCKED"
            if achievements_claimed.has(i): status = "COLLECTED"
            _button(Rect2(413,y+52,208,66),"ach:%d" % i,status,Color("658764") if status.begins_with("CLAIM") else Color("3c4b70"),Color.WHITE,18)
        _label("FACTORY RANK: %s" % _factory_rank_label(),360,1101,23,Color("ffe1ac"))
    _label("REWARDS ARE EARNED, NEVER PURCHASED",360,1102 if goals_tab != 2 else 1150,18,Color("c6ddf2"))
    _button(Rect2(92,1163,535,58),"back","BACK",Color("97e56b"),Color("172e3c"),25)

func _pointer(event_position: Vector2) -> Vector2:
    var size := get_viewport_rect().size
    var sc := minf(size.x / WIDTH, size.y / HEIGHT)
    var offset := (size - Vector2(WIDTH, HEIGHT) * sc) * .5
    return (event_position - offset) / sc

func _input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        var pos := _pointer(event.position)
        if event.pressed:
            _touch_down(pos, event.index)
        else:
            _touch_up(pos, event.index)
    elif event is InputEventScreenDrag and active_pointer == event.index and aiming:
        aim_x = clampf(_pointer(event.position).x, LEFT + 27, RIGHT - 27)
    elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        var pos := _pointer(event.position)
        if event.pressed:
            _touch_down(pos, -1)
        else:
            _touch_up(pos, -1)
    elif event is InputEventMouseMotion and active_pointer == -1 and aiming:
        aim_x = clampf(_pointer(event.position).x, LEFT + 27, RIGHT - 27)
    elif event is InputEventKey and event.pressed and not event.echo:
        if event.keycode == KEY_ESCAPE or event.keycode == KEY_P:
            _activate("pause" if screen == "game" else "back")
        elif screen == "game":
            if event.keycode == KEY_LEFT:
                aim_x = maxf(LEFT + 28, aim_x - 40)
            elif event.keycode == KEY_RIGHT:
                aim_x = minf(RIGHT - 28, aim_x + 40)
            elif event.keycode == KEY_ENTER:
                _drop(aim_x)
            elif event.keycode == KEY_SPACE or event.keycode == KEY_B:
                _boom()
    queue_redraw()

func _touch_down(pos: Vector2, pointer_id: int) -> void:
    # Never allow a second finger to drop a blob or buy something accidentally.
    if active_pointer != -999:
        return
    active_pointer = pointer_id
    for i in range(buttons.size() - 1, -1, -1):
        var hit_rect: Rect2 = buttons[i]["rect"]
        if hit_rect.has_point(pos):
            pressed_button = str(buttons[i].id)
            pressed_rect = hit_rect
            return
    if screen == "game" and pos.x >= LEFT and pos.x <= RIGHT and pos.y >= TOP and pos.y <= FLOOR:
        aiming = true
        aim_x = clampf(pos.x, LEFT + 27, RIGHT - 27)
        # Initialize hold-to-drop
        hold_drop_timer = 0.0
        hold_drop_count = 0

func _touch_up(pos: Vector2, pointer_id: int) -> void:
    if active_pointer != pointer_id:
        return
    active_pointer = -999
    if pressed_button != "":
        var chosen := pressed_button
        var valid := pressed_rect.has_point(pos)
        pressed_button = ""
        if valid:
            if not low_motion and not low_power:
                if ui_tap_rings.size() >= 7:
                    ui_tap_rings.pop_front()
                ui_tap_rings.append({"pos": pos, "age": 0.0})
            _activate(chosen)
        return
    if aiming:
        aiming = false
        hold_drop_timer = 0.0
        hold_drop_count = 0
        if pos.x >= LEFT and pos.x <= RIGHT and pos.y >= TOP - 15 and pos.y <= FLOOR + 18:
            _drop(clampf(pos.x, LEFT + 27, RIGHT - 27))

func _activate(id: String) -> void:
    if id in ["back", "pause", "home"]:
        _play_sfx("ui_back")
        _play_kenney_ui("back")
    elif id in ["normal", "daily", "retry", "resume", "locker", "settings", "events", "collection", "goals", "help"]:
        _play_sfx("ui_open")
        _play_kenney_ui("open")
    elif id == "boom":
        pass  # BOOM plays its own sound once it is legitimately activated.
    elif id.begins_with("tab:") or id.begins_with("goaltab:") or id in ["audio", "visual", "data", "next_shop"]:
        _play_sfx("ui_switch")
        _play_kenney_ui("switch")
    else:
        _play_sfx("ui_tap")
        _play_kenney_ui("click")
    if id == "normal" or id == "daily":
        _change_mode(id)
    elif id == "resume":
        screen = "game"
    elif id == "pause":
        screen = "pause"
        _flush_save()
    elif id == "boom":
        _boom()
    elif id == "next":
        notice = "DRAG YOUR FINGER ACROSS THE BOX TO AIM!"
        notice_timer = 2.5
    elif id == "copy_score":
        var share_text := "I scored %d in PLOPQUAKE! (%d merges, level %d/10). Can you beat me?" % [score, merges, biggest + 1]
        DisplayServer.clipboard_set(share_text)
        notice = "SCORE COPIED! PASTE IT TO YOUR FRIENDS."
        notice_timer = 3.3
        _play_sfx("ui_confirm")
    elif id == "retry":
        _new_game(false)
        screen = "game"
    elif id == "home":
        _save_all()
        _flush_save()
        screen = "home"
    elif id == "back":
        restore_armed = false
        screen = back_screen if back_screen in ["home", "pause", "game"] else "pause"
    elif id in ["collection", "settings", "locker", "events", "goals", "help", "credits"]:
        if id == "help":
            first_help_seen = true
        back_screen = screen
        screen = id
    elif id == "audio":
        settings_tab = 0
        restore_armed = false
    elif id == "visual":
        settings_tab = 1
        restore_armed = false
    elif id == "data":
        settings_tab = 2
    elif id == "export_save":
        _copy_save_to_clipboard()
    elif id == "import_save":
        if restore_armed:
            _restore_save_from_clipboard()
        else:
            restore_armed = true
            notice = "RESTORE WILL REPLACE THIS COPY — TAP AGAIN"
            notice_timer = 4.0
    elif id == "sound":
        sound_on = not sound_on
    elif id == "motion":
        low_motion = not low_motion
    elif id == "guide":
        show_guide = not show_guide
    elif id == "contrast":
        high_contrast = not high_contrast
    elif id == "seasonal":
        seasonal_art = not seasonal_art
    elif id == "power":
        low_power = not low_power
    elif id == "haptic":
        haptics = not haptics
    elif id == "music":
        music_on = not music_on
        if not music_on:
            soundtrack.stream_paused = true
            music_player.stop()
        elif screen in ["home", "game"] and not gameover:
            soundtrack.play()
    elif id == "music_vol":
        if music_volume > .95:
            music_volume = .25
        else:
            music_volume = minf(1.0, music_volume + .25)
        soundtrack.volume_db = linear_to_db(maxf(0.02, music_volume)) - 20.0
        music_player.volume_db = linear_to_db(maxf(0.02, music_volume)) - 6.0
        _play_sfx("plop")
    elif id == "vol":
        if sound_volume > .95:
            sound_volume = .25
        else:
            sound_volume = minf(1.0, sound_volume + .25)
        _play_sfx("plop")
    elif id.begins_with("tab:"):
        featured_shop = id.get_slice(":",1)
        shop_page = 0
    elif id == "next_shop":
        var item_count := SKIN_NAMES.size() if featured_shop == "looks" else BOARD_NAMES.size()
        shop_page = (shop_page + 1) % int(ceil(float(item_count) / 6.0))
    elif id.begins_with("goaltab:"):
        goals_tab = clampi(int(id.get_slice(":", 1)), 0, 2)
    elif id.begins_with("weekly:"):
        var idx := int(id.get_slice(":",1))
        if idx >= 0 and idx < WEEKLY_GOALS.size() and not bool(weekly_claimed[idx]) and int(weekly_stats[idx]) >= WEEKLY_GOALS[idx]:
            weekly_claimed[idx] = true
            tickets += WEEKLY_REWARDS[idx]
            notice = "WEEKLY CONTRACT DONE! +%d TICKETS" % WEEKLY_REWARDS[idx]
            notice_timer = 3.2
            _play_sfx("reward")
        else:
            notice = "NOT READY — KEEP WORKING ON YOUR WEEKLY GOAL"
            notice_timer = 2.6
            _play_sfx("ui_error")
    elif id.begins_with("ghoul:"):
        var idx := int(id.get_slice(":", 1))
        if _is_halloween() and idx >= 0 and idx < 4 and not bool(ghoul_claimed[idx]) and int(ghoul_stats[idx]) >= GHOUL_GOALS[idx]:
            ghoul_claimed[idx] = true
            sweets += GHOUL_REWARDS[idx]
            notice = "GHOULFALL REWARD: +%d SWEETS" % GHOUL_REWARDS[idx]
            notice_timer = 3.0
            _play_sfx("reward")
        else:
            notice = "NOT READY — COMPLETE THE EVENT CHALLENGE"
            notice_timer = 2.6
            _play_sfx("ui_error")
    elif id.begins_with("quest:"):
        var idx := int(id.get_slice(":",1))
        if idx >= 0 and idx < 3 and not bool(quest_claimed[idx]) and int(quest_stats[idx]) >= QUEST_GOALS[idx]:
            quest_claimed[idx] = true
            tickets += QUEST_REWARDS[idx]
            notice = "REWARD CLAIMED! +%d TICKETS" % QUEST_REWARDS[idx]
            notice_timer = 3.0
            _play_sfx("reward")
        else:
            notice = "NOT READY — COMPLETE THE DAILY MISSION"
            notice_timer = 2.6
            _play_sfx("ui_error")
    elif id.begins_with("ach:"):
        var idx := int(id.get_slice(":",1))
        var goals := [100,300,20,8]
        if idx >= 0 and idx < 4 and not achievements_claimed.has(idx) and _achievement_progress(idx) >= goals[idx]:
            achievements_claimed.append(idx)
            tickets += 75 + idx*30
            notice = "PERMANENT ACHIEVEMENT CLAIMED!"
            notice_timer = 3.0
            _play_sfx("reward")
        else:
            notice = "NOT READY — KEEP MERGING TO UNLOCK IT"
            notice_timer = 2.6
            _play_sfx("ui_error")
    elif id.begins_with("buy:"):
        var idx := int(id.get_slice(":",1))
        var names := SKIN_NAMES if featured_shop == "looks" else BOARD_NAMES
        var costs := SKIN_COSTS if featured_shop == "looks" else BOARD_COSTS
        var owned := unlocked if featured_shop == "looks" else board_owned
        if idx >= 0 and idx < names.size():
            var chosen := str(names[idx])
            var cost := int(costs[idx])
            var seasonal := chosen in ["Ghostfire", "Pumpkin Pop", "Ghoulfall"]
            if owned.has(chosen) or ((sweets if seasonal else tickets) >= cost and (not seasonal or _is_halloween())):
                if not owned.has(chosen):
                    if seasonal: sweets -= cost
                    else: tickets -= cost
                    owned.append(chosen)
                    notice = "UNLOCKED: %s" % chosen
                    notice_timer = 3.0
                if featured_shop == "looks":
                    equipped = chosen
                else:
                    board_equipped = chosen
                _play_sfx("reward")
            else:
                var shortage := cost - (sweets if seasonal else tickets)
                if seasonal and not _is_halloween():
                    notice = "THIS LOOK RETURNS IN OCTOBER!"
                else:
                    notice = "NEED %d MORE %s" % [maxi(0, shortage), "SWEETS" if seasonal else "TICKETS"]
                notice_timer = 2.9
                _play_sfx("ui_error")
    elif id.begins_with("skin:"):
        var skin_index := int(id.get_slice(":", 1))
        var all_skins := ["Classic", "Night Glow", "Candy Pop", "Ghostfire"]
        if skin_index < 0 or skin_index >= all_skins.size():
            return
        var chosen: String = all_skins[skin_index]
        var costs := [0, 60, 120, 90]
        var cost: int = costs[skin_index]
        if unlocked.has(chosen):
            equipped = chosen
            _play_sfx("reward")
        elif chosen == "Ghostfire":
            if sweets >= cost:
                sweets -= cost
                unlocked.append(chosen)
                equipped = chosen
                _play_sfx("reward")
        elif tickets >= cost:
            tickets -= cost
            unlocked.append(chosen)
            equipped = chosen
            _play_sfx("reward")
    _save_all()
    queue_redraw()

func _notification(what: int) -> void:
    # Android application pause: persist the run and cancel dangling drag gestures.
    if what == 2013 or what == 1006:
        aiming = false
        active_pointer = -999
        pressed_button = ""
        _save_all()
        _flush_save()
    elif what == 2014:
        _ensure_current_day()
        _ensure_weekly()
        _ensure_ghoul_year()
        pass
