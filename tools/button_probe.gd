extends Node2D

var font: Font

func _ready() -> void:
	font = ThemeDB.fallback_font
	var tex: Texture2D = load("res://art/kenney_ui/button_round_flat.png")
	print("TEX ", tex, " size=", tex.get_size(), " class=", tex.get_class())
	var ti := tex.get_image()
	print("IMG ", ti.get_size(), " fmt=", ti.get_format(), " px=", ti.get_pixel(32, 32))
	ti.save_png(ProjectSettings.globalize_path("res://builds/screenshots_v1.0.6/probe_tex_button.png"))
	var chrome: Texture2D = load("res://art/integrated/ui/industrial_panel.png")
	var ci := chrome.get_image()
	print("CHROME ", ci.get_size(), " fmt=", ci.get_format(), " px=", ci.get_pixel(190, 34))
	ci.save_png(ProjectSettings.globalize_path("res://builds/screenshots_v1.0.6/probe_tex_chrome.png"))
	await get_tree().process_frame
	for i in range(10):
		await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	img.save_png(ProjectSettings.globalize_path("res://builds/screenshots_v1.0.6/probe_buttons.png"))
	get_tree().quit()

func _draw() -> void:
	draw_rect(Rect2(0, 0, 720, 1280), Color("0c1631"))
	# Raw texture, at native and scaled sizes.
	var tex: Texture2D = load("res://art/kenney_ui/button_round_flat.png")
	draw_texture_rect(tex, Rect2(40, 40, 64, 64), false)
	draw_texture_rect(tex, Rect2(120, 40, 147, 58), false)
	# Same call pattern as game.
	_nine(tex, Rect2(40, 140, 147, 58))
	# Industrial chrome.
	var chrome: Texture2D = load("res://art/integrated/ui/industrial_panel.png")
	draw_texture_rect(chrome, Rect2(40, 240, 147, 58), false)
	_nine(chrome, Rect2(220, 240, 147, 58), Color(1, 1, 1, 0.64))
	# Various heights with kenney.
	for i in range(4):
		_nine(tex, Rect2(40 + i * 160, 340, 147, 50 + i * 5), Color(1, 1, 1, 1))
	# Native draw of region to see the actual source selection.
	draw_texture_rect_region(tex, Rect2(40, 520, 147, 58), Rect2(14, 18, 36, 28), Color(1, 1, 1, 1))
	var card: Texture2D = load("res://art/integrated/ui/card_play.png")
	draw_texture_rect(card, Rect2(320, 340, 280, 180), false)
	var blob: Texture2D = load("res://art/production/blobs/00_pip.png")
	draw_texture_rect(blob, Rect2(320, 540, 120, 120), false)
	draw_string(font, Vector2(40, 630), "raw / stretched / 9patch / chrome / heights / region", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color.WHITE)

func _nine(tex: Texture2D, target: Rect2, tint: Color = Color(1, 1, 1, 1)) -> void:
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
