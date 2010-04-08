document.observe("dom:loaded", function () {

    // Get the video player
    function getPlayer()
    {
        var movieName = "player";
        if (window.document[movieName])
        {
            return window.document[movieName];
        }
        else if (navigator.appName.indexOf("Microsoft Internet")==-1)
        {
            if (document.embeds && document.embeds[movieName])
                return document.embeds[movieName];
            else
                return null;

        }
        else // if (navigator.appName.indexOf("Microsoft Internet")!=-1)
        {
            return document.getElementById(movieName);
        }
    }

    // Use this to change curently played video
    function changeVideo(name)
    {
        var flashMovie = getPlayer();
        flashMovie.changeSource("../videos/" + name);
        $('txt').innerHTML = $('txt').innerHTML + "<br/>video played";
    }

    // Testing purpose. #TO DO : REMOVE
    document.getElementById("button").onclick = function () {
        changeVideo('barsandtone.flv');
    };

    //getPlayer().onVideoEnds = function () {
      //  alert('lol');
    //};

    // When finishing loading page
    function playFirstVid () {
        changeVideo('gunther.flv');
    }

    document.onmousemove = function () {
        playFirstVid();
        document.onmousemove = null;
    };
});
