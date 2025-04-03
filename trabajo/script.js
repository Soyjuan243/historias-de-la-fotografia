document.addEventListener("wheel", function(event) {
    if (event.ctrlKey) {
        event.preventDefault(); // Evita el zoom con Ctrl + Scroll
    }
}, { passive: false });
