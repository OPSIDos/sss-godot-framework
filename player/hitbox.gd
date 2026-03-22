class_name hitbox
extends Area2D

@export var damage = 0

func _init() -> void:
	collision_layer = 2
	collision_mask = 0
