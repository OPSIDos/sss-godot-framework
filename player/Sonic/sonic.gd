extends CharacterBody2D

@export var minSpeed:float = 15.0
@export var maxSpeed:float = 450.0
@export var jumpVel:float = -300.0
@export var addedJumpVel:float = -00.0

@export var accTime:float = 3.0
@export var dragTime:float = 1.25
@export var skidTime:float = 0.25
@export var maxJumpTime:float = 0.2

@export var gravAcc:float = 980.0
@export var gravVec:Vector2 = Vector2.DOWN

var currentSpeed:float
var floor_normal
var floor_angle

var dir:float = 0
var _facing:float = 1

var accel_amount:float
var drag_amount:float
var skid_amount:float

var jumpActionCount:int = 0
var fallState:bool = false
var jumpTimer:float = 0


@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var animation_tree:AnimationTree = $AnimationPlayer/AnimationTree

func _ready():
	animation_tree.active = true

func _process(_ddelta):
	update_animation_parameters()

func update_animation_parameters():
	if velocity.x == 0 and dir == 0 and is_on_floor():
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/moving"] = false
	elif velocity.x != 0 and dir != 0 and is_on_floor():
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/moving"] = true
	#
	#if Input.is_action_just_pressed("jump") and jumpActionCount == 1:
	#	animation_tree["parameters/conditions/jump"] = true
	#	CurrentAnimation = "jump"
	#else:
	#	animation_tree["parameters/conditions/jump"] = false

func _physics_process(delta: float) -> void:
	gravity_func(delta)
	if is_on_floor():
		floor_normal = get_floor_normal()
		floor_angle = floor_normal.angle() - PI/2
		jumpActionCount = 0
	jump_func(delta)
	if jumpActionCount == 0 and fallState == true:
		jumpActionCount = 1
	dir = Input.get_axis("left", "right")
	currentSpeed = abs(velocity.x)
	accel_amount = (maxSpeed-minSpeed) * delta/accTime
	drag_amount = (maxSpeed-0) * delta/dragTime
	skid_amount = (maxSpeed-0) * delta/skidTime
	sprite_flip()
	movement_aportunity() 
	move_and_slide()
func movement_aportunity():
	if dir != 0 and sign(velocity.x + 1 * dir) == sign(dir) and abs(velocity.x) >= 0 and abs(velocity.x) <= maxSpeed:
		currentSpeed = min(max(minSpeed, currentSpeed + accel_amount), maxSpeed)
		velocity.x = currentSpeed * dir
	elif dir == 0 and abs(velocity.x) > 0:
		currentSpeed = max(currentSpeed - drag_amount, 0)
		velocity.x = currentSpeed * _facing
	elif sign(dir) != 0 and sign(velocity.x) != sign(dir):
		currentSpeed = max(currentSpeed - skid_amount, 0)
		velocity.x = currentSpeed * _facing
	elif (dir == 0 and velocity.x == 0):
		velocity.x = 0
func jump_func(delta):
	if Input.is_action_just_pressed("jump") and jumpActionCount == 0:
		velocity.y = jumpVel
		jumpActionCount += 1
	
	if jumpActionCount == 1 and Input.is_action_pressed("jump"):
		velocity.y += addedJumpVel / 100
func gravity_func(delta:float):
	var gravity = gravAcc * gravVec
	if not is_on_floor():
		velocity += gravity * delta
	if is_on_floor_only():
		velocity += (gravity * delta) + (-gravity * delta)
func sprite_flip():
	if velocity.x != 0:
		_facing = sign(velocity.x)
	sprite.scale.x = abs(sprite.scale.x) * _facing
