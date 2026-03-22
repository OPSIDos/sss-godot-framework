class_name hurtbox
extends Area2D


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	collision_layer = 0
	collision_mask = 2
	self.area_entered.connect(_on_area_entered)


func _on_area_entered(Hitbox: hitbox):
	if Hitbox == null: return
