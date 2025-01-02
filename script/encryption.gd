extends Node



enum encrypt_way_all {Caesar,Vigenere,RSA,Transposition}
var encrypt_way:encrypt_way_all


func encrypt_Caesar(content:String,key:int)->String:
	key = key%26
	var par = content.to_utf8_buffer()
	print(par)
	for i in range(0,par.size()):
		if par[i]>=97 and par[i]<=122:
			par[i]=(par[i]-97+key)%26+97
		elif par[i]>=65 and par[i]<=90:
			par[i]=(par[i]-65+key)%26+65
	return par.get_string_from_utf8()

func decode_Caesar(content:String,key:int)->String:
	key = key%26
	var par = content.to_utf8_buffer()
	for i in range(0,par.size()):
		if par[i]>=97 and par[i]<=122:
			par[i]=(par[i]-97-key+26)%26+97
		elif par[i]>=65 and par[i]<=90:
			par[i]=(par[i]-65-key+26)%26+65
	return par.get_string_from_utf8()

func encrypt_Vigenere(content:String,key:String)->String:
	var par_content = content.to_utf8_buffer()
	var par_key = key.to_utf8_buffer()
	var key_size = par_key.size()
	var jishu:int = 0
	for i in range(0,par_content.size()):
		if par_content[i]>=97 and par_content[i]<=122:
			par_content[i]=(par_content[i]+par_key[jishu]-97-97)%26+97
			jishu=(jishu+1)%key_size
		elif par_content[i]>=65 and par_content[i]<=90:
			par_content[i]=(par_content[i]+par_key[jishu]-65-97)%26+65
			jishu=(jishu+1)%key_size
	return par_content.get_string_from_utf8()

func decode_Vigenere(content:String,key:String)->String:
	var par_content = content.to_utf8_buffer()
	var par_key = key.to_utf8_buffer()
	var key_size = par_key.size()
	var jishu:int = 0
	for i in range(0,par_content.size()):
		if par_content[i]>=97 and par_content[i]<=122:
			par_content[i]=(par_content[i]-par_key[jishu]-97+97+26)%26+97
			jishu=(jishu+1)%key_size
		elif par_content[i]>=65 and par_content[i]<=90:
			par_content[i]=(par_content[i]-par_key[jishu]-65+97+26)%26+65
			jishu=(jishu+1)%key_size
	return par_content.get_string_from_utf8()

func encrypt_RSA(content:String,public_key_1:int,public_key_2:int)->String:
	var par_content = content.to_utf8_buffer()
	for i in range(0,par_content.size()):
		if par_content[i]>=97 and par_content[i]<=122:
			par_content[i]=int(pow(par_content[i]-97,public_key_1))%public_key_2+97
		elif par_content[i]>=65 and par_content[i]<=90:
			par_content[i]=int(pow(par_content[i]-65,public_key_1))%public_key_2+97
	return par_content.get_string_from_utf8()
	
func decode_RSA(content:String,public_key:int,secret_key:int)->String:
	var par_content = content.to_utf8_buffer()
	for i in range(0,par_content.size()):
		if par_content[i]!=10 and par_content[i]!=32:
			par_content[i]=int(pow(par_content[i]-97,secret_key))%public_key+97
	return par_content.get_string_from_utf8()

func encrypt_Transposition(content:String,key:String)->String:
	var par_content = content.to_utf8_buffer()
	var par_key = key.to_utf8_buffer()
	var num_array:PackedByteArray = []
	for i in range(0,par_content.size(),par_key.size()+1):
		for j in range(0,par_key.size()):
			num_array.push_back(par_content[i+par_key[j]-1-48])
	return num_array.get_string_from_utf8()

func decode_Transposition(content:String,key:String)->String:
	var par_content = content.to_utf8_buffer()
	var par_key = key.to_utf8_buffer()
	var num_array:PackedByteArray = par_content.duplicate()
	for i in range(0,par_content.size()-1,par_key.size()):
		for j in range(0,par_key.size()):
			var num = i+par_key[j]-1-48
			num_array[num]=par_content[i+j]

	return num_array.get_string_from_utf8()
