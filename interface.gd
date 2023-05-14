extends Control


func game_over(snake_size:int):
	$score.text = "Snake size - "+str(snake_size)
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)

func restart():
	$"../..".snake = {0: Vector2(2, 2), 1: Vector2(1, 2)}
	$"../..".save_old = false
	$".".modulate.a = 0.0
	$"../../timer_event".wait_time = 1
	
	for i in $"../../map".get_used_cells():
		if $"../../map".get_cellv(i) != 0:
			$"../../map".set_cellv(i, -1)
	$"../../map".set_cell(4, 2, 2)
	$"../../rot".rotation_degrees = 0
	
	$"../../timer_event".start()
