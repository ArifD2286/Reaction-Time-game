# [# -- (name) --] will be used to label sectors of the code 
extends Control
@onready var color_signal = $ColorSignal
@onready var action_label = $ActionLabel
@onready var time = $Time
@onready var start_sound = $FartSound
@onready var bad_time_sound = [$VineBoomSound, $RobloxCrySound, $AckSound]
@onready var good_time_sound = [$AnimeWowSound, $RobloxWowSound, $RobloxYaySound ]
@onready var game_name_label = $GameNameLabel
@onready var restart_label = $RestartLabel


var reaction_time = 0
var game_start = false
var is_game_over = false
var permission_to_react = false

func _ready():
	action_label.text = "Press [SPACE] to start or react to signal."
	color_signal.color = Color.RED
	time.one_shot = true
	restart_label.visible = false


# -- Start and restart game --
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if is_game_over:
			restart_game()
		elif not game_start:
			start_game()
		elif game_start:
			if permission_to_react:
				var reaction_duration = Time.get_ticks_usec() - reaction_time
				# [get_ticks_usec()] takes a more detailed time, instead of only seconds it counts in ticks which is 1000000 faster than sec so we need to 
				action_label.text = "Time: " + str(reaction_duration / 1000000.0) + " sec"
				var reaction_seconds = reaction_duration / 1000000.0
				if reaction_seconds <= 0.45:
					good_time_sound[randi() % good_time_sound.size()].play()
					game_name_label.text = "Wow you are so fast!!"
				else:
					bad_time_sound[randi() % bad_time_sound.size()].play()
					game_name_label.text = "Too slow..."
			else:
				action_label.text = "FALSE START! >:("
				bad_time_sound[randi() % bad_time_sound.size()].play()
				time.stop()
			game_over()


# -- Start game functions --
func start_game():
	game_start = true
	is_game_over = false
	permission_to_react = false
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
	restart_label.visible = true
	restart_label.text = "Press [SPACE] to restart"

# -- Change color signal from default (red) to green --
func change_color_to_green():
	color_signal.color = Color.WEB_GREEN

# -- After random wait time finishes --
func _on_time_timeout():
	change_color_to_green()
	start_sound.play()
	permission_to_react = true
	reaction_time = Time.get_ticks_usec()
