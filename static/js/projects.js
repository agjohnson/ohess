/* Project functions */

function get_project_stats(project) {
    var req;

    if (window.XMLHttpRequest) {
        req = new XMLHttpRequest();
    }
    else if (window.ActiveXObject) {
        req = new ActiveXObject("Microsoft.XMLHTTP");
    }

    req.open('GET', '/projects/'+ project +'/stats.json', true);
    req.onreadystatechange = function() {
        if (req.readyState == 4) {
            var a = req.responseText;
            console.log(req.responseText);
            update_project_stats(
                eval('('+ req.responseText +')')
            );
        }
    }
    req.send();
}

function update_project_stats(stats) {
    var tests_pass = stats.passed;
    var tests_full = stats.passed + stats.failed;
    document.getElementById('project-stats').innerHTML = 'Latest build: '+ 
      tests_pass +'/'+ tests_full +' tests passed';
}

