dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE)  # create personal library
.libPaths(Sys.getenv("R_LIBS_USER"))  # add to the path
if (!require('ggplot2')) install.packages('ggplot2', lib = Sys.getenv("R_LIBS_USER"), repos = "https://cloud.r-project.org/"); library('ggplot2')
if (!require('scales')) install.packages('scales', lib = Sys.getenv("R_LIBS_USER"), repos = "https://cloud.r-project.org/"); library('scales')
if (!require('extrafont')) {
    install.packages('extrafont', lib = Sys.getenv("R_LIBS_USER"), repos = "https://cloud.r-project.org/")
    library('extrafont')
    font_import(prompt = FALSE)
    loadfonts()
}
library('ggplot2')
library('scales')
library('extrafont')


set_frame_breaks <- function(original_func, data_range) {
  function(x) {
    original_result <- original_func(x)
    original_result <- c(data_range[1], head(tail(original_result, -2), -2), data_range[2])
  }
}


plot_compare_energy_stats <- function(energy.all, energy.trim, args) {

    # Resolve file names
    args <- commandArgs(trailingOnly = TRUE)
    out.path <- args[1]
    out.path <- paste0(out.path, "energies/")

    name <- args[2]

    compare.file <- args[4]

    # Load table
    file.name <- compare.file
    if (!file.exists(file.name)) {
        stop("Missing file ", file.name)
    }

    energy.compare.all <- read.table(file.name,
                                   header = TRUE,
                                   sep = ";",
                                   dec = ".",
    )


    # Format table
    energy.compare.all$Time = NULL


    # Define colors
    colors <- c('compare' = '#b3e3ff', 'Docked' = '#0072B2')


    # Iterate over each column
    for (i in 2:ncol(energy.compare.all)) {
        colname <- colnames(energy.compare.all)[i]


        # Plot graphs
        png.name <- paste0("_compare_all_", colname, "_energy", ".png")
        out.name <- paste0(out.path, name, png.name)

        cat("Ploting", colname, "energy with compare stats.", '\n')
        plot <- ggplot(energy.all, aes_string(x = "Frame", y = colname, group = 1)) +
            geom_line(color = "#bfbfbf") +
            geom_smooth(data = energy.compare.all, aes_(y = as.name(colname), color = "compare"), size = 1.5, se = FALSE) +
            geom_smooth(aes_(color = "Docked"), size = 2, se = FALSE) +
            labs(title = paste("All", colname, "Energy"), x = "Frame", y = colname) +
            scale_y_continuous(breaks = breaks_pretty(n = 5)) +
            scale_x_continuous(breaks = set_frame_breaks(breaks_pretty(), range(energy.all$Frame)), labels = scales::comma_format()) +
            theme_minimal() +
            theme(text = element_text(family = "Times New Roman")) +
            theme(plot.title = element_text(size = 36, hjust = 0.5)) +
            theme(axis.title = element_text(size = 24)) +
            theme(axis.text = element_text(size = 20)) +
            theme(legend.text = element_text(size = 14), legend.key.size = unit(1, "cm")) +
            theme(legend.title = element_blank(), legend.key = element_rect(fill = 'white', color = 'white')) +
            scale_color_manual(values = colors, breaks = c("Docked", "compare"))

        ggsave(out.name, plot, width = 350, height = 150, units = 'mm', dpi = 320, limitsize = FALSE)
    }


    # Iterate over each column to plot whithout outliers
    for (i in 2:ncol(energy.compare.all)) {
        colname <- colnames(energy.compare.all)[i]

        outliers <- boxplot(energy.compare.all[[colname]], plot = FALSE)$out
        if (length(outliers) != 0) {
            energy.compare.trim <- energy.compare.all[-which(energy.compare.all[[colname]] %in% outliers),]
        } else {
            energy.compare.trim <- energy.compare.all
        }
        energy.compare.trim[1,]$frame <- min(energy.compare.all$frame)


        # Plot graphs
        png.name <- paste0("_compare_all_", colname, "_energy_trim", ".png")
        out.name <- paste0(out.path, name, png.name)

        cat("Ploting", colname, "energy without outliers with compare stats.", '\n')
        plot <- ggplot(energy.trim[[i]], aes_string(x = "Frame", y = colname, group = 1)) +
            geom_line(color = "#bfbfbf") +
            geom_smooth(data = energy.compare.trim, aes_(y = as.name(colname), color = "compare"), size = 1.5, se = FALSE) +
            geom_smooth(aes_(color = "Docked"), size = 2, se = FALSE) +
            labs(title = paste("All", colname, "Energy"), x = "Frame", y = colname) +
            scale_y_continuous(breaks = breaks_pretty(n = 5)) +
            scale_x_continuous(breaks = set_frame_breaks(breaks_pretty(), range(energy.trim[[i]]$Frame)), labels = scales::comma_format()) +
            theme_minimal() +
            theme(text = element_text(family = "Times New Roman")) +
            theme(plot.title = element_text(size = 36, hjust = 0.5)) +
            theme(axis.title = element_text(size = 24)) +
            theme(axis.text = element_text(size = 20)) +
            theme(legend.text = element_text(size = 14), legend.key.size = unit(1, "cm")) +
            theme(legend.title = element_blank(), legend.key = element_rect(fill = 'white', color = 'white')) +
            scale_color_manual(values = colors, breaks = c("Docked", "compare"))

        ggsave(out.name, plot, width = 350, height = 150, units = 'mm', dpi = 320, limitsize = FALSE)
    }
}