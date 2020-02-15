extends Node2D

onready var base = $base
onready var default = $marks

#textures
var base_tex = load("res://assets/0_1/BASE.png")
var rand_to_use
var player_mp = 3
var pmp = [1,2,3]
#base
onready var base_cells
var move_state = false
var sort = false
var initial_base_size
var init_seted = false
var PlayerCell = Vector2(0,0)
var insert_time = 0.05
onready var cell_base_ref

func _ready():
	
	base_cells = base.get_used_cells()
	initial_base_size = base_cells.size()
	cell_base_ref = $base.get_used_cells()
	print(base_cells)
	set_mark()
	$Button.set_disabled(true)
	$sort.set_disabled(true)
	rand_to_use()
	pass 

func rand_to_use():
	var new_ti = Timer.new()
	new_ti.set_name("_rand")
	new_ti.set_wait_time(1)
	new_ti.start()
	add_child(new_ti)
	yield(new_ti,"timeout")
	rand_to_use = rand_range(0,10)
	new_ti.queue_free()
	return rand_to_use()
	pass
onready var dot = load("res://assets/0_1/dot.png")

var teste_cont 
var weight_test = []
func teste_distance():
	if init_seted == true and teste_cont >0:
		var quant = cell_base_ref.size()
		for i in quant:
			var x = cell_base_ref[i]
			var y = Vector2(x.x,x.y)
			var z = $base.map_to_world(cell_base_ref[i])
			var w = Vector2(z.x+8,z.y+8)
			var k = Vector2(z.x+2,z.y+2)
			var names = Sprite.new()
			var lab = Label.new()
			weight_test.append(round(calculate_vector_distance(w,(Vector2(PlayerCell.x+8,PlayerCell.y+8)))))
			lab.set_text(str(weight_test[i]))
			names.set_texture(dot)
			add_child(names)
			add_child(lab)
			#names.rect_scale()
			print("TEST: "+str(weight_test[i]))
			names.set_position(w)
			lab.set_position(k)
			quant -=1
			print(weight_test)
			teste_cont -= 1
			pass
		pass
	pass

var cell_world_pos = []

func cursor_select_cell():
	var b_cells = $base.get_used_cells()
	if cell_world_pos.size() < b_cells.size():
		if b_cells != null:
			b_cells.erase(PlayerCell)
			for i in b_cells.size():
				var cell = $base.map_to_world(b_cells[i])
				var cellx = cell.x -8
				var celly = cell.y -8
				cell = Vector2(cellx,celly)
				cell_world_pos.append(cell)
				print(cell_world_pos)
				pass
			pass
		pass
	var cursor_pos = get_global_mouse_position()
	cursor_pos = Vector2(round(cursor_pos.x),round(cursor_pos.y))
	#print(cursor_pos)
	var world_t_pos = $base.world_to_map(cursor_pos)
	#print(world_t_pos)
	#$marks.set_cell(world_t_pos.x,world_t_pos.y,9)
	if Input.is_action_just_pressed("left_click") and world_t_pos == PlayerCell:
		print("Player CELL!!!")
		match move_state:
			true:
				move_state = false
				dataLoaded = false
				enemy_cell()
				pass
			false:
				move_cell()
				move_state = true
				pass
		pass
	if move_state:
		
		if not cell_weight.has(0):
			cell_base_ref.remove(cell_base_ref.find(PlayerCell))
			cell_base_ref.insert(0,PlayerCell)
			self.cell_weight.insert(0,0)
			#print(cell_weight[0])
			pass
		
		#print("Cell_index: "+str(cell_base_ref.find(world_t_pos)))
		#print("WEIGHT: "+str(cell_weight[cell_base_ref.find(world_t_pos)]))
		#calculate_vector_distance(A,B)
		#print(move_state)
		if cell_base_ref.has(world_t_pos) and can_move_cells.has(world_t_pos):
			if not select_cells.has(world_t_pos) and world_t_pos != PlayerCell:
				select_cells.insert(0,world_t_pos)
				print(select_cells)
				
				
				if select_cells.size() ==2 and calculate_vector_distance(PlayerCell,world_t_pos) <1.11:
					move_clicked = true
					select_cells.resize(3)
					$marks.set_cell(select_cells[0].x,select_cells[0].y,1)
					$marks.set_cell(select_cells[1].x,select_cells[1].y,3)
					#$marks.set_cell(select_cells[1].x,select_cells[1].y,cell_weight[cell_base_ref.find(select_cells[1])])
					pass
				if select_cells.size() > 2 and calculate_vector_distance(PlayerCell,world_t_pos) >1.12:
					if calculate_vector_distance(select_cells[0],select_cells[1]) < 1.11:
						$marks.set_cell(select_cells[0].x,select_cells[0].y,1)
					#for i in can_move_cells.size():
						#if calculate_vector_distance(can_move_cells[i],world_t_pos) < 1.1 and calculate_vector_distance(can_move_cells[i],PlayerCell)<1.1:
							#$marks.set_cell(select_cells[0].x,select_cells[0].y,1)
							#$marks.set_cell(select_cells[2].x,select_cells[2].y,3)
						pass
				else:
					$marks.set_cell(select_cells[0].x,select_cells[0].y,1)
					pass
	else:
		if move_clicked == true:
			#$marks.set_cell(select_cells[0].x,select_cells[0].y,cell_weight[cell_base_ref.find(select_cells[1])])
			pass
		pass
	pass

var move_arr = []
var can_move_cells = []
var blankMoveCells = []

func move_cell():
	for i in move_arr.size():
		#if calculate_vector_distance(PlayerCell,move_arr[i]) < 2.83:
		
		$marks.set_cell(move_arr[i].x,move_arr[i].y,3)
		can_move_cells.append(move_arr[i])
		
	pass
	for i in blankMoveCells.size():
		$marks.set_cell(blankMoveCells[i].x,blankMoveCells[i].y,0)
		
		pass
var move_clicked = false
var select_cells = []
func set_mark_by_weight(weight,cell):
	var x = cell.x
	var y = cell.y
	match weight:
		0:
			$marks.set_cell(x,y,10)
			pass
		1:
			$marks.set_cell(x,y,1)
			pass
		2:
			$marks.set_cell(x,y,2)
			pass
		3:
			$marks.set_cell(x,y,3)
			pass
		4:
			$marks.set_cell(x,y,4)
			pass
		5:
			$marks.set_cell(x,y,5)
			pass
		6:
			$marks.set_cell(x,y,6)
			pass
	pass	
	
func _process(delta):
	cursor_select_cell()
	pass
	
func set_mark():
	$Button.set_disabled(true)
	$sort.set_disabled(true)
	var bol = [true,false,true,false]
	if base_cells.size() > 0:
		var base = base_cells[0]
		var x = base.x
		var y = base.y
		var new_timer = Timer.new()
		new_timer.set_wait_time(insert_time)
		new_timer.start()
		add_child(new_timer)
		bol.shuffle()
		self.base.set_cell(x,y,round(rand_range(0,4)),bol[0],bol[1])
		yield(new_timer,"timeout")
			
		if not sort:
			default.set_cell(x,y,0)
			pass
		rand_to_use = rand_range(5,9)
		print(rand_to_use)
		if base_cells.size() <= ((initial_base_size/10)*rand_to_use) and init_seted == false:
			PlayerCell.x = x
			PlayerCell.y = y
			default.set_cell(x,y,10)
			print("CELULA INICIAL")
			init_seted = true
		new_timer.queue_free()
		base_cells.remove(0)
		base_cells.shuffle()
		return set_mark()
	else:
		print("its done")
		enemy_cell()
		$Button.set_disabled(false)
		$sort.set_disabled(false)
	pass
	
	
	#for enemy cells
var quant
var cell
var cell_distance = []
var dataLoaded = false
var doEnemuCell = false
var cell_weight = []

func enemy_cell():
	#loop´inicio
	var new_timer = Timer.new()
	new_timer.set_wait_time(insert_time)
	new_timer.start()
	add_child(new_timer)
	yield(new_timer,"timeout")
	#yeld do loop
	if not dataLoaded:
		var cells = $marks.get_used_cells()
		#escluir a celular do player
		cells.erase(PlayerCell)
		quant = cells.size()
		self.cell = cells
		dataLoaded = true
		doEnemuCell = true
		pass
	if doEnemuCell and quant > 0:
		cell_distance.append(calculate_vector_distance(PlayerCell,cell[0]))
		var label = Label.new()
		var ds = cell_distance[cell_distance.size()-1]
		label.set_text(str(floor(ds*10)))
		var temp_ds = floor(ds*10)
		if temp_ds <= (player_mp *10) and cell[0].x >= (PlayerCell.x -2) and cell[0].x <= (PlayerCell.x +2) and cell[0].y >= (PlayerCell.y -2) and cell[0].y <= (PlayerCell.y +2):
			move_arr.append(cell[0])
			
			pass
		else:
			blankMoveCells.append(cell[0])
			pass
		add_child(label)
		var pos = $base.map_to_world(cell[0])
		label.set_position(Vector2(pos.x+4,pos.y+4))
		var x = cell[0].x
		var y = cell[0].y
		if ds > 0 and ds < 1.111:
			$marks.set_cell(x,y,-1)
			$marks.set_cell(x,y,1)
			cell_weight.append(1)
			pass	
		if ds > 1.122 and ds < 2.111:
			$marks.set_cell(x,y,-1)
			$marks.set_cell(x,y,2)
			cell_weight.append(2)
			pass
		if ds > 2.122 and ds < 3.111:
			$marks.set_cell(x,y,-1)
			$marks.set_cell(x,y,3)
			cell_weight.append(3)
			pass
		if ds > 3.122 and ds < 4.111:
			$marks.set_cell(x,y,-1)
			$marks.set_cell(x,y,4)
			cell_weight.append(4)
			pass
		if ds > 4.122 and ds < 5.111:
			$marks.set_cell(x,y,-1)
			$marks.set_cell(x,y,5)
			cell_weight.append(5)
			pass
		if ds > 5.122 and ds < 6.111:
			$marks.set_cell(x,y,-1)
			$marks.set_cell(x,y,6)
			cell_weight.append(6)
			pass
		if ds > 6.122 and ds < 7.111:
			$marks.set_cell(x,y,-1)
			$marks.set_cell(x,y,7)
			cell_weight.append(7)
			pass
		if ds > 7.122 and ds < 8.111:
			$marks.set_cell(x,y,-1)
			$marks.set_cell(x,y,8)
			cell_weight.append(8)
			pass
		if ds > 8.122:
			$marks.set_cell(x,y,-1)
			$marks.set_cell(x,y,9)
			cell_weight.append(9)
			pass		
		cell.remove(0)
		quant = cell.size()
		print(cell_distance)
		print(cell_weight)
		enemy_cell()
		
		pass	
	new_timer.queue_free()
	pass

#cauculo da distancia euclidiana
func calculate_vector_distance(A,B):
	var distance = sqrt(((A.x - B.x)*(A.x - B.x))+((A.y - B.y)*(A.y - B.y)))
	print(distance)
	return distance
	pass
	
func toggle_visible_mark():
	if $marks.is_visible():
		$marks.set_visible(false)
	else:
		$marks.set_visible(true)
	pass 

func sort():
	sort = true
	insert_time = 0.05
	base_cells = base.get_used_cells()
	set_mark()
	pass 

func move():
	
	pass