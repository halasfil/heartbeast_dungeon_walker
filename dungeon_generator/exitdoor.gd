extends Area2D

signal leaving_level

func _on_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if (body is CharacterBody2D):
		emit_signal("leaving_level")
