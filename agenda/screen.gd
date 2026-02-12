extends Control

@onready var info = $app/info
@onready var tasks = $app/info/tasks
@onready var watch = $app/watch

var items_save_path = "user://items.save"
var records_save_path
var file
var items = []
var breakable = []

var texture = load("res://recording.png")
var previous
var lock = false

var task_input_index = 0

var time
var year
var month
var day
var format

var task_running = false
var start_time
var end_time
var records_months = []
var records_days = []
var records_tasks = []
var records_dur = []

var work_time = 5 #3600
var rest_time = 5 #600

func _ready():
	update_date()
	load_items()
	# focus on "add" when we open the app (keyboard driven approach)
	$panels/HBoxContainer/tasks.button_pressed = true
	$app/info/tasks.grab_focus()
	tasks.select(0)
	
	# my debug tool
	#var dict = {"month": records_months, "day": records_days, "task": records_tasks, "duration": records_dur}
	#print(dict)

func visualizer():
	# here we set an array with the index position of the actual day against
	# the database
	# maybe: https://www.wikidoc.org/index.php/Orders_of_magnitude
	var months_registers = records_months.count(month)
	var months_position = []
	var z = 0
	for x in months_registers:
		var a = records_months.find(month, z)
		months_position.append(a)
		z = a + 1
	var days_position = []
	for x in months_registers:
		var a = months_position.get(0)
		months_position.remove_at(0)
		if records_days.get(a) == day:
			days_position.append(a)
	# then we use this array to find the applications used
	# and their recorded time
	var y = days_position
	var d = 0
	for x in tasks.item_count - 1:
		var e = tasks.get_item_text(x + 1)
		days_position = y.duplicate()
		for w in days_position.size():
			var a = days_position.get(0)
			days_position.remove_at(0)
			if records_tasks.get(a) == e:
				var c = records_dur.get(a)
				d = c + d
		print("you worked in %s for %s" % [e, d])
		d = 0

# from https://www.youtube.com/shorts/M-0UNa8M5bE
var seconds: float = 0
func _process(delta: float) -> void:
	seconds += delta
	seconds = fmod(seconds, 60)
	if task_running:
		watch.text = "%d" % seconds

# TODO
# communicate with zid
# bring a screen that cycles between stretch exercises
# the rest time should prevent user from using the app
func ergonomics():
	stop_item()
	#$rest_timer.start(rest_time)

func stop_item():
	lock = false
	tasks.set_item_icon(previous, null)
	end_time = Time.get_unix_time_from_system()
	var dur = start_time - end_time
	dur = int(- dur)
	records_months.append(month)
	records_days.append(day)
	records_tasks.append(tasks.get_item_text(previous))
	records_dur.append(dur)
	task_running = false
	watch.hide()
	update_date()

func update_date():
	time = Time.get_date_dict_from_system()
	year = time["year"]
	month = time["month"]
	day = time["day"]
	format = "%s" % [year]
	records_save_path = "user://%s.save" % [format]
	format = "%s%s%s" % [year, month, day]
	info.text = format

func load_items():
	if FileAccess.file_exists(items_save_path):
		file = FileAccess.open(items_save_path, FileAccess.READ)
		items = file.get_var()
		breakable = file.get_var()
		var items_size = items.size()
		for z in items_size:
			tasks.add_item(items.get(z), null, true)
	if FileAccess.file_exists(records_save_path):
		file = FileAccess.open(records_save_path, FileAccess.READ)
		records_months = file.get_var()
		records_days = file.get_var()
		records_tasks = file.get_var()
		records_dur = file.get_var()

func save_items():
	file = FileAccess.open(items_save_path, FileAccess.WRITE)
	file.store_var(items)
	file.store_var(breakable)
	file = FileAccess.open(records_save_path, FileAccess.WRITE)
	file.store_var(records_months)
	file.store_var(records_days)
	file.store_var(records_tasks)
	file.store_var(records_dur)
	file.close()

# saves items before exiting
func _exit_tree() -> void:
	save_items()

func _on_line_edit_text_submitted(task_name_entry: String) -> void:
	if task_name_entry == "":
		return
	tasks.add_item(task_name_entry, null, true)
	items.append(task_name_entry)
	breakable.append($add_tasks/VBoxContainer/CheckBox.button_pressed)
	$add_tasks.hide()
	$add_tasks/VBoxContainer/LineEdit.clear()
	$app/info/tasks.grab_focus()
	tasks.select(0)

func _on_check_box_gui_input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		if !$add_tasks/VBoxContainer/CheckBox.button_pressed:
			$add_tasks/VBoxContainer/CheckBox.button_pressed = true
		else:
			$add_tasks/VBoxContainer/CheckBox.button_pressed = false
	if Input.is_key_pressed(KEY_ENTER):
		_on_line_edit_text_submitted($add_tasks/VBoxContainer/LineEdit.text)
	if Input.is_key_pressed(KEY_ESCAPE):
		$add_tasks.hide()
		$add_tasks/VBoxContainer/LineEdit.clear()
		$app/info/tasks.grab_focus()
	if Input.is_key_pressed(KEY_TAB):
		$add_tasks/VBoxContainer/LineEdit.grab_focus()

func _on_line_edit_gui_input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_TAB):
		$add_tasks/VBoxContainer/CheckBox.grab_focus()
	if Input.is_key_pressed(KEY_ESCAPE):
		$add_tasks.hide()
		$add_tasks/VBoxContainer/LineEdit.clear()
		$app/info/tasks.grab_focus()

func _on_tasks_item_selected(index: int) -> void:
	task_input_index = index

func _on_tasks_gui_input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ENTER):
		_on_tasks_item_activated(task_input_index)
	elif Input.is_key_pressed(KEY_DELETE):
		_on_tasks_item_activated(task_input_index)
		task_input_index = task_input_index - 1
		tasks.select(task_input_index)

func _on_tasks_item_activated(index: int) -> void:
	if index == 0:
		$add_tasks.show()
		$add_tasks/VBoxContainer/LineEdit.grab_focus()
	else:
		# hold CTRL to remove an item! or press DELETE
		if Input.is_key_pressed(KEY_CTRL) or Input.is_key_pressed(KEY_DELETE):
			tasks.remove_item(index)
			# minus 1 here because the arrays don't have the "add" item
			items.remove_at(index - 1)
			breakable.remove_at(index - 1)
			return
		# stops tracking the item, we identify if it has an icon, mark if there's a recording going
		# on where we clicked
		if tasks.get_item_icon(index):
			if breakable.get(index - 1):
				$ergonomics_timer.stop()
			stop_item()
		# start tracking the item
		else:
			# the 1° check is when we start the app and 'previous' is null
			# then we prevent from double registering a task in case user
			# starts the same task
			if previous and previous != index:
				if !breakable.get(index - 1):
					$ergonomics_timer.stop()
				if lock:
					stop_item()
			lock = true
			previous = index
			start_time = Time.get_unix_time_from_system()
			seconds = 0
			watch.show()
			task_running = true
			tasks.set_item_icon(index, texture)
			if breakable.get(index - 1):
				if $ergonomics_timer.time_left > 0:
					return
				$ergonomics_timer.start(work_time)

func _on_item_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	_on_tasks_item_activated(index)

func _on_tasks_focus_entered() -> void:
	if $add_tasks.visible:
		$add_tasks/VBoxContainer/LineEdit.grab_focus()

# still need to check the .visible logic properly... isn't better if we have
# just non-toggle buttons? and we hide() and show() stuff accordingly?
func _on_tasks_pressed() -> void:
	tasks.show()
	tasks.grab_focus()
	$panels/HBoxContainer/tasks.button_pressed = true
	$panels/HBoxContainer/todo.button_pressed = false
	$panels/HBoxContainer/time.button_pressed = false

func _on_time_pressed() -> void:
	$add_tasks.hide()
	tasks.hide()
	$panels/HBoxContainer/tasks.button_pressed = false
	$panels/HBoxContainer/todo.button_pressed = false
	$panels/HBoxContainer/time.button_pressed = true

func _on_todo_pressed() -> void:
	$add_tasks.hide()
	tasks.hide()
	$panels/HBoxContainer/tasks.button_pressed = false
	$panels/HBoxContainer/todo.button_pressed = true
	$panels/HBoxContainer/time.button_pressed = false
