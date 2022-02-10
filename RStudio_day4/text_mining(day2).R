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

useNIADic()

txt<-readLines("./Data/hiphop.txt", encoding = "UTF-8")
head(txt)

# 패키지 로드 에러 발생할 경우 -JAVA 설치 경로 확인 후 경로 설정
# Sys.setenv(JAVA_HOME="JAVA 파일경로")

install.packages("stringr")
library(stringr)

# 특수문자 제거 
#txt <- str_replace_all(txt, "\\w","")
#txt

# 가장 많은 단어 추출하기 

extractNoun("대한민국의 영토는 한반도와 그 부속도서로 한다")

# 가사에서 명사추출

nouns<-extractNoun(txt)
nouns

# 추출한 명사 list를 문자열 벡터로 변환, 단어별 빈도표 생성
wordcount<- table(unlist(nouns))
wordcount

# 데이터 프레임으로 변환
df_word <- as.data.frame(wordcount, stringsAsFactors = F)
df_word

# 변수명 수정
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)
df_word

# 두 글자 이상 단어 추출

df_word <- filter(df_word, nchar(word) >= 2)
df_word

# 탑 20

top_20 <- df_word %>%
  arrange(desc(freq)) %>%
  head(20)

top_20

#------------------------------------------------

# 워드 클라우드 만들기

install.packages("wordcloud")
library(wordcloud)
library(RColorBrewer)

pal <- brewer.pal(8,"Dark2")  # Dark2 색상 목록에서 8개 색상 추출
pal

wordcloud(words = df_word$word,  # 단어
          freq = df_word$freq,   # 빈도
          min.freq = 2,          # 최소 단어 빈도
          max.words = 200,       # 표현 단어 수
          random.order = F,      # 고빈도 단어 중앙 배치
          rot.per = .1,          # 회전 단어 비율
          scale = c(4, 0.3),     # 단어 크기 범위
          colors = pal)          # 색깔 목록

# 단어 색상 바꾸기 

pal <- brewer.pal(9,"Blues")[5:9]  # 색상 목록 생성
set.seed(1234)                     # 난수 고정

wordcloud(words = df_word$word,    # 단어
          freq = df_word$freq,     # 빈도
          min.freq = 2,            # 최소 단어 빈도
          max.words = 200,         # 표현 단어 수
          random.order = F,        # 고빈도 단어 중앙 배치
          rot.per = .1,            # 회전 단어 비율
          scale = c(4, 0.3),       # 단어 크기 범위
          colors = pal)            # 색상 목록


# 국정원 트윗 텍스트 마이닝
getwd()

twitter<- read.csv("./Data/twitter.csv",
                   header =  T,
                   stringsAsFactors = F,
                   fileEncoding = "UTF-8")
head(twitter)

# 변수명 수정
twitter <- rename(twitter,
                  no = 번호,
                  id = 계정이름,
                  date = 작성일,
                  tw = 내용,)
head(twitter)
twitter$tw


# 특수문자 제거 
# twitter$tw<- str_replace_all(twitter$tw, "\\W", "")


library(KoNLP)

nouns <- extractNoun(twitter$tw)
nouns
# 추출한 명사 list를 문자열 벡터로 변환, 단어별 빈도표 생성
wordcount<- table(unlist(nouns))
wordcount

# 데이터 프레임으로 변환
df_word<- as.data.frame(wordcount,StringAsFactors = F)
df_word

# 변수명 수정
df_word<- rename(df_word,
                 word = Var1,
                 freq = Freq)
df_word

# 트윗에서 명사추출

nouns<- extractNoun(twitter$tw)

wordcount<- table(unlist(nouns))
#데이터 프레임 변환
df_word<- as.data.frame(wordcount,StringAsFactors = F)

# 변수명 수정
df_word<- rename(df_word,
                 word = Var1,
                 freq = Freq)

# 두 글자 이상 단어만 추출
df_word<-filter(df_word, nchar(word)>=2)

# 상위 20개 확인
top20<- df_word %>%
  arrange(desc(freq))%>%
  head(20)

# 단어별 빈도 막대그래프 만들기

library(ggplot2)
order<- arrange(top20, freq)$word

ggplot(data = top20 , aes(x= word, y= freq)) +
  ylim(0,2500) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limits = order) +
  geom_text(aes(label =freq), hjust =  -0.3)

# 워드 클라우드 만들기

pal<- brewer.pal(8, "Dark2")
set.seed(1234)                   # 난수 고정
wordcloud(words= df_word$word,   # 단어
          freq = df_word$freq,   # 빈도
          min.freq = 10,         # 최소 단어 빈도
          max.words = 200,       # 표현 단어 수
          random.order = F,      # 고빈도 단어 중앙 배치
          rot.per = .1,          # 회전 단어 비율
          scale = c(6, 0.3),     # 단어 크기 범위
          colors = pal)          # 색깔 목록


pal <- brewer.pal(9,"Blues")[5:9]  # 색상 목록 생성
set.seed(1234)                     # 난수 고정

wordcloud(words = df_word$word,    # 단어
          freq = df_word$freq,     # 빈도
          min.freq = 10,           # 최소 단어 빈도
          max.words = 200,         # 표현 단어 수
          random.order = F,        # 고빈도 단어 중앙 배치
          rot.per = .1,            # 회전 단어 비율
          scale = c(6, 0.2),       # 단어 크기 범위
          colors = pal)            # 색상 목록






