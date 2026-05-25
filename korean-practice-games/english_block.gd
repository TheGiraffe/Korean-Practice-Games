extends CharacterBody3D
signal wrong_answer
signal correct_answer(answer: String)

var my_word
var current_round
var reward_flag = false

var random_speed = randf_range(1, 2)
	
func initialize(word_to_show, b, this_round):
	current_round = this_round
	var children = $Pivot.get_children()
	for child in children:
		child.hide()
	$Pivot.get_node(word_to_show).show()
	my_word = word_to_show
	$AnimationPlayer.speed_scale = random_speed

func eliminate_option():
	wrong_answer.emit()
	queue_free()

func become_reward():
	reward_flag = true
	correct_answer.emit(my_word)
	$Pivot.get_node(my_word).hide()
	$Pivot.get_node("reward").show()
	print(current_round)
	position = Vector3(-28 + (current_round*5), 0, -15)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("FloatingLanterns")
	$AnimationPlayer.speed_scale = random_speed/2.8
	
