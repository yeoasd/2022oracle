--응용SW 기초 기술활용 테스트 정리
--테이블 생성 -> 데이터 추가 -> 조회/수정/삭제


--1. 테이블 생성
create table ADDRESS(
anum number primary key,--중복 허용x, not null
name varchar2(20) not null,
gender char(1),--1바이트만.. '남','여'는 안됨. 한글이라.. char(3)이면 남,여 입력 가능.
tel varchar2(20),
address varchar2(100) not null
);

--2. 데이터 추가
insert into ADDRESS values(1, '강민재', 'M', '010-1111-1111', '대구');
insert into ADDRESS values(2, '권은재', 'F', '010-2222-2222', '부산');
insert into ADDRESS values(3, '김도영', 'M', '010-3333-3333', '서울');

--3. 데이터 조회 : ADDRESS 테이블의 모든 정보 조회
select * from ADDRESS;

--4. 데이터 추가 (4, '김은경', 'F', '010-4444-4444', '대구')
insert into ADDRESS values(4, '김은경', 'F', '010-4444-4444', '대구');

--5. 데이터 변경=수정=갱신 : 강민재의 address값을 '서울'로 변경
update ADDRESS SET address='서울' where name='강민재';




