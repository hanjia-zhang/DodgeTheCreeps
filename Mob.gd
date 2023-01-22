extends RigidBody2D

var motion = Vector2()

func _ready():
	$AnimatedSprite.playing = true
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()



func _on_Area2D_body_entered(body):#HZ
	if "bullet" in body.name:#HZ
		queue_free()#HZ
