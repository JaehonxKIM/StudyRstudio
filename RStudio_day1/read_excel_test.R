# df_midterm()
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

# 엑셀파일 읽기
install.packages("readxl")
library(readxl)

getwd()

df_exam <- read_excel("./Data/excel_exam.xlsx")
df_exam
df_exam_novar<- read_excel("./Data/excel_exam_novar.xlsx")
df_exam_novar

df_exam_novar<- read_excel("./Data/excel_exam_novar.xlsx", col_names = F)
df_exam_novar

df_exam_sheet<- read_excel("./Data/excel_exam_sheet.xlsx", sheet = 3)
df_exam_sheet


df_csv_exam<- read.csv("./Data/csv_exam.csv")
df_csv_exam

df_midterm<- data.frame(english= c(90, 80, 60, 70 ),
                        math =c(50, 60, 100, 20),
                        class=c(1, 1, 2, 2))
df_midterm

write.csv(df_midterm, file = "df_midterm1.csv")

mpg<- as.data.frame(ggplot2::mpg)
mpg

head(mpg, 10)
dim(mpg)
str(mpg)

#------------------------------------------

# dplyr 함수

install.packages("dplyr")
library(dplyr)

df_raw<- data.frame(var1= c(1,2,1),
                    var2= c(2, 3, 2))
df_raw

df_new <- df_raw # 데이터 복사 
df_new


df_new<- rename(df_new, v2 = var2) # 데이터명 바꾸기
df_new

#-----------------------------------

df<- data.frame(var1= c(4, 3, 8),
                var2= c(2, 6, 1))
df

df$var_sum<- df$var1+df$var2

# df$var_sum <- 10 파생변수 생성
df

#------------------------------------

df$var_mean <- (df$var1+ df$var2)/2
df
# 통합 연비 변수 생성
mpg
mpg$total<- (mpg$cty+ mpg$hwy)/2
head(mpg)
summary(mpg$total) # mpg$total의 요약
hist(mpg$total) # mpg$total의 히스토그램

#----------------------------------------

#데이터 컨트롤
mpg$test <- ifelse(mpg$total>= 20, "pass","fail")
head(mpg,20)
table(mpg$test)

library(ggplot2) 
qplot(mpg$test) #연비 합격 빈도 막대 그래프 생성

mpg$grade <- ifelse(mpg$total>=30,"A",
                    ifelse(mpg$total>=20,"B","C")) 
mpg$grade  # total을 기준으로 A,B,C 등급 부여 범주형 데이터

table(mpg$grade)
qplot(mpg$grade)

#----------------------------------------------------------

#데이터 실습 (midwest 내장데이터)

midwest<- as.data.frame(ggplot2::midwest)
head(midwest)
tail(midwest)
View(midwest) # 표로 보여주기
dim(midwest)
str(midwest)
summary(midwest)

library(dplyr)

midwest <-rename(midwest, total= poptotal, asian = popasian)
head(change)

midwest$ratio<- change$asian/change$total *100
midwest$ratio

mean(midwest$ratio)

midwest$group<-ifelse(change$ratio>0.4872462, "large", "small")
midwest$group


#-----------------------------------------------

# 데이터 전처리(필터링) 함수
# filter()      행 추출
# select()      열(변수) 추출
# arrange()     정렬
# mutate()      변수 추가
# summarise()   통계치 산출
# group_by()    집단별로 나누기
# left_join()   데이터 합치기(열)
# outer_join()  데이터 합치기(행)

getwd()
exam<-read.csv("./Data/csv_exam.csv")
exam

exam %>% filter(class==1)
exam %>% filter(class!=1) # 1이 아닌 모든 것
exam %>% filter(class==1 & math>=50) # 1반이면서 수학점수가 50점 이상인 경우
# '또는' 인 경우 | 를 사용

exam %>% filter(class==1| class == 3| class== 5) # 1, 3, 5 반에 해당되면 추출

# %in% 기호 사용하기 (매칭 확인)

#--------------------------------------------------------------------

mpg
mpg<- as.data.frame(ggplot2::mpg)


mpg_a <- mpg %>% filter(displ <=4)
mpg_b <- mpg %>% filter(displ >=5)

mean(mpg_a$hwy)
mean(mpg_b$hwy)

# 제조사가 쉐보레, 포드, 혼다에 해당하면 추출

mpg_new<-mpg %>% filter(manufacturer %in% c("chevolet","ford","honda") )
mpg_new
mean(mpg_new$hwy)

#---------------------------------------------

#변수 제외하기 

exam %>% select(-math)

#dplyr함수 조합하기

# class가 1인 행만 추출한 다음 english 추출

exam %>% filter(class==1) %>% select(english)

#--------------------------------------------------

# 실습

df<- mpg %>% select(class,cty)
head(df)

df_suv<- df %>% filter(class== "suv")
df_compact <- df %>% filter(class=="compact")

df_suv
df_compact

mean(df_suv$cty)
mean(df_compact$cty)

