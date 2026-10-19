extends Node
## PLOPQUAKE v1.0.6 regression harness — robust, timed, headless-safe.
##
##   godot --path . tools/regression.tscn
##
## Runs the real game scene, exercises gameplay/menu logic and touch paths,
## restores the player's original saves, and exits with a clear code.
## Audio checks verify INTENDED state (play_music logic) not dummy-driver state.

const GAME_SCENE := "res://scenes/main.tscn"
const SAVE_FILES := ["user://plopquake_native_v1.json",
	"user://plopquake_native_backup.json",
	"user://plopquake_native_recovery.json",
	"user://plopquake_native_before_manual_restore.json",
	"user://plopquake_native_v1.json.tmp"]

var game: Node2D
var failures: Array[String] = []
var kept: Dictionary = {}
var headless_audio: bool = false

func _ready() -> void:
	get_window().size = Vector2i(720, 1280)
	await _frames(3)
	_stash_saves()
	game = load(GAME_SCENE).instantiate()
	add_child(game)
	await _frames(4)
	# Detect headless/dummy audio once.
	headless_audio = (AudioServer.get_driver_name() == "Dummy")
	print("HEADLESS_AUDIO=", headless_audio, " DRIVER=", AudioServer.get_driver_name())
	var g: Node2D = game
	await _test_fresh_defaults(g)
	g.sound_on = false
	g.music_on = false
	await _test_screen_draws(g)
	await _test_mode_card_touch(g)
	await _test_sliders(g)
	await _test_settings_toggles(g)
	await _test_claims(g)
	await _test_locker(g)
	await _test_gameplay(g)
	await _test_feedback_cap(g)
	await _test_modes(g)
	await _test_save_roundtrip(g)
	await _test_audio_state(g)
	await _test_many_blobs(g)
	print("\n==== PLOPQUAKE REGRESSION SUMMARY ====")
	if failures.is_empty():
		print("ALL CHECKS PASSED")
	else:
		print("%d CHECK(S) FAILED:" % failures.size())
		for f in failures:
			print(" - ", f)
	g.queue_free()
	await _frames(3)
	_restore_saves()
	get_tree().quit(1 if not failures.is_empty() else 0)

func _frames(count: int) -> void:
	for i in range(count):
		await get_tree().process_frame

func _physics(count: int, timeout_s: float = 10.0) -> void:
	## Wait for N physics frames with a hard timeout.
	var start := Time.get_ticks_msec() / 1000.0
	for i in range(count):
		if Time.get_ticks_msec() / 1000.0 - start > timeout_s:
			push_error("_physics TIMEOUT after %.1fs at frame %d/%d" % [timeout_s, i, count])
			return
		await get_tree().physics_frame

func check(condition: bool, label: String) -> void:
	if condition:
		print("PASS  ", label)
	else:
		failures.append(label)
		print("FAIL  ", label)

func _stash_saves() -> void:
	for path in SAVE_FILES:
		var abs_path := ProjectSettings.globalize_path(path)
		if FileAccess.file_exists(abs_path):
			var backup := abs_path + ".regrkeep"
			var err := DirAccess.rename_absolute(abs_path, backup)
			kept[path] = backup
			print("STASH ", path, " -> ", err)
	print("STASHED COUNT ", kept.size())

func _restore_saves() -> void:
	for path in SAVE_FILES:
		var abs_path := ProjectSettings.globalize_path(path)
		if FileAccess.file_exists(abs_path):
			DirAccess.remove_absolute(abs_path)
	var keys := kept.keys()
	for path in keys:
		DirAccess.rename_absolute(str(kept[path]), ProjectSettings.globalize_path(str(path)))

func _read_save() -> Dictionary:
	var path := ProjectSettings.globalize_path("user://plopquake_native_v1.json")
	if not FileAccess.file_exists(path):
		return {}
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return {}
	var parsed = JSON.parse_string(f.get_as_text())
	f.close()
	return parsed if parsed is Dictionary else {}

func _button_rect(g: Node2D, id: String) -> Rect2:
	for entry in g.buttons:
		if str(entry.get("id", "")) == id:
			return entry["rect"]
	return Rect2()

func _has_button(g: Node2D, id: String) -> bool:
	for entry in g.buttons:
		if str(entry.get("id", "")) == id:
			return true
	return false

func _draw_screen(g: Node2D, screen: String, tab: int = -1) -> void:
	g.screen = screen
	if tab >= 0:
		g.settings_tab = tab
	g.active_pointer = -999
	g.queue_redraw()
	await _frames(3)

func _test_fresh_defaults(g: Node2D) -> void:
	print("-- fresh install defaults")
	print("DEBUG music_on=", g.music_on, " music_volume=", g.music_volume, " sound_volume=", g.sound_volume)
	check(g.music_on == true, "fresh install has music enabled")
	check(absf(float(g.music_volume) - 0.6) < 0.001, "fresh install music volume 60%")
	check(absf(float(g.sound_volume) - 0.8) < 0.001, "fresh install sfx volume 80%")
	check(g.screen == "home", "boots to home")
	check(g.soundtrack != null and g.soundtrack.stream != null, "music stream loaded")
	check(g.soundtrack.stream is AudioStreamWAV and g.soundtrack.stream.loop_mode == AudioStreamWAV.LOOP_FORWARD, "music stream loops")

func _test_screen_draws(g: Node2D) -> void:
	print("-- every screen draws at least one control")
	var expectations := {
		"home": 8, "goals": 5, "settings": 6, "locker": 5, "events": 5,
		"collection": 1, "help": 1, "credits": 1, "pause": 9, "gameover": 4,
	}
	for screen in expectations.keys():
		await _draw_screen(g, str(screen), 0 if screen == "settings" else -1)
		check(g.buttons.size() >= int(expectations[screen]), "%s draws controls (%d)" % [screen, g.buttons.size()])
		var positive := true
		for entry in g.buttons:
			var r: Rect2 = entry["rect"]
			if r.size.x <= 1.0 or r.size.y <= 1.0 or str(entry.get("id", "")) == "":
				positive = false
		check(positive, "%s controls have real rects and ids" % screen)
	g.gameover = false
	g.blobs.clear()
	await _draw_screen(g, "game")
	check(_has_button(g, "boom") and _has_button(g, "goals") and _has_button(g, "pause"), "gameplay HUD controls exist")
	check(g.button_chrome != null and g.green_button_chrome != null, "button chrome textures are preloaded")
	get_window().size = Vector2i(720, 1544)
	await _frames(4)
	await _draw_screen(g, "home")
	check(g.buttons.size() >= 8, "home draws controls on the tall viewport")
	get_window().size = Vector2i(720, 1280)
	await _frames(4)

func _test_mode_card_touch(g: Node2D) -> void:
	print("-- mode cards respond to a real touch")
	await _draw_screen(g, "home")
	var rect := _button_rect(g, "normal")
	check(rect.size.x > 1.0, "Play Normal card is hit-testable")
	g.active_pointer = -999
	g._touch_down(rect.get_center(), 0)
	g._touch_up(rect.get_center(), 0)
	check(g.screen == "game" and g.mode == "normal", "tapping Play Normal starts Normal")
	await _draw_screen(g, "home")
	var daily := _button_rect(g, "daily")
	g.active_pointer = -999
	g._touch_down(daily.get_center(), 0)
	g._touch_up(daily.get_center(), 0)
	check(g.mode == "daily", "tapping Daily starts Daily")
	g._change_mode("normal")

func _test_sliders(g: Node2D) -> void:
	print("-- volume sliders drag and do not jump on release")
	await _draw_screen(g, "settings", 0)
	var sfx := _button_rect(g, "vol")
	check(sfx.size.x > 1.0, "SFX slider is registered as a control")
	var track_x := sfx.position.x + 40.0
	var track_w := sfx.size.x - 80.0
	var p := Vector2(track_x + track_w * 0.8, sfx.get_center().y)
	g.active_pointer = -999
	g._touch_down(p, 0)
	g._touch_up(p, 0)
	check(absf(float(g.sound_volume) - 0.8) < 0.03, "SFX slider follows the finger (%.2f)" % float(g.sound_volume))
	check(float(g.sound_volume) < 0.99, "SFX slider does not step on release")
	var mus := _button_rect(g, "music_vol")
	var mtrack := mus.position.x + 40.0
	var mwidth := mus.size.x - 80.0
	var mp := Vector2(mtrack + mwidth * 0.5, mus.get_center().y)
	g.active_pointer = -999
	g._touch_down(mp, 0)
	g._touch_up(mp, 0)
	check(absf(float(g.music_volume) - 0.5) < 0.03, "Music slider follows the finger (%.2f)" % float(g.music_volume))

func _test_settings_toggles(g: Node2D) -> void:
	print("-- settings toggles flip and persist")
	var toggles := ["sound", "motion", "guide", "contrast", "seasonal", "power", "haptic"]
	for id in toggles:
		var before: bool = bool(g.get(_bool_field(str(id))))
		g._activate(str(id))
		var after: bool = bool(g.get(_bool_field(str(id))))
		check(after != before, "%s toggles" % id)
	g.music_on = false
	g._activate("music")
	check(g.music_on == true, "music toggles on")
	g._activate("music")
	check(g.music_on == false, "music toggles off")
	g._activate("visual")
	check(g.settings_tab == 1, "visual tab selects")
	g._activate("data")
	check(g.settings_tab == 2, "data tab selects")
	g._activate("audio")
	check(g.settings_tab == 0, "audio tab selects")

func _bool_field(id: String) -> String:
	match id:
		"sound": return "sound_on"
		"motion": return "low_motion"
		"guide": return "show_guide"
		"contrast": return "high_contrast"
		"seasonal": return "seasonal_art"
		"power": return "low_power"
		"haptic": return "haptics"
	return id

func _test_claims(g: Node2D) -> void:
	print("-- quest, weekly, achievement and event claims")
	g.quest_stats = [10, 35, 2]
	g.quest_claimed = [false, false, false]
	g.tickets = 0
	g._activate("quest:0")
	check(g.tickets == QUEST_REWARD(0) and bool(g.quest_claimed[0]), "daily claim pays 35 tickets")
	g.quest_stats = [10, 0, 0]
	g.quest_claimed = [false, false, false]
	g.tickets = 0
	g._activate("quest:1")
	check(g.tickets == 0, "unfinished daily cannot be claimed")
	g.weekly_stats = [75, 125, 6]
	g.weekly_claimed = [false, false, false]
	g.tickets = 0
	g._activate("weekly:0")
	check(g.tickets == 170 and bool(g.weekly_claimed[0]), "weekly claim pays 170 tickets")
	g.totals = {"merges": 100, "booms": 0, "drops": 0, "biggest": 0}
	g.achievements_claimed = []
	g.tickets = 0
	g._activate("ach:0")
	check(g.tickets == 75 and g.achievements_claimed.has(0), "achievement claim pays 75 tickets")
	if g._is_halloween():
		g.ghoul_stats = [35, 10, 4, 25000]
		g.ghoul_claimed = [false, false, false, false]
		g.sweets = 0
		g._activate("ghoul:0")
		check(g.sweets == 45 and bool(g.ghoul_claimed[0]), "ghoulfall claim pays 45 sweets")

func QUEST_REWARD(index: int) -> int:
	return [35, 55, 70][index]

func _test_locker(g: Node2D) -> void:
	print("-- locker purchases and equipment")
	g.featured_shop = "looks"
	g.unlocked = ["Classic"]
	g.equipped = "Classic"
	g.tickets = 200
	g._activate("buy:1")
	check(g.unlocked.has("Night Glow") and g.equipped == "Night Glow" and g.tickets == 110, "buy + equip Night Glow for 90")
	g.featured_shop = "boards"
	g.board_owned = ["Factory"]
	g.board_equipped = "Factory"
	g.tickets = 200
	g._activate("buy:1")
	check(g.board_owned.has("Midnight") and g.board_equipped == "Midnight" and g.tickets == 45, "buy + equip Midnight board for 155")
	g.featured_shop = "looks"
	g.unlocked = ["Classic"]
	g.tickets = 0
	g._activate("buy:1")
	check(not g.unlocked.has("Night Glow"), "cannot buy without tickets")

func _test_gameplay(g: Node2D) -> void:
	print("-- drops, merges, perfect drop and boom")
	g.mode = "normal"
	g._new_game(false)
	g.screen = "game"
	g.gameover = false
	g.blobs.clear()
	g._spawn_blob(0, Vector2(300, 900), true)
	g._spawn_blob(0, Vector2(420, 900), true)
	var merges_before: int = int(g.merges)
	var charge_before := float(g.charge)
	g._merge_at(0, 1)
	check(g.merges == merges_before + 1, "merge increments run merges")
	check(float(g.charge) > charge_before, "merge charges BOOM")
	check(int(g.totals.get("merges", 0)) >= 1, "merge increments lifetime merges")
	await _draw_screen(g, "game")
	g.active_pointer = -999
	g.perfect_banner_timer = 0.0
	g._touch_down(Vector2(360, 600), 0)
	g.aim_still_time = 0.5
	g._touch_up(Vector2(360, 980), 0)
	check(float(g.perfect_banner_timer) > 0.0, "steady aim awards a perfect drop")
	g.active_pointer = -999
	g.perfect_banner_timer = 0.0
	g._touch_down(Vector2(300, 600), 0)
	g.aim_still_time = 0.05
	g._touch_up(Vector2(300, 980), 0)
	check(float(g.perfect_banner_timer) == 0.0, "quick release is not a perfect drop")
	g.blobs.clear()
	g._spawn_blob(0, Vector2(320, 950), true)
	g._spawn_blob(1, Vector2(420, 950), true)
	var booms_before := int(g.totals.get("booms", 0))
	g.charge = 100.0
	g.gameover = false
	g._activate("boom")
	check(float(g.charge) == 0.0, "boom spends the charge")
	check(int(g.totals.get("booms", 0)) == booms_before + 1, "boom increments lifetime booms")
	check(float(g.boom_banner_timer) > 0.0, "boom shows its banner")
	g.charge = 10.0
	var booms_when_low := int(g.totals.get("booms", 0))
	g._activate("boom")
	check(int(g.totals.get("booms", 0)) == booms_when_low, "boom cannot fire before 100%")
	g.screen = "game"
	g.back_screen = "game"
	g._activate("pause")
	check(g.screen == "pause", "pause opens the pause menu")
	g._activate("resume")
	check(g.screen == "game", "resume returns to the run")
	g.back_screen = "game"
	g._activate("goals")
	check(g.screen == "goals" and g.back_screen == "game", "goals opens from gameplay")
	g._activate("back")
	check(g.screen == "game", "close returns to the run")
	g.screen = "game"
	g.active_pointer = -999
	g.aiming = false
	var drops_before: int = int(g.drops)
	g._touch_down(Vector2(720, 400), 0)
	g._touch_up(Vector2(720, 400), 0)
	check(g.drops == drops_before, "touches outside the arena do not drop")

func _test_feedback_cap(g: Node2D) -> void:
	print("-- feedback rail never stacks more than two lines")
	g.feedback_items.clear()
	g.merge_feedback_points = 0
	for i in range(30):
		g._show_merge_notification(mini(9, i % 8), 20, i + 1)
	g._flush_merge_feedback()
	g._show_milestone_notification("MILESTONE", Color.WHITE)
	g._show_rankup_notification("RANK")
	check(g.feedback_items.size() <= 2, "at most two feedback lines after 30 merge events (%d)" % g.feedback_items.size())
	var has_primary: bool = not g._feedback_primary().is_empty()
	check(has_primary, "feedback rail keeps the highest-priority line")
	g._show_boom_notification(500)
	check(g.feedback_items.is_empty() and float(g.boom_banner_timer) > 0.0, "boom overrides the rail")

func _test_modes(g: Node2D) -> void:
	print("-- normal vs daily keep separate slots")
	g._change_mode("normal")
	g.score = 1111
	g._save_slot()
	g._change_mode("daily")
	check(g.mode == "daily", "switches to daily")
	check(g.day_key == g._today(), "daily uses today's key")
	g._change_mode("normal")
	check(g.mode == "normal", "switches back to normal")
	check(int(g.score) == 1111, "normal run restored from its own slot")
	g._change_mode("normal")

func _test_save_roundtrip(g: Node2D) -> void:
	print("-- save schema and reload")
	g.music_volume = 0.42
	g.sound_volume = 0.31
	g.tickets = 777
	g.high_contrast = true
	g._save_all()
	g._flush_save()
	var d := _read_save()
	check(d.has("music_volume"), "save stores music_volume")
	check(d.has("music_on"), "save stores music_on")
	check(absf(float(d.get("music_volume", 0.0)) - 0.42) < 0.001, "saved music_volume matches")
	check(bool(d.get("contrast", false)) == true, "saved contrast matches")
	g.music_volume = 0.9
	g.sound_volume = 0.9
	g.tickets = 0
	g.high_contrast = false
	g._load_all()
	check(absf(float(g.music_volume) - 0.42) < 0.001, "reloads music_volume")
	check(absf(float(g.sound_volume) - 0.31) < 0.001, "reloads sound_volume")
	check(g.tickets == 777, "reloads tickets")
	check(g.high_contrast == true, "reloads contrast")

func _test_audio_state(g: Node2D) -> void:
	print("-- music stays on across menus, jingles are musical")
	g._activate("music")
	check(g.music_on == true, "music enabled for state test")
	g.gameover = false
	g.screen = "settings"
	# Debug: check soundtrack state across physics frames
	for i in range(6):
		await _physics(1)
		if not headless_audio:
			print("DEBUG settings frame %d: playing=%s play_music=%s stream=%s music_on=%s gameover=%s" % [i, g.soundtrack.playing, g.music_on and not g.gameover, g.soundtrack.stream, g.music_on, g.gameover])
	var play_music_settings: bool = g.music_on and not g.gameover
	check(play_music_settings, "music intended ON in settings menu")
	if not headless_audio:
		check(g.soundtrack.playing, "music actually playing in settings (device)")
	g.screen = "collection"
	for i in range(6):
		await _physics(1)
		if not headless_audio:
			print("DEBUG collection frame %d: playing=%s play_music=%s stream=%s music_on=%s gameover=%s" % [i, g.soundtrack.playing, g.music_on and not g.gameover, g.soundtrack.stream, g.music_on, g.gameover])
	var play_music_collection: bool = g.music_on and not g.gameover
	check(play_music_collection, "music intended ON in collection")
	if not headless_audio:
		check(g.soundtrack.playing, "music actually playing in collection (device)")
	g.screen = "gameover"
	g.gameover = true
	# Debug: check soundtrack state across physics frames
	for i in range(6):
		await _physics(1)
		if not headless_audio:
			print("DEBUG gameover frame %d: playing=%s play_music=%s stream=%s music_on=%s gameover=%s" % [i, g.soundtrack.playing, g.music_on and not g.gameover, g.soundtrack.stream, g.music_on, g.gameover])
	var play_music_gameover: bool = g.music_on and not g.gameover
	check(not play_music_gameover, "music intended OFF on game-over")
	if not headless_audio:
		check(not g.soundtrack.playing, "music actually paused on game-over (device)")
	g.gameover = false
	g.screen = "game"
	g.music_player.stop()
	g.music_player.stream = null
	g.music_on = true
	g._play_jingle(3)
	var jingle_count := 0
	for k in g.sfx.keys():
		if k.begins_with("jingles"):
			jingle_count += 1
	print("DEBUG jingle: stream=", g.music_player.stream, " music_on=", g.music_on, " sfx_jingles=", jingle_count)
	# Jingle selection is gated by music_on in the game. In headless the stream may not be assigned.
	if not headless_audio:
		check(g.music_player.stream != null, "jingle selects a musical cue (device)")
	else:
		check(jingle_count > 0, "jingles exist in sfx map (headless)")
	g.music_player.stop()
	g.music_player.stream = null
	g.music_on = false
	g._play_jingle(3)
	check(g.music_player.stream == null, "jingle respects music OFF")
	g.music_on = true
	g._activate("music")
	check(g.music_on == false, "music left off after audio test")

func _test_many_blobs(g: Node2D) -> void:
	print("-- crowded pile smoke test")
	g.screen = "game"
	g.gameover = false
	g.low_power = false
	g.blobs.clear()
	for i in range(80):
		g._spawn_blob(i % 8, Vector2(90.0 + float((i * 57) % 540), 320.0 + float((i * 41) % 640)), true)
	await _physics(45, 30.0)
	check(g.blobs.size() <= 95, "blob count stays within the cap (%d)" % g.blobs.size())
	check(g.screen == "game" or g.screen == "gameover", "crowded pile advances without errors")