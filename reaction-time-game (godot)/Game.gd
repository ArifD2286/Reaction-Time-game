# [# -- (name) --] will be used to label sectors of the code 
extends Control
@onready var panel = $Panel
@onready var action_label = $ActionLabel
@onready var time = $Time

var reaction_time = 0
var game_start = false
var is_game_over = false

func _ready():
	action_label.text = "Press [SPACE] to start, react to signal, or restart."
	panel.color = Color.RED


# -- Start and restart game --
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if is_game_over:
			restart_game()
		elif not game_start:
			start_game()


# -- Start game functions --
func start_game():
	game_start = true
	is_game_over = false
	action_label.text = "Wait for signal..."


# -- Random waiting time for signal --
	var waiting_time = randf_range(1.0, 4.0)
	reaction_time = Time.get_ticks_usec()
	time.wait_time = waiting_time
	time.start()


# -- Restart game functions --
func restart_game():
	get_tree().reload_current_scene()


# -- Game over functions --
func game_over():
	game_start = false
	is_game_over = true
	action_label.text = "Press [SPACE] to restart."


# -- Change panel colour from default (red) to green --
func change_color_to_green():
	panel.color = Color.WEB_GREEN


# -- After random wait time finish --
func _on_time_timeout():
	change_color_to_green()
	reaction_time = Time.get_ticks_usec()
