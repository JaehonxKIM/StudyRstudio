install.packages("ggplot2")
library(ggplot2)
ggplot(data = mpg, aes(x= displ, y = hwy)) # x,y축 만들기

# 배경에 산점도 추가 
ggplot(data = mpg, aes(x= displ, y = hwy)) + geom_point() 

# 범위 확대
ggplot(data = mpg, aes(x= displ, y = hwy)) + geom_point() + xlim(3,6)

# x 축범위 3~6, y축 범위 10~30으로 지정 (중간에 다 + 로 이어줘야 함)

ggplot(data = mpg, aes(x= displ, y = hwy)) + geom_point() + xlim(3,6) + ylim(10,30)

# ggplot2 가독성 높이기(Rstudio에서만 가능)

ggplot(data = mpg, aes(x= displ, y = hwy)) + 
  geom_point() +
  xlim(3,6)+ 
  ylim(10,30)

# qplot() vs ggplot()
# qplot : 전처리 단계 데이터 확인용 문법 -- 간단, 기능 단순
# ggplot : 최종 보고용, 색, 크기, 폰트 등 세부조작 가능

# 실습

mpg<-as.data.frame(ggplot2::mpg)

# 1.

ggplot(data = mpg, aes(x = cty, y = hwy)) + geom_point()

# 2.

midwest

ggplot(data = midwest, aes(x= poptotal , y = popasian)) +geom_point()

ggplot(data = midwest, aes(x= poptotal, y = popasian)) + 
  geom_point() + 
  xlim(0,500000) + 
  ylim(0,10000)

#평균 막대그리기

#집단별 평균표 그리기
install.packages("dplyr")

library(dplyr)
install.packages("ggplot2")
library("ggplot2")

df_mpg<- mpg %>%
  group_by(drv) %>%
  summarise(mean_hwy = mean(hwy))
df_mpg

ggplot(data = df_mpg, aes(x= drv, y = mean_hwy)) + geom_col()


df<- mpg %>%
  filter(class== "suv") %>%
  group_by(manufacturer) %>%
  summarise(mean_cty= mean(cty)) %>%
  arrange(desc(mean_cty)) %>%
  head(5)

ggplot(data =df, aes(x =reorder(manufacturer, -mean_cty),
                     y= mean_cty)) +geom_col()


            



