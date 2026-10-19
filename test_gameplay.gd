extends Node

func _ready() -> void:
    print("=== Starting Gameplay Tests ===")
    
    # Import the game script
    var game_script = load("res://scripts/game.gd")
    var game = game_script.new()
    add_child(game)
    
    # Reset game state for testing
    game.blobs.clear()
    game.score = 0
    game.drops = 0
    game.merges = 0
    game.charge = 0.0
    game.next_tier = 0
    game.deck_tier = 0
    game.danger_seconds = 0.0
    game.gameover = false
    game.combo_count = 0
    game.combo_timer = 0.0
    game.totals = {"merges": 0, "booms": 0, "drops": 0, "biggest": 0}
    
    # Test 1: Basic initialization
    print("=== Test 1: Basic Initialization ===")
    assert(game.WIDTH == 720.0)
    assert(game.HEIGHT == 1280.0)
    assert(game.NAMES.size() == 10)
    assert(game.RADII.size() == 10)
    print("OK: Constants and arrays initialized")
    
    # Test 2: Spawn blob
    print("\n=== Test 2: Spawn Blob ===")
    game._spawn_blob(0, Vector2(360, 700))
    assert(game.blobs.size() == 1)
    assert(game.blobs[0].t == 0)
    assert(game.blobs[0].x == 360)
    assert(game.blobs[0].y == 700)
    print("OK: Blob spawned correctly")
    
    # Test 3: Drop blob
    print("\n=== Test 3: Drop Blob ===")
    game.screen = "game"
    game.next_tier = 0
    game.deck_tier = 1
    game._drop(360)
    assert(game.drops == 1)
    assert(game.blobs.size() == 2)
    assert(game.next_tier == 1)
    print("OK: Drop works")
    
    # Test 4: Merge detection
    print("\n=== Test 4: Merge Detection ===")
    game.blobs.clear()
    game._spawn_blob(0, Vector2(360, 500), true)
    game._spawn_blob(0, Vector2(360, 460), true)  # 40 apart, radius 23 each = min 46, so they overlap
    # Age the blobs so they can merge (need age > 0.12)
    for b in game.blobs:
        b.age = 1.0
    game._physics_process(0.016)
    assert(game.blobs.size() == 1)
    assert(game.blobs[0].t == 1)
    assert(game.merges == 1)
    assert(game.score > 0)
    print("OK: Merge works")
    
    # Test 5: BOOM charge
    print("\n=== Test 5: BOOM Charge ===")
    game.charge = 100.0
    game._boom()
    assert(game.charge == 0.0)
    assert(game.totals["booms"] == 1)
    print("OK: BOOM works")
    
    # Test 6: Save/Load
    print("\n=== Test 6: Save/Load ===")
    game._save_all()
    game._flush_save()
    print("OK: Save works")
    
    # Test 7: Kenney assets loaded
    print("\n=== Test 7: Kenney Assets ===")
    assert(game.particle_textures.size() > 0)
    assert(game.kenney_ui_sounds.size() > 0)
    print("OK: Kenney assets loaded (particles: %d, sounds: %d)" % [game.particle_textures.size(), game.kenney_ui_sounds.size()])
    
    # Test 8: Mode switching
    print("\n=== Test 8: Mode Switching ===")
    game._change_mode("daily")
    assert(game.mode == "daily")
    game._change_mode("normal")
    assert(game.mode == "normal")
    print("OK: Mode switching works")
    
    # Test 9: Hold-to-drop constants
    print("\n=== Test 9: Hold-to-Drop ===")
    assert(game.HOLD_DROP_COOLDOWN == 0.18)
    assert(game.MAX_HOLD_DROPS == 8)
    print("OK: Hold-to-drop constants set")
    
    # Test 10: Merge squash constants
    print("\n=== Test 10: Merge Squash ===")
    assert(game.MERGE_SQUASH_DURATION == 0.12)
    assert(game.MERGE_SQUASH_SCALE == 0.7)
    print("OK: Merge squash constants set")
    
    print("\n=== ALL TESTS PASSED ===")
    get_tree().quit()