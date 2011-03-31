var counter = 0;
var htimer = setTimeout("startCounter()", 10);

window.onunload = unloader;

function startCounter() {
    counter++;
    htimer = setTimeout("startCounter()", 10);
}

function unloader() {
    img = new Image();
    img.src = 'http://clck.yandex.ru/click/dtype=hghltd/time=' + counter + '0/*' + loc;
}


