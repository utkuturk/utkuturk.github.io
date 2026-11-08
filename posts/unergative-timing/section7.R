# Rebuild Momma & Ferreira (2019) section 7 (Fig. 18, 19, Table 15) from the text description.
# Data: combined_data.csv (Exps 1, 2a, 2b, 3 of the paper; labelled Exp1, Exp2, Exp3, Exp4 in the file).
# Usage: Rscript section7.R <path/to/combined_data.csv> <out_dir> [corr_scope: verb|all]
suppressPackageStartupMessages({library(dplyr); library(tidyr); library(ggplot2); library(lme4); library(lmerTest)})
args <- commandArgs(TRUE)
f <- args[1]; out <- args[2]; scope <- if (length(args) >= 3) args[3] else "verb"
dir.create(out, showWarnings = FALSE, recursive = TRUE)

regions <- c("Onset", "The", "dog", "above", "the", "apple", "is")  # assumed Fig. 18 regions
paper_exp <- c(Exp1 = "Exp1", Exp2 = "Exp2a", Exp3 = "Exp2b", Exp4 = "Exp3")  # file label -> paper label

d <- read.csv(f) |>
  mutate(exp = paper_exp[experiment],
         spk = paste(exp, participant, sep = "_"),       # participant ids repeat across experiments
         logfreq = log(Vfreq)) |>
  filter(VerbType == "Unerg")

# Step 4: per speaker x region, Pearson r between production time and upcoming-verb frequency
long <- d |>
  filter(scope == "all" | DistractorType == "Verb") |>
  pivot_longer(all_of(regions), names_to = "region", values_to = "rt") |>
  filter(!is.na(rt), !is.na(logfreq))
r_tab <- long |>
  group_by(spk, region) |>
  filter(n() >= 10, sd(rt) > 0) |>
  summarise(r = cor(rt, logfreq), .groups = "drop")

# Step 5: most negative r per speaker
chosen <- r_tab |> group_by(spk) |> slice_min(r, n = 1, with_ties = FALSE) |> ungroup() |>
  rename(chosen = region) |> mutate(chosen = factor(chosen, regions))
cat("speakers:", nrow(chosen), "  mean r:", round(mean(chosen$r), 3),
    "  preposition or later:", sum(chosen$chosen %in% c("above", "the", "apple", "is")), "\n")
print(table(chosen$chosen))

# Fig. 18
p18 <- ggplot(chosen, aes(chosen)) + geom_bar() +
  labs(x = "Region with strongest negative frequency correlation", y = "Speakers")
ggsave(file.path(out, "fig18.pdf"), p18, width = 6, height = 4)

# Step 6-7: z-score within speaker x region, keep each speaker's chosen region, verb-distractor trials only
z <- d |> filter(DistractorType == "Verb") |>
  pivot_longer(all_of(regions), names_to = "region", values_to = "rt") |>
  filter(!is.na(rt)) |>
  group_by(spk, region) |> mutate(z = as.numeric(scale(rt))) |> ungroup() |>
  inner_join(select(chosen, spk, chosen), by = "spk") |>
  filter(region == chosen) |>
  mutate(rel = ifelse(Relatedness == "Related", .5, -.5),
         soa = factor(soa, c("n150", "pn0", "p300")))
# difference coding: -150 vs 0, then mean(-150, 0) vs 300 (Exp3 contributes -150 and 0 only)
contrasts(z$soa) <- cbind(s1 = c(-1, 1, 0), s2 = c(-1/3, -1/3, 2/3))   # TODO verify vs paper coding
z$exp <- relevel(factor(z$exp), "Exp1")
m <- lmer(z ~ rel * soa + exp + (1 | spk) + (1 | Pic), data = z, control = lmerControl(check.rankX = "silent.drop.cols"))
print(round(summary(m)$coefficients, 3))

# Fig. 19: related minus unrelated (z), by SOA, mean and 95% CI over speakers
eff <- z |> group_by(spk, soa, Relatedness) |> summarise(z = mean(z), .groups = "drop") |>
  pivot_wider(names_from = Relatedness, values_from = z) |> mutate(diff = Related - Unrelated) |>
  group_by(soa) |> summarise(m = mean(diff, na.rm = TRUE), se = sd(diff, na.rm = TRUE) / sqrt(sum(!is.na(diff))), .groups = "drop")
p19 <- ggplot(eff, aes(soa, m)) + geom_point() + geom_errorbar(aes(ymin = m - 1.96 * se, ymax = m + 1.96 * se), width = .1) +
  geom_hline(yintercept = 0, linetype = 2) + labs(x = "SOA", y = "Related - unrelated (z-scored production time)")
ggsave(file.path(out, "fig19.pdf"), p19, width = 5, height = 4)
