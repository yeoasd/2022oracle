--<북스 10장. 데이터 무결성과 제약조건>

--1. 제약조건
--'데이터 무결성' 제약조건 : 테이블에 유효하지 않은(부적절한) 데이터가 입력되는 것을 방지하기 위해 
--테이블 생성할 때 각 컬럼에 대해 정의하는 여러 규칙 

--<테이블 생성에 사용되는 제약 조건(5가지)>--------------------------------------------------------------------------------
--1. NOT NULL

--2. UNIQUE : 중복x -> 유일한 값 = 고유한 값 -> 고유키(암시적 index 자동 생성)
--            ★★ null은 unique 제약조건에 위반되지 않으므로 'null값을 허용'             



--3. PRIMARY KEY(기본키=PK) : not null제약조건 - null값 허용x
--                           unique 제약조건 - 중복x -> 고유키(암시적 index 자동 생성)

--4. FOREIGN KEY(외래키=참조키=FK) : 참조되는 테이블에 컬럼 값이 반드시 PK OR unique으로 존재 
--                              (예)사원테이블(자식) dno(pk) -> 부서테이블(부모) dno(pk or unique) 
--                              ※ 참조 무결성 제약조건: 테이블 사이의 '주종 관계를 설정'하기 위한 제약조건
--'어느 테이블부터 먼저 정의되어야 하는가 ?' : 먼저, 부모 테이블부터 정의하고 -> 참조하고 있는 자식 테이블 정의   
--- 참조 무결성이 위배되는 상황 발생 시, 다음 옵션으로 처리 가능
-- (CASCADE, NO ACTION, SET NULL, SET DEFAULT)

--5.CHECK : '저장가능한 데이터 범위나 조건 지정'하여 (예) CHECK(0 < salary && salary < 100000000) 
--          -> 설정된 값 이외의 값이 들어오면 오류
-------------------------------------------------------------------------------------
-- default 정의 : 아무런 값을 입력하지 않았을 때 default 값이 입력됨 

--제약조건 : 컬럼레벨 - 하나의 컬럼에 대해 모든 제약 조건을 정의
--        테이블레벨 - 'not null 제외' 한 나머지 제약 조건을 정의

--<제약조건이름 직접 지정할 때 형식>
-- constraint 제약조건 이름  
-- constraint 테이블명_컬럼명_제약조건유형
-- 제약조건이름 지정하지 않으면 자동 생성됨

--(1)제약조건 이름 지정하지 않으면 자동 생성
DROP TABLE customer2;

create table customer2(
id varchar2(20) unique,--컬럼레벨
pwd varchar2(20) not null,
name varchar2(20) not null,
phone varchar2(30),
address varchar2(100)
);
 --USER_CONSTRAINTS : 자기 계정의 제약 조건 확인
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE--P(=PK=기본키),R(=FK=참조키),(C=NOT NULL),(U=UNIQUE) 
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('CUSTOMER2');
----------------------------------------------------------------------------
--(2) 제약조건이름 지정 constraint 테이블명_컬럼명_제약조건유형
DROP TABLE customer2;

create table customer2(
id varchar2(20) constraint customer2_id_uq unique,
pwd varchar2(20) constraint customer2_pwd_nn null,
name varchar2(20) constraint customer2_name_nn not null,
phone varchar2(30),
address varchar2(100)
);
 --USER_CONSTRAINTS : 자기 계정의 제약 조건 확인
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE--P(=PK=기본키),R(=FK=참조키),(C=NOT NULL),(U=UNIQUE) 
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('CUSTOMER2');--주의 : 테이블명 '대문자'로검색
--소문자 검색시 밑에 방법
--WHERE LOWER(table_name) IN ('customer2');
--WHERE table_name in (UPPER('customer2'));
--(3)PK를 컬럼레벨 
DROP TABLE customer2;

create table customer2(
id varchar2(20) constraint customer2_id_pk primary key,--컬럼 레벨
pwd varchar2(20) constraint customer2_pwd_nn null,
name varchar2(20) constraint customer2_name_nn not null,
phone varchar2(30),
address varchar2(100)
);
 --USER_CONSTRAINTS : 자기 계정의 제약 조건 확인
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE--P(=PK=기본키),R(=FK=참조키),(C=NOT NULL),(U=UNIQUE) 
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('CUSTOMER2');


--(4)PK 를 테이블 레벨 
DROP TABLE customer2;

create table customer2(
id varchar2(20),
pwd varchar2(20) constraint customer2_pwd_nn null,
name varchar2(20) constraint customer2_name_nn not null,
phone varchar2(30),
address varchar2(100),

--테이블 레벨 시작
constraint customer2_id_pk primary key(id)
--constraint customer2_id_pk primary key(id,name)--기본키가 2개이상일 때 테이블 레벨 사용 
);


 --USER_CONSTRAINTS : 자기 계정의 제약 조건 확인
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE--P(=PK=기본키),R(=FK=참조키),(C=NOT NULL),(U=UNIQUE) 
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('CUSTOMER2');

--1.1 NOT NULL 제약조건 :컬럼 레벨로만 정의 : (1) 적용시
insert into customer2 values(null,null,null,'010-1111-1111','대구 달서구');--오류발생

--1.2 unique 제약조건 : 유일한 값만 허용(단, null 허용) (2) 적용시
insert into customer2 values('a1234','1234','홍길동','010-2222-2222','대구 북구');
insert into customer2 values(null,'5678','이순신','010-3333-3333','대구 서구');

--1.3 데이터 구분을 위한 primary key(=PK=기본키) 제약조건 
--테이블 모든 row를 구분하기 위한 식별자 -> index번호 자동 생성됨

--1.4'참조 무결성'을 위한 FOREIGN KEY(FK=참조키=외래키) 제약조건  
--사원 테이블의 부서번호는 언제나 부서테이블을 참조 가능 : 참조 무결성 
-- (예)사원테이블(자식) dno(pk) -> 부서테이블(부모) dno(pk or unique) 

select * from DEPARTMENT;--참조되는 부모

desc employee;--테이블 구조 확인 
 --USER_CONSTRAINTS : 자기 계정의 제약 조건 확인
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE--P(=PK=기본키),R(=FK=참조키),(C=NOT NULL),(U=UNIQUE) 
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('EMPLOYEE', 'DEPARTMENT');


--★★삽입(자식인 사원 테이블에서)하는 방법 
insert into employee(eno, ename, dno) values(8000, '홍길동',50); --참조하는 자식
--부서번호 50 입력하면 
--ORA-02291: integrity constraint (SYSTEM.SYS_C006999) violated - parent key not found
--'참조 무결성 제약조건 위배, 부모키를 발견하지 못했다.'

-- 이유 : 사원테이블에서 사원의 정보를 새롭게 추가할 경우 
--      사원테이블의 부서번호는 부서테이블의 저장된 부서번호 중 하나와 일치 
--      or NULL 만 입력 가능함(단, null 허용하면 )- 참조 무결성 제약조건  

--삽입 방법-1
insert into employee(eno, ename, dno) values(8000, '홍길동','');--''= (null) 단 ,dno가 null 허용하면 
 
select * from employee where eno=8000;

--삽입 방법-2 : 제약조건을 삭제하지 않고 일시적으로 '비활성화(=disable)' -> 데이터 추가 -> '다시 활성화(=enable)' -- d를빼야되 수동적으로 활성화 하려면
-- 먼저, --USER_constraintS 데이터 사전을 이용하여: CONSTRAINT_NAME과   CONSTRAINT_TYPE, status 조회 
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, status
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('EMPLOYEE');

--[1] 참조키 제약조건 '비활성화'
ALTER TABLE employee
disable constraint SYS_C006999-- constraint_type이 R(=fk)

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, status
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('EMPLOYEE');

--[2] 자식을 삽입
insert into employee(eno, ename, dno) values(9000, '홍길동',50);
--[3]다시 활성화 
ALTER TABLE employee
ENable constraint SYS_C006999;
--오류 :ORA-02298: cannot validate (SYSTEM.SYS_C006999) - parent keys not found

-- 오류 해결 방법-1(즉, 다시 활성화 시키기 위해  dno가 50인 row 삭제하거나 dno를 '' 로 수정 ) 
delete from employee where dno=50;
update employee SET dno='' where dno=50;--''(null) 허용시 사용가능 

--다시 활성화 
ALTER TABLE employee
ENable constraint SYS_C006999;
-- 활성화 상태 확인 
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, status
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('EMPLOYEE');

-- 오류 해결 방법-2 :이때 이미 여러 row를 추가했다면 찾아서 삭제
--[1]먼저-- 
select dno --{10,20,30,50,null}
from employee;

--[2]
select dno--{10,20,30}
from employee NATURAL JOIN department;--dno로 자연조인

--[3]
select dno---{10,20,30,50,null}-{10,20,30}={50,null}
from employee
MINUS
select dno
from employee NATURAL JOIN department;

--[4-1]삭제 : dno가 50인 사원을  삭제
delete from employee 
where dno=50;

---삭제 전 dno가 50 또는 null인 사원을 미리 백업시킴

--[4-2]수정 : dno가 50인 사원을 찾아서 ''(null)로 수정 후 향후 부서가 정해지면 다시 해당부서번호로 수정 
UPDATE employee
SET dno=''
where dno=50;

UPDATE employee
SET dno=40--정해진 부서번호로 
where dno is null;
--[삽입 방법-2 정리] : 제약조건 잠시 비활성화시켜 원하는 데이터를 삽입 하더라도 다시 제약조건 활성화시키면 오류가 발생하여
--                 삽입한 데이터를 삭제하거나 수정해야 하는  번거로운 일이 발생함  

--<★★ 삭제(부모인 부서 테이블에서)하는 방법>
DROP TABLE department;
--오류 발생 :ORA-02449: unique/primary keys in table referenced by foreign keys
--자식인 employee 테이블에서 참조하는 상황에서는 삭제 불가능

--1. 부모 테이블 생성 : 실습위해  department 테이블 구조와 데이터 복사하여 department2
--★★ 주의 : 제약 조건은 복사안됨
--DROP table department2;--오류 (?부모테이블로 참조되고 있어서)
--DROP table department2 CASCADE constraintS; -- 그래서 사원테이블의 참조키 제약조건을 함께 제거

create table department2--★ 주의 제약조건 복사 안됨
as 
select * from DEPARTMENT;--dno(pk=not null+unique)
--제약 조건 확인 결과 없음 제약조건 복사안됨
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, status
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('department2');

--- PRIMARY KEY 제약조건 추가하기 (단, 제약조건명을 직접 만들어 추가) : 제약조건 복사안되어 
ALTER TABLE department2
ADD constraint department2_dno_pk PRIMARY KEY(dno); 

--제약 조건 확인 결과 
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, status
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('DEPARTMENT2');

--2. 자식 테이블 생성 :


create table emp_second(
eno.number(4) constraint emp_second_eno_pk PRIMARY KEY,
ename varchar2(10),
job varchar2(9),
salary number(7,2) DEFAULT 1000 CHECK(salary > 0),
dno number(2), --constraint emp_second_dno_fk FOREIGN KEY references deprtment2 ON DELETE CASCADE--컬럼레벨   


--'테이블 레벨'에서만 가능 : ON DELETE옵션
constraint emp_second_dno_fk FOREIGN KEY(dno) references deprtment2(dno) ON DELETE CASCADE
);


/*
 == ON DELETE 뒤에 ==
 1.no action (기본값) : 부모 테이블 기본키 값을 자ㄷ식테이블에서 참조하고 있으면 부모테이블의 행에 대한 삭제 불가 
       ★ restrict(MYSQL에서 기본값, MYSQL에서 restrict는 no action과 같은 의미로사용함)
       
       ※ 오라클에서는 restrict와 no action은 약간의 차이가 있음

 2. cascade : 참조되는 '부모 테이블이 기본키 값이 삭제' 되면 연쇄적으로 '자식 테이블이 참조하는 값 역시 삭제'
              부서 테이블의 부서번호 40 삭제할 때 사원 테이블의 부서번호 40도 삭제하여 '참조무결성 유지함'
 3. set null: 참조되는 '부모 테이블이 기본키 값이 삭제' 되면  이키를  참조하는 '자식 테이블의  참조하는 값들은 NULL 값으로 설정'     
              (단, NULL 허용한 경우)
              
 4. set default : 자식 테이블에서 미리 DEFAULT값을 설정 
                  참조되는 '부모 테이블의 기본키 값이 삭제' 되면 이키를 참조하는 '자식 테이블의 참조 하는 값들은 default'값으로 설정
                     ※  이 제약조건이 실행하려면 모든 참조키 컬럼(사원테이블의 dno)에 DEFAULT값 정의가 있어야함                     
           컬럼이 null을 허용하고 명시적 DEFAULT값이 설정되어 있지 않은 경우 null은 해당 컬럼의 암시적 DEFAULT값이  됨                  
 */