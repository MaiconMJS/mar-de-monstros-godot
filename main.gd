extends Node

@export var Mob: PackedScene
var score

func _ready() -> void:
	randomize()

func game_over() -> void:
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_ver()
	get_tree().call_group("mobs", "queue_free")

func new_game():
	$Music.play()
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Prepare-se")

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_mob_timer_timeout() -> void:
	# Escolher um lugar aleatório em Path
	$MobPath/MobSpawnLocation.progress_ratio = randi()
	# Criar um clone de mob e adicionar a cena
	var mob = Mob.instantiate()
	add_child(mob)
	# Colocar direção do mob
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Colocar o clone em uma localização aleatória
	mob.position = $MobPath/MobSpawnLocation.position
	# Para onde aponta ? (Rotação)
	direction += randf_range(-PI/4, PI/4)
	mob.rotation = direction
	# Configuração do vetor velocidade (velocidade e direção)
	mob.linear_velocity = Vector2(randf_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	
