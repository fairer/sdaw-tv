document.observe("dom:loaded", function () {
    var last_value = '';
    new Form.Element.Observer($('name'), 0.3, function () {
        if (last_value != $('name').value)
        {
            new Ajax.Request('/search/index.xml', {
                method: 'post',
                postBody: 'q=' + $('name').value,
                onSuccess: function(response) {
                    var res = response.responseXML;
                    var results = res.getElementsByTagName('results')[0];
                    if (results.children.length != 0) { // If we get any result
                        $('results').innerHTML = '';
                        var films = results.getElementsByTagName('film');
                        var series = results.getElementsByTagName('serie');
                        $('results').innerHTML += '<strong>Pick a film or an episode here :</strong><br/>'
                        if (films.length != 0) // Print films
                        {
                            $('results').innerHTML += '<strong>Films</strong><br/>'
                            for (i = 0; i < films.length; i++) {
                                var node = new Element('input', {
                                    'type': 'radio',
                                    'name': 'planning[video]',
                                    // Video value in planning is "v_s_e" v:video s:season e:episode
                                    // For films it's v_0_0
                                    'value': nodeValue(films[i], 'id') + '_0_0'
                                });
                                $('results').appendChild(node);
                                $('results').innerHTML += nodeValue(films[i], 'name') + '<br/>';
                            }
                            $('results').innerHTML += '<br/>';
                        }
                        if (series.length != 0) // Print series
                        {
                            $('results').innerHTML += '<strong>Series</strong><br/>'
                            for (i = 0; i < series.length; i++) {
                                $('results').innerHTML += '<em>' + nodeValue(series[i], 'name') + '</em><br/>'
                                var episodes = series[i].getElementsByTagName('episode');
                                for (j = 0; j < episodes.length; j++) {
                                    var node = new Element('input', {
                                    'type': 'radio',
                                    'name': 'planning[video]',
                                    // Video value in planning is "v_s_e" v:video s:season e:episode
                                    // For films it's v_0_0
                                    'value': nodeValue(series[i], 'id') + '_' + nodeValue(episodes[j], 'season') + '_' + nodeValue(episodes[j], 'number')
                                    });
                                    $('results').appendChild(node);
                                    $('results').innerHTML += 'Season ' + nodeValue(episodes[j], 'season') + ', Episode ' + nodeValue(episodes[j], 'number') + ' : ' + nodeValue(episodes[j], 'name') + '<br/>';
                                }
                            }
                            $('results').innerHTML += '<br/>'
                        }
                        $('planning_submit').disabled = false;
                    }
                    else {
                        $('results').innerHTML = 'No result.';
                    }
                }
            });
        }
    });

    function nodeValue(elem, tag) {
        return elem.getElementsByTagName(tag)[0].firstChild.nodeValue;
    }

    new PeriodicalExecuter(function () {
        $('now').innerHTML = new Date().toUTCString();
    }, 1);
});