extends Node

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("==========================================")
	print(" DARK FORT: LOST TREASURE - TEST SUITE")
	print("==========================================")
	
	test_game_manager_init()
	test_puzzle_mechanics()
	test_key_and_inventory()
	test_damage_and_health_system()
	test_win_condition()
	test_main_scene_hierarchy()
	
	print("==========================================")
	print(" Results: %d Passed, %d Failed" % [tests_passed, tests_failed])
	print("==========================================")
	
	if tests_failed == 0:
		print(" ALL AUTOMATED TESTS COMPLETED SUCCESSFULLY!")
		get_tree().quit(0)
	else:
		printerr(" TESTS FAILED!")
		get_tree().quit(1)

func assert_true(condition: bool, test_name: String) -> void:
	if condition:
		tests_passed += 1
		print("  [PASS] %s" % test_name)
	else:
		tests_failed += 1
		printerr("  [FAIL] %s" % test_name)

func test_game_manager_init() -> void:
	print("\n-- Testing GameManager Initialization --")
	GameManager.reset_game_state()
	assert_true(GameManager.current_health == 100, "Initial player health is 100")
	assert_true(GameManager.has_treasure_key == false, "Player starts without key")
	assert_true(GameManager.puzzle_completed == false, "Puzzle is initially unsolved")
	assert_true(GameManager.is_game_over == false, "Game is not over initially")
	assert_true(GameManager.is_victory == false, "Game is not won initially")

func test_puzzle_mechanics() -> void:
	print("\n-- Testing Rune Puzzle Mechanics --")
	GameManager.reset_game_state()
	var flag = [false]
	GameManager.puzzle_solved.connect(func(): flag[0] = true)
	
	GameManager.activate_rune(1)
	assert_true(GameManager.active_runes.size() == 1, "Rune 1 added to active runes")
	assert_true(not GameManager.puzzle_completed, "Puzzle incomplete after 1 rune")
	
	GameManager.activate_rune(2)
	assert_true(GameManager.active_runes.size() == 2, "Rune 2 added to active runes")
	
	GameManager.activate_rune(3)
	assert_true(GameManager.active_runes.size() == 3, "Rune 3 added to active runes")
	assert_true(GameManager.puzzle_completed, "Puzzle completed after 3 runes")
	assert_true(flag[0], "puzzle_solved signal emitted")

func test_key_and_inventory() -> void:
	print("\n-- Testing Key Collection --")
	GameManager.reset_game_state()
	var flag = [false]
	GameManager.key_collected.connect(func(_k): flag[0] = true)
	
	GameManager.collect_key()
	assert_true(GameManager.has_treasure_key, "Player has treasure key in inventory")
	assert_true(flag[0], "key_collected signal emitted")

func test_damage_and_health_system() -> void:
	print("\n-- Testing Health & Damage System --")
	GameManager.reset_game_state()
	var flag = [false]
	GameManager.player_died.connect(func(): flag[0] = true)
	
	GameManager.take_damage(35)
	assert_true(GameManager.current_health == 65, "Player health reduced to 65 after 35 damage")
	
	GameManager.take_damage(70)
	assert_true(GameManager.current_health == 0, "Player health reduced to 0 after lethal damage")
	assert_true(GameManager.is_game_over, "is_game_over flag set to true")
	assert_true(flag[0], "player_died signal emitted on fatal damage")

func test_win_condition() -> void:
	print("\n-- Testing Win Condition --")
	GameManager.reset_game_state()
	var flag = [false]
	GameManager.game_won.connect(func(): flag[0] = true)
	
	GameManager.win_game()
	assert_true(GameManager.is_victory, "is_victory flag set to true")
	assert_true(flag[0], "game_won signal emitted")

func test_main_scene_hierarchy() -> void:
	print("\n-- Testing Main Scene Node Hierarchy --")
	var main_scene = load("res://main.tscn")
	assert_true(main_scene != null, "main.tscn loaded successfully")
	
	var instance = main_scene.instantiate()
	assert_true(instance != null, "main.tscn instantiated")
	
	var player = instance.get_node_or_null("Player")
	assert_true(player != null, "Player node found in main scene")
	assert_true(player.get_node_or_null("CameraPivot/SpringArm3D/Camera3D") != null, "Player Camera3D found")
	
	var gate = instance.get_node_or_null("PortcullisGate")
	assert_true(gate != null, "PortcullisGate node found")
	
	var pillar_sun = instance.get_node_or_null("FortCourtyard/PillarSun")
	var pillar_moon = instance.get_node_or_null("FortCourtyard/PillarMoon")
	var pillar_star = instance.get_node_or_null("FortCourtyard/PillarStar")
	assert_true(pillar_sun != null and pillar_moon != null and pillar_star != null, "All 3 Puzzle Pillars found in Courtyard")
	
	var key_item = instance.get_node_or_null("FortCourtyard/KeyItem")
	assert_true(key_item != null, "KeyItem found on Courtyard Altar")
	
	var trap = instance.get_node_or_null("UndergroundTunnel/TrapCorridor")
	assert_true(trap != null, "TrapCorridor found in Underground Tunnel")
	
	var chest = instance.get_node_or_null("TreasureChamber/TreasureChest")
	assert_true(chest != null, "TreasureChest found in Treasure Chamber")
	
	var hud = instance.get_node_or_null("UI/HUD")
	var win_ui = instance.get_node_or_null("UI/WinUI")
	var game_over_ui = instance.get_node_or_null("UI/GameOverUI")
	assert_true(hud != null and win_ui != null and game_over_ui != null, "HUD, WinUI, and GameOverUI all present")
	
	instance.free()
