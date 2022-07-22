--<북스 2장.데이터 조회하기>
--이름이 SCOTT 사원의 정보 출력
select *
from employee
where ename='SCOTT';--where 조건문이 참

select *
from employee
where ename='scott';--결과없음(문자값은 대소문자 구분함)

select *
from employee
where lower(ename)='scott';

select *
from employee
where ename=upper('scott');

--'1981년 1월 1일 이전에 입사'한 사원의 정보만 출력
select *
from employee
where hiredate<'1981/01/01';--(sql 무조건 문자는 '문자1개','문자여러개'	※자바: '문자1개',"문자여러개")

--<논리 연산자 NOT-> AND-> OR : 결과가 참 또는 거짓 ※자바 !-> &&-> ||>---------------------------------------------------------
--10번 부서 소속인 사원들 중에서 직급이 MANAGER인 사원 정보 검색
select * from employee;

select * 
from employee
where dno=10 and job='MANAGER';--둘 다 참이면 참

--10번 부서 소속이거나 직급이 MANAGER인 사원 정보 검색
select * 
from employee
where dno=10 OR job='MANAGER';--둘 중 하나만 참이면 참

--10번 부서에 소속된 사원만 제외
select * 
from employee
where NOT dno = 10;/*논리연산자 NOT 참 => 거짓,	NOT 거짓 => 참 */

select * 
from employee
where dno != 10;/*비교연산자 sql 같지않다. != , <>, ^=	자바에서도 같지 않다. != */

--<비교 연산자 : 45p 표 참조>----------------------------
/*
 * = 같다
 * != <> ^= 같지않다
 * > 보다 크다 :초과
 * < 보다 작다 :미만
 * >= 보다 크거나 같다:이상
 * <= 보다 작거나 같다:이하
 */

--급여가 1100인 사원의 정보 출력
select *
from employee
where salary=1100;

--급여가 1300인 사원의 정보 출력
select *
from employee
where salary=1300;

--급여가 1000~1500 사이인 사원의 정보 출력
select *
from employee
where 1000<=salary AND salary<=1500;

select *
from employee
where salary between 1000 and 1500;

--급여가 1000미만이거나 1500초과인 사원의 정보 출력
select *
from employee
where salary<1000 or salary>1500;

select *
from employee
where salary NOT between 1000 and 1500;

--'1982년'에 입사한 사원의 정보 출력
--방법-1 : '1982-01-01' '1982/01/01' 둘 다 날짜로 인식
select *
from employee
where '1982-01-01'<=hiredate and hiredate<='1982-12-31';

--방법-2
select *
from employee
where hiredate between '1982/01/01' and '1982/12/31';

--방법-3 : '82-01-01'  '82/01/01' 둘 다 19제외해도 1982년으로 인식됨
select *
from employee
where hiredate between '82/01/01' and '82/12/31';

--커미션이 300이거나 500이거나 1400인 사원 정보 검색(조회)
select *
from employee
where commission=300 or commission=500 or commission=1400;

select *
from employee
where commission IN(300, 500, 1400);--컬럼명 IN(수, 수, 수...)

--커미션이 300, 500, 1400이 모두 아닌 사원 정보 검색
--커미션이 null인 사원은 제외됨(null은 비교연산자로 비교 불가능함)
select *
from employee
where NOT(commission=300 or commission=500 or commission=1400);

select *
from employee
where commission != 300 AND commission <> 500 AND commission ^= 1400;

select *
from employee
where commission NOT IN(300, 500, 1400);

------------------------------------------------------------------
--와일드 카드 : %
--이름이 'F로 시작'하는 사원의 정보 출력
select *
from employee
where ename LIKE 'F%';
--%:문자가 없거나 하나 이상의 문자가 어떤 값이 와도 상관 없다. ex)'F', 'Fs', 'FVB글' 

--이름에 'M이 포함'된 사원의 정보 출력
select *
from employee
where ename LIKE '%M%';--ex)'M', 'aM', 'MB', 'AMb'

--이름이 'M으로 끝나는' 사원의 정보 출력
select *
from employee
where ename LIKE '%M';--ex)'M', 'aM', 'aaaM'

--이름의 '두번째 글자가 A'인 사원의 정보 검색
select *
from employee
where ename LIKE '_A%';--_:하나의 문자가 어떤 값이 와도 상관 없다.

--이름의 '세번째 글자가 A'인 사원의 정보 검색
select *
from employee
where ename LIKE '__A%';

--이름에 'A가 포함'된 사원의 정보 출력
select *
from employee
where ename LIKE '%A%';

--이름에 'A가 포함되지 않은' 사원의 정보 검색
select *
from employee
where ename NOT LIKE '%A%';

-------------------------------------------------------------

select * from employee;

--commission을 받지 못하는 사원 정보 검색
select *
from employee
where commission = NULL;--null은 비교연산자로 비교불가하므로 참이 되는 결과가 없음

select *
from employee
where commission IS NULL;

--commission을 받는 사원 정보 검색
select *
from employee
where commission IS NOT NULL;

---------------------------------------------------------------
--정렬 : ASC 오름차순(ASC 생략가능),	DESC 내림차순

--급여가 적은 순부터 출력
select *
from employee
ORDER BY salary asc;

--급여가 적은 순부터 출력(이 때, 급여가 같으면 commission이 많은 순부터 출력)
select *
from employee
ORDER BY salary asc, commission desc;

--급여가 적은 순부터 출력(이 때, 급여가 같으면 commission이 많은 순부터, commission이 같으면 이름을 알파벳순으로 출력)
select *
from employee
--ORDER BY salary asc, commission desc, ename asc;
--ORDER BY salary, commission desc, ename;
--ORDER BY 6 asc, 7 desc, 2 asc;--index 번호:sql은 1부터 시작, 자바는 0부터 시작
ORDER BY 6, 7 desc, 2;

--입사일을 중심으로 오름차순 정렬
select *
from employee
--ORDER BY hiredate asc;
ORDER BY 5;

--사원번호, 사원명, 입사일 출력(입사일을 중심으로 오름차순 정렬)
select eno, ename, hiredate
from employee
--ORDER BY 3;
ORDER BY hiredate asc;
------------------------------------------------------------------
/*
 *2장 혼자 해보기(65~72p)
 */

select * from employee;

--1.덧셈 연산자를 이용하여 모든 사원에 대해서 300의 급여인상을 계산한 후 
--사원의 이름, 급여, 인상된 급여 출력
select ename, salary, salary+300
from employee;--내가푼거

select ENAME, SALARY, SALARY+300 as "300이 인상된 급여"
from employee;


--2.사원의 이름,급여,연간 총수입을 총 수입이 많은 것부터 작은 순으로 출력
--연간 총수입=월급*12+상여금100
select ename, salary, salary*2+100 "연간 총수입"
from EMPLOYEE
ORDER BY salary*2+100 desc;--내가푼거

select ENAME, SALARY, SALARY*12+100 as "연간 총수입"
from employee
ORDER BY "연간 총수입" desc;--내림차순 정렬
--order by 3 desc;--내림차순 정렬

--3.'급여가 2000을 넘는' 사원의 이름과 급여를 '급여가 많은 것부터 작은 순'으로 출력
select ename, salary
from employee
where salary>2000
ORDER BY 2 desc;--내가푼거

select ename, salary
from employee
where salary>2000
order by salary desc;

--4.사원번호가 7788인 사원의 이름과 부서번호를 출력
select ename, dno
from employee
where eno=7788;--내가푼거

select ename, dno
from employee
where eno=7788;

--5.급여가 2000에서 3000 사이에 포함되지 않는 사원의 이름과 급여 출력
select ename, salary
from employee
where salary NOT BETWEEN 2000 and 3000;--내가푼거

select ename, salary
from employee
where salary < 2000 or salary > 3000; --방법 1

select ename, salary
from employee
where salary NOT between 2000 and 3000; --방법 2

--주의 : 우선순위 NOT -> AND -> OR (자바 ! -> && -> ||)
--우선순위를 바꾸는 방법은 ()괄호
select ename, salary
from employee
where NOT (2000 <= salary and salary <= 3000);--9

select ename, salary
from employee
where NOT 2000 <= salary and salary <= 3000;--8:괄호 빼면 결과가 다름

--5-2. 급여가 2000에서 3000 사이에 포함되는 사원의 이름과 급여 출력
select ename, salary
from employee
where salary BETWEEN 2000 and 3000;--내가푼거

select ename, salary
from employee
where 2000 <= salary and salary <= 3000;

--주의 : 우선순위 NOT -> AND -> OR (자바 ! -> && -> ||)
--우선순위를 바꾸는 방법은 ()괄호
select ename, salary
from employee
where 2000 NOT(2000 > salary or salary > 3000);

--6.1981년 2월 20일부터 1981년 5월 1일 사이에 입사한 사원의 이름, 담당업무, 입사일 출력
--오라클의 기본날짜 형식은 'YY/MM/DD'
select ename, job, hiredate
from employee
where '1981-02-20'<=hiredate and hiredate<='1981/05/01';--내가푼거

select ename, job, hiredate
from employee
where hiredate between '81/02/20' and '81/05/01';

select ename, job, hiredate
from employee
where hiredate between '1981-02-20' and '1981-05-01';

--7.부서번호가 20 및 30에 속한 사원의 이름과 부서번호를 출력하되 
--이름을 기준으로 영문자순으로 출력
select ename, dno
from employee
where dno=20 or dno=30
ORDER BY ename;--내가푼거
--order by 1;

select ename, dno
from employee
where dno IN(20,30)
ORDER BY 1;

--8.'사원의 급여가 2000에서 3000사이에 포함'되고 '부서번호가 20 또는 30'인 사원의 이름, 급여와 부서번호를 출력하되 
--이름순(오름차순)으로 출력
select ename, salary, dno
from employee
where salary BETWEEN 2000 and 3000 and dno=20 or dno=30--우선순위 not->and->or
ORDER BY ename;--내가푼거 --잘못된 결과 나옴
--★★해결법: 괄호로 우선순위 변경
select ename, salary, dno
from employee
where salary BETWEEN 2000 and 3000 and (dno=20 or dno=30)
ORDER BY ename;

--[방법-2]
select ename, salary, dno
from employee
where salary BETWEEN 2000 and 3000 and dno IN(20,30)
ORDER BY ename asc;


--9. 1981년도에 입사한 사원의 이름과 입사일 출력(like연산자와 와일드카드(% _) 사용)
--[방법-1]
select ename, hiredate --오라클의 기본날짜 형식은 'YY/MM/DD'
from employee
where hiredate LIKE '81%'; --'1981%' 결과 없음

--[방법-2] : to_char(수나 날짜, '형식')
select ename, hiredate
from employee
where TO_CHAR(hiredate,'yyyy') LIKE '1981%';--'1981', '1981시작'
--where TO_CHAR(hiredate,'yyyy') LIKE '1981';--'1981'

--[방법-3] 
select ename, hiredate
from employee
where TO_CHAR(hiredate,'yyyy-mm-dd') LIKE '1981%';--'1981', '1981시작' (정확한 결과)
--where TO_CHAR(hiredate,'yyyy-mm-dd') LIKE '1981';--'1981' (결과가 없음)

select hiredate, --년-월-일 시:분:초
to_char(hiredate, 'yyyy/mm/dd'),--년/월/일
to_char(hiredate, 'yyyy')--년
from employee;

--10.관리자(=상사)가 없는 사원의 이름과 담당업무
select ename, job
from employee
where manager IS NULL;--내가푼거


--11.'커미션을 받을 수 있는 자격'이 되는 사원의 이름, 급여, 커미션을 출력하되
--급여 및 커미션을 기준으로 내림차순 정렬
--[방법1]
select ename, salary, commission
from employee
where commission IS NOT null
ORDER BY salary desc, commission desc;--내가푼거

--[방법2]
select ename, salary, commission
from employee
where job = 'SALESMAN'
ORDER BY 2 desc, 3 desc;


--12.이름의 세번째 문자가 R인 사원의 이름 표시
select ename
from employee
where ename like '__R%';--내가푼거



--13.이름에 A와 E를 모두 포함하고 있는 사원이름 표시
select ename
from employee
where ename like '%A%E%';--내가푼거

select ename
from employee
where ename like '%A%' And ename like '%E%';

--14.'담당 업무가 사무원(CLERK) 또는 영업사원(SALESMAN)'이면서 
--'급여가 1600,950 또는 1300이 아닌' 사원이름, 담당업무, 급여 출력
--[방법1]
select ename, job, salary
from employee
where (job='CLERK' or job='SALESMAN')
and (salary != 1600 and salary ^= 950 and salary <> 1300);--내가푼거

--[방법2]
select ename, job, salary
from employee
where (job='CLERK' or job='SALESMAN')
and salary NOT IN(1600, 950, 1300);

--[방법3]
select ename, job, salary
from employee
where job IN('CLERK','SALESMAN')
and salary NOT IN(1600, 950, 1300);

--15.'커미션이 500이상'인 사원이름과 급여, 커미션 출력
select ename, salary, commission
from employee
where commission>=500;--내가푼거



