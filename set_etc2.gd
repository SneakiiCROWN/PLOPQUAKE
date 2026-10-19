extends SceneTree

func _init() -> void:
    ProjectSettings.set_setting("rendering/textures/vram_compression/import_etc2_astc", true)
    ProjectSettings.save()
    print("Setting saved")
    quit()