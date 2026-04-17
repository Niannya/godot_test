extends CharacterBody2D

@export var move_speed : float = 50
@export var animator : AnimatedSprite2D
@export var bullet_scene : PackedScene
var is_game_over : bool = false

func _process(delta: float) -> void:
	if velocity	== Vector2.ZERO or is_game_over:
		$RunningSound.stop()
	elif not $RunningSound.playing:
		$RunningSound.play()

func _physics_process(delta: float) -> void:
	if not is_game_over:
		velocity = Input.get_vector("left", "right", "up", "down") * move_speed
		if velocity == Vector2.ZERO:
			animator.play("idle")
		else:
			animator.play("run")
		move_and_slide()

func game_over():
	if not is_game_over:
		is_game_over = true
		animator.play("gameover")
		get_tree().current_scene.show_game_over()
		$GameOverSound.play()
		$RestartTimer.start()


func _on_fire() -> void:
	if velocity != Vector2.ZERO or is_game_over:
		return
	var bullet_node = bullet_scene.instantiate()
	bullet_node.position = position + Vector2(6, 6)
	get_tree().current_scene.add_child(bullet_node)
	$FireSound.play()


func _reload_scene() -> void:
	get_tree().reload_current_scene()
