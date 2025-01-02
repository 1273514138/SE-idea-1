extends PanelContainer

signal folder_selected(dir_path:String)
signal folder_selected_download(dir_path:String)
signal folder_selected_encrypt(encryption_way:Encryption.encrypt_way_all)
signal delete_selected

@onready var menu_file = %"上传文件"
@onready var menu_download = %"下载文件"
@onready var menu_encrypt = %"加密方式"
@onready var menu_delete = %"删除文件"


enum MenuFile {Open}
enum MenuDownload {Choose}
enum MenuEncrypy {Caesar,Vigenere,RSA,Transposition}
enum MenuDelete {Delete}

func _ready():
	init_menu_file()
	init_menu_download()
	init_menu_encrypy()
	init_menu_delete()

func init_menu_file():
	menu_file.clear()
	menu_file.add_item("选择文件",MenuFile.Open)
	menu_file.id_pressed.connect(call_menu_file)

func call_menu_file(id:int):
	if id == MenuFile.Open:
		DisplayServer.file_dialog_show("Open folder","","",false,
										DisplayServer.FILE_DIALOG_MODE_OPEN_FILE,
										["*.txt"],
										_on_floder_selected)


func _on_floder_selected(status:bool , selected_paths:PackedStringArray , selected_filter_index:int ):
	if not status:
		return
	folder_selected.emit(selected_paths[0])


func init_menu_download():
	menu_download.clear()
	menu_download.add_item("保存到本地",MenuDownload.Choose)
	menu_download.id_pressed.connect(call_menu_download)

func call_menu_download(id:int):
	if id == MenuDownload.Choose:
		DisplayServer.file_dialog_show("Open folder","","",false,
										DisplayServer.FILE_DIALOG_MODE_OPEN_DIR,
										[],
										_on_floder_selected_download)

func _on_floder_selected_download(status:bool , selected_paths:PackedStringArray , selected_filter_index:int ):
	if not status:
		return
	folder_selected_download.emit(selected_paths[0])
	
func init_menu_encrypy():
	menu_encrypt.clear()
	menu_encrypt.add_item("Caesar",MenuEncrypy.Caesar)
	menu_encrypt.add_item("Transposition",MenuEncrypy.Transposition)
	menu_encrypt.add_item("Vigenere",MenuEncrypy.Vigenere)
	menu_encrypt.add_item("RSA",MenuEncrypy.RSA)
	menu_encrypt.id_pressed.connect(change_encrypt)
	
func change_encrypt(id:int):
	if id == MenuEncrypy.Caesar:
		Encryption.encrypt_way = Encryption.encrypt_way_all.Caesar
	if id == MenuEncrypy.Vigenere:
		Encryption.encrypt_way = Encryption.encrypt_way_all.Vigenere
	if id == MenuEncrypy.RSA:
		Encryption.encrypt_way = Encryption.encrypt_way_all.RSA
	if id==MenuEncrypy.Transposition:
		Encryption.encrypt_way = Encryption.encrypt_way_all.Transposition
	folder_selected_encrypt.emit(Encryption.encrypt_way)
	
func init_menu_delete():
	menu_delete.clear()
	menu_delete.add_item("删除当前文件",MenuDelete.Delete)
	menu_delete.id_pressed.connect(delete_file)
	
func delete_file(id:int):
	if id == MenuDelete.Delete:
		delete_selected.emit()
