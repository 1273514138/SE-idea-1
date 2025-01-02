extends PanelContainer

signal file_change

@onready var tree = %Tree

var root:TreeItem

@export var file_path: String:
	set(value):
		file_path = value
		if is_inside_tree():
			init_file_path()

@export var ICON_FOLDER :Resource

func _ready():
	root = tree.create_item()
	DirAccess.make_dir_absolute("user://encryptionFile")
	file_path = "user://encryptionFile"
	tree.item_selected.connect(_on_item_selected)


func add_new_file(value:String):
	assert(FileAccess.file_exists(value),"file path must exists!")
	
	var file_to_name:String = value.get_file()
	var file_from = FileAccess.open(value,FileAccess.READ)
	var file_to = FileAccess.open("user://encryptionFile/"+file_to_name,FileAccess.WRITE)
	file_to.store_string(file_from.get_as_text())

	
	var sub_tree_item = tree.create_item(root) as TreeItem
	sub_tree_item.set_icon(0,ICON_FOLDER)
	sub_tree_item.set_text(0,file_to_name)
	sub_tree_item.set_metadata(0,"user://encryptionFile/"+file_to_name)
	
	file_from.close()
	file_to.close()

func download_file(value:String):
	var file_directory = get_current_directory()
	if not file_directory:
		return

	var file_from = FileAccess.open(file_directory,FileAccess.READ)
	var file_to_name =file_from.get_path().get_file()
	var file_to = FileAccess.open(value+"/"+file_to_name,FileAccess.WRITE)
	file_to.store_string(file_from.get_as_text())
	
	file_from.close()
	file_to.close()

func delete_file():
	var file_directory = get_current_directory()
	if not file_directory:
		return
	var current_item := tree.get_selected() as TreeItem
	current_item.free()
	
	DirAccess.remove_absolute(file_directory)

func add_create_file(file_name:String):
	var sub_tree_item = tree.create_item(root) as TreeItem
	sub_tree_item.set_icon(0,ICON_FOLDER)
	sub_tree_item.set_text(0,file_name)
	sub_tree_item.set_metadata(0,"user://encryptionFile/"+file_name)


func init_file_path():
	tree.clear()
	root = tree.create_item()
	if not file_path or not DirAccess.dir_exists_absolute(file_path):
		return
	create_tree_from_dir(root,file_path)
	


func create_tree_from_dir(parent:TreeItem,directory:String)->void:
	var dir = DirAccess.open(directory)
	for sub_dir in dir.get_files():
		var sub_tree_item = tree.create_item(parent) as TreeItem
		sub_tree_item.set_icon(0,ICON_FOLDER)
		sub_tree_item.set_text(0,sub_dir)
		
		var sub_dir_path = directory+"/"+sub_dir
		sub_tree_item.set_metadata(0,sub_dir_path)
	return

func get_current_directory():
	var current_item := tree.get_selected() as TreeItem
	if current_item:
		return current_item.get_metadata(0)


func _on_item_selected():
	file_change.emit()
