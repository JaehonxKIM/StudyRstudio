# 오라클과 R 연동하기

# ojdbc.jar를 이용해 데이터 접속을 위한 라이브러리

# 사전 설치 사항

# jdk 설치 및 환경변수 등록하기

install.packages("RJDBC")
library(RJDBC)

getwd()
# 오라클 드라이버 연결 경로 설정 (파일 경로)

driver<- JDBC("oracle.jdbc.OracleDriver",
              classPath = "C:/DEV/Server/Oracle/product/12.2.0/dbhome_1/jdbc/lib/ojdbc8.jar")
driver

# 오라클 접속하기 

conn<- dbConnect(driver,
                 "jdbc:oracle:thin:@//localhost:1521/orcl",
                 "busan","dbdb")
conn

#--- sql에서 실행

# CREATE USER busan IDENTIFIED BY dbdb;    # 계정/ 비밀번호 바꾸기

# GRANT CONNECT, RESOURCE , DBA TO busan;  # 접근권한 부여

# 데이터 입력하기

sql_in<- paste(" Insert into test",        # paste 하나의 문장으로 합치는 함수
               "(AA,BB,CC)",
               "values('a1','b1','c1')")
sql_in

in_stat = dbSendQuery(conn,sql_in)
in_stat

dbClearResult(in_stat)
# 데이터 조건 조회 하기

sql_sel<- "Select * From test Where AA = 'a1' "
sql_sel

getData<- dbGetQuery(conn,sql_sel)
getData


getData$AA 
str(getData)

### 중요 필수 무조건 오라클 접속 해제하기

# dbDisconnect(conn)



