const key = "crouton";

let crouton_activated = false;
let key_stack = "";
document.addEventListener("keypress", (event) => {
    if (crouton_activated) {
        return;
    }
    key_stack += event.key;
    if (key.startsWith(key_stack)) {
        if (key === key_stack) {
            crouton_activated = true;
            const crouton = document.createElement("img");
            crouton.src = "/img/crouton.png";
            crouton.style.position = "fixed";
            crouton.style.margin = "8px";
            document.body.prepend(crouton);
        }
    } else {
        key_stack = "";
    }
});