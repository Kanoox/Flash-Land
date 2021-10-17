window.addEventListener('message', function (event) {
    // Check for playSound transaction
    if (event.data.transactionType == "playSound") {
        play(event.data.transactionData);
    } else if (event.data.transactionType == "stopSound") {
        stop();
    } else if (event.data.transactionType == "volume") {
        setVolume(event.data.transactionData);
    }
})

//YouTube IFrame API player.
var player;

//Create DOM elements for the player.
var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";

var ytScript = document.getElementsByTagName('script')[0];
ytScript.parentNode.insertBefore(tag, ytScript);

function onYouTubeIframeAPIReady() {
    player = new YT.Player('player', {
        width: '1',
        height: '',
        playerVars: {
            'autoplay': 0,
            'controls': 0,
            'disablekb': 1,
            'enablejsapi': 1,
            'vq': 'tiny',
        },
        events: {
            'onReady': onPlayerReady,
            'onStateChange': onPlayerStateChange,
            'onError': onPlayerError,
        }
    });
}

function onPlayerReady(event) {
    title = event.target.getVideoData().title;
    player.setVolume(30);
}

function onPlayerStateChange(event) {
    if (event.data == YT.PlayerState.PLAYING) {
        title = event.target.getVideoData().title;
    }

    if (event.data == YT.PlayerState.ENDED) {
        musicIndex++;
        play();
    }
}

function onPlayerError(event) {
    try {
        fetch(`https://${GetParentResourceName()}/errorCallback`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                errorType: event.data
            })
        })

        console.log("Error id : " + event.data);
    } catch (error) {
        console.error(error);
    }

    skip();
}

function skip() {
    play();
}

function play(id) {
    title = "n.a.";
    player.loadVideoById(id, 0, "tiny");
    player.playVideo();
}

function resume() {
    player.playVideo();
}

function pause() {
    player.pauseVideo();
}

function stop() {
    player.stopVideo();
}

function setVolume(volume) {
    player.setVolume(volume)
}