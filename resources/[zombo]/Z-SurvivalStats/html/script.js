window.addEventListener('message', function(event) {
    if (event.data.type === 'updateHUD') {
        document.getElementById('temperature').innerText = `Temperatura: ${event.data.temperature} °C`;
    }
});


