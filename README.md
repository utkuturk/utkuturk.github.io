# utkuturk.github.io

This repository contains the source code for my personal website using [Quarto](https://quarto.org/).

Beyond the standard Quarto features, I have implemented several custom components to achieve a specific look and feel, including a "Hero" scroll effect, a content filtering system, and a custom blog listing style. Below is a guide on how these features work so you can adapt them for your own site.

## Setup & Dependencies

This project uses both Python and R, with dependency management handled by modern tools for reproducibility.

### Python Dependencies (uv)

The Python environment is managed using [uv](https://github.com/astral-sh/uv), a fast Python package installer and resolver.

**Installation:**
```bash
# Install uv (if not already installed)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install all Python dependencies
uv sync

# Install OpenAI CLIP (required for CLIP-related posts)
uv pip install git+https://github.com/openai/CLIP.git
```

**Running Python code:**
```bash
# Run a Python script with the project environment
uv run python your_script.py

# Activate the virtual environment manually
source .venv/bin/activate  # On macOS/Linux
```

**Key Python packages:**
- `torch` & `torchvision`: PyTorch for deep learning
- `transformers`: Hugging Face transformers library
- `clip`: OpenAI CLIP model (installed from GitHub)
- `pandas`, `numpy`, `matplotlib`, `seaborn`: Data analysis and visualization
- `pillow`: Image processing

### R Dependencies (renv)

The R environment is managed using [renv](https://rstudio.github.io/renv/) for reproducible R package management.

**Installation:**
```r
# Install renv (if not already installed)
install.packages("renv")

# Restore all R dependencies from the lockfile
renv::restore()
```

**Key R packages:**
- `yaml`: Reading YAML data files
- `knitr`, `rmarkdown`: Document rendering (used by Quarto)
- Additional packages as needed for data processing

### Quarto

This site is built with [Quarto](https://quarto.org/). Make sure you have Quarto installed:

```bash
# Check Quarto version
quarto --version

# Render the site
quarto render

# Preview the site locally
quarto preview
```

## 1. Hero Scroll Effect

The website features a full-screen "Hero" section on the homepage that fades out as you scroll down, revealing the main navigation bar.

### How it works:
- **HTML**: The `index.qmd` file includes a raw HTML block `<div class="hero-section">` that contains the photo, title, and bio.
- **CSS**: The `.hero-section` class (in `styles-v1.css`) is set to `position: fixed` handling the full-screen layout.
- **JavaScript**: The logic is contained in [`files/hero-scroll.js`](files/hero-scroll.js). This script:
    1.  Calculates the scroll position.
    2.  Adjusts the `opacity` of the `.hero-section` to fade it out.
    3.  Toggles the visibility of the `#quarto-header` (navbar) once the user scrolls past a certain threshold.

To use this, ensure you include the script at the bottom of your `index.qmd`:
```html
<script src="/files/hero-scroll.js"></script>
```

## 2. Content Filtering System

The **Papers** and **Research** pages use a custom filtering system that allows users to click on topics (e.g., "Syntax", "Processing") to filter the list of items.

### How it works:
- **Legend**: A legend is created using HTML in the `.qmd` file (e.g., `papers.qmd`), where each item has a `data-topic` attribute:
  ```html
  <span class="legend-item" data-topic="topic-syntax">Syntax</span>
  ```
- **List Items**: The content items (generated via R code in `papers.qmd`) are wrapped in divs with the corresponding class (e.g., `<div class="ref-item topic-syntax">`).
- **JavaScript**: The [`files/filter-v1.js`](files/filter-v1.js) script handles the click events. It toggles the `.hidden` class on items that do not match the selected topic.
- **CSS**: The `.hidden` class in `styles-v1.css` simply sets `display: none !important`.

## 3. Postcard Style Blog Listing

The homepage uses a custom EJS template to display blog posts in a "postcard" style layout, rather than the default Quarto list or grid.

### How it works:
- **Template**: The layout is defined in [`postcard.ejs`](postcard.ejs). This file iterates through the items and constructs the HTML for each "card".
- **Configuration**: In `index.qmd`, the listing is configured to use this template:
  ```yaml
  listing:
    contents: posts
    template: postcard.ejs
  ```
- **Styling**: Specific CSS for `.postcard`, `.postcard-thumb`, etc., is included directly in the `postcard.ejs` file (or can be moved to your main CSS).

## 4. Responsive Sidebar / News

I use a custom approach for the "News" section.
- On **Desktop**, it appears as a sidebar or margin content.
- On **Mobile**, it acts as a section at the bottom of the intro, controlled via CSS media queries.

In `index.qmd`, the news is inside a `::: {.mobile-sidebar-news}` div. The CSS in `styles-v1.css` handles hiding/showing this block based on the viewport width (using `@media` rules).

## License

Feel free to use the code in this repository as a reference for your own Quarto website.

## 5. Data-Driven Content Generation

The **Papers**, **Talks**, and **Teaching** pages are not static HTML/Markdown lists. Instead, they are generated dynamically from YAML data files using embedded R code. This makes it easy to add new items without worrying about formatting HTML.

### How it works:
- **Data Source**: All data is stored in the `_data/` directory:
    - [`_data/writing.yaml`](_data/writing.yaml): (Dissertations, Articles, Chapters, Proceedings, etc.)
    - [`_data/talks.yaml`](_data/talks.yaml): (Conferences, Talks, Posters)
    - [`_data/teaching.yaml`](_data/teaching.yaml): (Workshops, Lectures, TA Info)

- **Rendering Logic**: The `.qmd` files (e.g., [`papers.qmd`](papers.qmd)) contain an R code block that:
    1.  Reads the corresponding YAML file using the `yaml` library.
    2.  Defines helper functions (e.g., `fmt_article`, `format_conference`) to format the data into HTML strings.
    3.  Iterates through the lists and outputs the HTML using `cat()`.

This approach ensures consistent formatting across all entries and allows for conditional logic (e.g., only showing a link if it exists).
