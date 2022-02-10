# 지도 시각화

# 패키지 설치

install.packages("ggiraphExtra")
library(ggiraphExtra)

# 미국 주별 범죄데이터 

str(USArrests)
head(USArrests)

library(tibble)

# 행 이름을 state 변수로 바꿔 데이터 프레임 생성
crime<- rownames_to_column(USArrests, var = "state")
crime

# 지도 데이터에 동일하게 맞추기 위해 state의 값을 소문자로 수정
crime$state<- tolower(crime$state)
crime$state

str(crime)

# 미국 주 지도 데이터 준비

library(ggplot2)
states_map<- map_data("state")
str(states_map)

# 지도 표현 하기

ggChoropleth(data= crime,             # 지도에 표현할 데이터
             aes(fill = Murder,       # 색깔로 표현할 함수
                 map_id = state),     # 지역 기준 변수
             map =states_map)         # 지도 데이터

# 인터렉티브 단계 구분도 만들기

ggChoropleth(data= crime,             # 지도에 표현할 데이터
             aes(fill = Murder,       # 색깔로 표현할 함수
                 map_id = state),     # 지역 기준 변수
             map =states_map,         # 지도 데이터
             interactive =  T)        # 인터렉티브

# 대한민국 시도별 인구, 결핵 환자 수 단계 구분도 

install.packages("string1")
install.packages("devtools")
# devtools:: install_github("cardiomoon/kormaps2014")
library(kormaps2014)

new_data_korm<- kormap1
new_data_korm               # 복사본

# 대한민국 시도별 인구 데이터

str(changeCode(korpop1))

library(dplyr)
korpop1<- rename(korpop1,
                 pop = 총인구_명,
                 name = 행정구역별_읍면동)

str(changeCode(korpop1))
str(changeCode(kormap1))

# 단계 구분도 만들기 

ggChoropleth(data= korpop1,          # 지도에 표현할 데이터
             aes(fill = pop,         # 색깔로 표현할 변수
                 map_id = code,      # 지역 기준 변수 
                 tooltip =name),     # 지도 위에 표시할 지역명
             map= kormap1,           # 지도 데이터
             interactive= T)         # 인터렉티브

# 대한민국 시도별 결핵 환자 수 단계 구분도 만들기

str(changeCode(tbc))

ggChoropleth(data= tbc,               # 지도에 표현할 데이터
             aes(fill = NewPts,       # 색깔로 표현할 변수
                 map_id = code,       # 지역 기준 변수
                 tooltip =name),      # 지도 위에 표시할 지역명
             map= kormap1,            # 지도 데이터 
             interactive= T)          # 인터렉티브

#------------------------------------------------------------------------------

# head시 글자 깨질 때 사용
head(changeCode(tbc))
head(changeCode(korpop1))
head(changeCode(kormap1))



