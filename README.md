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
