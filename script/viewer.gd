extends PanelContainer

signal add_file_tree(file_name:String)

@onready var title = $MarginContainer/HSplitContainer/TextPanel/VBoxContainer/title
@onready var message = $MarginContainer/HSplitContainer/TextPanel/VBoxContainer/VSplitContainer/message
@onready var secret_key = $MarginContainer/HSplitContainer/TextPanel/VBoxContainer/VSplitContainer/secretKey

@onready var public_key = $MarginContainer/HSplitContainer/ButtonPanel/VBoxContainer/publicKey
@onready var encrypt_text = $MarginContainer/HSplitContainer/ButtonPanel/VBoxContainer/encryptText

@onready var encrypt = $MarginContainer/HSplitContainer/ButtonPanel/VBoxContainer/encrypt
@onready var decode = $MarginContainer/HSplitContainer/ButtonPanel/VBoxContainer/decode



func _ready():
	pass # Replace with function body.

func _init_txt(the_title:String,the_content:String):
	title.set_text(the_title)
	message.set_text(the_content)
	pass

func change_encrypt_text(the_way:Encryption.encrypt_way_all):
	match the_way:
		Encryption.encrypt_way_all.Caesar:
			encrypt_text.set_text("Caesar")
			public_key.set_editable(false)
		Encryption.encrypt_way_all.Vigenere:
			encrypt_text.set_text("Vigenere")
			public_key.set_editable(false)
		Encryption.encrypt_way_all.RSA:
			encrypt_text.set_text("RSA")
			public_key.set_editable(true)
		Encryption.encrypt_way_all.Transposition:
			encrypt_text.set_text("Transposition")
			public_key.set_editable(false)


func button_encrypt():
	match Encryption.encrypt_way:
		Encryption.encrypt_way_all.Caesar:
			var key_String = secret_key.get_text()
			var key = key_String.to_int()
			var content = Encryption.encrypt_Caesar(message.get_text(),key)
			save_file("密文"+title.get_text(),content)
		Encryption.encrypt_way_all.Vigenere:
			var key_String = secret_key.get_text()
			var content = Encryption.encrypt_Vigenere(message.get_text(),key_String)
			save_file("密文"+title.get_text(),content)
		Encryption.encrypt_way_all.RSA:
			var public_key_String = public_key.get_text()
			var public_key_Array = public_key_String.split(",")
			var public_key_1 = int(public_key_Array[0])
			var public_key_2 = int(public_key_Array[1])
			var content = Encryption.encrypt_RSA(message.get_text(),public_key_1,public_key_2)
			save_file("密文"+title.get_text(),content)
		Encryption.encrypt_way_all.Transposition:
			var key_String = secret_key.get_text()
			var content =Encryption.encrypt_Transposition(message.get_text(),key_String)
			save_file("密文"+title.get_text(),content)



func button_decode():
	match Encryption.encrypt_way:
		Encryption.encrypt_way_all.Caesar:
			var key_String = secret_key.get_text()
			var key = key_String.to_int()
			var content = Encryption.decode_Caesar(message.get_text(),key)
			save_file("明文"+title.get_text(),content)
		Encryption.encrypt_way_all.Vigenere:
			var key_String = secret_key.get_text()
			var content = Encryption.decode_Vigenere(message.get_text(),key_String)
			save_file("明文"+title.get_text(),content)
		Encryption.encrypt_way_all.RSA:
			var public_key_String = public_key.get_text()
			var public_key_Array = public_key_String.split(",")
			var public_key_2 = int(public_key_Array[1])
			var content = Encryption.decode_RSA(message.get_text(),public_key_2,int(secret_key.get_text()))
			save_file("明文"+title.get_text(),content)
		Encryption.encrypt_way_all.Transposition:
			var key_String = secret_key.get_text()
			var content =Encryption.decode_Transposition(message.get_text(),key_String)
			save_file("明文"+title.get_text(),content)


func save_file(file_name:String,file_content:String):
	var file_dir = "user://encryptionFile/"+file_name
	var file = FileAccess.open(file_dir,FileAccess.WRITE)
	file.store_string(file_content)
	file.close()
	add_file_tree.emit(file_name)
