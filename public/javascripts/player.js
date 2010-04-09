document.observe("dom:loaded", function () {
    current_id = -1;

    // Testing purpose. #TO DO : REMOVE
    document.getElementById("button").onclick = function () {
        changeVideo('numanuma.flv');
    };

    $('play').onclick = function () {
        $('player').play();
        $('play').hide();
        $('pause').show();
    }

    $('pause').onclick = function () {
        $('player').pause();
        $('pause').hide();
        $('play').show();
    }


    $('fs').onclick = function () {
        $('player').fullscreen();
    }

    $('next').onclick = function () {
        changeVideo(urls);
    }


    function get_urls() {
        var urls = new Array();
        new Ajax.Request('videos/to_xml/', {
            asynchronous: false,
            onSuccess: function(response) {
                var tree = response.responseXML;
                var elements = tree.getElementsByTagName('url');
                for(i = 0; i < elements.length; i++)
                    urls.push(elements[i].firstChild.nodeValue);
            },
            onFailure: function(response) {
                alert('Error getting video list :\n' + response.responseHTML);
            }
        });
        return urls;
    }

    function changeVideo(urls)
    {
        var next = (current_id + 1) % (urls.length);
        var name = urls[next];
        current_id++;
        $('player').changeSource('/videos/' + name)
    }

    $('play').hide();
    var urls = get_urls();
});


    function onVideoEnds() {
        alert('end');
    }

    function onPaused() {
        alert('paused');
    }
