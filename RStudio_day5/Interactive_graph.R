# 인터렉티브 그래프 그리기

install.packages("plotly")
library(plotly)

mpg
library(ggplot2)
p<- ggplot(data= mpg, aes(x= displ, y = hwy, col = drv)) + geom_point()
ggplotly(p)

p<- ggplot(data= diamonds, aes(x= cut, fill = clarity)) +
  geom_bar(position = "dodge")
ggplotly(p)

# 인터렉티브 시계열 그래프 그리기

# 패키지
install.packages("dygraphs")
library(dygraphs)

economics<-ggplot2:: economics
head(economics)

# 시간 순서 속성을 지니는 xts 데이터로 변경

library(xts)

eco<- xts(economics$unemploy, order.by =  economics$date)
head(eco)

dygraph(eco)

#날짜 범위 선택기능

dygraph(eco) %>% dyRangeSelector()

# 여러 값 표현하기

eco_a<- xts(economics$psavert, order.by = economics$date)
eco_b<- xts(economics$unemploy/1000 , order.by = economics$date)

eco2<- cbind(eco_a,eco_b)                   # 데이터 결합
colnames(eco2) <- c("psavert", "unemploy")  # 변수명 바꾸기
head(eco2)

# 결합 그래프 만들기 

dygraph(eco2) %>% dyRangeSelector()

## 그래프에 들어가는 데이터의 형태 확인, 경우에 맞는 그래프 사용하기!!




