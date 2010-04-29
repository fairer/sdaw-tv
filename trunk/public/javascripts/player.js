// ID of the current played video. init to -1
current_id = -1;

// Play the video
$('play').onclick = function () {
    //$('player').play();
    var url = get_url();
    changeVideo(url[0], url[1]);
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

function find_ad() {
    var name = '';
    new Ajax.Request('plannings/get_ad.xml', {
        asynchronous: false,
        onSuccess: function(response) {
            name = response.responseXML.getElementsByTagName('ad')[0].firstChild.nodeValue;
        }
    });
    return name;
}

// Get XML list of videos and return an array of videos' urls (AJAX, synchronous)
function get_url() {
    url = new Array;
    new Ajax.Request('plannings/now.xml', {
        asynchronous: false,
        onSuccess: function(response) {
            var tree = response.responseXML.firstChild;
            if (tree.children.length != 0) {
                if (tree.getElementsByTagName('is-film')[0].firstChild.nodeValue == "true") {
                    url[0] = 'films/' + tree.getElementsByTagName('safe-name')[0].firstChild.nodeValue + '.flv';
                    url[1] = tree.getElementsByTagName('seek-time')[0].firstChild.nodeValue;
                }
                else{
                    alert('not a movie');
                }
            }
            else {
                url[0] = 'ads/' + find_ad();
                url[1] = 0;
            }
        },
        onFailure: function(response) {
            alert('Error getting video list :\n' + response.statusText);
        }
    });
    return url;
}

// Play the next video in the database
function changeVideo(url, seek)
{
    $('player').changeSource('/videos/' + url, seek)
}

// After fully loaded the page :
// Hide the button play
// Record videos' urls in the *urls* array
$('pause').hide();

function get_urls(){}

// This function is trigered when a video is finished
function onVideoEnds() {
    var url = get_url();
    changeVideo(url[0], url[1]);
}

// This function is trigered when the player is paused
//function onPaused() {
//    return null;
//}
