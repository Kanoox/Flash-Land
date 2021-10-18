fx_version 'bodacious'
game 'gta5'

ui_page 'html/index.html'

client_script 'cl_chat.lua'
server_script 'sv_chat.lua'

files {
	'html/**/*',

	'chatthemecivlifechat.css',
}

chat_theme 'gtao' {
	styleSheet = 'chatthemecivlifechat.css',
	msgTemplates = {
		default = '<b>{0}</b><span>{1}</span>'
	}
}





