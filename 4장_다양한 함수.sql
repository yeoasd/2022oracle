--<북스-4장.다양한 함수>
/***<문자함수>************************************/
--1. 대소문자 변환함수
select 'Apple',
upper('Apple'),--대문자로 변환
lower('Apple'),--소문자로 변환
initcap('aPPLE')--첫글자만 대문자, 나머지는 소문자로 변환
from dual;--가상테이블

--대소문자 변환함수 어떻게 활용되는지 살펴보기
--'scott' 사원의 사원번호, 이름, 부서번호 출력
select * from employee;

select ename, lower(ename), initcap(ename)
from employee;

select eno, ename, dno
from employee
where ename = upper('scott'); --값을 대문자로 변환하여 비교

select eno, ename, dno
from employee
where lower(ename) = 'scott'; --비교대상인 사원이름을 모두 소문자로 변환하여 비교

select eno, ename, dno
from employee
where initcap(ENAME) = 'Scott';


--2. 문자길이를 반환하는 함수
--영문, 수, 특수문자(1byte) 또는 한글의 길이 구하기
--length() : 문자 수
select length('Apple'), length('사과')
from dual;--5 2

--lengthB() : 한글2bytes--'인코딩 방식'에 따라 달라짐(UTF-8:한글 1글자가 '3바이트')
select lengthB('Apple'), lengthB('사과')
from dual;--5바이트 6바이트

--3. 문자 조작 함수
--concat('문자열1', '문자열2') : '두 문자열'을 하나의 문자열로 연결(=결합)
--		★반드시 2개 문자열만 연결 가능 = 매개변수 2개만
--매개변수=인수=인자=argument
select 'Apple', '사과',
concat('Apple', '사과') as "함수 사용",--자바에서는 "Apple".concat("사과")
'Apple' || '사과' || '맛있어' as "|| 사용"--자바에서는 "Apple" + "사과" + "맛있어"
from dual;

--substr(기존문자열, 시작index, 추출할 개수) :기존  문자열의 일부만 추출하여 부분문자열을 만듬
--시작index : 음수이면 문자열의 마지막을 기준으로 거슬러 올라옴
--인덱스(index) : 1 2 3... (※자바 index : 0 1 2...)
select substr('apple mania', 7, 5),--'mania'
substr('apple mania', -11, 5)--'apple'
from dual;

--[문제1] '이름이 N으로 끝나는' 사원 정보 표시
select * from employee;

select *
from EMPLOYEE
where ename LIKE '%N';

select *
from EMPLOYEE
where ename LIKE upper('%n');

select *
from EMPLOYEE
where substr(ename,-1,1)='N';

select ename, substr(ename, -1, 1)
from EMPLOYEE
where substr(ename,-1,1)='N';

select *
from EMPLOYEE
where substr(ename,-1,1)= upper('n');

select *
from EMPLOYEE
where lower(substr(ename,-1,1))='n';


--[문제2] 87년도에 입사한 사원 정보 검색
--[방법-1]
select *
from employee
where substr(hiredate,1,2)='87';--★오라클 : 날짜 기본 형식 'YY/MM/DD'

select *
from employee
where substr(hiredate,1,4)='1987';--결과 없음

--[방법-2]
--TO_CHAR(수나 날짜, '형식') : 수나 날짜를 원하는 형식의 문자로 형변환함
select *
from employee
where substr(to_char(hiredate,'yyyy'),1,4)='1987';--substr('1987',1,4)

select *
from employee
where substr(to_char(hiredate,'yyyy-mm-dd'),1,4)='1987';--substr('1987-11-12',1,4)


--[문제3] '급여가 50으로 끝나는' 사원의 사원이름과 급여 출력
--[방법-1]
select ename, salary
from employee
where salary like '%50';--salary는 실수 number(7,2)타입이지만 '문자로 자동형변환'되어 비교

[--방법-2]
select ename, salary
from employee--시작index : 끝에서 2번째부터 시작해서 2개 문자로 부분문자열 생성
--where substr(salary,-2,2)='50';--salary는 실수 number(7,2)타입이지만 '문자로 자동형변환'
where substr(salary,-2,2)=50;--'50'=50	50=50 (문자'50'이 숫자 50으로 자동 형변환되어 비교됨)
	
--[방법-3] : 자동으로 형변환되어 비교된다는 사실을 모르면
--substr()는 문자함수
select ename, salary
from employee
where substr(to_char(salary),-2,2)='50';--TO_CHAR(수나 날짜)를 문자로 형변환해야 함

--substrB(기존 문자열, 시작index, 추출할 바이트수)
select substr('사과매니아',1,2),--'사과'
substrB('사과매니아',1,3),--'사' : 1부터 시작해서 3바이트 추출해서 부분문자열을 생성
substrB('사과매니아',4,3),--'과'
substrB('사과매니아',1,6)--'사과'
from dual;

--instr(대상문자열, 찾을 문자열, 시작 index, 몇 번째 발견) : '대상문자열' 내에 '시작index'부터 시작해서 '몇 번째 발견'하는 '해당 문자열'을 찾아 index 번호 리턴
--즉, 찾을 문자열이 어느 '위치(=index번호)'에 있는지와, 대상문자열에 존재하는지의 여부를 알 수 있다.
--'시작 index, 몇 번째 발견' 생략하면 모두 1로 간주
--ex) instr('대상문자열','찾을문자') == instr('대상문자열','찾을문자', 1, 1)
--찾는 문자가 없으면 0을 결과로 돌려줌(※자바에서는 -1을 돌려줌)
--자바에서는 "행복,사랑".indexOf("사랑")==3(※자바의 index는 0부터 시작)
select instr('apple','p'), instr('apple','p',1,1),--2 2
		instrB('apple','p'), instrB('apple','p',1,1),-- 2 2
instr('apple','p',1,2)--3('apple'내에서 1부터 시작해서 두 번째 발견하는 'p'를 찾아 index 번호 리턴)
from dual;

select instr('apple','p',2,2)
from dual;--3

select instr('apple','p',3,1)
from dual;--3

select instr('apple','p',3,2)
from dual;--0 : 찾는 문자가 없다.(※자바에서는 -1을 돌려줌)

select instr('apple','pl',1,1)
from dual;--3

--영어는 무조건 1글자에 1byte, 그러나 한글은 인코딩방식에 따라 달라짐
--'바나나'에서 '나'문자가 1부터 시작해서 1번째 발견되는 '나'를 찾아 위치(index번호)=?
select instr('바나나','나'), instr('바나나','나',1,1),--2 2
	   instrB('바나나','나'), instrB('바나나','나',1,1)--4 4
from dual;

--'바나나'에서 '나'문자가 2부터 시작해서 2번째 발견되는 '나'를 찾아 위치(index번호)=?
select instr('바나나','나',2,2),--3
	   instrB('바나나','나',2,2)--7
from dual;

--이름의 세번째 글자가 'R'인 사원의 정보 검색
--[방법-1]
select *
from employee
where ename like '__R%';

--[방법-2]
select *
from employee
where substr(ename,3,1) = 'R';
--where lower(substr(ename,3,1)) = 'r';

select *
from employee
where substr(ename,1,3) like '__R';

--[방법-3]
select *
from employee
where instr(ename,'R',3,1) = 3;


--LPAD(Left Padding) : '컬럼'이나 대상 문자열을 명시된 자릿수에서 오른쪽에 나타내고
--남은 왼쪽은 특정 기호로 채움

--10자리를 마련 후 salary는 오른쪽, 남은 왼쪽자리를 '*'로 채움
select salary, lpad(salary, 10, '*')
from employee;

select salary, lpad(salary, 10, ' ')--' '로 채움
from employee;

--10자리를 마련 후 salary는 왼쪽, 남은 오른쪽자리를 '*'로 채움
select salary, rpad(salary, 10, '*')
from employee;

--LTRIM('	문자열') : 문자열의 '왼쪽'공백 제거
--RTRIM('문자열	') : 문자열의 '오른쪽'공백 제거
-- TRIM('	문자열	') : 문자열의 '양쪽'공백 제거
select '   사과매니아  '||'입니다.',
LTRIM('  사과매니아  ')||'입니다.',
RTRIM('  사과매니아  ')||'입니다.',
 TRIM('  사과매니아  ')||'입니다.'
from dual;

--TRIM('특정문자1개만' from 컬럼이나 '대상문자열')
--컬럼이나 '대상문자열'에서 '특정문자'가 '첫 번째 글자'이거나 '마지막 글자'이면 잘라내고
--남은 문자열만 결과로 반환(=리턴=돌려준다)
select TRIM('사과' from '사과매니아')
from dual;/*오류 메세지 : trim set should have only one character*/

select TRIM('사' from '사과매니아')
from dual;--'과매니아'

select TRIM('아' from '사과매니아')
from dual;--'사과매니'

select TRIM('과' from '사과매니아')
from dual;--'사과매니아' : '과'가 처음이나 마지막 글자가 아니므로 잘라내지 못해 '사과매니아'그대로 리턴됨


/************* <숫자함수>-북스 114p~*******************************/

-- -2(백)	-1(십)	0(일) . 1	2	3




--1. round(대상, 화면에 표시되는 자릿수) : 반올림
--단, 자릿수 생략하면 0으로 간주
select 98.7654,
round(98.7654),	  --99
round(98.7654, 0),--99 	  	일의 자리까지 표시. 소수 1째자리에서 반올림하여
round(98.7654, 2),--98.77 소수 2째자리까지 표시. 소수 3째자리에서 반올림하여
round(98.7654, -1)--100		십의 자리까지 표시. 일의 자리에서 반올림하여
from dual;

--2. trunc(대상, 화면에 표시되는 자릿수) : '화면에 표시되는 자릿수'까지 남기고 나머지 버림
--단, 자릿수 생략하면 0으로 간주

select 98.7654,
trunc(98.7654),	  --98
trunc(98.7654, 0),--98 	  	일의 자리까지 표시. 
trunc(98.7654, 2),--98.76 소수 2째자리까지 표시. 
trunc(98.7654, -1)--90		십의 자리까지 표시. 
from dual;

--3. mod(수1,수2) : 수1을 수2로 나눈 나머지
select MOD(10,3)
from dual;

--사원이름, 급여, 급여를 500으로 나눈 나머지 출력
select ename, salary, mod(salary,500)
from employee;

/********* <날짜함수>-북스 117p~ *********************************/
--1. sysdate : 시스템으로부터 오늘의 날짜와 시간을 반환 (★주의 : 뒤에 괄호() 없음)
--(※Mysql에서는 now())
select sysdate from dual;

-- date + 수 = 날짜에서 수만큼 '지난 날짜'
-- date - 수 = 날짜에서 수만큼 '이전 날짜'
-- date - date = 일수
-- date + 수/24 = 날짜 + 시간

select sysdate-1 as 어제,
sysdate 오늘,
sysdate+1 as "내 일"
from dual;

--[문제]사원들의 현재까지의 근무일수 구하기(단, 실수이면 반올림하여 일의 자리까지 표시)
select hiredate from employee;
--근무일수=현재날짜-입사일
select '2022/06/14'-'2022/06/13' as "근무일수"
from dual;--오류 : 문자로 인식되어 연산 안됨
--그래서, '문자'를 to_date('문자')로 날짜로 변경
select to_date('2022-06-14')-to_date('2022/06/13') as "근무일수"
from dual;--1(정수)

--[순서-1]
select sysdate, hiredate, sysdate-hiredate as 근무일수--실수
from employee;

--[순서-2]
select sysdate, hiredate, sysdate-hiredate as "근무일수(실수)",
round(sysdate-hiredate,0) as"근무일수(정수)", --반올림
trunc(sysdate-hiredate,0) as"근무일수(정수)" --버림
from employee;

--입사일에서 '월을 기준'으로 잘라내려면('월까지 표시', 나머지 버림)
select hiredate,
trunc(hiredate,'month')--일은 01로 초기화, 시간은 0으로 초기화
from employee;

select sysdate,
trunc(sysdate, 'year'),--'년까지 표시'하고 나머지 잘림
trunc(sysdate, 'month'),--'월까지 표시'하고 나머지 잘림
trunc(sysdate, 'day'),--※요일 초기화(해당 날짜에서 그 주의 지나간 일요일로 초기화)

trunc(sysdate),		-- '일까지 표시'하고 시간 잘림
trunc(sysdate, 'dd'),-- '일까지 표시'하고 시간 잘림(윗줄과 동일 결과)
trunc(sysdate, 'hh24'),--'시까지 표시'하고 분과 초 잘림
trunc(sysdate, 'mi')  --'분까지 표시'하고 초 잘림
from dual;

SELECT
TO_CHAR(SYSDATE ,'yyyy/mm/dd'), --오늘 날짜
TO_CHAR(SYSDATE + 1 ,'yyyy/mm/dd'), --내일 날짜
TO_CHAR(SYSDATE -1 ,'yyyy/mm/dd'), --어제 날짜
TO_CHAR(TRUNC(SYSDATE,'dd') ,'yyyy/mm/dd hh24:mi:ss'), -- 오늘 정각 날짜
TO_CHAR(TRUNC(SYSDATE,'dd') + 1,'yyyy/mm/dd hh24:mi:ss'), -- 내일 정각 날짜
TO_CHAR(SYSDATE + 1/24/60/60 ,'yyyy/mm/dd hh24:mi:ss'), -- 1초 뒤 시간
TO_CHAR(SYSDATE + 1/24/60 ,'yyyy/mm/dd hh24:mi:ss'), -- 1분 뒤 시간
TO_CHAR(SYSDATE + 1/24 ,'yyyy/mm/dd hh24:mi:ss'), -- 1일 뒤 시간
TO_CHAR(TRUNC(SYSDATE,'mm') ,'yyyy/mm/dd'), --이번 달 시작날짜
TO_CHAR(LAST_DAY(SYSDATE) ,'yyyy/mm/dd'), --이번 달 마지막 날
TO_CHAR(trunc(ADD_MONTHS(SYSDATE, + 1),'mm') ,'yyyy/mm/dd'), --다음 달 시작날짜
TO_CHAR(ADD_MONTHS(SYSDATE, 1) ,'yyyy/mm/dd hh24:mi:ss'), -- 다음달 오늘 날자
TO_CHAR(TRUNC(SYSDATE, 'yyyy') ,'yyyy/mm/dd'), --올해 시작 일
TO_CHAR(TRUNC(ADD_MONTHS(SYSDATE, -12), 'dd'),'yyyy/mm/dd'), --작년 현재 일
TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')) - TO_DATE('19930315'), -- 두 날짜 사이 일수 계산
MONTHS_BETWEEN(SYSDATE, '19930315'), -- 두 날짜 사이의 월수 계산
TRUNC(MONTHS_BETWEEN(SYSDATE, '19930315')/12,0) --두 날짜 사이의 년수 계산
FROM DUAL;

--2. monthS_between(날짜1, 날짜2) : 날짜1과 날짜2 사이에 개월 수 구하기
--※ 날짜1-날짜2=일수
select ename, sysdate, hiredate, 
sysdate-hiredate as "근무일수1",
--오늘날짜-입사일자=근무일수(결과가 실수?시간이 포함)
--그래서, to_char(수나 날짜, '형식') 문자로 변형 => 다시 date로 변형(모든 시간이 0으로 초기화)
-- 형식 생략해도 결과 같음
to_date(to_char(sysdate)),--그래서 형식 생략
to_date(to_char(hiredate,'yyyy-mm-dd')),
--[방법-1:권장]모든 시간이 0으로 초기화되어 => 결과가 정수
to_date(to_char(sysdate)) - to_date(to_char(hiredate,'yyyy-mm-dd')) as "days",

--[방법-2]모든 시간이 0으로 초기화되어 => 결과가 정수
to_date(to_char(sysdate, 'yyyy-mm-dd'),'yyyy-mm-dd') as "비교1",--2022-06-21 00:00:00.0 => 사용함
to_date(to_char(sysdate),'yyyy-mm-dd') as "비교2(사용X)",--0022-06-21 00:00:00.0 => 따라서, 이 방법 사용하지 말기

monthS_between(sysdate, hiredate) as "근무개월수",--실수(양수)
TRUNC(monthS_between(sysdate, hiredate),0) as "근무개월수",--정수(소수점 뒤 버림) 48.78 => 48
ROUND(monthS_between(sysdate, hiredate),0) as "근무개월수",--정수(반올림) 48.78 => 49
--★주의 : 날짜의 위치 
monthS_between(hiredate, sysdate) as "근무개월수",--실수(음수)
TRUNC(monthS_between(hiredate, sysdate)) as "근무개월수",--정수(소수점 뒤 버림)
ROUND(monthS_between(hiredate, sysdate)) as "근무개월수"--정수(반올림)
from employee;

--※참고------------------------------------------------------------------
--TO_CHAR(날짜,'형식')에 맞게 원하는 부분만 출력할 수 있다.
--입사일자를 '날짜와 관련된 형식'
select ename, hiredate,
to_char(hiredate, 'yyyy') as "년도만",
to_char(hiredate, 'mm') as "달만(01)",
to_char(hiredate, 'mon') as "달만(1월)",
to_char(hiredate, 'dd') as "일만(02)",
to_char(hiredate, 'day') as "요일만(월요일)",--월요일, 화요일, 수요일...일요일
to_char(hiredate, 'd') as "요일만(정수)",--1:일, 2:월, 3:화,...7:토
to_char(hiredate, 'dy') as "요일만(월)"
from employee;

--오늘날짜를 '시간과 관련된 형식'
select sysdate,
to_char(sysdate, 'hh24') as "시간만-24시간 기준",
to_char(sysdate, 'hh') as "시간만-12시간 기준",
to_char(sysdate, 'mi') as "분만",
to_char(sysdate, 'ss') as "초만"
from dual;

select to_char(sysdate, 'day') as "요일",
to_char(sysdate, 'd') as "요일만(정수)",
DECODE(to_char(sysdate, 'd'),1,'일요일',2,'월요일',3,'화요일',4,'수요일',5,'목요일',6,'금요일',7,'토요일') as "요일만"--1:일, 2:월, 3:화,...7:토
from dual;

select sysdate, 
to_char(sysdate,'yyyy-mm-dd'),--  2022-06-21
to_char(sysdate,'yyyy/mm/dd'),--  2022/06/21
to_char(sysdate,'yyyy#mm#dd'),--  2022#06#21
to_char(sysdate,'yyyy^mm^dd')--  2022^06^21
--to_char(sysdate,'yyyy년mm월dd일'),-- 오류: date format not recognized
from dual;

--※정리 : TO_DATE('날짜문자', '형식')에 관계없이 '년-월-일 00:00:00.0'로 출력해줌
select sysdate,
TO_DATE(to_char(sysdate)),-- ★★가장 간단한 방법(권장함) 2022-06-21 00:00:00.0
TO_DATE(to_char(sysdate,'yyyy-mm-dd')),-- 2022-06-21 00:00:00.0
TO_DATE(to_char(sysdate,'yyyy/mm/dd')),-- 2022-06-21 00:00:00.0 (/가 아니라 -로 바뀜)
TO_DATE(to_char(sysdate,'yyyy-mm-dd'), 'yyyy/mm/dd'),-- 2022-06-21 00:00:00.0
TO_DATE(to_char(sysdate,'yyyy/mm/dd'), 'yyyy-mm-dd') -- 2022-06-21 00:00:00.0
from dual;


--[문제]입사일자가 '수요일'인 사원의 이름과 입사일자, 요일 출력
select ename, hiredate, 
to_char(hiredate, 'day') as "입사한 날의 요일"
from employee
where to_char(hiredate, 'day')='수요일';


--3. add_monthS(날짜, 더할 개월수) : 특정 개월수를 더한 날짜
select ename, hiredate,
add_monthS(hiredate, 3), add_monthS(hiredate, -3)
from employee;

--4. next_day(날짜, '요일') : 해당날짜를 기준으로 최초로 도래하는 요일에 해당하는 날짜 반환
select sysdate,
next_day('2022-05-14','수요일'),
next_day(sysdate,'토요일'),
next_day(sysdate,7)--일요일(1), 월요일(2), 화요일(3) ...토요일(7)
from dual;

--5. last_day(날짜) : 해당날짜가 속한 달의 마지막 날짜를 반환
--대부분 달의 경우, 마지막 날이 정해져 있지만
--2월달은 마지막 날이 28 또는 29가 될 수 있으므로 '2월에 사용하면 효과적임'
select sysdate, last_day(sysdate)
from dual;

select ename, hiredate, last_day(hiredate)
from employee;

--6.날짜 또는 시간 차이 계산 방법
--(1)날짜 차이 : 종료일자(YYYY-MM-DD) - 시작일자(YYYY-MM-DD)
--(2)시간 차이 : (종료일시(YYYY-MM-DD HH:MI:SS) - 시작일시(YYYY-MM-DD HH:MI:SS)) * 24
--			  ex) (2022-06-21 02:20:27 - 2022-06-19 02:20:27) * 24 = 2*24 = 48시간
--(3)분 차이 : (종료일시(YYYY-MM-DD HH:MI:SS) - 시작일시(YYYY-MM-DD HH:MI:SS)) * 24*60
--			  ex) (2022-06-21 02:20:27 - 2022-06-19 02:20:27) * 24 = 2*24 = 48*60=2880분
--(4)초 차이 : (종료일시(YYYY-MM-DD HH:MI:SS) - 시작일시(YYYY-MM-DD HH:MI:SS)) * 24*60*60
--			  ex) (2022-06-21 02:20:27 - 2022-06-19 02:20:27) * 24 = 2*24 = 48*60*60=172800초
--※ '종료일자'-'시작일자' 빼면 차이 값이 '일 기준'의 수치값으로 변환된다.

--(1)날짜 차이-예시
--날짜 연산이 아님
select '20220621'-'20220620' --문자-문자 => number로 자동형변환(20220621-20220620=1)
from dual;--결과로 정수1

--날짜 차이 계산
select '2022-06-21'-'2022-06-21' ----문자-문자 => number로 자동형변환되지 않는 문자임
from dual;--오류 : invalid number

--해결법 : to_date(수나 문자, '형식')에 맞게 날짜로 형변환
--to_date(문자, '형식') : '문자'->'날짜'로 변환
--(예) 1800-01-01 => 1, 2022-06-21 => 10002일이 지남, 2022-06-19 => 10000일이 지남,
select to_date('2022-06-21','YYYY-MM-DD') - to_date('2022-06-19','YYYY-MM-DD')
from dual;--결과로 정수2

select to_date('2022-06-21') - to_date('2022-06-19')
from dual;--결과로 정수2

--to_date(수, '형식') : '수' ->'날짜'로 변환
select 20220621, to_date(20220621, 'YYYY-MM-DD'), to_date(20220621)
from dual;

--(2-1)시간 차이-예시
select to_date('15:00','HH24:MI')-to_date('13:00','HH24:MI') as "일",
(to_date('15:00','HH24:MI')-to_date('13:00','HH24:MI'))*24 as "시간"
from dual;--0.083333일*24 = 2시간

select to_date('2022-06-21 15:00','YYYY-MM-DD HH24:MI')-to_date('2022-06-19 13:00','YYYY-MM-DD HH24:MI') as "일",
(to_date('2022-06-21 15:00','YYYY-MM-DD HH24:MI')-to_date('2022-06-19 13:00','YYYY-MM-DD HH24:MI'))*24 as "시간(실수)",
ROUND((to_date('2022-06-21 15:00','YYYY-MM-DD HH24:MI')-to_date('2022-06-19 13:00','YYYY-MM-DD HH24:MI'))*24,0) as "시간(정수-반올림)"
from dual;--2.083333일*24= 49.9999....시간 => 50(소수 첫째자리에서 반올림해서 일의 자리까지 표시)

select (to_date('15:00:58','HH24:MI:SS')-to_date('13:00:40','HH24:MI:SS'))*24
from dual;--0.083541666일*24=2.005시간

--위 결과를 소수 2째자리까지 표시(소수 3째자리에서 '반올림'하여)
select round((to_date('15:00:58','HH24:MI:SS')-to_date('13:00:40','HH24:MI:SS'))*24,2)
from dual;--2.01시간

--(2-2)분 차이-예시
--위 결과를 분으로 변환(단, 일의 자리까지 표시-소수 첫째자리에서 '반올림'하여)
select round((to_date('15:00:58','HH24:MI:SS')-to_date('13:00:40','HH24:MI:SS'))*24*60,0)-- ,0 생략가능
from dual;--120분

--위 결과를 분으로 변환(소수점 절사)
select trunc((to_date('15:00:58','HH24:MI:SS')-to_date('13:00:40','HH24:MI:SS'))*24*60,0)-- ,0 생략가능
from dual;--120분

--(2-3)초 차이-예시(단, 일의 자리까지 표시-소수 첫째자리에서 '반올림'하여)
select round((to_date('15:00:58','HH24:MI:SS')-to_date('13:00:40','HH24:MI:SS'))*24*60*60,0)-- ,0 생략가능
from dual;--7218초


/********** <형변환함수>-북스 124p~ *******************************/
/*
 * 		 --TO_char(수)-->			<--TO_char(날짜)--
 * 	[수]						[문자]						[날짜]
 * 		<--TO_number('문자')--		--TO_date('문자')-->
 * 		----------------- To_date(수) ---------------->
 */
 
/* 1. TO_char(수나 '날짜', '형식') : 수나 '날짜'를 '형식'에 맞게 문자로 변환
 * 
 * <'날짜'와 관련된 형식>
 * YYYY : 연도 4자리, YY : 연도 2자리
 * MM : 월 2자리 수로(예)1월->01,	MON : 월을 '알파벳'으로
 * DD : 일 2자리 수로(예)2일->02,	  D : 요일을 정수로 표현(예)1:일
 * DAY : 요일 표현(예)월요일,		 DY : 요일을 약어로 표현(예)월
 * 
 * <'시간'과 관련된 형식>
 * AM 또는 PM			: 오전AM, 오후PM 시각 표시
 * A.M. 또는 P.M.		: 오전A.M., 오후P.M. 시각 표시
 * => 위 4가지 다 같은 결과 (12시 이전은 '오전' 출력됨, 12시 이후는 '오후' 출력됨)
 * => AM 또는 PM 또는 A.M. 또는 P.M. + HH 또는 HH12에 반드시 사용
 * 
 * HH 또는 HH12		: 시간(1~12시로 표현)
 * 
 * 		  HH24		: 24시간으로 표현(0~23)
 * 					  AM 또는 PM 또는 A.M. 또는 P.M. 사용 안해도 시간 충분히 전달됨
 * 
 * 		  MI		: 분
 * 		  SS		: 초
 */

--입사일자를 '날짜와 관련된 형식'
select ename, hiredate,
to_char(hiredate, 'yy-mm') as "2자리연도와 달",
to_char(hiredate, 'yyyy/mm/dd day dy') as "날짜와 요일",
to_char(hiredate, 'yyyy') as "년도만",
to_char(hiredate, 'mm') as "달만(01)",
to_char(hiredate, 'mon') as "달만(알파벳)",
to_char(hiredate, 'dd') as "일만(02)",
to_char(hiredate, 'day') as "요일만(월요일)",--월요일, 화요일, 수요일...일요일
to_char(hiredate, 'd') as "요일만(정수)",--1:일, 2:월, 3:화,...7:토
to_char(hiredate, 'dy') as "요일만(월)"
from employee;

--오늘날짜를 '시간과 관련된 형식'
select sysdate,
to_char(sysdate, 'YYYY/MM/DD DAY DY HH'),--HH 사용하지 말고(오전 오후 구분x)
to_char(sysdate, 'YYYY/MM/DD DAY DY AM HH'),--AM 또는 PM + hh
to_char(sysdate, 'YYYY/MM/DD DAY DY P.M. HH12'),
to_char(sysdate, 'YYYY/MM/DD DAY DY HH24:MI:SS'),--AM 또는 PM 생략가능 + hh24
to_char(sysdate, 'YYYY/MM/DD DAY DY A.M. HH24:MI:SS'),
to_char(sysdate, 'hh24') as "시간만-24시간 기준",
to_char(sysdate, 'hh') as "시간만-12시간 기준",
to_char(sysdate, 'mi') as "분만",
to_char(sysdate, 'ss') as "초만"
from dual;

/*
 * <'숫자'와 관련된 형식>
 * 0 : 자릿수를 나타내며 자릿수가 맞지 않을 경우 '0으로 채움'
 * 9 : 자릿수를 나타내며 자릿수가 맞지 않을 경우 '채우지 않음'
 * L : 각 지역별 통화기호를 앞에 표시 (예)대한민국 W (단, 달러는 직접 앞에 $붙여야 함)
 * . : 소수점 표시
 * , : 천 단위 자리 표시
 */
select ename, salary,
to_char(salary, 'L000,000'),
to_char(salary, 'L999,999'),
to_char(salary, 'L999,999.00'),
to_char(salary, 'L999,999.99')
from employee;

select
to_char(1234, 'L000,000'),
to_char(1234, 'L999,999'),
to_char(1234.5, 'L000,000.00'),
to_char(1234.5, 'L999,999.99')
from dual;

--<진수 변환>---------------------------------------------------------
--(1) 10진수 -> 16진수 '문자'(0~9 A~F)로 변환
--이 때, 'X' : 한 자리 문자로 표현(테스트 할 수 있는 수는 10진수 0~15)
select to_char(10, 'X'),--10진수 10인 수를 -> 16진수 문자로 변환
to_char(11, 'X'),
to_char(15, 'X'),
to_char(0, 'X')
from dual;

select
to_char(255,'X'),-- '##' : 자릿수가 부족
to_char(255,'XX')-- 'FF'
from dual;

--(2) 16진수 '문자'(0~9 A~F) -> 10진수로 변환
select
TO_NUMBER('A', 'X'),--16진수 A ->10진수 10으로 변환
TO_NUMBER('FF', 'XX')--16진수 FF ->10진수 255로 변환
from dual;

--2. TO_NUMBER('10진수 형태의 문자','형식') : '10진수 문자'를 수로 형변환
select
0123,--123
TO_NUMBER('0123'),--123
TO_NUMBER('0123.4')--123.4
from dual;

select
--TO_NUMBER('10,100'),--오류 : invalid number
TO_NUMBER('10,100','99999'),--10100
TO_NUMBER('10,100','99,999')--10100
from dual;

select 100000 - 50000
from dual;--50000

select 100,000 - 50,000
from dual;--100		-50		0

select '100000' - '50000'
from dual;--50000(why?'10진수 문자'는 수로 자동형변환 되어 연산됨)

select to_NUMBER('100000') - '50000'
from dual;--50000(강제형변환)

select '100000' - 50000
from dual;--50000(why?'10진수 문자'는 수로 자동형변환 되어 연산됨)

select '100,000' - '50,000'
from dual;--오류 : invalid number(why?'10진수 이외에 ,가 같이 있는 문자'이므로 수로 자동형변환 안됨)
--[오류 해결법]
--[방법-1] 천단위 구분쉼표
select TO_number('100,000','999,999') - To_number('50,000', '999,999')
from dual;--결과 50000
--[방법-2] 천단위 구분쉼표 생략
select TO_number('100,000','999999') - To_number('50,000', '999999')
from dual;--결과 50000


/**
 * 대부분 사용하는 TO_NUMBER('10진수 형태의 문자')의 용도는
 * 단순히 '10진수 형태의 문자'를 숫자로 변환하는데 사용됨
 */
select
to_number('0123'),--123
to_number('12.34')--12.34
from dual;

select
to_number('0123'),
to_number('12.34'),
to_number('가')--오류 : invalid SQL statement
from dual;
/*
 * ※ 참고 : JAVA에서 "문자열"->수로 변환
 * int num1 = Integer.parseInt("0123"); //123
 * int num1 = Integer.parseInt("가"); //예외 발생->프로그램이 종료
 * 
 * double num3 = Double.parseDouble("12.34");
 * double num3 = Double.parseDouble("ab");//예외 발생->프로그램이 종료
 */

/*-------------------------------------------------------------------
 * 3.to_DATE(수나 '문자', '형식') : 수나 '문자'를 날짜형으로 변환
 */
--비교연산자로 비교하려면 같은 타입이어야 함
select ename, hiredate
from employee
where hiredate = 19810220;--오류 :inconsistent datatypes: expected DATE got NUMBER
--그래서 to_date()함수로 수를 날짜로 형변환하여 해결
select ename, hiredate, to_date(19810220,'yyyymmdd')
from employee
where hiredate = to_date(19810220,'yyyymmdd');

select ename, hiredate, to_date(19810220,'yyyy-mm-dd')
from employee
where hiredate = to_date(19810220,'yyyy-mm-dd');

select ename, hiredate, to_date(19810220,'yyyy/mm/dd')
from employee
where hiredate = to_date(19810220,'yyyy/mm/dd');

select ename, hiredate, to_date(19810220,'yyyy#mm#dd')
from employee
where hiredate = to_date(19810220,'yyyy#mm#dd');

select ename, hiredate, to_date(19810220,'yyyy년mm월dd일')
from employee
where hiredate = to_date(19810220,'yyyy년mm월dd일');--오류 : data format not recognized

/********* <일반함수>-북스 130p~ *************************************/
/*
 * null은 연산과 비교를 하지 못함
 * 
 * ★★ null 처리하는 함수들
 * 1. NVL(값1, 값2) : 값1이 null이 아니면 값1 그대로 사용,
 * 					 값1이 null이면 값2로 대체
 * 		※ 주의 : 값1과 값2는 반드시 데이터 타입이 일치해야함
 * 			ex) NVL(hiredate, '2022/06/24') : 둘 다 date타입으로 일치해야함
 * 				NVL(job, 'MANAGER') : 둘 다 문자타입으로 일치
 * 
 * 2. NVL2(값1, 값2, 값3) :
 * 		 (값1, 값1이 null이 아니면 값2, 값1이 null이면 값3)
 * =>1과 차이점 : null이 아닐 때 대체할 값을 정할 수 있다.
 * 
 * 3. nullif(값1, 값2) : 두 값이 같으면 null, 다르면 '첫번째 값1'을 반환.
 */

select ename, salary, commission,
salary*12 + NVL(commission, 0) as "연봉1",
salary*12 + NVL2(commission, commission, 0) as "연봉2",
NVL2(commission, salary*12+commission, salary*12) as "연봉3"
from employee;

select ename, salary, commission,
TO_CHAR(salary*12 + NVL(commission, 0), 'L999,999,999') as "연봉1",
TO_CHAR(salary*12 + NVL2(commission, commission, 0), 'L999,999,999') as "연봉2",
TO_CHAR(NVL2(commission, salary*12+commission, salary*12), 'L999,999,999') as "연봉3"
from employee;

select nullif('A','A'), nullif('A','B')
from dual;

--4. coalesce(인수, 인수, 인수....)
/*
 * 사원테이블에서 커미션이 null이 아니면 커미션을 출력,
 * 			  커미션이 null이면 급여(=salary)가 null이 아니면 급여를 출력,
 * 			  커미션과 급여 모두 null이면 0 출력
 */

select ename, salary, commission,
coalesce(commission, salary, 0)
from employee;

/*
 * java에서는
 * if(commission != null) commission출력
 * else if(salary != null) salary출력
 * else 0출력 
 * 
 */

--[문제] 사원테이블로부터 부서번호를 이용해 부서이름을 오름차순 정렬하여 출력 : 
--사원테이블에는 부서번호가 있고 부서이름은 없다.
--[방법-1] decode()함수 사용
/* 5. decode() : switch~case문 ★☆ 많이 사용하는 함수
 * switch(dno){ //비교연산자 중 == 같다 이용
 * case 10 : 'ACCOUNTING'출력; break;
 * case 20 : 'RESEARCH'출력; break;
 * case 30 : 'SALES'출력; break;
 * Case 40 : 'OPERATIONS'출력; break;
 * default : '기본' 출력; //break;
 * }
 */

select ename, dno,
DECODE(dno, 10, 'ACCOUNTING',
			20, 'RESEARCH',
			30, 'SALES',
			40, 'OPERATIONS', 
			'기본') as dname
from employee
order by dno asc;

--[방법-2] case~end; 사용 (자바의 if~else if~...else문과 비슷)
--※ 주의 : case~end 사이에 , 없음
--decode()함수에서 사용하지 못하는 비교연산자 중 =(같다) 제외한 나머지 비교연산자(>=, <=. >, <, !=)를 쓰고싶을 때 사용.

select ename, dno,
CASE when dno=10 then 'ACCOUNTING'
	 when dno=20 then 'RESEARCH'
	 when dno=30 then 'SALES'
	 when dno=40 then 'OPERATIONS'
	 else '기본' 
END as dname
from employee
order by dno asc;

--[방법-3] : 두 테이블을 합쳐서(=join) 하나의 테이블로 만든 다음 출력
--사원테이블과 부서테이블에는 둘 다 '부서번호'가 있다.
--사원테이블에는 '부서번호'만 있고 부서테이블에는 '부서번호와 부서이름'이 있다.
--[순서-1]
select *
from employee e JOIN DEPARTMENT d
ON e.dno=d.dno;--조인 조건

--[순서-2]
select ename, e.dno, dname
from employee e JOIN DEPARTMENT d
ON e.dno=d.dno
order by dno asc;

---------------------------------------------------------------------------
--[교재없는 내용]
/*
 * 자동 형변환
 */
select '100'+200
from dual;--300(결과 이유? 문자'100'이 수 100으로 자동형변환 되어 연산)

--문자 연결
select concat(100, '200')--100200(결과 이유? 수100이 문자'100'으로 자동형변환되어 연결됨)
from dual;

--문자 여러 개 연결
select 100 || '200' || '300' || '400'
from dual;

select ename
from employee
where eno = '7369';--'eno가 number(4)'이므로 문자 '7369'를 number로 자동형변환 후 비교연산자로 비교함

select ename
from employee
where eno = CAST('7369' AS number(4));--강제 형변환
--많이 사용하지는 않지만, cast함수를 사용하면 타입이 맞지않아 발생하는 에러를 방지할 수 있다.

/*
 * cast() : 데이터 형식 변환 함수
 * 			데이터 형식을 실시간으로 변환하는데 사용됨
 */
select AVG(salary) as "평균 월급"
from employee;--결과가 실수 2073.2142...

--1.1 실수로 나온 결과를 '전체 자릿수 6자리 중 소수점 이하 2자리까지 표현(3째 자리에서 반올림)'
select cast(AVG(salary) AS number(6,2)) as "평균 월급"
from employee;--2073.21

select round(AVG(salary),2) as "평균 월급"
from employee;--2073.21

--데이터 형식을 실시간으로 변환(예)
select CAST(ename AS char(20)),
		length(ename),
		length(CAST(ename AS char(20)))
from employee;
--RUN SQL command Line
--desc employee;
--결과 : ename의 데이터 형식은 변하지 않고 원래 테이블 생성할 때의 데이터 형식 그대로임 (주의)

--1.2 실수로 나온 결과를 '정수로 보기 위해서'
select cast(AVG(salary) AS number(6)) as "평균 월급"
from employee;--2073 (만약 2073.8142... 라면 =>2074로 결과가 달라짐)

select cast(AVG(salary) AS number(6)) as "평균 월급"
from employee;--2073(자바에서 (int)2073.2142...=>2073)

--테스트 : 사원번호 7369의 급여를 800으로 수정
update employee --update 테이블명(★주의 : from 없음)
set salary=800 --set 컬럼명=변경할 값
where eno=7369; --where 조건;

select salary
from employee
where eno=7369;

--2. 다양한 구분자를 날짜 형식으로 변경 가능(예)날짜:'2022-06-27', '2022/06/27'
select CAST('2022$06$27' AS date ) from dual;
select CAST('2022%06%27' AS date ) from dual;
select CAST('2022#06#27' AS date ) from dual;
select CAST('2022@06@27' AS date ) from dual;

--3. 쿼리의 결과를 보기 좋도록 처리할 때
select nvl(salary,0) + nvl(commission,0) as "통합"
from employee;

select CAST(nvl(salary,0) AS CHAR(7)) || '+'
|| CAST(nvl(commission,0) AS CHAR(7)) || '=' as "월급+커미션",
NVL(salary,0) + NVL(commission,0) as "통합"
from employee;

--<4장 다양한 함수-혼자해보기>----------------------------------------------
/*
 * 1.SUBSTR 함수를 사용하여 사원들의 입사한 년도와 입사한 달만 출력하시오.
 */
--[방법-1]
select hiredate,
substr(hiredate,1,2) as "입사 년도",
substr (hiredate,4,2) as "입사 달"
from employee;--저장된 날짜 기본 형식(YY/MM/DD)

--[방법-2]
select hiredate,
substr(to_char(hiredate,'yyyy/mm/dd'),1,4) 년도,
substr(to_char(hiredate,'yyyy/mm/dd'),6,2) 달
from employee; 


/*
 * 2.SUBSTR 함수를 사용하여 4월에 입사한 사원을 출력하시오.
 */
--[방법-1]
select *
from employee
where substr(hiredate,4,2) = '04';

--[방법-2]
select *
from employee
where substr(to_char(hiredate,'mm'),1,2) = '04';--지정된 날짜 형식을 변경 '월만'

--[방법-3]
select *
from employee
where substr(to_char(hiredate,'yyyy-mm-dd'),6,2) = '04';

--[방법-4]
select *
from employee
where substr(hiredate, INSTR(hiredate, '04', 4, 1), 2) = '04';

/*
 * 3. MOD 함수를 사용하여 사원번호가 짝수인 사람만 출력
 */
select *
from employee
where MOD(eno,2) = 0;--eno를 2로 나눈 나머지가 0과 같으면 참

/*
 * 4. 입사일을 연도는 2자리(YY), 월은 숫자(MON)로 표시하고 요일은 약어(DY)로 지정하여 출력
 */
select hiredate, to_char(hiredate, 'yy/mm/dd dy')
from employee;--81/11/23 수

select hiredate, to_char(hiredate, 'yy/mon/dd day')
from employee;--81/11월/23 수요일

/*
 * 5. 올해 며칠이 지났는지 출력
 * 현재 날짜에서 올해 1월 1일을 뺀 결과를 출력하고 TO_DATE 함수를 사용하여
 * 데이터 형을 일치
 */
--TO_CHAR('문자')
select sysdate - '2022/01/01'
from dual;--오류:invalid number(날짜형식-문자형식) => 데이터 형식이 일치하지 않아서

select sysdate - to_date('2022/01/01')
from dual;--177.66456...일

--다시 정수로 출력하기 위해
select TRUNC(sysdate - to_date('2022/01/01'))
from dual;--177일

--TO_CHAR(수)
select sysdate - 20220101
from dual;--오류

select sysdate - to_date(20220101)
from dual;--177.66456일

select sysdate - to_date(20220101, 'YYYY/MM/DD')
from dual;--177.66456...일

--다시 정수로 출력하기 위해
select TRUNC(sysdate - to_date(20220101))
from dual;--177일


/*
 * 6. 사원들의 상관 사번을 출력하되 상관이 없는 사원에 대해서는 NULL값 대신 0으로 출력
 */
select eno, ename,
NVL(manager,0) as "상관 사번"--NVL2(manager, manager, 0)
from employee;

/*
 * 7. decode 함수로 직급에 따라 급여를 인상
 * 직급이 'ANALYST'인 사원은 200, 'SALESMAN'인 사원은 180, 'MANAGER'인 사원은 150, 'CLERK'인 사원은 100 인상
 */
select ename, job, salary as "원래 급여",
decode(job, 'ANALYST', salary+200,
			'SALESMAN', salary+180,
			'MANAGER', salary+150,
			'CLERK', salary+100,
			 salary) as "인상된 급여"
from employee;

