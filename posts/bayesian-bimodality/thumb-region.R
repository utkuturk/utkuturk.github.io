suppressMessages(library(ggplot2))
out <- "thumb-region.png" # run from this directory

crit_p <- function(D) { s <- sqrt(D^2 - 1); 1 / (1 + exp(2 * log(D - s) + 2 * D * s)) }
Dg <- seq(1.0001, 2.35, length.out = 800)
band <- data.frame(D = Dg, lo = crit_p(Dg), hi = 1 - crit_p(Dg))

p <- ggplot(band) +
  geom_ribbon(aes(D, ymin = lo, ymax = hi), fill = "grey45") +
  geom_line(aes(D, lo), linewidth = 2.2, colour = "grey10", lineend = "round") +
  geom_line(aes(D, hi), linewidth = 2.2, colour = "grey10", lineend = "round") +
  geom_vline(xintercept = 1, linetype = "22", linewidth = 2.2, colour = "grey10") +
  coord_cartesian(xlim = c(0.28, 2.35), ylim = c(0.015, 0.985), expand = FALSE) +
  theme_void() +
  theme(
    plot.background = element_rect(fill = "white", colour = NA),
    plot.margin = margin(18, 18, 18, 18)
  )

ggsave(out, p, width = 4, height = 4, dpi = 200)
cat("saved\n")
