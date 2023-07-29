extends Node

var speed_of_rotation = 0.08
var vision_radious = 85

var vision_angle_in_radians = 2.356
var target


func distance_between_2points(obj1, obj2):
	return sqrt(pow(obj1.position.x-obj2.position.x, 2.0) + pow(obj1.position.y-obj2.position.y, 2.0))


func angle_2_point(center_obj, target_p):
		var rel_pos = target_p - center_obj.position
		var desired_angle = atan2(rel_pos.y, rel_pos.x) - center_obj.rotation
		
		if desired_angle < -PI || desired_angle > PI:
			desired_angle = desired_angle + sign(desired_angle)*-2*PI
		
		return desired_angle

# Called when the node enters the scene tree for the first time.
func _ready():
	target = 	get_node("target")
	#boid = get_node("boid")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for boid in self.get_children(true):
		if boid.name=="target":
			continue
		var desired_angle = 0
		#desired_angle += alignment(boid)
		desired_angle += cohesion(boid)
		#desired_angle = desired_angle/2
		boid.rotation += sign(desired_angle) * min(speed_of_rotation/1.5, abs(desired_angle))
		#alignment(boid)
		#turn_to_target(boid)


func visible_boids(boid):
	var nearby_boids = []
	for other_boid in self.get_children(true):
		if distance_between_2points(boid, other_boid) > vision_radious\
		 and angle_2_point(boid, other_boid.position) > vision_angle_in_radians\
		 or angle_2_point(boid, other_boid.position) < - vision_angle_in_radians\
		 and other_boid.name != boid.name and other_boid.name!="target":	
			nearby_boids.append(other_boid)
	return nearby_boids
	

func cohesion(boid):
	var sum_of_positions = boid.position
	var nearby_boids = visible_boids(boid)
	if len(nearby_boids) == 0:
		return 0
		
	for other_boid in nearby_boids:
		sum_of_positions += other_boid.position

	return angle_2_point(boid, sum_of_positions/(len(nearby_boids)+1))


func alignment(boid):
	var sum_of_rotations = boid.rotation
	var nearby_boids = visible_boids(boid)
	for other_boid in nearby_boids:
		sum_of_rotations += other_boid.rotation
	var a = 0
	if len(nearby_boids) == 0:
		a=1

	var desired_angle = sum_of_rotations / (len(nearby_boids)+a) - boid.rotation
		
	if desired_angle < -PI || desired_angle > PI:
		desired_angle = desired_angle + sign(desired_angle)*-2*PI
	
	return desired_angle
	
	
func turn_to_target(boid):
	var desired_angle = angle_2_point(boid, target.position)
	boid.rotation += sign(desired_angle) * min(speed_of_rotation/1.5, abs(desired_angle))
