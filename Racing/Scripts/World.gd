extends Node2D


func _ready():
	$StaticBody2D/CollisionPolygon2D.polygon = $Path2D.curve.tessellate()
