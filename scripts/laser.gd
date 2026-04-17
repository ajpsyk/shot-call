extends Node2D


class Laser:
	var position: Vector2
	var velocity: Vector2
	var body := RID()
	var hitbox := RID()
	var polarity
