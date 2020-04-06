extends KinematicBody2D

enum{
	MOVE,
	ATTACK
}

var state = MOVE

#_____Variables for movement_____
var speed = 75
var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
#________________________________

#_____Variables for animation__________________________________________
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
#________________________________________________________________________

#_______Variables for weapon texture___________________________________
export var weapon = "Fist" 
onready var weapon_file_format = "res://assets/weapons/%s.png"
onready var weapon_file = weapon_file_format % weapon
#________________________________________________________________

func _ready():
#______Initializes animation__________
	animationState.start("Idle")
	animationTree.active = true
	
#______Initializes weapon_______________
	var weapon_tex = load(weapon_file)
	$Sprite/sprite.texture = weapon_tex
	$Sprite/sprite.visible = false
	
func _process(_delta):
#______set machine state____
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack_state()
	
#______close program when 'esc' is pressed______
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

func move_state(): #Character movement and animation
#_________Get input from player___________________________________________________________________
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
#__________________________________________________________________________________________________

	if input_vector != Vector2.ZERO: #if player is moving
	#___________________Get animation state_________________________________
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
	#________________________________________________________________________
		
		animationState.travel("Run")
		velocity = input_vector * speed #move
	else: #if player is standing still
		animationState.travel("Idle")
		velocity = Vector2.ZERO #stopr
	
	velocity = .move_and_slide(velocity) #starts player movement
	
#___________________ATTACK!!! ('A' key)_______________________
	if Input.is_action_just_pressed("ui_attack"):
			state = ATTACK

func attack_state():
	animationState.travel("Attack")

func attack_anim_finished():
	state = MOVE
#_______________________________________________________
