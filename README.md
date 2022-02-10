# StudyRstudio
RStudio
### 1잁차
-  R Studio 설치
-  엑셀 파일 읽기 
 - install.packages("readxl")   library(readxl)
 - read.excel("파일 경로")
- dplyr 함수
 -install.packages("dplyr")  library(dplyr)
- 데이터 컨트롤
- midwest 내장데이터 사용
- 데이터 전처리(필터링) 함수
 - filter()      행 추출
 - select()      열(변수) 추출
 - arrange()     정렬
 - mutate()      변수 추가
 - summarise()   통계치 산출
 - group_by()    집단별로 나누기
 - left_join()   데이터 합치기(열)
 - outer_join()  데이터 합치기(행)
- %in% 기호 사용하기 (매칭 확인)
- 변수 제외하기 
 - exam %>% select(-math)

### 2일차
- 요약하기 summarise()
- 집단 별로 요약하기  group_by()
- mpg 데이터 실습 left_join()
- csv.exam 데이터 실습
- 결측치 표기 (NA)
 - is.na()  , is.omit() 함수
- %>% 
- outliner() , ifelse()  함수
- 그래프 만들기
 - boxplot()
 - 산점도 그래프
- visualization

### 3일차
- visualization 이어서
- data_analyze(foreign) install.packages("foreign")
- 자체 데이터 분석 
- 막대그래프에 색 입히기 
  - ggplot(data = sex_income, aes(x = ageg, y = mean_income, fill = sex)) + 
   geom_col() +
   scale_x_discrete(limits = c("young", "middle","old"))
- Text Mining

### 4일차 
- Text Mining 계속
- 대통령 연설문 단어 빈도 분석 (wordcloud)
- 지도 시각화
- 데이터 분석 실습 




