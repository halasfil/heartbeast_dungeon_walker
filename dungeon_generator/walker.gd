extends Node
#walker script which will "walk" around our map within its defined borders and randomly create a map
class_name Walker

#directions walker can go to
const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
#beginning position for walker
var position = Vector2.ZERO
#beginning direction
var direction = Vector2.RIGHT
#borders for our walker and borders for our map generation
var borders = Rect2()
#walker steps he commited
var step_history = []
#walks walker did since last turn
var steps_since_last_turn = 0
#rooms
var rooms = []

#variables to be changed and configured to make it satisfying
const MAX_STEPS = 5
const RANDOMIZATION_OF_DIRECTION = 0.25
#max is const below + min
const MAX_X_ROOM_SIZE = 4
const MIN_X_ROOM_SIZE = 2
const MAX_Y_ROOM_SIZE = 4
const MIN_Y_ROOM_SIZE = 2

#constructor
func _init(starting_position, new_borders):
	#assertion to be sure that our starting point is within our borders of a map
	assert(new_borders.has_point(starting_position))
	position = starting_position
	step_history.append(position)
	borders = new_borders

func walk(steps):
	place_room(position)
	for step in steps:
		#gives us 25% chance to change direction and never have a hallway longer than 4 steps
		#those are constants that can be configured
		#if randf() <= RANDOMIZATION_OF_DIRECTION || steps_since_last_turn >= MAX_STEPS:
		#we can choose one or other if statement option to create the map
		if steps_since_last_turn >= MAX_STEPS:
			change_direction()
		if can_do_step():
			step_history.append(position)
		else:
			change_direction()
	return step_history;
		
func can_do_step():
	var target_position = position + direction
	if borders.has_point(target_position):
		#we can walk there
		steps_since_last_turn += 1
		position = target_position
		return true;
	else:
		#we can't walk there
		return false;
	
func change_direction():
	place_room(position)
	steps_since_last_turn = 0
	var directions = DIRECTIONS.duplicate()
	#removes direction that was just commited not to walk the same direction
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	#if can't walk that direction, try another till you find available
	while not borders.has_point(position + direction):
		direction = directions.pop_front()

func create_room(pos, siz):
	return {position = pos, size = siz}

func place_room(pos):
	#room sizes
	#we can insert different max numbers. for now it is max size of 6x6 and min 2x2
	var size = Vector2(randi() % MAX_X_ROOM_SIZE + MIN_X_ROOM_SIZE, randi() % MAX_Y_ROOM_SIZE + MIN_X_ROOM_SIZE)
	var top_left_corner = (pos - size/2).ceil()
	#add room to array
	rooms.append(create_room(pos, size))
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			if borders.has_point(new_step):
				step_history.append(new_step)

#get the last room/furthest one
func get_end_room():
	var end_room = rooms.pop_front()
	var starting_position = step_history.front()
	for room in rooms:
		if starting_position.distance_to(room.position) > starting_position.distance_to(end_room.position):
			end_room = room
	return end_room
