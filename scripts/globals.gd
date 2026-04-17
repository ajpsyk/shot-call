extends Node

enum Polarity { RED, BLUE }

# Bit representation of physics layers to pass into PhysicsServer2D
class PhysicsLayers:
	const PLAYER = 1
	const PLAYER_ATTACK = 2
	const ENEMY = 4
	const ENEMY_ATTACK = 8
	const WORLD = 16
