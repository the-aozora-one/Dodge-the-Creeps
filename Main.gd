extends Node

@export var mob_scene: PackedScene
var score


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play()


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Set direction perpendicular to path direction
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Set position to a random location
	mob.position = mob_spawn_location.position
	
	# Add randomness to the direction
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Choose velocity
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Spawn mob
	add_child(mob)


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
