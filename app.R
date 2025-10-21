library(shiny)
library(bslib)
library(ggplot2)
library(hw4)

# UI
ui <- page_fluid(
  theme = bs_theme(version = 5, bootswatch = "minty"),
  title = "Study Design Calculator",

  # Main panel with tabs
  navset_card_tab(

    nav_panel("Sample Size Results",
              card(
                card_header("Sample Size Calculation"),
                numericInput("delta", "Delta (Effect Size):", value = 0.5, min = 0, step = 0.1),
                numericInput("sd", "Standard Deviation:", value = 1.08, min = 0, step = 0.01),
                numericInput("sig_level", "Significance Level:", value = 0.05, min = 0, max = 1, step = 0.01),
                numericInput("power", "Power:", value = 0.9, min = 0, max = 1, step = 0.01),
                checkboxInput("bonferonni", "Bonferonni Correction:", value = FALSE),
                selectInput("alternative", "Alternative:",
                            choices = c("two.sided", "one.sided"),
                            selected = "two.sided"),
                actionButton("calc_sample", "Calculate Sample Size", class = "btn-primary"),
                textOutput("sample_size_result")
              )
    ),

    nav_panel("Budget Results",
              card(
                card_header("Budget Breakdown"),
                numericInput("n_primary", "Primary Participants:", value = 100, min = 1),
                numericInput("n_secondary", "Secondary Participants:", value = 50, min = 0),
                numericInput("n_followup_primary", "Primary Follow-ups:", value = 1, min = 0),
                numericInput("n_followup_secondary", "Secondary Follow-ups:", value = 1, min = 0),
                actionButton("calc_budget", "Calculate Budget", class = "btn-success"),
                textOutput("budget_text")
              )
    ),

    nav_panel("Plot",
              card(
                card_header("Power Analysis Plot"),
                fluidRow(
                  column(6,
                         numericInput("delta_start", "Delta Start:", value = 0.1, step = 0.1),
                         numericInput("sd_start", "SD Start:", value = 0.5, step = 0.1),
                         numericInput("length_vec", "Number of Points:", value = 20, min = 5, max = 50)
                  ),
                  column(6,
                         numericInput("delta_end", "Delta End:", value = 1.0, step = 0.1),
                         numericInput("sd_end", "SD End:", value = 2.0, step = 0.1),
                         actionButton("create_plot", "Create Plot", class = "btn-info")
                  )
                ),
                plotOutput("power_plot", height = "500px")
              )
    )
  )
)

# Server
server <- function(input, output, session) {

  # Sample size calculation
  sample_size <- eventReactive(input$calc_sample, {
    hw4::sample_size_calc(
      delta = input$delta,
      sd = input$sd,
      sig.level = input$sig_level,
      power = input$power,
      bonferonni = input$bonferonni,
      alternative = input$alternative
    )
  })

  output$sample_size_result <- renderText({
    req(sample_size())
    out <- sample_size()
    paste("Required sample size:", ceiling(out$n), "participants per group")
  })

  # Budget calculation
  budget_results <- eventReactive(input$calc_budget, {
    hw4::budget_calc(
      n_primary = input$n_primary,
      n_secondary = input$n_secondary,
      n_followup_primary = input$n_followup_primary,
      n_followup_secondary = input$n_followup_secondary
    )
  })

  output$budget_text <- renderText({
    req(budget_results())
    out <- budget_results()
    paste("Required Total Budget: $", out)
  })

  # Plot creation
  power_plot <- eventReactive(input$create_plot, {
    hw4::plot_n(
      power = input$power,
      delta_start = input$delta_start,
      delta_end = input$delta_end,
      sd_start = input$sd_start,
      sd_end = input$sd_end,
      length_vec = input$length_vec
    )
  })

  output$power_plot <- renderPlot({
    req(power_plot())
    power_plot()
  })
}

# Run the app
shinyApp(ui = ui, server = server)
