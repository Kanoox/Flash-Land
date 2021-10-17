(function(){

	let MenuTpl =
		'<div id="menu_{{_namespace}}_{{_name}}" class="dialog {{#isBig}}big{{/isBig}}">' +
			'<div class="head"><span>{{title}}</span></div>' +
				'{{#isDefault}}<input type="text" name="value"/>{{/isDefault}}' +
				'{{#isBig}}<textarea name="value"/>{{/isBig}}' +
				'<button type="button" name="submit">Envoyer</button>' +
				'<button type="button" name="cancel">Annuler</button>'
			'</div>' +
		'</div>'
	;

	window.FL_MENU       = {};
	FL_MENU.ResourceName = 'fl_menu_dialog';
	FL_MENU.opened       = {};
	FL_MENU.focus        = [];
	FL_MENU.pos          = {};

	FL_MENU.open = function(namespace, name, data){

		if(typeof FL_MENU.opened[namespace] == 'undefined')
			FL_MENU.opened[namespace] = {};

		if(typeof FL_MENU.opened[namespace][name] != 'undefined')
			FL_MENU.close(namespace, name);

		if(typeof FL_MENU.pos[namespace] == 'undefined')
			FL_MENU.pos[namespace] = {};

		if(typeof data.type == 'undefined')
			data.type = 'default';

		if(typeof data.align == 'undefined')
			data.align = 'top-left';

		data._index     = FL_MENU.focus.length;
		data._namespace = namespace;
		data._name      = name;

		FL_MENU.opened[namespace][name] = data;
		FL_MENU.pos   [namespace][name] = 0;

		FL_MENU.focus.push({
			namespace: namespace,
			name     : name
		});

		FL_MENU.render();
	}

	FL_MENU.close = function(namespace, name){

		delete FL_MENU.opened[namespace][name];

		for(let i=0; i<FL_MENU.focus.length; i++){
			if(FL_MENU.focus[i].namespace == namespace && FL_MENU.focus[i].name == name){
				FL_MENU.focus.splice(i, 1);
				break;
			}
		}

		FL_MENU.render();
	}

	FL_MENU.render = function(){

		let menuContainer = $('#menus')[0];

		$(menuContainer).find('button[name="submit"]').unbind('click');
		$(menuContainer).find('button[name="cancel"]').unbind('click');
		$(menuContainer).find('[name="value"]')       .unbind('input propertychange');
		menuContainer.innerHTML = '';

		$(menuContainer).hide();

		for(let namespace in FL_MENU.opened){
			for(let name in FL_MENU.opened[namespace]){

				let menuData = FL_MENU.opened[namespace][name];
				let view     = JSON.parse(JSON.stringify(menuData));

				switch(menuData.type){

					case 'default' : {
						view.isDefault = true;
						break;
					}

					case 'big' : {
						view.isBig = true;
						break;
					}

					default : break;

				}

				let menu = $(Mustache.render(MenuTpl, view))[0];

				$(menu).css('z-index', 1000 + view._index);

				$(menu).find('button[name="submit"]').click(function() {
					FL_MENU.submit(this.namespace, this.name, this.data);
				}.bind({namespace: namespace, name: name, data: menuData}));

				$(menu).find('button[name="cancel"]').click(function() {
					FL_MENU.cancel(this.namespace, this.name, this.data);
				}.bind({namespace: namespace, name: name, data: menuData}));

				$(menu).find('[name="value"]').bind('input propertychange', function(){
					this.data.value = $(menu).find('[name="value"]').val();
					FL_MENU.change(this.namespace, this.name, this.data);
				}.bind({namespace: namespace, name: name, data: menuData}));

				if(typeof menuData.value != 'undefined')
					$(menu).find('[name="value"]').val(menuData.value);

				menuContainer.appendChild(menu);
			}
		}


		$(menuContainer).show();
		$(menuContainer).find('[name="value"]').focus();
		$(menuContainer).find('[name="value"]').keydown(function(event) {
			if(event.which == 13){
				$(menuContainer).find('button[name="submit"]').click();
			}
			if(event.which == 8){
				$(menuContainer).find('button[name="cancel"]').click();
			}
			if(event.which == 27){
				$(menuContainer).find('button[name="cancel"]').click();
			}
		});
	}

	FL_MENU.submit = function(namespace, name, data){
		$.post('http://' + FL_MENU.ResourceName + '/menu_submit', JSON.stringify(data));
	}

	FL_MENU.cancel = function(namespace, name, data){
		$.post('http://' + FL_MENU.ResourceName + '/menu_cancel', JSON.stringify(data));
	}

	FL_MENU.change = function(namespace, name, data){
		$.post('http://' + FL_MENU.ResourceName + '/menu_change', JSON.stringify(data));
	}

	FL_MENU.getFocused = function(){
		return FL_MENU.focus[FL_MENU.focus.length - 1];
	}

	window.onData = (data) => {

		switch(data.action){

			case 'openMenu' : {
				FL_MENU.open(data.namespace, data.name, data.data);
				break;
			}

			case 'closeMenu' : {
				FL_MENU.close(data.namespace, data.name);
				break;
			}

		}

	}

	window.onload = function(e){
		window.addEventListener('message', (event) => {
			onData(event.data)
		});
	}

})()