install.packages("readxl")
library("readxl")

getwd()
exam<- read.csv("./Data/csv_exam.csv")
head(exam)

mpg<- as.data.frame(ggplot2::mpg)
mpg %>% filter(manufacturer == "audi") %>%
  arrange(desc(hwy)) %>%
  head(5)

#파생변수 추가하기

exam
install.packages("dplyr")
library("dplyr")

exam<- exam %>%
  mutate(total = math + english + science )
  head(exam)  # 점수 총합 구해서 열 추가하기

exam %>%
  mutate(total = math + english + science,
         mean= (math + english + science)/3)  # 평균 구해서 열 추가하기

exam %>%
  mutate(test = ifelse(science >= 60, "pass","fail")) %>%
  head     # mutate에 ifelse 적용하기
         
# 실습

install.packages("ggplot")
library("ggplot")
mpg<- as.data.frame(ggplot::mpg)
mpg_new <- mpg
mpg_new

install.packages("dplyr")
library("dplyr")

mpg_new <- mpg_new %>%
  mutate(total = cty + hwy) 
head(mpg_new)


mpg_new <- mpg_new %>%
  mutate(avr = total/2)
head(mpg_new)


mpg_new %>%
  arrange(desc(avr)) %>%
  head(3)

mpg %>%
  mutate(total = cty + hwy ,
         mean = total/2) %>%
  arrange(desc(mean)) %>%
  head(3)

# 집단별로 요약하기

# 학급별 수학점수 평균
exam %>%
  group_by(class) %>%                 # class별로 분리
  summarise(mean_math = mean(math))   # math의 평균 산출

# 여러 요약 통계랑 한번에 산출하기
exam %>%
  group_by(class) %>% 
  summarise(mean_math = mean(math),
            sum_math = sum(math),
            median_math = median(math),  # math 중앙 값
            n = n())                     # 학생 수

# 각 집단 별로 다시 집단 나누기

mpg %>% 
  group_by(manufacturer,drv) %>%
  summarise(mean_cty = mean(cty)) %>%
  head(10)

# dplyr 조합하기

head(mpg)

mpg_new <-mpg %>%
  group_by(manufacturer) %>%
  filter(class == "suv") %>%
  mutate(total = (cty + hwy)/2) %>%
  summarise(mean_total = mean(total)) %>%
  arrange(desc(mean_total)) %>%
  head(5)
mpg_new

# mpg 실습

# 1.
mpg<-as.data.frame(ggplot::mpg)


mpg %>%
  group_by(class) %>%
  summarize(mean_cty = mean(cty))

# 2.
mpg %>%
  group_by(class) %>%
  summarize(mean_cty = mean(cty)) %>%
  arrange(desc(mean_cty))

# 3.
mpg %>%
  group_by(manufacturer) %>%
  summarize(mean_hwy = mean(hwy)) %>%
  arrange(desc(mean_hwy)) %>%
  head(3)

# 4.
mpg %>%
  filter(class == "compact") %>%
  group_by(manufacturer) %>%
  summarize(count = n()) %>%  # 빈도 구하기
  arrange(desc(count))


# 가로로 합치기
test1<- data.frame(id = c(1,2,3,4,5),
                   midterm = c(60,80,70,90,85))
test1 # 중간고사 성적

test2<- data.frame(id = c(1,2,3,4,5),
                   final = c(70,83,65,95,80))
test2 # 기말고사 성적

# id 기준으로 합치기
total <- left_join(test1,test2, by = "id")
total

# 일반변수 type_of(변수명)
# 데이터컬럼 mode(컬럼명)

# 다른 데이터 활용해 변수 추가하기

# 반별 담임교사 명단 생성

name <- data.frame(class=c(1,2,3,4,5),
                   teacher= c("kim","lee","park","choi","jung"))
name

# class 기준 합치기

exam_new <-left_join(exam, name, by = "class")
exam_new

# 세로로 합치기 bind_rows(group_a,group_b)

# 학생 1~5번 시험 데이터 생성

group_a<- data.frame(id = c(1,2,3,4,5),
                     test = c(60,70,80,90,85))

# 학생 6~10번 시험 데이터 생성

group_b <- data.frame(id = c(6,7,8,9,10),
                      test = c(70,83,65,95,80))
group_all <- bind_rows(group_a,group_b)
group_all

#-------------------------------------------------

# 실습

fuel <- data.frame(fl= c("c","d","e","p","r"),
                   price_fl =c(2.35, 2.38, 2.11, 2.76 , 2.22),
                   stringsAsFactors = F)
fuel

mpg<- as.data.frame(ggplot2::mpg)
mpg

mpg<- left_join(mpg,fuel, by = "fl")

mpg %>%
  select(model,fl,price_fl) %>%
  head(5)

# 결측치 만들기

# 결측치 표기 NA

df<- data.frame(sex= c("M","F",NA,"M","F"),
                score =c(5,4,3,4,NA))
df

# 결측치 확인하기
is.na(df)

table(is.na(df))

# 결측치 포함된 상태로 분석

mean(df$score)

sum(df$score)

# 결측치 제거하기 

library(dplyr)
df %>% filter(is.na(score)) # score가 NA인 데이터만 출력

df %>% filter(!is.na(score)) # score 결측치 제거

# 여러 변수 동시에 결측치 없는 데이터 추출하기

df_nomiss<- df %>% filter(!is.na(score)& !is.na(sex))
df_nomiss

# 결측치가 하나라도 있으면 제거하기

df_nomiss2 <- na.omit(df) # 모든 변수에 결측치 없는 데이터 추출
df_nomiss2

# 함수의 결측치 제외 기능 이용하기  - na.rm = T
mean(df$score, na.rm= T)

exam<- read.csv("./Data/csv_exam.csv")
exam[c(3,8,15), "math"] <-NA
exam

# 평균으로 대체하기

exam$math<- ifelse(is.na(exam$math),55,exam$math) #math가 NA면 55로 대체
table(is.na(exam$math))

exam$math # 확인


# 실습

mpg< as.data.frame(ggplot2::mpg)
mpg[c(65,124,131,153,212),"hwy"] <- NA
mpg
                   
# 1.

table(is.na(mpg$drv))
table(is.na(mpg$hwy))

# 2.

mpg %>%
  filter(!is.na(hwy)) %>%
  group_by(drv) %>%
  summarise(mean_hwy = mean(hwy))

# 이상치 정제하기

outliner<- data.frame(sex =c(1,2,1,3,2,1),
                      score =c(5,4,3,4,2,6))
outliner

# 이상치 확인하기

table(outliner$sex)
table(outliner$score)

# 결측치 처리하기 - sex

# sex가 3인경우 NA 할당

outliner$sex<- ifelse(outliner$sex ==3 , NA, outliner$sex)
outliner  

# score가 5 이상인경우 NA할당
outliner$score<-ifelse(outliner$score>5, NA , outliner$score)
outliner 

# 정제
outliner %>%
  filter(!is.na(sex)& !is.na(score)) %>%
  group_by(sex) %>%
  summarise(mean_score = mean(score))

# 이상치 제거하기(극단적인 값) boxplot

mpg<-as.data.frame(ggplot2::mpg)
boxplot(mpg$hwy)

boxplot(mpg$hwy)$stats # 상자그림 통계치 출력

# 결측 처리하기

# 12 ~ 37 벗어나면 NA할당

mpg$hwy <- ifelse(mpg$hwy < 12 | mpg$hwy> 37, NA, mpg$hwy)
table(is.na(mpg$hwy))

# 결측치 제외하고 분석하기

mpg %>%
  group_by(drv) %>%
  summarise(mean_hwy = mean(hwy, na.rm = T))


# 실습

mpg<- as.data.frame(ggplot2::mpg)
mpg[c(10,14,58,93),"drv"] <- "k"
mpg[c(29,43,129,203), "cty"]<- c(3,4,39,42)
mpg


# 1.
table(mpg$drv)

mpg$drv<- ifelse(mpg$drv %in% c("4","f","r"), mpg$drv, NA)
table(mpg$drv)

# 2.
boxplot(mpg$cty)$stats

mpg$cty <- ifelse(mpg$cty < 9 | mpg$cty> 26, NA, mpg$cty)

boxplot(mpg$cty)

# 3.
mpg %>%
  filter(!is.na(drv)& !is.na(cty)) %>%
  group_by(drv) %>%
  summarise(mean_hwy = mean(cty))







