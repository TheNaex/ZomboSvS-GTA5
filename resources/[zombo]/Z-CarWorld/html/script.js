function displayCarInfo(info) {
    document.getElementById("carinfo-content").innerHTML = info;
    document.getElementById("carinfo-container").style.display = 'block';
}

window.addEventListener('message', function(event) {
    if (event.data.action === 'display') {
        displayCarInfo(event.data.info);
    } else if (event.data.action === 'close') {
        document.getElementById("carinfo-container").style.display = 'none';
    }
});

function displayCarInfo(info) {
    document.getElementById("carinfo-content").innerHTML = info;
    document.getElementById("carinfo-container").style.display = 'block';
}

window.addEventListener('message', function(event) {
    if (event.data.action === 'display') {
        displayCarInfo(event.data.info);
    }
});