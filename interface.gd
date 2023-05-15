extends Control


func game_over(snake_size:int):
	$score.text = "Snake size - "+str(snake_size)
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)

onready var main = $"../.."
func restart():
	main.snake = {0: Vector2(2, 2), 1: Vector2(1, 2)}
	main.save_old = false
	modulate.a = 0.0
	main.get_node("timer_event").wait_time = 1
	
	for i in main.get_node("map").get_used_cells():
		if main.get_node("map").get_cellv(i) != 0:
			main.get_node("map").set_cellv(i, -1)
	main.get_node("map").set_cell(4, 2, 2)
	main.get_node("rot").rotation_degrees = 0
	
	main.get_node("timer_event").start()
