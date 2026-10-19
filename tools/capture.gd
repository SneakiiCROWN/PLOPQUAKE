extends Node
## Development screenshot harness for PLOPQUAKE v1.0.6.
## Run with:
##   godot --path . tools/capture.tscn --resolution 720x1544
## Screenshots are written to res://builds/screenshots_v1.0.6/.

const OUT_DIR := "res://builds/screenshots_v1.0.6"

var game: Node2D

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT_DIR))
	# Capture at the design resolution, then switch to the S23 Ultra aspect.
	get_window().size = Vector2i(720, 1280)
	for i in range(3):
		await get_tree().process_frame
	game = load("res://scenes/main.tscn").instantiate()
	add_child(game)
	await get_tree().process_frame
	await get_tree().process_frame

	# Stable showcase state, never written to a real player save.
	game.best = 48250
	game.totals = {"merges": 380, "booms": 14, "drops": 512, "biggest": 6}
	game.tickets = 1420
	game.sweets = 88
	game.music_on = true
	game.top_chain = 22
	game.quest_stats = [10, 35, 2]
	game.weekly_stats = [75, 125, 6]
	game.ghoul_stats = [35, 10, 4, 25000]
	game.achievements_claimed = []
	game.unlocked = ["Classic", "Night Glow", "Candy Pop", "Ghostfire", "Comet Trail"]
	game.board_owned = ["Factory", "Midnight", "Candy Lab", "Ghoulfall"]
	game.equipped = "Candy Pop"
	game.board_equipped = "Factory"
	game.notice = ""
	game.notice_timer = 0.0

	await _shot("01_home", func(): game.screen = "home")

	game.goals_tab = 0
	await _shot("02_goals_daily", func(): game.screen = "goals")
	game.goals_tab = 1
	await _shot("03_goals_weekly", func(): game.screen = "goals")
	game.goals_tab = 2
	await _shot("04_goals_lifetime", func(): game.screen = "goals")

	game.settings_tab = 0
	await _shot("05_settings_audio", func(): game.screen = "settings")
	game.settings_tab = 1
	await _shot("06_settings_visual", func(): game.screen = "settings")
	game.settings_tab = 2
	await _shot("07_settings_data", func(): game.screen = "settings")

	game.featured_shop = "looks"
	game.shop_page = 0
	await _shot("08_locker_looks", func(): game.screen = "locker")
	game.featured_shop = "boards"
	game.shop_page = 0
	await _shot("09_locker_boards", func(): game.screen = "locker")

	await _shot("10_events", func(): game.screen = "events")
	await _shot("11_collection", func(): game.screen = "collection")
	await _shot("12_help", func(): game.screen = "help")
	await _shot("13_credits", func(): game.screen = "credits")

	# Gameplay arena with a believable pile.
	game.screen = "game"
	game.mode = "normal"
	game.score = 18240
	game.best = maxi(game.best, game.score)
	game.drops = 64
	game.merges = 91
	game.biggest = 6
	game.charge = 72.0
	game.next_tier = 1
	game.deck_tier = 0
	game.gameover = false
	game.blobs.clear()
	game._spawn_blob(0, Vector2(150, 997), true)
	game._spawn_blob(0, Vector2(205, 998), true)
	game._spawn_blob(2, Vector2(310, 980), true)
	game._spawn_blob(1, Vector2(410, 989), true)
	game._spawn_blob(4, Vector2(520, 954), true)
	game._spawn_blob(3, Vector2(610, 945), true)
	game._spawn_blob(0, Vector2(260, 920), true)
	game._spawn_blob(1, Vector2(365, 900), true)
	game.notice = ""
	game.notice_timer = 0.0
	await _shot("14_gameplay", func(): pass)

	# x20+ notification stress test: only two lines may be visible.
	game.feedback_items.clear()
	game.merge_feedback_points = 0
	game.merge_feedback_timer = 0.0
	game.combo_count = 21
	game.combo_timer = 1.0
	for i in range(21):
		game._show_merge_notification(mini(9, i % 8), 25 * (1 << mini(8, i % 8)), i + 1)
	game._flush_merge_feedback()
	game._show_evolution_notification("HUGE")
	game.perfect_banner_timer = 1.0
	await _shot("15_combo_x21", func(): pass)

	game.screen = "pause"
	await _shot("16_pause", func(): pass)

	game.score = 18240
	game.screen = "gameover"
	game.gameover = true
	game.notice = ""
	game.notice_timer = 0.0
	await _shot("17_gameover", func(): pass)

	# BOOM ready state must be high-contrast and legible.
	game.screen = "game"
	game.gameover = false
	game.charge = 100.0
	game.feedback_items.clear()
	game.perfect_banner_timer = 0.0
	await _shot("18_boom_ready", func(): pass)

	# Tall/narrow S23 Ultra aspect, rendered at 720x1544.
	get_window().size = Vector2i(720, 1544)
	for i in range(4):
		await get_tree().process_frame
	game.screen = "home"
	await _shot("19_home_tall", func(): pass)
	game.screen = "settings"
	game.settings_tab = 0
	await _shot("20_settings_tall", func(): pass)
	game.screen = "game"
	game.charge = 100.0
	await _shot("21_gameplay_tall", func(): pass)

	get_tree().quit()

func _shot(name: String, setup: Callable) -> void:
	setup.call()
	game.queue_redraw()
	for i in range(3):
		await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	var path := "%s/%s.png" % [OUT_DIR, name]
	var err := image.save_png(ProjectSettings.globalize_path(path))
	if err != OK:
		push_error("Could not save screenshot %s: %s" % [path, err])
	else:
		print("SCREENSHOT ", path, " ", image.get_width(), "x", image.get_height())
