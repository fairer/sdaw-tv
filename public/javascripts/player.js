document.observe("dom:loaded", function () {

    function changeVideo(name)
    {
        $('player').changeSource('/videos/' + name)
    }

    // Testing purpose. #TO DO : REMOVE
    document.getElementById("button").onclick = function () {
        changeVideo('numanuma.flv');
    };

    //getPlayer().onVideoEnds = function () {
      //  alert('lol');
    //};

    document.onmousemove = function () {
        changeVideo('gunther.flv');
        document.onmousemove = null;
    };

    $('play').onclick = function () {
        $('player').play();
    }

    $('pause').onclick = function () {
        $('player').pause();
    }


    $('fs').onclick = function () {
        $('player').fullscreen();
    }


    function get_urls() {
        new Ajax.Request('videos/to_xml/', {
            onSuccess: function(response) {
                alert(response);
            }
        });
    }

    get_urls();
});


    function onVideoEnds() {
        alert('end');
    }

    function onPaused() {
        alert('paused');
    }
