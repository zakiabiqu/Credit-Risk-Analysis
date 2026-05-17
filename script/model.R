# Load required libraries
library(openxlsx)
library(C50)
library(reshape2)

# Read data
credit_data <- read.xlsx(xlsxFile = "CreditRisk_R.xlsx")

# Prepare target variable and input variables
credit_data$risk_rating <- as.factor(credit_data$risk_rating)
credit_data$kpr_aktif <- as.factor(credit_data$kpr_aktif)  # convert to factor

# Select input columns
input_columns <- c("pendapatan_setahun_juta", "kpr_aktif", "durasi_pinjaman_bulan", "jumlah_tanggungan")
input_data <- credit_data[, input_columns]

# Split data into training and testing sets
set.seed(100)
training_index <- sample(nrow(credit_data), 800)

# Create training and testing sets
training_input <- input_data[training_index, ]
training_class <- credit_data[training_index, ]$risk_rating
testing_input <- input_data[-training_index, ]

# Build C5.0 decision tree model
risk_model <- C5.0(training_input, 
                   training_class, 
                   control = C5.0Control(label = "Risk Rating"))

# Display model summary
summary(risk_model)

# Store actual risk ratings and predictions for testing set
testing_input$actual_rating <- credit_data[-training_index, ]$risk_rating
testing_input$predicted_rating <- predict(risk_model, testing_input)

# Create confusion matrix
confusion_matrix <- dcast(predicted_rating ~ actual_rating, 
                          data = testing_input, 
                          value.var = "predicted_rating", 
                          fun.aggregate = length)
print("Confusion Matrix:")
print(confusion_matrix)

# Calculate correct predictions
correct_predictions <- nrow(testing_input[testing_input$actual_rating == testing_input$predicted_rating, ])
cat("\nNumber of correct predictions:", correct_predictions)

# Calculate wrong predictions
wrong_predictions <- nrow(testing_input[testing_input$actual_rating != testing_input$predicted_rating, ])
cat("\nNumber of wrong predictions:", wrong_predictions)

# Calculate accuracy
accuracy <- correct_predictions / nrow(testing_input) * 100
cat("\nModel accuracy:", round(accuracy, 2), "%\n")

# Create new application data for prediction
new_app1 <- data.frame(
  pendapatan_setahun_juta = 200,
  kpr_aktif = "YA",
  durasi_pinjaman_bulan = 12,
  jumlah_tanggungan = 6
)

new_app2 <- data.frame(
  pendapatan_setahun_juta = 150,
  kpr_aktif = "TIDAK",
  durasi_pinjaman_bulan = 64,
  jumlah_tanggungan = 6
)

new_app3 <- data.frame(
  pendapatan_setahun_juta = 300,
  kpr_aktif = "TIDAK",
  durasi_pinjaman_bulan = 24,
  jumlah_tanggungan = 2
)

# Predict risk ratings for new applications
cat("\n=== New Application Predictions ===\n")
cat("Application 1 (income=200M, active_kpr=YES, tenure=12months, dependents=6):")
pred1 <- predict(risk_model, new_app1)
print(pred1)

cat("Application 2 (income=150M, active_kpr=NO, tenure=64months, dependents=6):")
pred2 <- predict(risk_model, new_app2)
print(pred2)

cat("Application 3 (income=300M, active_kpr=NO, tenure=24months, dependents=2):")
pred3 <- predict(risk_model, new_app3)
print(pred3)

# Display variable importance
cat("\n=== Variable Importance ===\n")
importance <- C5imp(risk_model)
print(importance)
