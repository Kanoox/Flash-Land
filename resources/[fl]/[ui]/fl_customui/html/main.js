
var rgbStart = [139,195,74]
var rgbEnd = [183,28,28]

$(function(){
	$('#ui').hide();
	window.addEventListener('message', function(event) {
		if (event.data.action == "setValue"){
			if (event.data.key == "job"){
				setJobIcon(event.data.icon);
				updateDisplayJob(event.data.icon == "unemployed");
			}

			if (event.data.key == "faction"){
				setFactionIcon(event.data.icon);
				updateDisplayFaction(event.data.icon == "resid");
			}

			if (event.data.key == "money"){
				updateDisplayMoney(event.data.value == "$0");
			}

			if (event.data.key == "dirtymoney"){
				updateDisplayBlackMoney(event.data.value == "$0");
			}

			setValue(event.data.key, event.data.value)

		}else if (event.data.action == "updateStatus"){
			updateStatus(event.data.status);
		}else if (event.data.action == "setTalking"){
			setTalking(event.data.value);
		}else if (event.data.action == "setProximity"){
			setProximity(event.data.value)
		}else if (event.data.action == "toggle"){
			if (event.data.show){
				$('#ui').show();
			} else{
				$('#ui').hide();
			}
		} else if (event.data.action == "toggleCar"){
			if (event.data.show){
				//$('.carStats').show();
			} else{
				//$('.carStats').hide();
			}
		}else if (event.data.action == "updateCarStatus"){
			updateCarStatus(event.data.status);
		}else if (event.data.action == "updateWeight"){
			updateWeight(event.data.weight, event.data.maxweight);
		}else if (event.data.action == "updateDisplayMoney"){
			updateDisplayMoney(event.data.hide);
		}else if (event.data.action == "updateDisplayBlackMoney"){
			updateDisplayBlackMoney(event.data.hide);
		}else if (event.data.action == "updateDisplayJob"){
			updateDisplayJob(event.data.hide);
		}else if (event.data.action == "updateDisplayFaction"){
			updateDisplayFaction(event.data.hide);
		}
	});

});

function updateDisplayMoney(hide) {
	if(hide){
		$('#money').hide()
	} else {
		$('#money').show();
	}
}
function updateDisplayBlackMoney(hide) {
	if(hide){
		$('#dirtymoney').hide()
	} else {
		$('#dirtymoney').show();
	}
}
function updateDisplayJob(hide) {
	if(hide){
		$('#job').hide()
	} else {
		$('#job').show();
	}
}
function updateDisplayFaction(hide) {
	if(hide){
		$('#faction').hide()
	} else {
		$('#faction').show();
	}
}

function updateCarStatus(status){
	var gas = status[0]
	$('#gas .bg').css('height', gas.percent+'%')
	var bgcolor = colourGradient(gas.percent/100, rgbStart, rgbEnd)
	//var bgcolor = colourGradient(0.1, rgbStart, rgbEnd)
	//$('#gas .bg').css('height', '10%')
	$('#gas .bg').css('background-color', 'rgb(' + bgcolor[0] +','+ bgcolor[1] +','+ bgcolor[2] +')')
}

function setValue(key, value){
	$('#'+key+' span').html(value)
}

function setJobIcon(value){
	$('#job img').attr('src', 'img/jobs/'+value+'.png')
}

function setFactionIcon(value){
	$('#faction img').attr('src', 'img/faction/'+value+'.png')
}

function updateStatus(status){
	var hunger = status['hunger'] / 10000;
	var thirst = status['thirst'] / 10000;
	var drunk = status['drunk'] / 10000;

	$('#hunger .bg').css('height', hunger+'%')
	$('#water .bg').css('height', thirst+'%')
	$('#drunk .bg').css('height', drunk+'%')

	if (drunk != undefined && drunk > 0){
		$('#drunk').show();
	}else{
		$('#drunk').hide();
	}
}

function setProximity(value){
	var color;
	var speaker;
	if (value == 1){
		color = "#bfead3";
		speaker = 1;
	}else if (value == 2){
      color = "#e1d99c"
      speaker = 2;
    }else if (value == 3){
		color = "#eda277"
		speaker = 2;
	}else if (value == 4){
		color = "#f48a78"
		speaker = 3;
	}
	$('#voice .bg').css('background-color', color);
	$('#voice img').attr('src', 'img/speaker'+speaker+'.png');
}

function setTalking(value){
	if (value){
		//#64B5F6
		$('#voice').css('border', '3px solid #3dbf15')
	}else{
		//#81C784
		$('#voice').css('border', 'none')
	}
}

var tgl=true;
$(this).keypress((e) => {
    if (e.which == 13) {
    tgl=!tgl;
        if(tgl)
        {
        $('#ui').show();
        }
        else
        {
        $('#ui').hide();
        }
}})

//API Shit
function colourGradient(p, rgb_beginning, rgb_end){
    var w = p * 2 - 1;

    var w1 = (w + 1) / 2.0;
    var w2 = 1 - w1;

    var rgb = [parseInt(rgb_beginning[0] * w1 + rgb_end[0] * w2),
        parseInt(rgb_beginning[1] * w1 + rgb_end[1] * w2),
            parseInt(rgb_beginning[2] * w1 + rgb_end[2] * w2)];
    return rgb;
};