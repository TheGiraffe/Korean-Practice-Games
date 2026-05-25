extends CharacterBody3D
@export var current_word = "buy"
@export var speed = 15
@export var fall_acceleration = 75
@export var bounce_back = 15

var target_velocity = Vector3.ZERO

func new_random_word():
	var n_options = $Pivot.get_child_count() - 1
	if (n_options > 0):
		var prev_block = $Pivot.get_node(String(current_word))
		var new_block = $Pivot.get_children()[randi_range(0, n_options)]
		prev_block.hide()
		new_block.show()
		current_word = new_block.name

func _ready():
	var children = $Pivot.get_children()
	for child in children:
		child.hide()
	randomize()
	new_random_word()
	
func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("go_right"):
		direction.x += 1
	if Input.is_action_pressed("go_left"):
		direction.x -= 1
	if Input.is_action_pressed("go_down"):
		direction.z += 1
	if Input.is_action_pressed("go_up"):
		direction.z -= 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		#$Pivot.basis = Basis.looking_at(direction)
		
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	velocity = target_velocity
	move_and_slide()
	
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision.get_collider() == null:
			continue
		if collision.get_collider().is_in_group("EnglishBlock"):
			var eng_block = collision.get_collider()
			if eng_block.my_word != current_word:
				target_velocity.y = bounce_back
				position.z = position.z + 5
				eng_block.eliminate_option()
				break
			else:
				eng_block.become_reward()
				break
