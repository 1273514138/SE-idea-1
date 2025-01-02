extends Control

@onready var menu_bar_panel = %MenuBarPanel
@onready var files_manager = %FilesManager
@onready var viewer = %Viewer


func _ready():
	menu_bar_panel.folder_selected.connect(files_manager.add_new_file)
	files_manager.file_change.connect(_on_file_change)
	viewer.add_file_tree.connect(files_manager.add_create_file)
	menu_bar_panel.folder_selected_encrypt.connect(viewer.change_encrypt_text)
	menu_bar_panel.folder_selected_download.connect(files_manager.download_file)
	menu_bar_panel.delete_selected.connect(files_manager.delete_file)
	
func _on_file_change(): 
	var file_directory = files_manager.get_current_directory()
	var file = FileAccess.open(file_directory,FileAccess.READ)
	

	var title = file.get_path() as String

	var content = file.get_as_text()
	viewer._init_txt(title.get_file(),content)
	file.close()
