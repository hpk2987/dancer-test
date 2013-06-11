var serverUrl = "http://localhost:3000/";

function postToServer(url,callback,params){
    var ajax = new XMLHttpRequest(); 
    if (! ajax) { 
        alert ("Failed"); 
    }
    ajax.onreadystatechange = function(){ 
                                    if (ajax.readyState == 4) { 
                                        if (ajax.status == 200) { 
                                            callback(ajax,params);
                                        } else { 
                                            alert ("Error => Status is "+ajax.status+" | params => "+params );
                                        }  
                                    }
                                };
    
    ajax.open("POST", serverUrl+url, true);

    //Send the proper header information along with the request
    ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    ajax.setRequestHeader("Content-length", params.length);    
    ajax.setRequestHeader("Connection", "close");

    if(ajax.readyState == 0) { 
        alert("error:"+ajax.readyState+'  '+ajax.responseText); 
    } 
    
    ajax.send(""); 
}

function loadList(slidesList){
    for( var i=0 ; i<slidesList.length-1; i++ ){
        var divCallback = function(ajax,v){
            var div = document.getElementById(v);
            div.innerHTML = ajax.responseText;
        }
        opt = slidesList[i].split('|');
        postToServer(opt[1],divCallback,opt[0]);
    }
}

function init(){
    var slidesList
    var callback = function(ajax){
        var ret = ajax.responseText;
        slidesList = ret.split('\n');
        loadList(slidesList);
    };
    postToServer("slides.txt",callback,"");
}

window.onload=init
