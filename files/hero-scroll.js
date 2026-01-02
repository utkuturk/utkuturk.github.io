
document.addEventListener("DOMContentLoaded", function () {
    const heroSection = document.querySelector(".hero-section");
    const navbar = document.querySelector("#quarto-header"); // The main Quarto navbar
    const mainWrapper = document.querySelector(".main-content-wrapper");

    if (!heroSection || !navbar) return;

    // Initial state: Navbar hidden, Hero visible
    navbar.style.opacity = "0";
    navbar.style.pointerEvents = "none";
    navbar.style.transition = "opacity 0.3s ease, transform 0.3s ease";

    // Optional: Add a class to body to indicate we are effectively on the "hero" view
    document.body.classList.add("hero-view-active");

    // Select hero content for finer control
    const heroContent = document.querySelector(".hero-content");

    window.addEventListener("scroll", function () {
        const scrollY = window.scrollY;
        const windowH = window.innerHeight;

        // --- Hero Opacity Logic ---
        const heroFadeEnd = windowH * 0.9;
        let heroAlpha = 1 - (scrollY / heroFadeEnd);
        if (heroAlpha < 0) heroAlpha = 0;

        heroSection.style.opacity = heroAlpha;
        heroSection.style.transform = `translateY(-${scrollY * 0.2}px)`;

        // Disable hero content clicks when it's mostly faded to prevent blocking navbar
        if (heroContent) {
            if (heroAlpha < 0.1) {
                heroContent.style.pointerEvents = "none";
            } else {
                heroContent.style.pointerEvents = "auto";
            }
        }

        // --- Navbar Visibility Logic ---
        const navThreshold = windowH * 0.4;

        if (scrollY > navThreshold) {
            navbar.style.opacity = "1";
            navbar.style.pointerEvents = "auto";
            document.body.classList.remove("hero-view-active");
        } else {
            navbar.style.opacity = "0";
            navbar.style.pointerEvents = "none";
            document.body.classList.add("hero-view-active");
        }
    });
});

