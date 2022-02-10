# 전두환 대통령 취임사 분석


library(KoNLP)
library(dplyr)
txt<-readLines("./Data/president_speak3.txt", encoding = "UTF-8")
head(txt)

library(stringr)

#txt <- str_replace_all(txt, "\\w",'')
#txt

nouns<-extractNoun(txt)
nouns

wordcount<- table(unlist(nouns))
wordcount


df_word <- as.data.frame(wordcount, stringsAsFactors = F)
df_word


df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)
df_word


df_word <- filter(df_word, nchar(word) >= 2)
df_word


top_20 <- df_word %>%
  arrange(desc(freq)) %>%
  head(20)

top_20

## 워드 클라우드 만들기

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
