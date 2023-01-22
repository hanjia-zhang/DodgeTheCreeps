extends Area2D

signal hit

export var life: int =3 #HZ
export var speed = 300 # How fast the player will move (pixels/sec).#HZ
var bullet_speed = 1000 #HZ
var bullet = preload("res://bullet.tscn")#HZ

var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size
	hide()


func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
		
	look_at(get_global_mouse_position())#HZ
	if Input.is_action_just_pressed("Space"):
		fire()


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_Player_body_entered(_body):
	
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.

func disablePlayer(): #HZ
	$CollisionShape2D.set_deferred("disabled", true)	
	hide() # Player disappears after being hit.

func fire():#HZ(66-71)
	var bullet_instance = bullet.instance()
	bullet_instance.position = get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(),Vector2(bullet_speed,0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", bullet_instance)
	
	
