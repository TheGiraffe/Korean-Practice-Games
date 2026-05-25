extends Node
@export var english_blocks_scene: PackedScene
# Called when the node enters the scene tree for the first time.
var curr_word
var curr_word_list = []
var this_round = 1
var score_cutoff = 10

var challenge_number = 1

var score = 0

func get_random_word():
	curr_word_list = []
	randomize()
	var max_children = $KoreanBlock/Pivot.get_child_count() - 1
	var rand_word = $KoreanBlock/Pivot.get_children()[randi_range(0, max_children)].name
	if rand_word in curr_word_list && rand_word != curr_word:
		return get_random_word()
	return rand_word
	
func setupround():
	randomize()
	var x_positions = [-14, -7, 0, 7, 14]
	var z_offsets = [0,-7,0,-7,0]
	$KoreanBlock.position = Vector3(0,0,6)
	$KoreanBlock.new_random_word()
	curr_word = $KoreanBlock.current_word
	curr_word_list.append(curr_word)
	var rand_curr_word_pos = randi_range(0, 4)
	for b in range(5):
		var english_block = english_blocks_scene.instantiate()
		if b == rand_curr_word_pos:
			english_block.initialize(String(curr_word), b, this_round)
		else:
			var random_word = get_random_word()
			curr_word_list.append(random_word)
			english_block.initialize(String(random_word), b, this_round)
		english_block.position = Vector3(x_positions[b], 0, z_offsets[b])
		english_block.connect("correct_answer", _on_english_block_correct_answer)
		add_child(english_block)
		

func next_challenge():
	challenge_number += 1
	$KoreanBlock.show()
	this_round = 1
	$UserInterface/ColorRect.hide()
	$UserInterface/ContinueLabel.hide()
	$UserInterface/Yes.hide()
	$UserInterface/No.hide()
	var kids = get_children().filter(func(kid): return kid.has_method("become_reward"))
	for kid in kids:
		kid.queue_free()
	score_cutoff = score_cutoff + 10
	setupround()

func _ready() -> void:
	$UserInterface/ColorRect.hide()
	$UserInterface/ContinueLabel.hide()
	$UserInterface/Yes.hide()
	$UserInterface/No.hide()
	setupround()
		

func _on_english_block_correct_answer(answer: String) -> void:
	var kids = get_children().filter(func(kid): return kid.has_method("become_reward"))
	for kid in kids:
		if kid.reward_flag != true:
			kid.queue_free()
	this_round += 1
	score += 1
	$UserInterface/ScoreLabel.text = "Score: %s" % score
	if score < score_cutoff:
		setupround()
	else:
		$KoreanBlock.hide()
		$UserInterface/ColorRect.show()
		$UserInterface/Yes.show()
		$UserInterface/No.show()
		$UserInterface/ContinueLabel.text = "Congrats! Challenge %s is complete! \n \n Continue Playing?" % challenge_number
		$UserInterface/ContinueLabel.show()


func _on_yes_pressed() -> void:
	next_challenge()
