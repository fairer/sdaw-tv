document.observe("dom:loaded", function () {
    // ID of the current played video. init to -1
    current_id = -1;

    // Play the video
    $('play').onclick = function () {
        $('player').play();
        $('play').hide();
        $('pause').show();
    }

    // Pause the video
    $('pause').onclick = function () {
        $('player').pause();
        $('pause').hide();
        $('play').show();
    }

    // View video in fullscreen mode
    $('fs').onclick = function () {
        $('player').fullscreen(); // Not working
        // #FIX ME !!
    }

    // Select and play next video in the database
    $('next').onclick = function () {
        changeVideo(urls);
    }

    // Get XML list of videos and return an array of videos' urls (AJAX, synchronous)
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

    // Play the next video in the database
    function changeVideo(urls)
    {
        var next = (current_id + 1) % (urls.length);
        var name = urls[next];
        current_id++;
        $('player').changeSource('/videos/' + name)
    }

    // After fully loaded the page :
    // Hide the button play
    // Record videos' urls in the *urls* array
    $('play').hide();
    var urls = get_urls();
});

    // This function is trigered when a video is finished
    function onVideoEnds() {
        alert('end');
    }

    // This function is trigered when the player is paused
    function onPaused() {
        alert('paused');
    }
