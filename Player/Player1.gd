extends KinematicBody2D

const MAX_SPEED = 100
const ACCELERATION = 300
const FRICTION = 1500

enum{ MOVE, ROLL, ATTACK }

var state = MOVE
var velocity =  Vector2.ZERO

enum{ right ,left ,down ,up}
var act

var x1 
var y1 
var x2 
var y2

var d

onready var animationPlayer = $AnimationPlayer

func _process(delta):
	match state:
		MOVE: 
			move_state(delta)
		
		ROLL:
			pass
		
		ATTACK:
			attack_state(delta,act)
			
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:

		if input_vector.x == 1:
			animationPlayer.play("RunRight") 
			x1 = input_vector.x
			if Input.is_action_just_pressed("attack"):
				state = ATTACK
				act = right
		
		if input_vector.x == -1:
			animationPlayer.play("RunLeft")
			x2 = input_vector.x
			if Input.is_action_just_pressed("attack"):
				state = ATTACK
				act = left
			
		if input_vector.y == 1:
			animationPlayer.play("RunDown")
			y1 = input_vector.y
			if Input.is_action_just_pressed("attack"):
				state = ATTACK
				act = down
		
		if input_vector.y == -1:
			animationPlayer.play("RunUp")
			y2 = input_vector.y
			if Input.is_action_just_pressed("attack"):
				state = ATTACK
				act = up
	
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	if input_vector == Vector2.ZERO:
		if x1:
			animationPlayer.play("IdleRight")
			d = 0
			
		if x2: 
			animationPlayer.play("IdleLeft")
			d = 1
				
		if y1: 
			animationPlayer.play("IdleDown")
			d = 2 
				
		if y2: 
			animationPlayer.play("IdleUp")
			d = 3
			
		if Input.is_action_just_pressed("attack"):
				state = ATTACK
				if d == 0 : act = right
					
				if d == 1 : act = left
					
				if d == 2 : act = down
					
				if d == 3: act = up
		x1 = 0 
		x2 = 0 
		y1 = 0 
		y2 = 0
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)
	
	
func attack_state(delta,act):
	velocity = Vector2.ZERO
	if act == right:
		animationPlayer.play("AttackRight")
		
	if act == left:
		animationPlayer.play("AttackLeft")
		
	if act == down:
		animationPlayer.play("AttackDown")
		
	if act == up:
		animationPlayer.play("AttackUp")
		
func attack_state_finished():
	state = MOVE
