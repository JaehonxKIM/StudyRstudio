# 빅데이터 자료 수집

# 파일 데이터셋 자료수집

# 다양한 기관이 공익적인 목적에서 제공되는 파일 데이터셋을 이용함
## 공공데이터포털
## 국가통계포털
## 서울열린데이터광장
## UC 얼바인 머신러닝 저장소
## 캐글 (kaggle)

# 공공데이터포털에서 가져오기
getwd()
setwd("C:/Users/admin/Documents/StudyRstudio/Recture/Busan_202202_R/Rstudy")
exam<- read.csv("./Data/전라남도_목포시_장애인_복지시설_20210802.csv")
exam

# 웹 스크래핑

 # 패키지 설치
install.packages("rvest")
install.packages("stringr")
library(rvest)
library(stringr)

# 웹 스크래핑 순서

# 웹 스크래핑 대상 url 할당(보배드림 국산차매장)

url<- "http://www.bobaedream.co.kr/cyber/CyberCar.php?gubun=K&page=1"
url

# 웹 문서 가져오기
usedCar<- read_html(url)
usedCar

# 특정 태그의 데이터 추출
# 가져온 usedCar에서 css가 "product-item인것을 찾기
carInfos<- html_nodes(usedCar, css = ".product-item")
head(carInfos)

# 차량 명칭 추출

title_tmp<- html_nodes(carInfos, css= ".tit.ellipsis")
title_tmp

title<- html_text(title_tmp)
title

# 데이터 정제
title<- str_trim(title)    # 문자열에서 공백 제거
title

# 차량 연식 추출
year_tmp<- html_nodes(carInfos, css=".mode-cell.year")
year_tmp

year<- html_text(year_tmp)
year

year<- str_trim(year)
year

# 연료 구분
fuel_tmp<- html_nodes(carInfos, css=".mode-cell.fuel")
fuel_tmp

fuel<- html_text(fuel_tmp)
fuel

fuel<- str_trim(fuel)
fuel
#주행거리 추출
km_tmp<- html_nodes(carInfos, css=".mode-cell.km")
km_tmp

km<- html_text(km_tmp)
km

km<- str_trim(km)
km
# 판매가격 추출
price_tmp<- html_nodes(carInfos, css=".mode-cell.price")
price_tmp

price<- html_text(price_tmp)
price

price<- str_trim(price)
price

price<- str_replace(price, '\n','') # 문자열 변경(\n을 스페이스로 변경)
price

# 차량 명칭으로부터 제조사 추출 (패턴이 있을 때만 가능)
maker= c()
maker
title

for(i in 1: length(title)){
  maker<- c(maker,unlist(str_split(title[i],' '))[1]) #str_split 문자열 분리
}
maker

# 데이터 프레임 만들기

usedcars<- data.frame(title, year, fuel, km, price, maker)
View(usedcars)

# 데이터 정제
# km 자료 숫자로 변경

usedcars$km
usedcars$km<- gsub("만km", "0000", usedcars$km)
usedcars$km<- gsub("천km", "000", usedcars$km)
usedcars$km<- gsub("km", "", usedcars$km)
usedcars$km<- gsub("미등록", "", usedcars$km)
usedcars$km<- as.numeric(usedcars$km)

usedcars$km

# price 자료 숫자로 변경

usedcars$price
usedcars$price<- gsub("만원", "", usedcars$price)
usedcars$price<- gsub("계약", "", usedcars$price)
usedcars$price<- gsub("팔림", "", usedcars$price)
usedcars$price<- gsub("금융리스", "", usedcars$price)
usedcars$price<- gsub(",", "", usedcars$price)
usedcars$price<- as.numeric(usedcars$price)

usedcars$price

View(usedcars)

# 웹 스크래핑 자료 파일로 저장
setwd("C:/Users/admin/Documents/StudyRstudio/Recture/Busan_202202_R/Rstudy/Data")
write.csv(usedcars, "usedcars_new.csv")

# 오픈 API기반 자료수집
# 구글, 공공데이터포탈, 네이버, 카카오, 페이스북
# 오픈 API 자료 요청

install.packages("XML")
library(XML)
# 웹사이트 url 설정
api_url <- "http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getCtprvnRltmMesureDnsty"

# 승인 받은 KEY 등록
service_key <- "y3ZdMrjmr3V1BdW091pQ14y%2BB3pUu%2B7dzSFm0GZkmJrEhiP5MAm3se%2FsZmYeRTf7QxWQm64KrevZ7MXTVKI%2F2Q%3D%3D"
# 요청변수 등록
numOfRows<- "30"
sidoName<-"경기"

sidoName<- URLencode(iconv(sidoName,to="UTF-8"))
sidoName

searchCondition<- "DAILY"
# 오픈 API URL 

# paste 와 paste0 의 차이

# url 주소를 공백없이 모두 묶기
open_api_url<- paste0(api_url,"?serviceKey=",service_key,
                      "&numOfRows=", numOfRows,
                      "&sidoName=",sidoName,
                      "&searchCondition=",searchCondition)
open_api_url

# 오픈 API 통해 XML 형식으로 가져오기
raw.data<- xmlTreeParse(open_api_url,             #데이터 가져오기
                        useInternalNodes = TRUE,
                        encoding = "utf-8")
raw.data

# <./item> 태그별로 데이터 구분하기
air_pollution <- xmlToDataFrame(getNodeSet(raw.data,"//item"))
air_pollution

View(air_pollution)

# subset(): 데이터프레임 내에서 검색 조건에 
#           맞는 항목들만 가지고 오기
air_pollution<- subset(air_pollution,
                       select = c(dataTime,
                                  stationName,
                                  so2Value,
                                  coValue,
                                  o3Value,
                                  no2Value,
                                  pm10Value))
View(air_pollution)

# 오픈 API 자료 파일로 저장하기 

#디렉토리 설정
setwd("C:/Users/admin/Documents/StudyRstudio/Recture/Busan_202202_R/Rstudy/Data")
write.csv(air_pollution, "air_pollution_new.csv")



