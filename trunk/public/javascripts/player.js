last_vid_type = "ad";

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
            if (tree.childNodes.length > 1) {
                if (tree.getElementsByTagName('is-film')[0].firstChild.nodeValue == "true") {
                    url[0] = 'films/' + tree.getElementsByTagName('safe-name')[0].firstChild.nodeValue + '.flv';
                    url[1] = tree.getElementsByTagName('seek-time')[0].firstChild.nodeValue;
                    $('now').innerHTML = 'Now Playing : ' + tree.getElementsByTagName('name')[0].firstChild.nodeValue;
                }
                else{
                    var serie = tree.getElementsByTagName('video')[0];
                    var episode = tree.getElementsByTagName('episode')[0];
                    url[0] = 'series/' + tree.getElementsByTagName('safe-name')[0].firstChild.nodeValue + '/season' +
                        episode.getElementsByTagName('season')[0].firstChild.nodeValue + '/episode' +
                        episode.getElementsByTagName('episode-number')[0].firstChild.nodeValue + '.flv';
                    url[1] = tree.getElementsByTagName('seek-time')[0].firstChild.nodeValue;
                    $('now').innerHTML = 'Now Playing : ' + serie.getElementsByTagName('name')[0].firstChild.nodeValue +
                        ', Season ' + episode.getElementsByTagName('season')[0].firstChild.nodeValue + ', ' +
                        'Episode ' + episode.getElementsByTagName('episode-number')[0].firstChild.nodeValue + ' : ' +
                         episode.getElementsByTagName('name')[0].firstChild.nodeValue;
                }
                last_vid_type = "video";
            }
            else {
                url[0] = 'ads/' + find_ad();
                url[1] = 0;
                last_vid_type = "ad";
                $('now').innerHTML = 'Advertisement. Please wait for programmation to start.';
            }
        },
        onFailure: function(response) {
            alert('Error getting video :\n' + response.statusText);
        }
    });
    return url;
}

// Play the next video in the database
function changeVideo(url, seek)
{
    $('player').changeSource('/videos/' + url, seek);
}

// After fully loaded the page :
// Hide the button play
// Record videos' urls in the *urls* array
$('pause').hide();

// This function is trigered when a video is finished
function onVideoEnds() {
    $('now').innerHTML = 'Click the button on the left to start the TV.';
    if (last_vid_type == "video") {
        new Ajax.Request('plannings/clean/');
    }
    var url = get_url();
    changeVideo(url[0], url[1]);
}

function fancy_time(t, l) {
    var m = Math.floor(t / 60).toString();
    var s = Math.floor(t % 60).toString();
    while (m.length < l) {
        m = '0' + m;
    }
    while (s.length < l) {
        s = '0' + s;
    }
    return m + ':' + s;
}

function onVideoProgress(progress, total) {
    var width_progress = progress / total * 644;
    $('progress_time').innerHTML = fancy_time(progress, 2);
    $('total_time').innerHTML = fancy_time(total, 2);
    $('progress').setStyle({'width': width_progress + 'px'});
}

$('now').innerHTML = 'Click the button on the left to start the TV.';

$$('.etagere').each(function (item) {
    item.observe('mouseover', function () {
        item.setStyle({'background': 'rgba(0,0,0,0.8)'});
    });
    item.observe('mouseout', function () {
        item.setStyle({'background': 'rgba(0,0,0,0)'});
    });
});
