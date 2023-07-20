extends CharacterBody2D


const SPEED = 300.0

func _physics_process(delta):
	print(sin(self.rotation))
	velocity.y = sin(self.rotation) * SPEED
	velocity.x = cos(self.rotation) * SPEED

	move_and_slide()
