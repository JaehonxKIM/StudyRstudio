english <- c(90, 80, 70, 60)
english

math <-c(60, 70, 80, 100)
math

class <- c(1, 1, 2, 2)
class

df_midterm<- data.frame(english, math, class)
df_midterm

#f_midterm의 english로 평균 산출
mean(df_midterm$english)
mean(df_midterm$math)

