extends Node

var main_scene_instance: Node3D = null
var player: CharacterBody3D = null
var sim_step: int = 0
var timer: float = 0.0

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n==========================================")
	print(" LIVE GAMEPLAY & VISUAL SIMULATION SUITE ")
	print("==========================================")
	
	GameManager.reset_game_state()
	
	var scene = load("res://main.tscn")
	if not scene:
		printerr("[FAIL] Could not load res://main.tscn")
		get_tree().quit(1)
		return
		
	main_scene_instance = scene.instantiate()
	add_child(main_scene_instance)
	player = main_scene_instance.get_node_or_null("Player")
	
	if not player:
		printerr("[FAIL] Player not found in scene!")
		get_tree().quit(1)
		return
		
	print("[PASS] main.tscn instantiated and added to active tree.")

func assert_check(condition: bool, message: String) -> void:
	if condition:
		tests_passed += 1
		print("  [PASS] %s" % message)
	else:
		tests_failed += 1
		printerr("  [FAIL] %s" % message)

func _process(delta: float) -> void:
	timer += delta
	match sim_step:
		0:
			if timer > 0.2:
				print("\n-- Step 1: Testing Player & Camera --")
				assert_check(player != null, "Player exists")
				var camera = player.get_node_or_null("CameraPivot/SpringArm3D/Camera3D")
				assert_check(camera != null and camera.current, "Player 3D Camera is active")
				
				# Test movement simulation
				player.velocity = Vector3(2.0, 0, 2.0)
				player.move_and_slide()
				assert_check(player.position != Vector3.ZERO, "Player movement responds to velocity")
				
				_save_screenshot("step1_courtyard.png")
				sim_step = 1
				timer = 0.0
		1:
			if timer > 0.3:
				print("\n-- Step 2: Testing Puzzle Activation & Portcullis --")
				var pillar1 = main_scene_instance.get_node_or_null("FortCourtyard/PillarSun")
				var pillar2 = main_scene_instance.get_node_or_null("FortCourtyard/PillarMoon")
				var pillar3 = main_scene_instance.get_node_or_null("FortCourtyard/PillarStar")
				var gate = main_scene_instance.get_node_or_null("PortcullisGate")
				
				assert_check(pillar1 != null and pillar2 != null and pillar3 != null, "All 3 pillars located")
				pillar1.activate()
				pillar2.activate()
				pillar3.activate()
				
				assert_check(GameManager.puzzle_completed, "GameManager marks puzzle solved")
				assert_check(gate.is_open, "Portcullis gate opens upon puzzle completion")
				
				_save_screenshot("step2_puzzle_solved.png")
				sim_step = 2
				timer = 0.0
		2:
			if timer > 0.3:
				print("\n-- Step 3: Testing Key Item Collection --")
				var key_item = main_scene_instance.get_node_or_null("FortCourtyard/KeyItem")
				assert_check(key_item != null, "Key item located on altar")
				
				GameManager.collect_key()
				assert_check(GameManager.has_treasure_key, "GameManager holds ancient key")
				var key_badge = main_scene_instance.get_node_or_null("UI/HUD/TopBar/KeyBadge")
				assert_check(key_badge != null and key_badge.visible, "HUD key badge displayed")
				
				_save_screenshot("step3_key_collected.png")
				sim_step = 3
				timer = 0.0
		3:
			if timer > 0.3:
				print("\n-- Step 4: Testing Spike Trap & Damage System --")
				var trap = main_scene_instance.get_node_or_null("UndergroundTunnel/TrapCorridor")
				assert_check(trap != null, "Spike trap found in tunnel")
				
				var hp_before = GameManager.current_health
				GameManager.take_damage(35)
				assert_check(GameManager.current_health == hp_before - 35, "Player health dropped by 35")
				
				var hp_bar = main_scene_instance.get_node_or_null("UI/HUD/TopBar/HealthContainer/HealthBar")
				assert_check(hp_bar != null and hp_bar.value == 65, "HUD HealthBar reflects 65 HP")
				
				_save_screenshot("step4_tunnel_trap.png")
				sim_step = 4
				timer = 0.0
		4:
			if timer > 0.3:
				print("\n-- Step 5: Testing Treasure Chest & Win Screen --")
				var chest = main_scene_instance.get_node_or_null("TreasureChamber/TreasureChest")
				assert_check(chest != null, "Treasure chest located on vault dais")
				
				chest.open_chest()
				assert_check(chest.is_opened, "Treasure chest lid opened")
				assert_check(GameManager.is_victory, "Victory state registered in GameManager")
				
				var win_ui = main_scene_instance.get_node_or_null("UI/WinUI")
				assert_check(win_ui != null and win_ui.visible, "WinUI screen is visible to player")
				
				_save_screenshot("step5_treasure_win.png")
				sim_step = 5
				timer = 0.0
		5:
			if timer > 0.2:
				print("\n-- Step 6: Testing Game Over Screen --")
				# Reset victory state so damage takes effect
				GameManager.is_victory = false
				GameManager.take_damage(100)
				assert_check(GameManager.is_game_over, "GameManager marks player dead")
				
				var game_over_ui = main_scene_instance.get_node_or_null("UI/GameOverUI")
				assert_check(game_over_ui != null and game_over_ui.visible, "GameOverUI screen is visible")
				
				_save_screenshot("step6_game_over.png")
				sim_step = 6
				timer = 0.0
		6:
			print("\n==========================================")
			print(" LIVE SIMULATION COMPLETED")
			print(" Results: %d Passed, %d Failed" % [tests_passed, tests_failed])
			print("==========================================")
			
			if tests_failed == 0:
				print("ALL LIVE GAMEPLAY CHECKS PASSED!")
				get_tree().quit(0)
			else:
				printerr("LIVE SIMULATION CHECKS FAILED!")
				get_tree().quit(1)

func _save_screenshot(filename: String) -> void:
	if DisplayServer.get_name() == "headless":
		return
	var tex = get_viewport().get_texture()
	if tex:
		var img = tex.get_image()
		if img:
			var path = "res://tests/screenshots/" + filename
			img.save_png(path)
			print("    [Screenshot saved: %s]" % filename)
