install.packages("foreign")
library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)

getwd()




raw_welfare<- read.spss(file= "./Data/Koweps_hpc10_2015_beta1.sav",
                        to.data.frame = T)

welfare<-raw_welfare
welfare

# 데이터 확인

head(welfare)
tail(welfare)
View(welfare)
dim(welfare)
str(welfare)
summary(welfare)

welfare$sex
welfare <- rename(welfare,
                  sex = h10_g3,               # 성별
                  birth = h10_g4,             # 출생연도
                  marriage = h10_g10,         # 결혼여부
                  religion = h10_g11,         # 종교
                  income = p1002_8aq1,        # 수익
                  code_job = h10_eco9,        # 직종 코드
                  code_region = h10_reg7)     # 지역 코드
welfare

# 성별에 따라 월급이 다를까?

class(welfare$sex)

table(welfare$sex)  # 남여 인원 수

welfare$sex <- ifelse(welfare$sex == 9, NA , welfare$sex) # 이상치 결측 처리

# 결측치 확인
table(is.na(welfare$sex))

# 성별 항목 이름부여

welfare$sex<- ifelse(welfare$sex == 1, "male", "female")
table(welfare$sex)

qplot(welfare$sex)

# 월급 변수 검토 및 전처리

# 변수 검토

class(welfare$income)     

summary(welfare$income) # 요약 

qplot(welfare$income)   # 월급


qplot(welfare$income) + xlim(0, 1000)

# 이상치 결측 처리

welfare$income <- ifelse(welfare$income %in% c(0,9999), NA , welfare$income)
table(is.na(welfare$income)) # 결측치 확인

## 성별에 따른 월급 차이 분석

# 성별 월급 평균표 만들기

sex_income<- welfare %>%
  filter(!is.na(income)) %>%
  group_by(sex) %>%
  summarise(mean_income = mean(income))
sex_income

# 그래프 만들기

ggplot(data = sex_income, aes(x = sex, y = mean_income)) + geom_col()

# 나이와 월급의 관계

# 변수 검토

class(welfare$birth)
summary(welfare$birth)
qplot(welfare$birth)

# 이상치 결측처리

welfare$birth<- ifelse(welfare$birth == 9999 , NA , welfare$birth)
table(is.na(welfare$birth))

# 파생변수 만들기 (나이)

welfare$age<- 2015 - welfare$birth + 1
summary(welfare$age)

qplot(welfare$age)


# 나이에 따른 월급 평균표 만들기

age_income <- welfare %>%
  filter(!is.na(income)) %>%
  group_by(age) %>%
  summarise(mean_income = mean(income))
head(age_income)

# 그래프 만들기

ggplot(data = age_income, aes(x = age, y = mean_income)) + geom_line()


# 연령대에 따른 월급 차이

welfare <- welfare %>%
  mutate(ageg = ifelse(age< 30 , "young",
                       ifelse(age<= 59, "middle","old")))
table(welfare$ageg)

qplot(welfare$ageg)

# 연령대 별 월급 평균표 만들기

ageg_income<- welfare %>%
  filter(!is.na(income)) %>%
  group_by(ageg) %>%
  summarise(mean_income = mean(income))

ageg_income

# 막대 정렬 (청년, 중년, 노년 나이순)

ggplot(data = ageg_income, aes(x = ageg, y = mean_income)) + 
  geom_col() +
  scale_x_discrete(limits = c("young", "middle","old"))

# 성별 월급 차이는 연령대 별로 다를까?

# 막대 정렬: 초년, 중년, 노년 순

ggplot(data = ageg_income, aes(x = ageg, y = mean_income)) +
  geom_col() +
  scale_x_discrete(limits = c("young", "middle", "old"))

# 성별, 연령대 월급 평균표 만들기

sex_income<- welfare %>%
  filter(!is.na(income)) %>%
  group_by(ageg, sex) %>%
  summarise(mean_income = mean(income))
sex_income

# 막대 합치기
ggplot(data = sex_income, aes(x = ageg, y = mean_income, fill = sex)) + 
  geom_col() +
  scale_x_discrete(limits = c("young", "middle","old"))

# 성별 막대 분리

ggplot(data = sex_income, aes(x = ageg, y = mean_income, fill = sex)) + 
  geom_col(position = "dodge") +
  scale_x_discrete(limits = c("young", "middle","old"))

# 나이 및 성별 월급 차이 분석

# 성별 연령별 월급 평균표 만들기

sex_age<- welfare %>%
  filter(!is.na(income)) %>%
  group_by(age, sex) %>%
  summarise(mean_income = mean(income))
head(sex_age)

# 그래프

ggplot(data = sex_age, aes(x = age, y = mean_income, col = sex)) + geom_line()

# 변수 검토하기

class(welfare$code_job)
table(welfare$code_job)

# 엑셀 파일 읽기

library(readxl)
list_job<- read_excel("./Data/Koweps_Codebook.xlsx", col_names = T , sheet = 2)
head(list_job)

# welfare에 직업명 추가

welfare<- left_join(welfare,list_job, id = "code_job")
welfare %>%
  filter(!is.na(code_job)) %>%
  select(code_job, job) %>%
  head(10)

job_income<- welfare %>%
  filter(!is.na(job)& !is.na(income)) %>%
  group_by(job) %>%
  summarise(mean_income= mean(income))
head(job_income)

# 탑텐 추출
top10<- job_income %>%
  arrange(desc(mean_income)) %>%
  head(10)
top10

# 그래프 그리기 (월급 많은 top10 순으로 정렬)
ggplot(data = top10, aes(x = reorder(job, mean_income), y = mean_income)) + 
  geom_col() +
  coord_flip()

# 하위 10위 추출
bottom10<- job_income %>%
  arrange(mean_income) %>%
  head(10)
bottom10

# 그래프 그리기
ggplot(data = bottom10, aes(x = reorder(job, -mean_income), 
                            y = mean_income)) + 
  geom_col() +
  coord_flip() +
  ylim(0,850)

# 성별 직업 빈도 (성별로 어떤 직업이 가장 많을까?)

# 전처리
# 성별 직업 빈도표 만들기

# Top10 추출

# 남자 TOP 10
job_male<- welfare %>%
  filter(!is.na(job)& sex == "male") %>%
  group_by(job) %>%
  summarise(n= n()) %>%
  arrange(desc(n)) %>%
  head(10)

job_male

# 여자 TOP10
job_female<- welfare %>%
  filter(!is.na(job)& sex == "female") %>%
  group_by(job) %>%
  summarise(n= n()) %>%
  arrange(desc(n)) %>%
  head(10)
job_female


# 그래프 만들기 (남성)
ggplot(data = job_male, aes(x = reorder(job,n), y =n)) + 
  geom_col() +
  coord_flip()

# 그래프 만들기 (여성)
ggplot(data = job_female, aes(x = reorder(job,n), y =n)) + 
  geom_col() +
  coord_flip()

# 종교 유무에 따른 이혼율 (종교가 있는 사람들이 이혼을 덜 할까?)

# 전처리

# 변수 검토하기
class(welfare$religion)

table(welfare$religion)

#종교 유무 이름 부여

welfare$religion <- ifelse(welfare$religion == 1, "yes", "no")
table(welfare$religion)

qplot(welfare$religion)

# 변수 검토하기

class(welfare$marriage)
table(welfare$marriage)

# 이혼 여부 변수 만들기

welfare$group_marriage <- ifelse(welfare$marriage == 1,"marriage",
                                  ifelse(welfare$marriage ==3, "divorce", NA))
table(welfare$group_marriage)
table(is.na(welfare$group_marriage))
 
# 그래프 만들기

qplot(welfare$group_marriage)

# 종교 유무에 따른 이혼율 표 만들기

religion_marriage <- welfare %>%
  filter(!is.na(group_marriage)) %>%
  group_by(religion, group_marriage) %>%
  summarise(n = n()) %>%
  mutate(tot_group = sum(n)) %>%
  mutate(pct = round(n/tot_group*100, 1))
religion_marriage





# count 활용

religion_marriage <- welfare %>%
  filter(!is.na(group_marriage)) %>%
  count(religion, group_marriage) %>%
  group_by(religion) %>%
  mutate(pct = round(n/sum(n)*100,1))
religion_marriage
 
# 이혼 추출

divorce <- religion_marriage %>%
  filter(group_marriage == "divorce") %>%
  select(religion, pct)
divorce

ggplot(data = divorce, aes(x = religion, y = pct)) + geom_col()

# 연령대 및 종교 유무에 따른 이혼율 분석

# 연령대별 이혼율 표 만들기

ageg_marriage<- welfare %>%
  filter(!is.na(group_marriage)) %>%
  group_by(ageg, group_marriage) %>%
  summarise(n = n()) %>%
  mutate(tot_group = sum(n)) %>%
  mutate(pct= round(n/tot_group*100,1))
ageg_marriage

# count 활용
ageg_marriage <- welfare %>%
  filter(!is.na(group_marriage)) %>%
  count(ageg, group_marriage) %>%
  group_by(ageg) %>%
  mutate(pct = round(n/sum(n)*100,1))
religion_marriage 


# 초년 제외, 이혼 추출

ageg_divorce<- ageg_marriage %>%
  filter(ageg!= "young" & group_marriage == "divorce") %>%
  select(ageg, pct)
ageg_divorce

# 그래프 만들기
ggplot(data = ageg_divorce, aes(x= ageg, y = pct)) + geom_col()


ageg_religion_marriage<- welfare %>%
  filter(!is.na(group_marriage) & ageg != "young") %>%
  group_by(ageg, religion, group_marriage) %>%
  summarise(n=n()) %>%
  mutate(tot_group = sum(n)) %>%
  mutate(pct = round(n/tot_group*100,1))
ageg_religion_marriage

# 연령대 및 종교 유무 별 이혼율 표 만들기

df_divorce<- ageg_religion_marriage  %>%
  filter(group_marriage == "divorce") %>%
  select(ageg, religion, pct)
df_divorce

# 연령대 및 종교 유무에 따른 이혼율 그래프 만들기

ggplot(data= df_divorce, aes(x= ageg, y= pct, fill = religion)) +
  geom_col(position = "dodge")

# 노년층이 많은 지역은 어디일까?

class(welfare$code_region)
table(welfare$code_region)

# 지역이름으로 숫자데이터 바꾸기

list_region<- data.frame(code_region = c(1:7),
                         region = c("서울",
                                    "수도권(인천/경기)",
                                    "부산/경날/울산",
                                    "대구/경북",
                                    "대전/충남",
                                    "강원/충북",
                                    "광주/전남/전북/제주도"))
list_region

# welfare에 지역명 변수 추가

welfare <- left_join(welfare,list_region,id ="code_region")


##Joining, by = "code_region"


welfare %>%
  select(code_region, region) %>%
  head

# 지역별 연령대 비율표 만들기

region_ageg<- welfare %>%
  group_by(region, ageg) %>%
  summarise(n=n()) %>%
  mutate(tot_group = sum(n)) %>%
  mutate(pct = round(n/tot_group*100,2))

head(region_ageg)


ggplot(data = region_ageg, aes(x = region, y = pct, fill = ageg)) +
  geom_col() +
  coord_flip()

# 노년층 비율 내림차순 정렬

list_order_old <- region_ageg %>%
  filter(ageg == "old") %>%
  arrange(pct)
list_order_old

# 지역별 순서 변수 만들기

order<- list_order_old$region
order

# 그래프 만들기

ggplot(data = region_ageg, aes(x = region, y = pct, fill = ageg)) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limits = order)


# 연령대 순으로 막대 색깔 나열하기

class(region_ageg$ageg)

levels(region_ageg$ageg)

region_ageg$ageg <- factor(region_ageg$ageg,
                           level =c("old","middle","young"))
class(region_ageg$ageg)

levels(region_ageg$ageg)


ggplot(data = region_ageg, aes(x = region, y = pct, fill = ageg)) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limits = order)
