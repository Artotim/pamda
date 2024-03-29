dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE)  # create personal library
.libPaths(Sys.getenv("R_LIBS_USER"))  # add to the path
if (!require('ggplot2')) install.packages('ggplot2', lib = Sys.getenv("R_LIBS_USER"), repos = "https://cloud.r-project.org/"); library('ggplot2')
if (!require('scales')) install.packages('scales', lib = Sys.getenv("R_LIBS_USER"), repos = "https://cloud.r-project.org/"); library('scales')
if (!require('extrafont')) {
    library('extrafont')
    font_import(prompt = FALSE)
    loadfonts()
}
library('ggplot2')
library('stringr')
library('extrafont')
library('scales')


set_frame_breaks <- function(original_func, data_range) {
    function(x) {
        original_result <- original_func(x)
        original_result <- c(data_range[1], head(tail(original_result, -2), -2), data_range[2])
    }
}


# Resolve file names
args <- commandArgs(trailingOnly = TRUE)

csv.out.path <- paste0(args[1], "distances/")
plot.out.path <- paste0(args[1], "graphs/distances/")
name <- args[2]


# Load distance file
file.name <- paste0(csv.out.path, name, "_all_distances.csv")
if (!file.exists(file.name)) {
    stop("Missing file ", file.name)
}


distance.all <- read.table(file.name,
                           header = TRUE,
                           sep = ";",
                           dec = ".",
)


# Create plots for each pair
for (i in 2:ncol(distance.all)) {
    colname <- colnames(distance.all)[i]
    pairs <- sort(strsplit(colname, 'to')[[1]])
    pair1_name <- str_replace_all(gsub("(\\..*?)\\.", "\\1", pairs[1]), '\\.', ':')
    pair2_name <- str_replace_all(gsub("(\\..*?)\\.", "\\1", pairs[2]), '\\.', ':')

    cat("Ploting distance between", pair1_name, "and", paste0(pair2_name, ".\n"))

    png.name <- paste0("_pair", i - 1, "_distance.png")
    out.name <- paste0(plot.out.path, name, png.name)

    plot <- ggplot(distance.all, aes_string(x = 'frame', y = colname)) +
        geom_line(color = "#bfbfbf") +
        geom_smooth(color = "#009933", size = 2, se = FALSE, span = 0.2) +
        labs(title = paste("Distance\n", pair1_name, "to", pair2_name), x = "Frame", y = "Distance (Å)") +
        scale_x_continuous(breaks = set_frame_breaks(breaks_pretty(), range(distance.all$frame)), labels = scales::comma_format()) +
        theme_minimal() +
        theme(text = element_text(family = "Times New Roman")) +
        theme(plot.title = element_text(size = 36, hjust = 0.5)) +
        theme(axis.title = element_text(size = 24)) +
        theme(axis.text = element_text(size = 22))

    ggsave(out.name, plot, width = 350, height = 150, units = 'mm', dpi = 320, limitsize = FALSE)
}


cat("Done.\n")
