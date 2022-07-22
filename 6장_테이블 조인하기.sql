--<북스-6장. 테이블 조인하기>
--1조인
--1.1 카디시안 곱(=곱집합) : (구방식, ) (현방식 cross join)- 조건이 없다.
select * from EMPLOYEE; --컬럼수:8, 행수 :14 
select * from DEPARTMENT;--컬럼수:3개 행수:4


select * --컬럼수:11 행수:56
from EMPLOYEE,DEPARTMENT;
--조인결과 : 컬럼수(11)=사원테이블의 컬럼수(8) + 부서테이블의 컬럼수(3)
--         행수:=사원테이블의 행수(14) * 부서테이블의 컬럼수(4)
--             =사원테이블의 사원 1명 당 * 부서테이블의 행수(4) 

select eno --eno 컬럼만, 56개 전체 행수 
from EMPLOYEE, DEPARTMENT;

select eno --eno 컬럼만, 56개 전체 행수 
from EMPLOYEE cross join DEPARTMENT;

select * --컬럼수:11,eno가7369 
from EMPLOYEE, DEPARTMENT
where eno = 7369;--(조인조건아님)검색조건

--1.2 조인의 유형
--오라클 8i이전 조인 : equi 조인(=등가 조인 같은거), non-equi 조인(=비등가 조인 같지않은거), outer조인(왼쪽, 오른쪽) , self 조인 
--오라클 9i이후 조인 : cross 조인, natural 조인(=자연 조인), join~using,  outer조인(왼쪽, 오른쪽, full까지)
--(※오라클 9i부터 ANSI 표준 SQL 조인 : 현재 대부분의 상용 데이터베이스 시스템에서  사용.
--                               다른 DBMS와 호환이 가능하기 때문에 ANSI 표준 조인에 대해서 확실히 학습하자.)

-------------------<아래 4가지 비교:내부조인(=inner join)>----------------------------------------------------
--[해결할 문제] '사원번호가 7788' 인 사원이 소속된 '사원번호,사원이름, 소속부서번호, 소속된부서이름'얻기  
--먼저, 사원번호, 사원이름, 소속부서번호,소속부서이름 의 컬럼들이 어느 테이블에 있는지 부터 파악
--사원번호, 사원이름, 소속부서번호(dno) =>사원테이블에 있음
--소속부서번호(dno2),소속부서이름 => 부서테이블에 있음

-- '소속부서번호'가 양 테이블에 존재하므로 등가 조인이 가능함
--2. equi 조인(=등가 조인=동일조인): 동일한 이름과 유형(=데이터 타입)를 가진 컬럼으로 조인
-- 단,[방법-1] , ~ where 과 [방법-2] join ~ on은 '데이터 타입만 같아도 조인'이 됨


--[방법-1] , ~ where-----------------------------------------------------------------------------------------
--동일한 이름과 데이터 유형을 가진 컬럼으로 조인 + "임이의 조건을 지정" 하거나 "조인할 컬럼을 지정" where절을 사용
--조인결과는 중복된 컬럼 제거x -> 따라서, 테이블에 '별칭 사용'해서 어느 테이블의 컬럼인지 구분해야된다
select 컬럼명1,컬럼명2.. -- 중복되는 컬럼은 반드시 '별칭.컬럼명'(예)e.dno d.dno  
from 테이블1 별칭1,테이블2 별칭2, .... --별칭사용(별칭 : 해당 SQL 명령문내에서만 유효함) 
where 조인조건(주의 : 테이블의 별칭 사용)
AND ★(검색조건)
--★문제점 : 원하지 않는 결과가 나올 수 있다. (이유? AND -> OR의 우선수위 떄문에)
--★문제점 해결법 : AND ★ 검색조건에서 '괄호()를 이용하여 우선순위 변경'
--예)부서번호로 조인한 후 부서번호가 10이거나 30인 정보 조회
--where e.dno = d.dno AND d.dno=10 OR d.dno=30; --문제 발생 (원하지 않는 결과 나옴) 
--where e.dno = d.dno AND (d.dno=10 OR d.dno=30);


--★★★ [장점] 이 방법은 outer join(=외부조인) 하기가  편리하다.
--(단, 한쪽에만 (+)사용가능->즉 ,왼쪽과 오른쪽 외부조인만 가능.
-- 양쪽에 (+)사용불가 -> 즉, full 외부조인은 불가) 
--[1]
select*
 from EMPLOYEE, DEPARTMENT;
 order by eno;
--[2]별칭 사용안할 경우
select*
 from EMPLOYEE, DEPARTMENT
 where EMPLOYEE.dno = DEPARTMENT.DNO;

 
-- 두 테이블에서 같은 dno끼리 조인 (그 결과 부서테이블의 40은 표시안됨)

 --40 부서의 정보를 함께 표시하기 위해서는 (+) 붙여서 외부조인함
--[3]
 select*
 from EMPLOYEE e, DEPARTMENT d
 where e.dno(+) = d.dno;
--외부조인하기 편리하나 full outer join 안됨 
--full outer join은 join~on으로 해결가능함

 --[3]아래 결과는 같다. 그이유 ? DEPARTMENT 테이블에만 표시될 내용이 더 있으므로 ,....
 select *
 from EMPLOYEE e, RIGHT OUTER JOIN DEPARTMENT d
 ON e.dno = d.DNO;

 select *
 from EMPLOYEE e, FULL OUTER JOIN DEPARTMENT d
 ON e.dno = d.DNO;
 
 --[해결할 문제] '사원번호가 7788' 인 사원이 소속된 '사원번호,사원이름, 소속부서번호, 소속된부서이름'얻기  
 
 --[문제해결법- 방법-1]
--select e.eno, e.ename, e.dno, d.dname--e.dno에는 반드시 별칭사용 : 두 테이블에 모두 존재하므로 구분하기 위해
 select eno, ename, e.dno, dname
 from EMPLOYEE e, DEPARTMENT D
 where e.dno = d.dno 
 and eno='7788';
 
 -----[방법-2](inner)join ~ on----------------------------------------------------------------------------------------------------
--동일한 이름과 데이터 유형을 가진 컬럼으로 조인 + "임이의 조건을 지정" 하거나 "조인할 컬럼을 지정" ON절을 사용
--조인결과는 중복된 컬럼 제거x -> 따라서, 테이블에 '별칭 사용'해서 어느 테이블의 컬럼인지 구분해야된다
select 컬럼명1,컬럼명2...-- 중복되는 컬럼은 반드시 '별칭.컬럼명'(예)e.dno d.dno  
from 테이블1 별칭1(inner)join 테이블2 별칭2, ....
ON ★ 조인조건(주의 : 테이블의 별칭 사용) --별칭사용(별칭 : 해당 SQL 명령문내에서만 유효함) 
where ★(검색조건)
 
--[문제해결법 방법-2 쓴것]
 select eno, ename, e.dno, dname
 from EMPLOYEE e join DEPARTMENT d--e.dno에는 반드시 별칭사용 : 두 테이블에 모두 존재하므로 구분하기 위해
on e.dno = d.dno 
where eno='7788';
 ------------------------------------------------[방법-1]과 [방법-2]는 문법적 특징이 동일하다 .
 ------------------------------------------------                 의 조인 결과 : 중복된 컬럼은 제거하지 않음 ->테이블의 별칭이 필요하다
-------------------------------------------------                 ★컬럼명 다르고 데이터 타입만 같아도 JION가능  (예)a.id=b.id2

--------------------------------------------------[방법-3]:컬럼명이 다르면 cross join 결과가 나옴
--------------------------------------------------[방법-4]:컬럼명이 다르면 join안됨(=>오류 발생)

---------------------[방법3]natural join ---------------------------------------------------------------------------------------------
--※ Oracle SQL에서만 지원 
--조인결과, 중복된 컬럼 제거됨 
--[문제해결법 ]
 --select e.eno, e.ename, dno, d.dname
 select eno, ename, dno, dname--dno는 중복 제거했으므로 e.dno, d.dno 별칭사용하면 오류 발생함
from EMPLOYEE  natural join DEPARTMENT --별칭 만들어도 되나 필요없음 
--on e.dno = d.dno 
where eno='7788';


 
select eno, ename, dno, dname
from EMPLOYEE  natural join DEPARTMENT 
where eno='7788';




--'자연스럽게' 동일한 이름과 데이터 유형을 가진 컬럼으로 조인(★이때 단, 1개만 있을 때 사용하는 것을 권장)
--동일한 이름과 데이터 유형을 가진 컬러이 없으면 cross join 결과가 나옴 
--★★ 동일한 이름과 데이터 유형을 가진 컬럼으로 자연스럽게 조인되나 문제가 발생할 수 있다.
-------> 문제 발생하는 이유? (예) EMPLOYEE의 dno와 DEPARTMENT의 dno : 동일한 이름 (dno)과 데이터 유형(number(2))
 --                                 ★두 테이블에서 dno는 부서번호로 의미도 같다. 
---                                 만약, EMPLOYEE의 manager_id (각 사원의 '상사'를 의미하는 번호)가 있고
--                                  DEPARTMENT의 manager_id(각 사원의 '부장'을 의미하는 번호)가 있고
--                                  둘 다 동일한 이름과 데이터 유형을 가졌지만 manager_id의 의미가 다르다면 자연조인한 후 원하지 않는 결과 가 나올 수 있다
--                                        
select 컬럼명1,컬럼명2...
from 테이블1 natural join 테이블2  ....--별칭사용 안함 (권장)
--★ 조인조건 필요없음 
where ★(검색조건)
 



------[방법4] join~ USING (★반드시 '동일한 데이터 유형인 컬럼명'만 가능)★다르면 오류발생---------------------------------------------
--※ Oracle SQL에서만 지원 
--조인결과, 중복된 컬럼 제거됨 

-- natural JON 은 같은 데이터 유형과 이름을 가진 컬럼을 모두 join 하지만 
--USING 은 같은 데이터 유형과 이름을 가진 컬럼들 중에서도 특정컬럼만 따로 선택할 수 있다.

--조인결과는 중복된 컬럼 제거 -> 제거한 결과에 FULL outer join~ USING(id)하면 하나의 id로 항목값들이 합쳐져서
--동일한 이름과 유형을 가진 컬럼으로 조인(★조인 시 1개 이상 사용할 때 편리 : 가독성 좋아서..) 
select 컬럼명1,컬럼명2...
from 테이블1 natural join 테이블2  ....--별칭사용 안함 (권장)
USING (dno,dname)--USING (동일한 타입과 컬럼명1)
where ★(검색조건)


--[문제해결법 1]
 
select e.eno, e.ename, dno, d.dname--dno는 중복 제거했으므로 e.dno, d.dno 별칭사용하면 오류 발생함
from EMPLOYEE e    join DEPARTMENT d  --별칭 만들어도 되나 필요없음 
USING (dno)
where eno='7788';

--[문제해결법 2_간략]
select eno, ename, dno, dname
from EMPLOYEE join DEPARTMENT 
USING (dno)
where eno='7788';

--★★ 만약, manager가 DEPARTMENT에 있다고 가정 후 아래 결과 유추
select eno, ename, dno, dname,DEPARTMENT.manager --반드시 테이블명이나 별칭 사용 하여 구분해야 함
from EMPLOYEE join DEPARTMENT 
USING (dno)--dno만 중복제거(★manager는 중복제거안함)
where eno='7788';


--USING을 사용하면 여러개의 컬럼을 기술할 수 있다.
--※ 이 때 기술된 여러 컬럼의 값은 하나의 값으로 묶어서 판단해야 한다.
--[예] 실습을 위해 테이블 생성 후 데이터 추가
create table emp_test(
eno number primary key,
dno_id number,
loc_id char(2)
);

insert into emp_test values(1, 10, 'A1');
insert into emp_test values(2, 10, 'A2');
insert into emp_test values(3, 20, 'A1');

create table dept_test(
dno_id number primary key,
dname varchar2(20),
loc_id char(2)
);

insert into dept_test values(10, '회계', 'A1');
insert into dept_test values(20, '경영', 'A1');
insert into dept_test values(30, '영업', 'A2');

--USING 조인 
select *
from emp_test JOIN dept_test
USING(dno_id,loc_id);
--'10A1','20A1'은 조인결과에 포함되나 '10A2'나 '30A2'는 조인결과에 포함되지 않음
--이에 따라 두 테이블에 공통요소인 '10A1', '20A1'만 조인된 출력결과를 확인할 수 있다.  

--※ 여러 테이블 간 조인할 경우 NATURAL JOIN과 JOIN~USING 을 이용한 조인 모두 사용 가능하나 
--가독성이 높은 JOIN~USING을 이용하는 방법을 권한다. 
----------------------------------------------[방법-3] : 컬럼명이 다르면 cross join 결과가 나옴
----------------------------------------------[방법-4] : 컬럼명이 다르면  join 안됨(오류 발생)
---------------------------<4가지 정리 끝>-----------------------ㄴ
























