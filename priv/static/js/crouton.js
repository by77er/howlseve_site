const secret = (key, action) => {
    let activated = false;
    let key_stack = "";
    document.addEventListener("keypress", (event) => {
        if (activated) {
            return;
        }
        key_stack += event.key;
        if (key.startsWith(key_stack)) {
            if (key === key_stack) {
                activated = true;
                action();
                
            }
        } else {
            key_stack = "";
        }
    });
};

secret("crouton", () => {
    const crouton = document.createElement("img");
    crouton.src = "/img/crouton.png";
    crouton.style.position = "fixed";
    crouton.style.margin = "8px";
    document.body.prepend(crouton);
});

secret("sigma", () => {
    const base = "What the <em>Sigma</em>?";
    const h1 = document.querySelector("#about_header");
    h1.setHTMLUnsafe(base);
    setTimeout(() => {
        h1.setHTMLUnsafe(base + " Sigma balls.");
    }, 2000);
});

