--<북스 9장. 데이터 조작과 트랜잭션>--
--데이터 조작이(DML:Data Manipulation Language) 
--1. INSERT : 데이터 입력
--2. UPDATE : 데이터 수정
--3. DELETE : 데이터 삭제
--위 작업 후 반드시 commit;(영구적으로 데이터 저장) 

--TCL(Transaction Control Language):트랜잭션 처리어 (commit, rollback, savepoint)

-----------------------------------------------------------------------------
--1.INSERT : 데이터 입력하여 테이블에 내용 추가 
--문자(char, varchar2)와 날짜(date)는 ''를 사용

--[실습위해 기존의 '부서테이블의 구조만 복사'하여 dept_copy 테이블 생성] 이 때, 제약조건은 복사안됨.not null 제약조건만 복사
create TABLE dept_copy--복사된 dno(pk가아니므로 같은dno가 여러개 추가 할 수 있다.(예)10을 여러번 추가 가능)
as select *
from DEPARTMENT--dno(pk=not null+unique)
WHERE 0 = 1; --조건이 무조건 거짓=>데이터 복사안함

select * from dept_copy;
--RUN 창 열어
DESC dept_copy;--테이블 구조 보고 데이터 타입 확인후 INSERT함
insert into dept_copy values(10, 'accounting', '뉴욕');--3
insert into dept_copy (dno,loc,dname) values(20, '달라스', 'research');--3 

commit;--이클립스에서는 자동 commit되어 명령어가 실행안됨
------>RUN SQL ... 또는 SQL Developer 사용할 떄는 반드시 commit; 해줘야함 

--1.1 NULL값을 갖는 ROW 삽입
--문자나 날짜 타입은 null '' 사용가능
--dept_copy 테이블은 제약조건이 복사되지 않음. 
--아래 3개 다 같은 형식임
insert into dept_copy(dno,dname) values(30,'sales');  --null값을 허용하여 loc에 null이 저장됨  
insert into dept_copy values(40,'operations',null);
insert into dept_copy values(50,'compution','');

commit;--영구적으로 데이터 저장 

select * from dept_copy

--[실습위해 기존의 '사원테이블의 구조만 복사'하여 emp_copy 테이블 생성] 이 때, 제약조건은 복사안됨.not null 제약조건만 복사
create TABLE emp_copy
as 
select eno, ename, job, hiredate, dno 
from employee
WHERE 0 = 1; --조건이 무조건 거짓=>데이터 복사안함

select * from emp_copy;

insert into emp_copy values(7000,'캔디','manager','2021/12/20',10);
--날짜 기본 형식 : 'YY/MM/DD'
insert into emp_copy values(7010,'톰','manager',to_date('2021,06,01','YYYY,MM,DD'),20);
--sysdate : 시스템으로부터 현재 날짜 데이터를 반환하는 함수(주의: ()없음, => MySQL에서는 now()있음 )
insert into emp_copy values(7020,'제리','SELESMAN',sysdate,30);

select * from emp_copy;

--1.2 다른 테이블에서 데이터 복사하기
--INSERT INTO + 다른 테이블의 서브쿼리 결과 데이터 복사  
--단 , 컬럼수 = 서브쿼리 결과의 컬럼수

----[실습위해 기존의 '사원테이블의 구조만 복사'하여 dept_copy 테이블 생성] 이 때, 제약조건은 복사안됨.not null 제약조건만 복사
--drop table dept_copy;

create TABLE dept_copy--복사된 dno(pk가아니므로 같은dno가 여러개 추가 할 수 있다.(예)10을 여러번 추가 가능)
as select *
from DEPARTMENT--dno(pk=not null+unique)
WHERE 0 = 1; --조건이 무조건 거짓=>데이터 복사안함

select * from dept_copy;

--(예) 서브쿼리로 다중 행 입력하기
INSERT INTO dept_copy--dept_copy 의 컬럼수와 데이터타입과  department의 컬럼수와 데이터타입과 1:1로 같아야 함   
select * from department; 

select * from dept_copy; 
--확인해보면 dno가 pk가 아니므로 같은 dno들이 여러개 존재함

-------------------------------------------------------------


--2. UPDATE : 테이블의 데이터 수정 
-- WHERE절 생략 : 테이블의 모든 행 수정됨 
UPDATE dept_copy
set dname ='programming'
where dno = 10; 

select * from dept_copy; 

--컬럼 값 여러 개를 한 번에 수정하기
UPDATE dept_copy
set dname ='accounting',loc='서울'
where dno = 10; 

select * from dept_copy;


--update문의 set절에서 서브쿼리를 기술하면 서브쿼리를 수행한 결과로 내용이 변경됨
--즉, 다른 테이블에 저장된 데이터로 해당 컬럼 값 변경 가능

--예 : 10번 부서의 지역명을 20번 부서의 지역으로 변경
--[1] 20번 부서의 지역명 구하기 
select loc
from dept_copy
where dno = 20;--'DALLAS'

--[2]
UPDATE dept_copy
set loc = (select loc
           from dept_copy
           where dno = 20)--서브쿼리의 결과 단 1개만 
where dno = 10; 

select * from dept_copy;

--[3]확인
select dno,loc 
from dept_copy
where dno= 10 OR dno =20;

-- 예 : 10번 부서의 '부서명과 지역명'을 30번 부서의 '부서명과 지역명'으로 변경
--[1]
select loc
from dept_copy
where dno = 30;

--[2]
UPDATE dept_copy
set loc = (select loc
           from dept_copy
           where dno = 30), 
           dname =(select dname from dept_copy where dno=30)--서브쿼리의 결과 단 1개만 
where dno = 10; 

--[3]
select dno,loc 
from dept_copy
where dno= 10 OR dno =30;
----------------------------------------------

--3.DELETE문 : 테이블의 데이터 삭제 
---WHERE절 생략 : 모든 데이터 삭제

DELETE 
from dept_copy-- from 생략 가능 
where dno=10; 

select * from dept_copy;

--모든데이터 삭제
DELETE 
from dept_copy;

select * from dept_copy;

-- 실습위해 삭제한 데이터 다시 추가후 
INSERT INTO dept_copy select * from department; 

--[문제]
--예 : emp_copy 테이블에서 '영업부(SALES)'에 근무하는 사원 모두 삭제
--[1] 부서테이블에서 '영업부(SALES)'의 부서번호 구하기
select dno
from dept_copy-- from dapartment
where dname='SALES';--30

--내가한것
select *
from dept_copy;
--[2]emp_copy 테이블에서 '구한 부서번호와 같은' 부서번호를 가진 사원을 모두 삭제
DELETE from emp_copy
where dno = (select dno
             from dept_copy	
        	 where dname='SALES');
insert into dept_copy
select * from department where dno = 30;

 select * from emp_copy;

DELETE 
from dept_copy
where dname='SALES';

select *
from dept_copy;
------------------------------------------------------------------------------------
--★★ 이클립스는 자동 commit 되어 있으므로 수동으로 commit되도록 환경설정 후 테스트 하기 

--4. 트랜잭션 관리
--오라클은 트랜잭션 기반으로 '데이터의 일관성을 보장함'
--(예) 두 계좌
--'출금계좌 출금금액'과 '입금계좌의 입금금액'이 동일해야 함
-- update          insert             
-- 반드시 두 작업은 함께 처리되거나 함께 취소
-- 출금처리는 되었는데 입금처리가 되지 않았다면 '데이터 일관성을 유지 못함'

-- [트랜잭션 처리요건] : ALL-OR-Nothing 반드시 처리되든지 안되든지 
--                 데이터의 일관성을 유지, 안정적으로 데이터 복구

--1.commit :(DML) '데이터 추가, 수정, 삭제 '등 실행됨과 동시에 트렌잭션이 진행됨 
--             성공적으로 변경된 내용을 영구 저장위해 반드시 commit 
             /* 메모리의 내용을 하드디스크에 저장함 영구히 저장  */

--2.rollback : 작업을 취소
--           트랜잭션으로 인한 하나의 묶음 처리가 시작되기 이전 상태로 되돌림
            /*메모리의 내용을 하드디스크에 저장하지 않고 버림 메모리 내용 무효화 */

---★★ 여기서부터 RUN SQL ~ 에서 테스트하기 
SQL> CONN SYSTEM/1234
Connected.
SQL> delete from dept_copy;-- 모든 ROW 다삭제

5 rows deleted.

SQL> select * from dept_copy;

no rows selected
SQL> rollback;--DELETED 이전으로 되돌림(commit하기 전에) 
Rollback complete.
SQL> select * from dept_copy;--확인:모든 row 다 복구됨

--[실습위해 기존의 '부서테이블의 구조만 복사'하여 dept_copy 테이블 생성] 이 때, 제약조건은 복사안됨.not null 제약조건만 복사
drop table dept_copy;

create TABLE dept_copy--복사된 dno(pk가아니므로 같은dno가 여러개 추가 할 수 있다.(예)10을 여러번 추가 가능)
as select *
from DEPARTMENT--dno(pk=not null+unique)
WHERE 0 = 1; --조건이 무조건 거짓=>데이터 복사안함

--자동 commit 되므로 RUN SQL~에서 추가하기--------------------------------------------------
SQL>insert into dept_copy values(10, 'accounting', '뉴욕');
SQL>insert into dept_copy (dno,loc,dname) values(20, '달라스', 'research');
SQL> ROLLBACK;
------------------------------------------------------------------------------
select * from dept_copy;--추가딘 데이터가 없음 

--※정리 : insert,update, dalete 후 commit하기 전 rollback하면 모두 취소됨 (commit 하기전까지 )
--(예)1
insert..;
insert..;

update..;
delete..;

rollback; 하면 insert..;update..;delete..; 다 취소됨

--(예)2
insert..;
insert..;

update..;
commit;--영구저장

delete..;
rollback; 하면 delete만 취소됨 


--(예)3
insert..;
insert..;
savePoint i;


update..;
savePoint u;



delete..;
savePoint d;

rollback i; 하면 update와 delete 취소됨 
-------------------------------------------------------------------------------------------------
--3.CHECKPOINT ROLLBACK 범위 설정을 위해 메모리상 경계를 설정함 상태 기억
--             rollback 할 위치를 지정함
--[실습위해 기존의 '부서테이블의 구조만 복사'하여 dept_copy 테이블 생성] 이 때, 제약조건은 복사안됨.not null 제약조건만 복사
drop table dept_copy;

create TABLE dept_copy--복사된 dno(pk가아니므로 같은dno가 여러개 추가 할 수 있다.(예)10을 여러번 추가 가능)
as select *
from DEPARTMENT;
--RUN SQL~ 실행하기
--(예) 10번 부서 삭제 -> 20번 부서 삭제 -> SAVEPOINT로 이 지점을 d20이란 이름으로 저장 
SQL>delete from dept_copy where dno=10;
1 row deleted.

SQL>delete from dept_copy where dno=20;
1 row deleted.
SQL> SAVEPOINT d20;--

SQL>delete from dept_copy where dno=30;
1 row deleted.

SQL> ROLLBACK to d20;--d20지점으로 되돌림 
Rollback complete.

SQL> select* from dept_copy; --10과 20번만 삭제

SQL> commit;--영구 저장됨.
SQL>Rollback;-- 영구 저장 후 DML실행한 것이 없어 되돌릴 것이 없음

--다시30번 부서만 삭제 
SQL>delete from dept_copy where dno=20;
SQL> commit;--영구 저장됨.
SQL>Rollback;--삭제된 20번 부서의 내용이 되돌릴수 없음 

SQL>delete from dept_copy where dno=30;
SQL>Rollback;--삭제된 30번 부서의 내용을 되돌려 복구됨

SQL> select * from dept_copy;--삭제된 40번 내용 다시 나타남
/* CHECKPOINT 정리
<트랜잭션 시나리오>
------------------------------------------------------------
순서 명령문         비고
------------------------------------------------------------
1 트랜잭션         시작 
2 INSERT 
3 SAVEPOINT P1   P1이라는 이름으로 복구 지점 설정 
4 UPDATE
5 SAVEPOINT P2   P2라는 이름으로 복구 지점 설정 
6 DELETE
7 (현재 위치에서 ROLLBACK 예정) 복구 지점 사용에 따라 결과 달라짐
------------------------------------------------------------

<트랜잭션 ROLLBACK 경우>
------------------------------------------------------------
7번째 명령문        결과 
------------------------------------------------------------
ROLLBACK         1번째 명령까지 취소됨
                 즉, 현재 위치 이전 트랜잭션 처리 내용이 모두 취소됨
ROLLBACK TO P1   1~3까지의 명령은 유효하게 남고, 4~6까지의 내용이 취소됨
ROLLBACK TO P2   1~5까지의 명령은 유효하게 남고, 6 내용이 취소됨
------------------------------------------------------------
 */

--AutoCommit 상태 확인 방법
SQL> show AutoCommit;
autocommit off

SQL>SET AutoCommit ON;

--AutoCommit 켜기
SQL> SET AutoCommit on;
--AutoCommit 끄기
SQL> SET AutoCommit off;

--<9장 데이터 조작과 트랜잭션-혼자 해보기>-----------------------------
/*
 * 1.EMPLOYEE 테이블의 구조만 복사하여 EMP_INSERT란 이름의 빈 테이블을 만드시오.
 */
drop table EMP_INSERT;

create TABLE EMP_INSERT
as 
select *
from employee
WHERE 0 = 1;

select * from EMP_INSERT;
/*
 * 2.본인을 EMP_INSERT 테이블에 추가하되 SYSDATE를 이용하여 입사일을 오늘로 입력하시오.
 */
DESC EMP_INSERT;--테이블의 구조와 각 컬럼의 데이터 타입 확인후 

insert into EMP_INSERT values(9210,'YHY','SELESMAN',null,sysdate,3000,null,10);
select * from EMP_INSERT;

/*
 * 3.EMP_INSERT 테이블에 옆 사람을 추가하되 TO_DATE 함수를 이용하여 입사일을 어제로 입력하시오.
 */
insert into EMP_INSERT values(9410,'SYK','manager',to_date('2022,07,20','YYYY,MM,DD'),20);
select * from EMP_INSERT;
/*
 * 4.EMPLOYEE 테이블의 구조와 내용을 복사하여 EMP_COPY_2란 이름의 테이블을 만드시오.
 */
create table EMP_COPY_2
AS
select * from EMPLOYEE;

select * from EMP_COPY_2;

/*
 * 5.사원번호가 7788인 사원의 부서번호를 10번으로 수정하시오.
 */
update EMP_COPY_2
set dno=10
where eno=7788;
/*
 * 6.사원번호가 7788의 담당 업무 및 급여를 사원번호 7499의 담당 업무 및 급여와 일치하도록 갱신하시오.
 */
update EMP_COPY_2
SET job=(select job from EMP_COPY_2 where eno=7499)
    salary=(select salary from EMP_COPY_2)

