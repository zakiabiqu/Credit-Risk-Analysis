# Load library yang diperlukan
library(openxlsx)
library(C50)
library(reshape2)

# Membaca data
dataCreditRating <- read.xlsx(xlsxFile = "E:/Curriculum Vitae/Project/R 1/CreditRisk_R.xlsx")

# Mempersiapkan class dan input variables (dengan variabel tambahan)
dataCreditRating$risk_rating <- as.factor(dataCreditRating$risk_rating)
dataCreditRating$kpr_aktif <- as.factor(dataCreditRating$kpr_aktif)  # konversi ke faktor

# Memilih kolom untuk input (menambahkan pendapatan_setahun_juta dan kpr_aktif)
input_columns <- c("pendapatan_setahun_juta", "kpr_aktif", "durasi_pinjaman_bulan", "jumlah_tanggungan")
datafeed <- dataCreditRating[, input_columns]

# Mempersiapkan training dan testing set
set.seed(100)
indeks_training <- sample(nrow(dataCreditRating), 800)

# Membuat training set dan testing set
input_training_set <- datafeed[indeks_training, ]
class_training_set <- dataCreditRating[indeks_training, ]$risk_rating
input_testing_set <- datafeed[-indeks_training, ]

# Menghasilkan model C5.0 dengan variabel tambahan
risk_rating_model <- C5.0(input_training_set, 
                          class_training_set, 
                          control = C5.0Control(label = "Risk Rating"))

# Menampilkan ringkasan model
summary(risk_rating_model)

# Menyimpan risk_rating asli dan hasil prediksi testing set
input_testing_set$risk_rating <- dataCreditRating[-indeks_training, ]$risk_rating
input_testing_set$hasil_prediksi <- predict(risk_rating_model, input_testing_set)

# Membuat confusion matrix
confusion_matrix <- dcast(hasil_prediksi ~ risk_rating, 
                          data = input_testing_set, 
                          value.var = "hasil_prediksi", 
                          fun.aggregate = length)
print("Confusion Matrix:")
print(confusion_matrix)

# Menghitung jumlah prediksi yang benar
correct_predictions <- nrow(input_testing_set[input_testing_set$risk_rating == input_testing_set$hasil_prediksi, ])
cat("\nJumlah prediksi yang benar:", correct_predictions)

# Menghitung jumlah prediksi yang salah
wrong_predictions <- nrow(input_testing_set[input_testing_set$risk_rating != input_testing_set$hasil_prediksi, ])
cat("\nJumlah prediksi yang salah:", wrong_predictions)

# Menghitung akurasi
accuracy <- correct_predictions / nrow(input_testing_set) * 100
cat("\nAkurasi model:", round(accuracy, 2), "%\n")

# Membuat data frame aplikasi baru untuk prediksi
aplikasi_baru1 <- data.frame(
  pendapatan_setahun_juta = 200,
  kpr_aktif = "YA",
  durasi_pinjaman_bulan = 12,
  jumlah_tanggungan = 6
)

aplikasi_baru2 <- data.frame(
  pendapatan_setahun_juta = 150,
  kpr_aktif = "TIDAK",
  durasi_pinjaman_bulan = 64,
  jumlah_tanggungan = 6
)

aplikasi_baru3 <- data.frame(
  pendapatan_setahun_juta = 300,
  kpr_aktif = "TIDAK",
  durasi_pinjaman_bulan = 24,
  jumlah_tanggungan = 2
)

# Melakukan prediksi untuk aplikasi baru
cat("\n=== Prediksi Aplikasi Baru ===\n")
cat("Aplikasi 1 (pendapatan=200jt, kpr_aktif=YA, durasi=12bln, tanggungan=6):")
pred1 <- predict(risk_rating_model, aplikasi_baru1)
print(pred1)

cat("Aplikasi 2 (pendapatan=150jt, kpr_aktif=TIDAK, durasi=64bln, tanggungan=6):")
pred2 <- predict(risk_rating_model, aplikasi_baru2)
print(pred2)

cat("Aplikasi 3 (pendapatan=300jt, kpr_aktif=TIDAK, durasi=24bln, tanggungan=2):")
pred3 <- predict(risk_rating_model, aplikasi_baru3)
print(pred3)

# Menampilkan variabel penting dalam model
cat("\n=== Variabel Penting dalam Model ===\n")
importance <- C5imp(risk_rating_model)
print(importance)
