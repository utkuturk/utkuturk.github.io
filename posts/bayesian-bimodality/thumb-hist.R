# Standalone thumbnail: the formal/plural-attractor condition, bold enough to
# survive being displayed at 82px. Run from this directory.
suppressMessages({
  library(ggplot2)
  library(dplyr)
})
out <- "thumb-hist.png"

is_unimodal <- function(mu1, mu2, sigma, p) {
  D <- abs(mu1 - mu2) / (2 * sigma)
  s <- sqrt(pmax(D^2 - 1, 0))
  D <= 1 | abs(log(p / (1 - p))) >= 2 * log(D - s) + 2 * D * s
}
mix <- function(x, mu1, mu2, sigma, p) {
  p * dnorm(x, mu1, sigma) + (1 - p) * dnorm(x, mu2, sigma)
}
gibbs_bimodal <- function(x, n_iter = 12000, burn_in = 2000, m = 1, nu = 4) {
  n <- length(x); s2 <- var(x); xi <- unname(quantile(x, c(0.25, 0.75)))
  mu <- xi; sig2 <- var(x) / 2; p <- 0.5
  d <- matrix(NA_real_, n_iter - burn_in, 4,
              dimnames = list(NULL, c("mu1", "mu2", "sigma", "p")))
  for (t in seq_len(n_iter)) {
    d1 <- p * dnorm(x, mu[1], sqrt(sig2))
    d2 <- (1 - p) * dnorm(x, mu[2], sqrt(sig2))
    z <- 1 + (runif(n) > d1 / (d1 + d2))
    for (j in 1:2) {
      nj <- sum(z == j); xb <- if (nj > 0) mean(x[z == j]) else 0
      mu[j] <- rnorm(1, (m * xi[j] + nj * xb) / (m + nj), sqrt(sig2 / (m + nj)))
    }
    b <- (s2 + sum((x - mu[z])^2) + m * sum((mu - xi)^2)) / 2
    sig2 <- 1 / rgamma(1, shape = (nu + n + 2) / 2, rate = b)
    n1 <- sum(z == 1); p <- rbeta(1, n1 + 1, n - n1 + 1)
    if (t > burn_in) {
      o <- order(mu)
      d[t - burn_in, ] <- c(mu[o], sqrt(sig2), if (o[1] == 1) p else 1 - p)
    }
  }
  as.data.frame(d)
}

x <- read.csv("honorific-plural.csv") |>
  filter(verb == "pl", register == "formal", attractor == "pl") |>
  group_by(participant) |>
  summarise(a = mean(yes), .groups = "drop") |>
  pull(a)

set.seed(2026)
f <- gibbs_bimodal(x)
mu1 <- mean(f$mu1); mu2 <- mean(f$mu2); s <- mean(f$sigma); w <- mean(f$p)

xg <- seq(-0.12, 1.12, length.out = 601)
curve <- data.frame(x = xg, y = mix(xg, mu1, mu2, s, w))

# modes of the fitted density
sl <- diff(curve$y)
modes <- curve$x[which(sl[-length(sl)] > 0 & sl[-1] <= 0) + 1]
peaks <- data.frame(x = modes, y = mix(modes, mu1, mu2, s, w))

p <- ggplot() +
  geom_histogram(
    data = data.frame(a = x), aes(a, after_stat(density)),
    binwidth = 0.2, center = 0,
    fill = "grey78", colour = "white", linewidth = 1.6
  ) +
  geom_segment(
    data = peaks, aes(x = x, xend = x, y = 0, yend = y),
    linewidth = 1.6, colour = "grey10"
  ) +
  geom_line(data = curve, aes(x, y), linewidth = 2.8, colour = "grey10",
            lineend = "round") +
  coord_cartesian(xlim = c(-0.12, 1.12), ylim = c(0, 1.55), expand = FALSE) +
  theme_void() +
  theme(
    plot.background = element_rect(fill = "white", colour = NA),
    plot.margin = margin(18, 18, 18, 18)
  )

ggsave(out, p, width = 4, height = 4, dpi = 200)
cat("saved", out, "\n")
