--JOIN
--여러개 테이블의 데이터가 필요한 경우 사용, 관계형 DB의 기본
---- 기준 테이블에서 다른테 이블의 row 긁어옴
--ORACLE JOIN : EQUI, NON-EQUI, SELF, OUTER
--ANSI JOIN : CROSS, JOIN, OUTER, NATURAL


-- 위 INNER JOIN은 WHERE 문이 빠짐
/*
JOIN = INNER JOIN = 두 개의 테이블에서 TRUE 만 RETURN, FALSE 또는 NULL은 추출되지 않음
*/

-- CREATE TABLE M(M1 VARCHAR(10), M2 VARCHAR2(10));
-- INSERT INTO M VALUES('A','1');
-- INSERT INTO M VALUES('B','1');
-- INSERT INTO M VALUES('C','3');
-- INSERT INTO M VALUES(NULL,'3');

-- CREATE TABLE S (S1 VARCHAR(10), S2 VARCHAR2(10));
-- INSERT INTO S VALUES('A','X');
-- INSERT INTO S VALUES('B','X');
-- INSERT INTO S VALUES(NULL,'Z');

-- CREATE TABLE X(X1 VARCHAR(10), X2 VARCHAR2(10));
-- INSERT INTO X VALUES('A','DATA');

-- SELECT * FROM M;
-- SELECT * FROM S;
-- SELECT * FROM X;

/*
JOIN = INNER JOIN = 두 개의 테이블에서 TRUE 만 RETURN, FALSE 또는 NULL은 추출되지 않음
USING : JOIN TABLE과 같은 컬럼명
ON : JOIN테이블에 다른 컬럼명
CROSS JOIN : FROM M,S라면 S(뒤)에서 M으로 컬럼값 비교 (작업량은 칼럼의 행 개수 곱이 됨)
OUTER JOIN : 주 테이블은 다 나오고, 종 테이블은 TRUE 만 RETURN, 나머진 NULL
    주 테이블은 LEFT OUTER JOIN(왼쪽이 주), RIGHT OUTER JOIN(오른쪽이 주), 으로 결정됨 FULL OUTER JOIN
    ORACLE은 (+); 로 끝나면 됨
NONEQUI JOIN : 범위 구할 때 사용
*/

/*
ANSI : FROM A JOIN B USING(ON) COLUMN
ORACLE : FROM A, B WHERE COLUMN
위 같은 기본형은 INNER JOIN
*/

--INNER JOIN. 사원 이름, 그 사원이 속해있는 부서명
--ANSI CASE1
SELECT ENAME, DNAME
FROM EMP JOIN DEPT USING (DEPTNO);
--ANSI CASE2
SELECT ENAME, DNAME
FROM EMP INNER JOIN DEPT USING (DEPTNO);
--ORACLE CASE1
SELECT ENAME, DNAME
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO;
--ORACLE CASE2
SELECT ENAME, DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO;

--INNER JOIN. 사원의 이름과 속한 부서이름 및 부서명
--ANSI
SELECT ENAME, DEPTNO, DNAME
FROM EMP JOIN DEPT USING (DEPTNO);
--ORACLE
SELECT ENAME, EMP.DEPTNO, DNAME
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO;

--CROSS JOIN

--OUTER JOIN
--ANSI
SELECT *
FROM M LEFT OUTER JOIN S
ON M1=S1
-- M은 전부 다 나오며, S는 M에 있는 A,B만 나옴
SELECT *
FROM M RIGHT OUTER JOIN S
ON M1=S1 --RIGHT면 반대로 나옴
--ORACLE
SELECT *
FROM M,S
WHERE M1=S1(+);
--위와 결과는 동일함. 종 테이블은 (+) 별첨 필요_
SELECT *
FROM M,S
WHERE M1(+)=S1; --RIGHT OUTER JOIN 의 경우
--INNER JOIN, 3개 이상 엮어줄 때 추가 사용 가능
-- ANSI
SELECT *
FROM M INNER JOIN S
ON M1=S1
INNER JOIN X
ON S1=X1
-- ORACLE
SELECT *
FROM M,S,X
WHERE M1=S1 AND S1=X1


--SELF JOIN, NULL값 처리
SELECT E.EMPNO, E.ENAME,A.EMPNO, A.ENAME
FROM EMP E, EMP A
WHERE E.MGR=A.EMPNO(+); --KING이 NULL
--ANSI로 바꾸면
SELECT E.EMPNO, E.ENAME,A.EMPNO, A.ENAME
FROM EMP E LEFT OUTER JOIN EMP A ON(E.MGR=A.EMPNO)

--NONEQUI JOIN 각 사원의 이름과 월급, 급여등급 출력 **
SELECT E.ENAME, E.SAL, S.GRADE
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL;
--ANSI로 바꾸면
SELECT ENAME, SAL, GRADE
FROM EMP JOIN SALGRADE ON (SAL BETWEEN LOSAL AND HISAL);

--NONEQUI JOIN 각 사원의 이름과 월급, 급여등급, 속한 부서이름 출력 **
SELECT ENAME, SAL, DNAME, GRADE
FROM EMP JOIN DEPT USING(DEPTNO)
    JOIN SALGRADE ON (SAL BETWEEN LOSAL AND HISAL);

--EMP TABLE과 DEPT 테이블을 Cartesian product > 사원번호, 이름, 업무, 부서명, 근무지 코드 리턴 **
SELECT EMPNO, ENAME, JOB, DNAME, LOC
FROM DEPT, EMP
ORDER BY 1;

SELECT COUNT(*) FROM DEPT;

-- SELECT FROM START CONNECT BY PRIOR > 계층 구조 출력
SELECT LPAD('   ',4*LEVEL*4) || ENAME AS RES, EMPNO, MGR, DEPTNO
FROM EMP
WHERE CONNECT_BY_ISLEAF =1
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO =MGR;

==================================================
--테이블 CRUD

-- 사원 테이블의 EMP를 TEST_EMP로
CREATE TABLE TEST_EMP AS SELECT * FROM EMP; --AS가 CREATE 뒤에 오면 이하는 SUBQUERY

--사원 테이블에 있는 EMP에서 사원이름, 봉급 선택한 TABLE 생성
CREATE TABLE TEST_EMP00
AS
SELECT ENAME, SAL FROM EMP;

CREATE TABLE TEST_EMP02(사원이름, 봉급)
AS
SELECT ENAME, SAL FROM EMP;

--사원 테이블에 있는 EMP에서 사원이름, 봉급 선택한 TABLE 생성. 단, 직업이 SALESMAN
CREATE TABLE TEST_EMP03(사원이름, 봉급)
AS
SELECT ENAME, SAL FROM EMP
WHERE JOB = 'SALESMAN';

--TEST_EMP01 테이블에서 WARD의 월급을 0으로 변경
UPDATE TEST_EMP00
SET SAL =0
WHERE ENAME='WARD';

COMMIT; --위에서 수정을 위해 걸었던 LOCK이 풀림

ROLLBACK; -- COMMIT 이후 모든 진행상황 초기화

SELECT * FROM TEST_EMP00;


----

create table test(
id number(5) not NULL,               
name char(10),
address varchar2(50));

DROP TABLE TEST;

insert into TEST values(1,'1','1');
 --null 입력 불가
insert into TEST values(2,NULL,'1');
insert into TEST values(3,NULL,'1');
insert into TEST values(4,'1',NULL);
insert into TEST(ID, name) values(5,'5'); -- ADDRESS는 NOT NULL이 포함되지 않음 - 자동으로 NULL이 들어가있음

COMMIT;

SELECT * FROM TEST;
SELECT * FROM TEST WHERE NAME IS NULL;

--DELTE
DELETE FROM TEST WHERE NAME IS NULL;

DROP TABLE TEST;
DROP TABLE TEST PURGE; --휴지통 거치지 않고 바로삭제
PURGE RECYCLEBIN;

--RENAME
ALTER TABLE TEST RENAME TO EXAM;

----

create table user1(
idx     number  primary key, --식별키(중복, null 불가)
id      varchar2(10) unique, --중복 불허(null 가능)
name    varchar2(10) not null, --null 불허
phone   varchar2(15),
address varchar2(50),
score   number(6,2)  check(score >=0 and score <= 100), --check는 비교 연산자로 나타낸 true 범위 한정
subject_code  number(5),
hire_date  date default sysdate, --입력 없을 시 default 값을 null이 아닌 sysdate(오늘 날짜)로
marriage   char(1)  default 'N'  check(marriage in('Y','N')));

--제약조건 확인
select  constraint_name, constraint_type
from user_constraints
where table_name='USER1';

--시퀀스 생성/삭제
create sequence  idx_sql increment by 5 start with 1 maxvalue  20  cycle nocache;
select  idx_sql.nextval  from dual;    ---> 다음 시퀀스값표시(nextval)
select  idx_sql.currval  from dual;    ---> 현재 시퀀스값표시(currtval)
drop sequence idx_sql;

insert into TEST_EMP01 values(idx_sql.nextval, sysdate);

------

--1 insert into 테이블명 values();
--subquery 이용 - insert
--사원번호가 7902인 사원의 부서번호를 scott의 부서번호와 같게 수정
UPDATE TEST_EMP
SET DEPTNO = (select deptno from TEST_EMP where ename='SCOTT')
WHERE EMPNO='7902';

INSERT INTO TEST_EMP
SELECT * FROM EMP
WHERE EMPNO='7902'

SELECT * FROM TEST_EMP;


-----

--프로시저 : 작업을 수행하기 위한 서브시스템
-- 모드 IN : 입력전용, OUT은 출력전용(return과 같음), INOUT은 입출력
-- 오직 IN만 DEFAULT 가능

--함수 : 값을 리턴하는 프로그램
--트리거 : 특정 이벤트 발생 시 자동 실행되는 단위 (JS의 Eventlistner 생각하면 됨)

--Loop : 기본 loop, 무한 루프
--while : 입력객체 있을 때 주로 사용
--for : 출력 시 주로 사용
--Exit, Exit when : %인자로 인한 상수값으로 탈출 조건 지정
--Continue, Continue when




CREATE OR REPLACE FUNCTION FUNC02 (mydata varchar2) RETURN VARCHAR2 AS 
  grade VARCHAR2(10) := mydata;
  RES VARCHAR2(20) := NULL;
BEGIN
  CASE grade
    WHEN 'A' THEN RES := 'Excellent';
    WHEN 'B' THEN RES :='Very Good';
    WHEN 'C' THEN RES :='Good';
    WHEN 'D' THEN RES :='Fair';
    WHEN 'F' THEN RES :='Poor';
    ELSE DBMS_OUTPUT.PUT_LINE('No such grade');
  END CASE;
  RETURN RES;
END FUNC02;
--
SELECT
    FUNC02('C')
FROM
    DUAL;
--
DECLARE
  x NUMBER := 0;
BEGIN
  LOOP -- After CONTINUE statement, control resumes here
    DBMS_OUTPUT.PUT_LINE ('Inside loop:  x = ' || TO_CHAR(x));
    x := x + 1;
    CONTINUE WHEN x < 3;
    DBMS_OUTPUT.PUT_LINE
      ('Inside loop, after CONTINUE:  x = ' || TO_CHAR(x));
    EXIT WHEN x = 5;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE (' After loop:  x = ' || TO_CHAR(x));
END;
/
--
<<ASDF>>  -- Label block.
DECLARE
  i NUMBER := 5;
BEGIN
  FOR i IN 1..3 LOOP
    DBMS_OUTPUT.PUT_LINE (
      'local: ' || TO_CHAR(i) || ', global: ' ||
      TO_CHAR(ASDF.i)  -- Qualify reference with block label.
    );
  END LOOP;
END ASDF; --label 붙혔으면 label로 끝내야됨
/
--
DECLARE
  v_EMP EMP%ROWTYPE; --TYPE 정렬
  CURSOR c1 is SELECT * FROM EMP; --하나 이상의 열을담기 위해 CURSOR 사용
BEGIN
  OPEN c1;
  -- Fetch entire row into v_EMP record:
  FOR i IN 1..14 LOOP
    FETCH c1 INTO v_EMP;
    EXIT WHEN c1%NOTFOUND;
    -- Process data here
    DBMS_OUTPUT.PUT_LINE(v_EMP.Ename ||'    '|| v_emp.sal);
  END LOOP;
  CLOSE c1;
END;
/
---- 예제

--CHECK PROC
SELECT
  *
FROM
  USER_PROCEDURES;

--CHECK SOURCE
SELECT
  *
FROM
  USER_SOURCE;

--부서 번호 20인 사원의 사원번호, 이름, 봉급 구하는 PROC
SELECT EMPNO, ENAME, SAL
FROM EMP
WHERE DEPTNO=20;

SELECT EMPNO, ENAME, SAL INTO :A, :B, :C
FROM EMP
WHERE DEPTNO=20;


-- 부서 번호 20번인 사원의 사번, 이름, 봉급 (부서번호 예시 1)
CREATE OR REPLACE PROCEDURE EX01 
(
V_EMPNO IN EMP.EMPNO%TYPE, 
V_ENAME IN EMP.ENAME%TYPE,
V_DEPTNO IN EMP.DEPTNO%TYPE 
) AS 

R_EMPNO  EMP.EMPNO%TYPE;
R_ENAME  EMP.ENAME%TYPE;
R_SAL  EMP.SAL%TYPE;

CURSOR EMP_CURSOR IS --CURSOR. 1개 이상의 ROW 담을 수 있는 객체
  SELECT EMPNO, ENAME, SAL
  FROM EMP
  WHERE DEPTNO=V_DEPTNO;

BEGIN --2. 실제 작동할 CODE
OPEN EMP_CURSOR; --3 CURSOR OPEN

LOOP
FETCH EMP_CURSOR INTO R_EMPNO, R_ENAME, R_SAL ; --4 변수 대입
EXIT WHEN EMP_CURSOR%ROWCOUNT > 5 OR EMP_CURSOR%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(R_EMPNO||' '||R_ENAME||'  '||R_SAL);
END LOOP;

CLOSE EMP_CURSOR; --END 역시 사용 가능함
END EX01;


SELECT *
FROM EMP;

--부서 번호 20번인 사원의 사번, 이름, 봉급 (부서번호 예시 2)
create or replace procedure ex02
is
   v_empno   emp.empno%type;
   v_ename   emp.ename%type;
   v_sal        number(7,2);
  
 cursor emp_cursor(v_deptno  number) is  --커서에 매개변수 선언
   select empno,ename,sal
   from  emp
   where deptno = v_deptno;

begin
   open  emp_cursor(10);
   loop
   fetch emp_cursor into v_empno, v_ename,v_sal;
   exit  when emp_cursor%rowcount > 5 or
         emp_cursor%notfound;
   dbms_output.put_line(v_empno||'  '||v_ename||'  '||v_sal||'-----------');
  end loop;
  close emp_cursor;

   open  emp_cursor(20);
   loop
   fetch emp_cursor into v_empno, v_ename,v_sal;
   exit  when emp_cursor%rowcount > 5 or
         emp_cursor%notfound;
   dbms_output.put_line(v_empno||'  '||v_ename||'  '||v_sal);
  end loop;
  close emp_cursor;
end ex02;

exec ex02;

-- 사번 받아 연봉 RETURN 하는 함수
-- 단, 봉급 = 연봉 + 커미션
CREATE OR REPLACE FUNCTION GETBONG(V_EMPNO IN EMP.EMPNO%TYPE) RETURN NUMBER
  IS
  V_SAL EMP.SAL%TYPE :=0;
  V_COM EMP.COMM%TYPE :=0;
  V_TOT NUMBER :=0;
  BEGIN
  SELECT SAL, COMM INTO V_SAL, V_COM
  FROM EMP WHERE EMPNO = V_EMPNO;
  V_TOT := V_SAL*12 + NVL(V_COM,0);
  RETURN V_TOT;
END GETBONG;

SELECT EMPNO, SAL, GETBONG(EMPNO) FROM EMP;

--view 확인
SELECT * FROM MY_VIEW;
INSERT INTO MY_VIEW VALUES (9000, 123, 300);

--VIEW 특징
-- INSERT : 가능은 함. 다만 VIEW가 가진 컬럼만
-- 원본 업데이트 시 자동 업데이트

