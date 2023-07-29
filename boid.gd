extends CharacterBody2D


const SPEED = 400.0
const scrn_size_x = 1250
const scrn_size_y = 650

func wrap_around_scrn(delta):
	if self.position.x > scrn_size_x:
		self.position.x = 0
	elif self.position.x < 0:
		self.position.x = scrn_size_x
	if self.position.y > scrn_size_y:
		self.position.y = 0
	elif self.position.y < 0:
		self.position.y = scrn_size_y
		
func _ready():
	var rng = RandomNumberGenerator.new()
	#self.rotation = rng.randf_range(0, 6.283)
	self.rotation = rng.randf_range(0, 6.283)
	
func _physics_process(delta):
	wrap_around_scrn(delta)
		
	velocity.y = sin(self.rotation) * SPEED
	velocity.x = cos(self.rotation) * SPEED
	move_and_slide()
