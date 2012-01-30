/* Project functions */

function get_project_stats(project) {
    var req;
    
    if (window.XMLHttpRequest) {
        req = new XMLHttpRequest();
    }
    else if (window.ActiveXObject) {
        req = new ActiveXObject("Microsoft.XMLHTTP");
    }

    req.open('POST', '/projects/'+ project +'/stats.json', true);
    req.onreadystatechange = function() {
        if (req.readyState == 4) {
            update_project_stats(
                eval('('+req.responseXML+')')
            );
        }
    }
    req.send();
}

function update_project_stats(stats){
    document.getElementById('project-stats').innerHTML = sprintf(
        'Build tests: '+ stats.failed +' failed, '+ stats.passed +' passed'
    );
}

