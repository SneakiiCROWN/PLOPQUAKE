@tool
extends SceneTree

func _init() -> void:
    var particle_names = ["circle_01", "spark_01", "star_01", "magic_01", "fire_01", "smoke_01", "twirl_01", "trace_01"]
    for name in particle_names:
        var tex = load("res://art/kenney_particles/%s.png" % name)
        if tex == null:
            print("MISSING: %s" % name)
        else:
            print("OK: %s (%dx%d)" % [name, tex.get_width(), tex.get_height()])

    var ui_sounds = ["click_001", "select_001", "confirmation_001", "back_001", "open_001", "close_001", "error_001", "switch_001"]
    for name in ui_sounds:
        var stream = load("res://audio/kenney_ui/%s.ogg" % name)
        if stream == null:
            print("MISSING SOUND: %s" % name)
        else:
            print("OK SOUND: %s" % name)

    var music = ["jingles_NES00", "jingles_NES01", "jingles_NES02"]
    for name in music:
        var stream = load("res://audio/kenney_music/%s.ogg" % name)
        if stream == null:
            print("MISSING MUSIC: %s" % name)
        else:
            print("OK MUSIC: %s" % name)

    var ui_tex = ["button_round_flat", "button_round_border", "icon_checkmark", "star"]
    for name in ui_tex:
        var tex = load("res://art/kenney_ui/%s.png" % name)
        if tex == null:
            print("MISSING UI TEX: %s" % name)
        else:
            print("OK UI TEX: %s (%dx%d)" % [name, tex.get_width(), tex.get_height()])
    
    quit()