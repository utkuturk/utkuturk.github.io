# Standalone thumbnail: the dot-whisker column on its own, bold enough to read
# at 82px on the front page. Numbers are the same ones used in the post's table.
# Run from this directory.
suppressMessages(library(ggplot2))
out <- "thumb-whisker.png"

d <- data.frame(
  row = 7:1,
  est = c(6.39, 0.13, -0.06, -0.66, -1.35, 0.40, -1.48),
  lo  = c(5.79, -0.21, -0.49, -1.32, -2.22, -0.27, -2.78),
  hi  = c(7.03, 0.48, 0.39, 0.00, -0.48, 1.08, -0.17)
)

p <- ggplot(d, aes(est, row)) +
  geom_vline(xintercept = 0, linetype = "22", linewidth = 2.6, colour = "grey55") +
  geom_linerange(aes(xmin = lo, xmax = hi), linewidth = 4,
                 colour = "grey10", lineend = "round") +
  geom_point(size = 9, colour = "grey10") +
  coord_cartesian(xlim = c(-3.15, 7.45), ylim = c(0.45, 7.55), expand = FALSE) +
  theme_void() +
  theme(
    plot.background = element_rect(fill = "white", colour = NA),
    plot.margin = margin(14, 14, 14, 14)
  )

ggsave(out, p, width = 4, height = 4, dpi = 200)
cat("saved", out, "\n")
