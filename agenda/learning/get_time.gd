extends Node2D

var file_name
var year
var month
var save_path
var file
var time
var saved
var godot = []
var test

func _ready() -> void:
	
	# save-file name
	time = Time.get_date_dict_from_system()
	year = time["year"]
	month = time["month"]
	test = 1
	var format = "%s%s"
	file_name = format % [year, month]
	#print(file_name)
	save_path = "user://%s.save" % [file_name]
	writing()
	stuff()
	reading()

func writing():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(test)
	file.store_var(time)
	file.store_var(month)
	
func stuff():
	var file = FileAccess.open(save_path, FileAccess.READ)
	for n in 3:
		godot.insert(n, file.get_var())
	print(godot)
	file = FileAccess.open(save_path, FileAccess.WRITE)
	godot.remove_at(1)
	for n in 2:
		file.store_var(godot.get(n))
	var hello = "tring"
	file.store_var(hello)
	
func reading():
	if FileAccess.file_exists(save_path):
		print("file found")
		var file = FileAccess.open(save_path, FileAccess.READ)
		var test = file.get_var()
		var test1 = file.get_var()
		var test2 = file.get_var()
		var test3 = file.get_var()
		print(test)
		print(test1)
		print(test2)
		print(test3)
		# so the get_var is an array/dictionary?
