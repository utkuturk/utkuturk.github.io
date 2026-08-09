# Standalone thumbnail: the waveform of simple_example.mp3, bold enough to read
# at 82px on the front page. Needs ffmpeg on PATH. Run from this directory.
suppressMessages(library(ggplot2))
out <- "thumb-audio.png"
src <- "simple_example.mp3"

# decode to mono 16-bit PCM at 8 kHz and read the raw stream
con <- pipe(sprintf(
  "ffmpeg -v quiet -i %s -ac 1 -ar 8000 -f s16le -", shQuote(src)
), "rb")
pcm <- readBin(con, "integer", n = 1e7, size = 2, signed = TRUE, endian = "little")
close(con)

# envelope: peak amplitude in each of 220 equal bins
nb <- 220
bin <- cut(seq_along(pcm), nb, labels = FALSE)
amp <- tapply(abs(pcm), bin, max)
amp <- as.numeric(amp) / max(amp)

d <- data.frame(i = seq_len(nb), a = amp)

p <- ggplot(d, aes(i)) +
  geom_linerange(aes(ymin = -a, ymax = a), linewidth = 1.9,
                 colour = "grey25", lineend = "round") +
  geom_hline(yintercept = 0, linewidth = 1.2, colour = "grey10") +
  coord_cartesian(ylim = c(-1.15, 1.15), expand = FALSE) +
  theme_void() +
  theme(
    plot.background = element_rect(fill = "white", colour = NA),
    plot.margin = margin(20, 14, 20, 14)
  )

ggsave(out, p, width = 4, height = 4, dpi = 200)
cat("saved", out, "\n")
