(function () {
  function isMobile() { return window.innerWidth <= 991; }

  function makeToggle(headerEl, contentEl, startOpen) {
    var open = startOpen;
    var contentEls = Array.isArray(contentEl) ? contentEl : [contentEl];

    var chevron = document.createElement('span');
    chevron.className = 'accordion-chevron';
    chevron.setAttribute('aria-hidden', 'true');
    chevron.textContent = '▾';
    headerEl.appendChild(chevron);

    function setOpen(val) {
      open = val;
      contentEls.forEach(function (el) {
        if (el) el.style.display = open ? '' : 'none';
      });
      if (open) {
        chevron.classList.remove('closed');
      } else {
        chevron.classList.add('closed');
      }
    }

    setOpen(startOpen);

    headerEl.addEventListener('click', function () { setOpen(!open); });
  }

  function init() {
    if (!isMobile()) return;

    // Essays accordion: h2 "essays" → type filter bar + #listing-listing
    var essaysH2 = document.querySelector('h2[data-anchor-id="essays"]');
    var listingDiv = document.getElementById('listing-listing');
    var typeBar = document.getElementById('essay-types');
    if (essaysH2 && listingDiv) {
      makeToggle(essaysH2, [typeBar, listingDiv], true);
    }

    // News accordion: h3 "news" → ul + more-link inside #news
    var newsSection = document.getElementById('news');
    if (newsSection) {
      var newsH3 = newsSection.querySelector('h3[data-anchor-id="news"]');
      if (newsH3) {
        // Wrap everything after the h3 in a single div for toggling
        var wrapper = document.createElement('div');
        wrapper.className = 'news-accordion-content';
        var siblings = [];
        var el = newsH3.nextElementSibling;
        while (el) { siblings.push(el); el = el.nextElementSibling; }
        if (siblings.length) {
          newsH3.parentNode.insertBefore(wrapper, siblings[0]);
          siblings.forEach(function (s) { wrapper.appendChild(s); });
          makeToggle(newsH3, wrapper, false); // start collapsed
        }
      }
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();

// Essay type filter bar (all / opinion / tutorial / question).
// Types are ordinary Quarto categories, so this just drives the same
// listing filter that the per-post #tags use.
(function () {
  function enc(category) { return category ? btoa(encodeURIComponent(category)) : ''; }

  function listingRoot() { return document.getElementById('listing-listing'); }

  // Keep the bar's highlight in sync with whatever filter is active.
  // A non-type category (e.g. #linguistics) leaves every button unlit,
  // since the listing is filtered but not to one of the three types.
  window.homeSyncEssayTypes = function (category) {
    var bar = document.getElementById('essay-types');
    if (!bar) return;
    var active = category || '';
    var buttons = bar.querySelectorAll('.essay-type');
    for (var i = 0; i < buttons.length; i++) {
      var isActive = (buttons[i].getAttribute('data-type') || '') === active;
      buttons[i].classList.toggle('active', isActive);
      buttons[i].setAttribute('aria-pressed', isActive ? 'true' : 'false');
    }
  };

  function applyCategory(category) {
    if (window.quartoListingCategory) window.quartoListingCategory(enc(category));
    var root = listingRoot();
    if (root) root.dataset.activeCategory = enc(category);
    window.homeSyncEssayTypes(category);
  }

  // Quarto stores the active filter in the URL as #category=<value>
  function categoryFromHash() {
    var hash = window.location.hash ? window.location.hash.slice(1) : '';
    var found = '';
    hash.split('&').forEach(function (pair) {
      var kv = pair.split('=');
      if (kv[0] === 'category' && kv.length === 2) found = decodeURIComponent(kv[1]);
    });
    return found;
  }

  // Quarto puts the h2 and the bar in separate rows of the section's grid,
  // so move both into one flex wrapper to get them on a single line.
  function mount() {
    var bar = document.getElementById('essay-types');
    var heading = document.querySelector('h2[data-anchor-id="essays"]');
    if (!bar) return null;

    if (heading && !bar.closest('.essays-head')) {
      var head = document.createElement('div');
      head.className = 'essays-head';
      heading.parentNode.insertBefore(head, heading);
      head.appendChild(heading);
      head.appendChild(bar);
    }
    bar.classList.add('ready');
    return bar;
  }

  function init() {
    var bar = mount();
    if (!bar) return;

    bar.addEventListener('click', function (event) {
      var button = event.target.closest('.essay-type');
      if (!button) return;
      event.preventDefault();

      var type = button.getAttribute('data-type') || '';
      var root = listingRoot();
      var current = root ? (root.dataset.activeCategory || '') : '';
      // clicking the already-active type toggles back to unfiltered
      if (type && current === enc(type)) type = '';
      applyCategory(type);
    });

    // Restore state on load / back-forward navigation
    var initial = categoryFromHash();
    var root = listingRoot();
    if (root) root.dataset.activeCategory = enc(initial);
    window.homeSyncEssayTypes(initial);
    window.addEventListener('hashchange', function () {
      window.homeSyncEssayTypes(categoryFromHash());
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
