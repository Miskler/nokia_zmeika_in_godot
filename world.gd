extends Control


var game_zone = Rect2(Vector2(1, 1), Vector2(11, 6))


var snake = {
	0: Vector2(2, 2),
	1: Vector2(1, 2)
}

func _ready():
	randomize()
var save_old = false
func event():
	#МОДУЛЬ НАПРАВЛЕНИЯ ДВИЖЕНИЯ
	#$rot.look_at(snake[0]-snake[1])
	if Input.is_action_pressed("ui_left"):
		$rot.rotation_degrees -= 90
	elif Input.is_action_pressed("ui_right"):
		$rot.rotation_degrees += 90
	
	if $rot.rotation_degrees >= 360:
		$rot.rotation_degrees -= 360
	elif $rot.rotation_degrees <= -360:
		$rot.rotation_degrees += 360
	
	var move = $rot/pos.global_position
	
	
	#МОДУЛЬ ДВИЖЕНИЯ
	var new_snake = {}
	for i in snake.keys():
		if snake.has(i-1):
			new_snake[i] = snake[i-1]
			if not snake.has(i+1) and save_old:
				new_snake[i+1] = snake[i]
				save_old = false
		else:
			var new_head_point = snake[i]+move
			
			if not game_zone.has_point(new_head_point):
				if game_zone.position.x > new_head_point.x:
					new_head_point.x += game_zone.size.x
				elif game_zone.position.y > new_head_point.y:
					new_head_point.y += game_zone.size.y
				elif game_zone.size.x < new_head_point.x:
					new_head_point.x -= game_zone.size.x
				else:
					new_head_point.y -= game_zone.size.y
				
				#Убераем возможные погрешности рассчетов
				new_head_point = Vector2(int(new_head_point.x), int(new_head_point.y))
			
			new_snake[i] = new_head_point
	
	
	#МОДУЛЬ ВЗАИМОДЕЙСТВИЯ С МИРОМ
	if $map.get_cellv(new_snake[0]) == 2:
		save_old = true
		
		var pos = Vector2(round(rand_range(game_zone.position.x, game_zone.size.x)),round(rand_range(game_zone.position.y, game_zone.size.y)))
		while new_snake.values().has(pos):
			pos = Vector2(round(rand_range(game_zone.position.x, game_zone.size.x)),round(rand_range(game_zone.position.y, game_zone.size.y)))
		
		$map.set_cellv(pos, 2)
	elif $map.get_cellv(new_snake[0]) in [-1, 0]:
		$timer_event.stop()
		$map.set_cellv(new_snake[0], 3)
		$interface/box.game_over(new_snake.size())
		return
	
	
	#МОДУЛЬ ОТРИСОВКИ
	for snak in snake.values(): #СБРАСЫВАЕМ ПРОШЛОЕ СОСТОЯНИЕ ЗМЕИ
		$map.set_cellv(snak, -1)
	for i in new_snake.keys(): #УСТАНАВЛИВАЕМ НОВОЕ СОСТОЯНИЕ ЗМЕИ
		$map.set_cellv(new_snake[i], 1, false, false, false, Vector2(4, 0))
	$map.set_cellv(new_snake[0], 1, false, false, false, {
			0: Vector2(3,0), 
			-90: Vector2(0,0), 
			90: Vector2(2,0),
			-180: Vector2(1,0),
			180: Vector2(1,0),
			-270: Vector2(2,0),
			270: Vector2(0,0),
		}[int($rot.rotation_degrees)])
	
	
	#ПОДГОТОВКА К СЛЕДУЮЩЕМУ КАДРУ
	snake = new_snake
	
	$timer_event.wait_time = 1.0-float(snake.size())/15.0
	$timer_event.start()
