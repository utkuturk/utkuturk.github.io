function setupLegendFilters() {
    const legendItems = document.querySelectorAll('.legend-item');
    // We now target both .ref-item (for papers/talks) and .research-topic (for research page blocks)
    const filterableItems = document.querySelectorAll('.ref-item, .research-topic');

    legendItems.forEach(item => {
        item.addEventListener('click', () => {
            const topic = item.getAttribute('data-topic');

            // Toggle active class on the clicked legend item
            // If it was already active, we are de-activating it (resetting)
            const isAlreadyActive = item.classList.contains('active');

            // Reset all legend items
            legendItems.forEach(l => l.classList.remove('active'));

            if (isAlreadyActive) {
                // We clicked the active one -> Reset everything to show all
                filterableItems.forEach(ref => ref.classList.remove('hidden'));
            } else {
                // We clicked a new one -> Activate it and filter
                item.classList.add('active');

                filterableItems.forEach(ref => {
                    if (ref.classList.contains(topic)) {
                        ref.classList.remove('hidden');
                    } else {
                        ref.classList.add('hidden');
                    }
                });
            }
        });
    });
}

document.addEventListener('DOMContentLoaded', setupLegendFilters);
