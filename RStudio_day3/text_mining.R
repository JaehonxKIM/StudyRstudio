# 텍스트 마이닝

# 전 설치 
install.packages("usethis")
usethis::edit_r_environ()
Sys.which("make")
#PATH= "${RTOOLS40_HOME}\usr\bin;${PATH}"

install.packages("rJava")
install.packages("remotes")
remotes::install_github('haven-jeon/KoNLP', upgrade = "never", INSTALL_opts=c("--no-multiarch"))
library(KoNLP)
text <- "R은 통계 계산과 그래픽을 위한 프로그래밍 언어이자 소프트웨어 환경이자 프리웨어이다.[2] 뉴질랜드 오클랜드 대학의 로버트 젠틀맨(Robert Gentleman)과 로스 이하카(Ross Ihaka)에 의해 시작되어 현재는 R 코어 팀이 개발하고 있다. R는 GPL 하에 배포되는 S 프로그래밍 언어의 구현으로 GNU S라고도 한다. R는 통계 소프트웨어 개발과 자료 분석에 널리 사용되고 있으며, 패키지 개발이 용이해 통계 소프트웨어 개발에 많이 쓰이고 있다." 
extractNoun(text)

library(KoNLP)
library(dplyr)

# useNIADic()

txt<-readLines("./Data/hiphop.txt", encoding = "UTF-8")
head(txt)

install.packages("stringr")

