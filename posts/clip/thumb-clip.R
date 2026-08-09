# Standalone thumbnail: CLIP similarity by verb type, from cached_scores.csv.
# Bold enough to read at 82px on the front page. Run from this directory.
suppressMessages({
  library(ggplot2)
  library(dplyr)
})
out <- "thumb-clip.png"

d <- read.csv("cached_scores.csv") |>
  mutate(VerbType = factor(VerbType, levels = c("Unergative", "Unaccusative")))

s <- d |>
  group_by(VerbType) |>
  summarise(
    m = mean(CLIP_Similarity),
    se = sd(CLIP_Similarity) / sqrt(n()),
    .groups = "drop"
  ) |>
  mutate(lo = m - 1.96 * se, hi = m + 1.96 * se, x = as.numeric(VerbType))

set.seed(1)
pts <- d |> mutate(x = as.numeric(VerbType) + runif(n(), -0.17, 0.17))

p <- ggplot() +
  geom_point(data = pts, aes(x, CLIP_Similarity),
             size = 4.5, colour = "grey80") +
  geom_line(data = s, aes(x, m), linewidth = 3.4, colour = "grey10") +
  geom_linerange(data = s, aes(x = x, ymin = lo, ymax = hi),
                 linewidth = 4.5, colour = "grey10", lineend = "round") +
  geom_point(data = s, aes(x, m), size = 13, colour = "grey10") +
  coord_cartesian(xlim = c(0.72, 2.28), expand = TRUE) +
  theme_void() +
  theme(
    plot.background = element_rect(fill = "white", colour = NA),
    plot.margin = margin(14, 14, 14, 14)
  )

ggsave(out, p, width = 4, height = 4, dpi = 200)
cat("saved", out, "\n")
