----<시험문제 정리>


--[SQL 활용] 정리

--<DDL:데이터 정의어>
--1. 테이블 생성
[테이블명 test]
----------------------------------------
필드(=컬럼명) Type           null      key   
----------------------------------------
id         varchar2(20)   no           
password   varchar2(30)   no            
name       varchar2(25)   no            
성별        char(2)        yes           
birth      date           yes          
age        number(4)      yes       
----------------------------------------
create table test(
id varchar2(20) not null,
password varchar2(30) not null,
name varchar2(25) not null,
성별 char(2),
birth date,
age number(4));
--2. 컬럼 이름(=열 이름) 변경 : 성별 -> gender 
alter table test
RENAME column 성별 to gender;

--3. 컬럼 이름(=열 이름) 추가:address varchar2(60) 추가
alter table test
ADD address varchar2(60);
--4. birth 열 제거
alter table test
DROP column birth;
/*
 * [컬럼의 길이 변경(줄일 때) 주의사항]
 * 컬럼의 길이를 줄일 경우 이미 insert된 해당 컬럼의 값 중 변경할 길이보다 큰 값이 있으면 오류가 발생한다.
 * ORA-01441: cannot decrease column length because some value is too big 
 * 
 * 이럴 때는 해당 컬럼의 길이를 조회하여 변경할 길이보다 큰 값이 있는지 확인한 후 값을 변경해야 한다.
 * 
 * select id, age -- select *
 * from test
 * where length(age) > 3;
 */

--5. 열 수정 : 아직 insert한 row(=레코드)가 없으므로 컬럼 크기를 줄일 수 있다.
--age : number(3), null:NO, Default값:0
alter table test
MODIFY age number(3) default 0 not null; -- ★★ 순서 주의 : not null default 0(오류)

--(2) gender : char(1), default:'M'
alter table test
MODIFY gender char(1) default 'M';

--※'테이블 제약조건'을 확인하려면 'USER_constraintS'데이터 사전 사용함
select constraint_name, constraint_type --p,r,c,u
from USER_constraintS
where table_name IN('TEST');
--6. id에 '기본키 제약조건' 추가
--[방법-1]
--자동으로 생성된 제약조건명
alter table test
ADD primary key(id);

--제약조건명
alter table test
ADD constraint test_id_pk primary key(id);
--[방법-2] 컬럼 id 수정
alter table test 
MODIFY id varchar2(20) primary key;--primary key = notnull + unique(index 자동생성됨) 

--7. 테이블 구조 확인
desc test ; --SQL PLUS 명령어는 이클립스에서는 실행안됨(RUN SQL~에서 실행 가능)
 
--8. 테이블의 제약조건 확인(테이블명, 제약조건명, 제약조건타입)
--[1] 컬러명을 모르겠으면 *로 조회하여 이름확인한 후 
select*
from USER_constraintS
where table_name IN('TEST');

--[2]테이블명, 제약조건명, 제약조건타입
select table_name, constraint_name, constraint_type --p,r,c,u
from USER_constraintS
where table_name IN('TEST');
-------------------------------------------------------------------------------------------------------------------

--<DML:데이터 조작어(insert, update, delete) -> TCL:트랜잭션 처리어(commit, rollback, savepoint)
--9. insert : 데이터 입력
id     password   name   gender    age    address
---------------------------------------------------
yang1  !1111      양영석     M       27     구미시
yoon2  $2222      윤호섭     M       19     대구광역시
lee3   #3333      이수광     M       30     서울특별시
an4    &4444      안여진     F       24     부산광역시
insert into test values('yang1','!1111','양영석','M',27,'구미시');
insert into test values('yang2','!1111','윤호섭','M',19,'대구광역시');
insert into test values('lee3','#3333',' 이수광','M',30,'서울특별시');
insert into test values('an4','&4444','안여진','F', 24,'부산광역시');
select * from test;

delete from test ;
--10. update : '광역시' -> '시'로 데이터 변경
UPDATE test
SET address = replace(address,'광역시','시')
where address LIKE '%광역시';

select * from test;
--10번 변경문제. update : '광역시' -> '시'로 데이터 변경
--(단, 서브쿼리 사용하여 해결하기)

--11. delete : 나이가 20미만인 데이터 삭제
--미만 <20, 이하 <=20, 초과 >20, 이상>=20
delete test---delete from test
where age < 20;
--12. 데이터 입력한 후 영구저장(트랜잭션 완료) : RUN SQL~에서 실행
----->결과 확인 : 이클립스에서 결과 확인
--삽입할 데이터 : jun5 *5555 전상호  M 28 NULL

--[1]
delete test
where ID='jun5';
insert into test values('jun5','*5555','전상호','M',28,NULL);
commit;
--[2]확인은 이클립스에서
select * from test;

--13. 데이터 삭제한 후 이전 상태로 복귀(트랜잭션 취소) : RUN SQL~에서 실행
----->결과 확인 : 이클립스에서 결과 확인
--[문제] 주소가 '구미시'인 row 삭제 후  트랜잭셕 취소 -> 확인
--[1]RUN_SQL~ 에서 실행
delete from test
where address = '구미시';
--[2]이전 상태로 복귀(트랜잭셕 취소) 
rollback;
--[3]결과확인
select * from test
--데이터 사전(8장-6. 데이터 사전 참조)
--14. 사용자가 소유한 테이블 이름 조회 => USER_데이터 사전 
select TABLE_NAME
from USER_tableS;

--15. 테이블 구조 확인
----SQL PLUS명령어는 이클립스에서 실행안됨(RUN SQL~에서 실행)
desc test;
--16. index 생성(index 명 : name_idx)
--인덱스:검색 속도를 향상시키기 위해 사용
--     사용자의 필요에 의해서 직접 생성할 수도 있지만
--     데이터 무결성을 확인하기 위해서 수시로 데이터를 검색하는 용도로 사용되는 
--     '기본키나 유일키는 인덱스 자동 생성'
create index name_idx 
ON test(name);   

--index 생성 확인 방법 -1 
select * 
from USER_indexES
where table_name ='TEST'; -- 반드시 테이블명은 대문자로
--where table_name IN ('TEST');
--index 생성 확인 방법 -2
select index_name, column_name  
from USER_ind_columnS --column_name 알려면 
where table_name ='TEST';--반드시 테이블명은 대문자로 
--17. view 생성(뷰 이름 : viewTest)
--뷰? 하나 이상의 테이블이나 다른 뷰를 이용하여 생성되는 가상테이블
--뷰는 복잡한 쿼리를 단순화 시킬수 있다.
--뷰는 사용자에게 필요한 정보만 접근하도록 접근을 제한할 수 있다.
create view viewTest
AS
select id, name, gender
from test;
--뷰 생성 확인 방법
select view_name
from USER_viewS;
where view_name='VIEWTEST'

--사용자가 소유한 뷰 이름 조회
select view_name
from USER_viewS;
--------------------------------------------------------------------------------------------
--18. test2 테이블 생성
[테이블명 test2]
-------------------------------------
필드       Type           null   key 
-------------------------------------
id        varchar2(20)   no     PK  
major     varchar2(20)   yes  
-------------------------------------

--test, test2 EQUI 조인(=등등조인=동일조인) : 데이터 타입이 같아야 함

/*
 * ▶ NATURAL 조인과 USING 절을 이용한 조인의 차이점
 * 조인되는 테이블간 공통된 컬럼이 2개 이상이라면 둘의 결과는 완전히 다를 수 있다.
 * 
 * select *
 * from employee 
 * join department USING(dno)--조인한 결과와
 * join test3 USING(manager_id);--조인.(manager_id의 이름, 타입, 의미는 같다.)
 * 
 * select *
 * from employee 
 * NATURAL join department;--자동으로 dno로 조인한 결과와
 * NATURAL join test3;--조인.
 * --(manager_id뿐만 아니라 '같은 이름과 같은 타입이 하나 더 존재'한다면 2개의 공통된 컬럼으로 조인이 되어)
 * -->둘의 결과는 완전히 다를 수 있다.
 * 
 * ※ 따라서, 같은 이름, 타입, 의미의 컬럼이 하나이면  NATURAL 조인을 사용하고
 * 2개 이상이면'가독성이 좋은 USING 절'을 이용한 방법을 권한다.
 */

--------------------------------------[18. join 간단 정리 끝]--------------------------------------

--19. 서브쿼리를 이용하여 major가 '컴퓨터 공학'인 사람의 이름 조회

--20. 집합연산자 : 각 쿼리의 '컬럼 개수'와 '데이터 타입'이 일치
--20.1 UNION : 각 쿼리의 결과의 합을 반환하는 '합집합'(중복제거)
--             쿼리의 결과를 합친 후 '중복을 제거'하는 작업이 추가로 적용되므로 쿼리의 속도 및 부하가 발생한다.
--             중복을 제거할 필요가 없으면 UNION ALL을 사용하는 것이 합리적이다.


--20.2 INTERSECT : 각 쿼리의 결과 중 '같은 결과만 반환'하는 '교집합'


--20.3 MINUS : 앞 쿼리의 결과 - 뒤 쿼리의 결과  ('차집합')(중복제거)
--             앞 쿼리의 결과 - 앞뒤 교집합의 결과

----------------------------------------------------------------------------------------------------

--UNION : 특징들을 예로 설명
--(예1) job별로 급여의 총합과 커미션의 총합 구하기


--(예1 변경-2) 모든 별칭 생략하면 '1번째 컬럼 자체'가 '컬럼명'으로 표시됨

--(예2) 사원 테이블과 부서 테이블을 결합하여 부서번호와 부서이름을 조회(중복 제거)

--[문제] 사원 테이블과 부서 테이블에 '동시에 없는 부서번호, 부서이름' 조회
--(employee의 dno가 department의 dno를 references를 아는 전제 하에서
--즉,'employee의 dno가 참조하는 dno는 반드시 department의 dno로 존재한다'는 사실을 아는 전제 하에서 문제 해결함) 

---------------------------------------------------------------------------------------------------                                         

-- UNION 사용 : 서로 다른 테이블을 사용한 쿼리의 결과가 합쳐서 조회
--            select문의 컬럼의 개수와 각 컬럼의 데이터 타입만 일치하면 된다.   

