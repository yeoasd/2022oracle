--����SW ���� ���Ȱ�� �׽�Ʈ ����
--���̺� ���� -> ������ �߰� -> ��ȸ/����/����


--1. ���̺� ����
create table ADDRESS(
anum number primary key,--�ߺ� ���x, not null
name varchar2(20) not null,
gender char(1),--1����Ʈ��.. '��','��'�� �ȵ�. �ѱ��̶�.. char(3)�̸� ��,�� �Է� ����.
tel varchar2(20),
address varchar2(100) not null
);

--2. ������ �߰�
insert into ADDRESS values(1, '������', 'M', '010-1111-1111', '�뱸');
insert into ADDRESS values(2, '������', 'F', '010-2222-2222', '�λ�');
insert into ADDRESS values(3, '�赵��', 'M', '010-3333-3333', '����');

--3. ������ ��ȸ : ADDRESS ���̺��� ��� ���� ��ȸ
select * from ADDRESS;

--4. ������ �߰� (4, '������', 'F', '010-4444-4444', '�뱸')
insert into ADDRESS values(4, '������', 'F', '010-4444-4444', '�뱸');

--5. ������ ����=����=���� : �������� address���� '����'�� ����
update ADDRESS SET address='����' where name='������';




