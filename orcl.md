# Oracle

> 목차

- part 0

  - Tools for string
  - Tools for Int
  - Tools for date
  - Tools for Analistic
  - Tools for Null Management

- part 1

  - select, from, where
  - having - order by
  - 집계함수 group by
  - 소계(cube, rollup), group, grouping set
  - Subquery - Join

- part 2
  - 데이터 무결성(제약조건)
  - Table CRUD - 시퀀스 - view, index
  - pl/sql - 함수, 프로시저, 트리거

<br />

## 기본 형태

```sql
SELECT JOB, AVG(SAL), SUM(SAL) -- 1열 제목에 나열할 값
FROM SCOTT.EMP -- 참조할 DB
GROUP BY JOB -- 조건절
HAVING AVG(SAL) >= 3000 -- 조건절
ORDER BY 1; -- 조건절
```

<br />

## Part 0

<br />

### Tools for string

| Edit String           | Description                                                                 |
| --------------------- | --------------------------------------------------------------------------- |
| LOWER(char)           | 문자열을 소문자로                                                           |
| UPPER(char)           | 문자열을 대문자로                                                           |
| INITCAP(char)         | 첫 번째 문자를 대문자로 나머지 문자는 소문자로                              |
| CONCAT(char1, char2)  | 두 문자를 결합                                                              |
| SUBSTR(s, m ,[n])     | m 번째 자리부터 길이가 n개인 문자열을 반환                                  |
| INSTR(s1, s2 , m, n)  | 문자열 검색, s1의 m번째부터 s2 문자열이 나타나는 n번째 위치 (없으면 0 반환) |
| LENGTH(s)             | 문자열의 길이                                                               |
| CHR(n)                | ASCII값                                                                     |
| (R)LPAD(s1,n,[s2])    | s1 보다 n만큼 떨어진 곳에 s2 삽입                                           |
| TRIM                  | 특정 문자 제거                                                              |
| REPLACE(s,from,to)    | s문자열에서 from을 to로 변경                                                |
| TRANSLATE (s,from,to) | s문자열에서 from을 to로 리턴                                                |

### Tools for Int

| Edit Int   | Description           |
| ---------- | --------------------- |
| ROUND      | 반올림                |
| TRUNC      | 버림                  |
| FLOOR      | 올림                  |
| CEIL       | 내림                  |
| POWER(M,N) | 제곱                  |
| MOD(M,N)   | M을 N으로 나눈 나머지 |
| ABS        | 절대값                |

  </BR>

### Tools for date

| Edit Date                         | Description                                                |
| --------------------------------- | ---------------------------------------------------------- |
| SYSDATE                           | 현재 시각                                                  |
| EXTRACT(YEAR\* FROM SYSDATE)      | 현재 시각에서 연\* 추출                                    |
| TO_CHAR(HIREDATE,'YYYY-MM-DD-Dy') | HIREDATE 테이블(날짜)을 'YYYY-MM-DD-DY'로 재정렬           |
| MONTHS_BETWEEN(D1,D2)             | 날자 사이 개월 수 (숫자 RETURN)                            |
| ADD_MONTH(D1,N)                   | D1에 N만큼 더한 월 (월 값이 RETURN)                        |
| NEXTT_DAY(D1,'CHAR')              | D1 이후 지정한 요일에 해당하는 날짜 (MON 같은 날짜 RETURN) |
| LAST_DAY                          | 해당 월의 마지막 날짜 (날짜 RETURN)                        |
| ROUND                             | 일자 - 12시 기준, 월 - 15일 기준, 년 - 6월 기준 반올림     |
| TRUNC                             | 일자 - 당일 자정, 월- 당월 1일, 년 - 해당 년의 1월 1일     |

- Year 대신 Month 추출 가능

  </BR>

### Tools for Analistic

| Analistic Function              | Description                                      |
| ------------------------------- | ------------------------------------------------ |
| MAX                             | 범위 내 최대 값 Return                           |
| MIN                             | 범위 내 최소 값 Return                           |
| COUNT                           | 범위 내 개수 Return                              |
| LEAD() OVER()\*                 | 상위 열 참조 값 Return. 상세 설명 하단 별첨      |
| RANK() OVER()\*                 | 순위 (동점 발생 시 후순위 생략)                  |
| DENSE_RANK() OVER()\*           | 순위 (동점 발생 시 후순위 생략하지 않음)         |
| CUME_DIST() OVER (ORDER BY SAL) | 누적 분산                                        |
| RATIO_TO_REPORT() OVER()\*      | 0~1 사이로 나타낸 비율. 상세 설명 하단 별첨      |
| ROWNUM, ROW_NUMBER()\*          | 열 번호 부여                                     |
| SUM                             | 합계 값                                          |
| AVG                             | 평균 값                                          |
| Partition                       | 기준값으로 분할(ROLLUP과 비슷하지만 소계는 없음) |

</BR>

```sql
SELECT DENSE_RANK() OVER(partition by DEPTNO ORDER BY SAL DESC) "RANK"
```

- DEPTNO에 따라 집계된 SAL의 RANK 산출 (내림차순)

```SQL
SELECT RANK() OVER(ORDER BY SAL DESC, COMM DESC)
```

- 동점 제거 위해선 위와 같이 2차 기준을 탑재하면 됨
- 즉 RANK 사용법은 아래와 같음 (위 예시에서 괄호 안에 있는 것들을 먼저 하면 됨)
  1.  기준 테이블 만들기
  2.  순위 설정
  3.  함수 설정

```sql
LEAD(SAL, 1, SAL) OVER (ORDER BY SAL)
```

- LEAD(참조할 열, 가져올 값의 위치 (현 위치 대비 몇번째 이후?), 값이 없을 경우 참조할 값(고정값, 테이블 둘 다 가능))

```SQL
 SELECT RATIO_TO_REPORT(sal) OVER(PARTITION BY job)
```

- JOB으로 소계된 것 안에서 SAL 비율
- 만약 OVER() 이면 전체 구간에서 SAL의 비율

```SQL
SELECT ROWNUM
SELECT ROW_NUMBER() OVER (PARTITION BY JOB ORDER BY ENAME)
```

- 후자와 같이 소계에서의 번호 한정해서 부여 가능

</BR>

### Tools for Null Management

| Tool names                   | Description                                                            |
| ---------------------------- | ---------------------------------------------------------------------- |
| NVL(기준값,대체값)           | 기준값이 NULL이면 대체값으로 적용. NULL이 아니면 그대로 기준값 적용    |
| NVL2(기준값, 설정값, 대체값) | 기준값이 NULL이면 대체값으로 적용. NULL이 아니면 설정값으로 적용       |
| NULLIF(A,B)                  | A, B 같으면 NULL, 다르면 A RETURN                                      |
| COALESCE(A,B,C,D)            | 앞에서부터 NULL이 아닌 최초 값 반환(A,B,C,D는 서브쿼리 역시 설정 가능) |

- COALESCE(A,B)와 같이 기준이 2개면 NVL, NVL2 사용을 권장

</BR>

### Tools for Case Management

| Tool names                            | Description                                                                                                                                                         |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| DECODE                                | ![img](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Ft1.daumcdn.net%2Fcfile%2Ftistory%2F99D8F6415CFFC30731)                           |
| CASE WHEN "##" THEN '@' ELSE '$$' END | ![img](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2F03vYC%2FbtqE5fwA1US%2FUf4jRvoPOFKFeEYGBcuZ0k%2Fimg.png) |
| DISTINCT                              | 중복 값 제거                                                                                                                                                        |

</BR>

## Part 1

### SELECT, FROM, WHERE

기초적인 3가지

```sql
SELECT JOB, AVG(SAL), SUM(SAL) -- 1열 제목에 나열할 값
FROM SCOTT.EMP -- 참조할 DB
WHERE JOB != IS 'CLERK' -- 조건
```

### SELECT

```SQL
SELECT FIRST_NAME||' '||LAST_NAME AS "사원명"
```

- 위와 같이 다양한 형태의 내용 및 열 이름 TEXT 생성 가능

  - AS 이후 "" 안에 들어가는 것이 제목

- 사용 가능한 요소들
  - "\*" : 전체 출력
  - NVL(COMM,0) : COMM 참조하되 NULL VALUE를 0으로 세팅

<br />

> INTO와 엮어서 사용 시

```SQL
SELECT * INTO r_customer
FROM customers
WHERE customer_id = 100;
```

특정한 조건을 만족하는 새로운 테이블 생성 가능

- 위 예시의 경우 customers테이블에서
- customer_id = 100인 모든 row를
- r_customer라는 새로운 테이블에 저장

<br />

### FROM

> 참조할 원본 테이블. 사용법은 아래와 같음

```SQL
FROM EMP E, SALGRADE S -- 테이블에 별칭 지정 가능

FROM DUAL; -- 기본 제공되는 빈 테이블. 결과값 확인 시 한시적 사용
```

<br />

### WHERE

> 조건절

#### 사용 가능한 조건목록

|                |                                                                        |
| :------------: | :--------------------------------------------------------------------: |
|      산술      |                              +, -, \*, /                               |
|      논리      |                                >, <, =                                 |
|  LIKE 정규식   |                S% : S로 시작, %S% : S 포함, %S : S로 끝                |
|      NOT       |                   !=, <>(국제표준), ^= 로 대용 가능                    |
| BETWEEN 사이값 |               Between A and B (Not between A and B 가능)               |
| IS (NOT) NULL  |                              NULL 값 체크                              |
|  IN 조건 추출  |          IN (7902,7788, 7566) : 괄호 안과 일치한 것들 가져옴           |
| ANY 조건 추출  |    ( >, <, = ) ANY (7902,7788, 7566) : 조건이 하나라도 맞으면 추출     |
| ALL 조건 추출  | ( >, <, = ) ALL (7902,7788, 7566) : 괄호 안이 조건에 모두 해당 시 추출 |
|    OR, AND     |                        최소 1개 성립, 모두 성립                        |

- = ANY 형식으로 시작할 경우 IN 과 동일한 의미를 가짐
- NVL 역시 응용 가능

```SQL
WHERE SAL  BETWEEN 1700 AND 1300;
WHERE EMPNO IN (7902,7788, 7566);
WHERE PNAME LIKE '%@_%' ESCAPE '@' --ESCAPE는 단순 공백
WHERE COMM = NVL(COMM,0);
WHERE  JOB NOT IN ('MANAGER', 'CLERK', 'ANALYST');
```

<br />

### 그룹함수

> GROUP BY
>
> HAVING (반드시 GROUP BY와 함께 사용해야하는 조건절)

```sql
SELECT DEPTNO, COUNT(*), SUM(SAL)
FROM SCOTT.EMP
GROUP BY DEPTNO
HAVING  COUNT(*)  > 4 ;
```

- HAVING 을 이용해서 집계함수결과로 그룹을 제한 한다
- HAVING 절은 반드시 GROUP BY, SELECT에 포함된 것들을 기준으로 잡아야
  - WHERE과 비슷하지만 WHERE은 단일 값 기준, HAVING은 테이블 자체에서 FILTERING

> ORDER BY

```sql
SELECT ROWNUM, ROWID, ENAME, SAL, HIREDATE,DEPTNO
FROM SCOTT.EMP
ORDER BY   5  ASC ;
```

- 정렬 기준값 설정
- 위 같이 숫자로 5번째 설정하거나 열 이름 가져와도 됨

<br />

### 소계 Rollup, Cube, Grouping sets

<br />

> Rollup

```sql
SELECT DEPTNO,JOB, MGR, SUM(SAL)
FROM SCOTT.EMP
GROUP BY ROLLUP (DEPTNO, (JOB, MGR)); --조합열 (JOB, MGR)
```

- 왼쪽에서 오른쪽 순서로 기준
- 가장 왼쪽 (위 경우 deptno) 기준으로 Grouping
- 항목별 소계를 아래에 기준값 아래에 제공

<br />

> Cube

```sql
SELECT DEPTNO,JOB, MGR, SUM(SAL)
FROM SCOTT.EMP
GROUP BY ROLLUP (DEPTNO, (JOB, MGR)); --조합열 (JOB, MGR)
```

- Rollup과 달리 합한 값을 각 항목 "위"에 제공
- Rollup과 비슷하지만 그룹화된 소계 뿐 아니라 총계 역시 제공
- 괄호 묶으면 괄호 안의 것들이 동시에 들어있는 경우만 나열됨

<br />

> Grouping sets(a,b)

```SQL
select job, DEPTNO, count(*)
from EMP
group by grouping sets((job,deptno))
having count(*)>2;
```

- job, deptno 각각 union 한 값들을 묶은 값
- (job, deptno)의 경우 각각 따로 표시됨
- ((job, deptno))의 경우 위 값을 다시 하나로 묶은 값 () 유무에 따라 결과값이 달라짐

<br />

### Subquery

> 조건을 query 자체로 선택

<br />

#### 단일 행 선택 예시

> 조건행 추출 결과가 1개 행일 경우

<br />

```sql
SELECT ENAME, SAL
FROM EMP
WHERE SAL >(SELECT SAL FROM EMP WHERE ENAME ='JONES');
```

- 비교 연산자 (>, <, ==, >=, <=, !=) 사용으로 조건 적용

<br />

#### 다중 행 선택 예시

> 조건행 추출 결과가 2개 이상의 행일 경우

```sql
SELECT ENAME, MGR, DEPTNO
FROM EMP
WHERE (MGR, DEPTNO) IN (SELECT MGR, DEPTNO FROM EMP WHERE ENAME IN ('FORD', 'BLAKE'));
```

- 복수 행 연산자 (IN, ANY, ALL) 사용으로 비교
  | Tools |Description |
  |---|---|
  | IN | 목록에 있는 임의의 값과 동일하면 참 |
  | ANY | 서브쿼리에서 리턴된 각각의 값과 비교하여 하나라도 참이면 참 |
  | ALL | 서브쿼리에서 리턴된 모든 값과 비교하여 모두 참이어야 참 |
  | NOT| 위의 도구들 앞에 붙어 부정문 적용 Ex) NOT IN|

> 테이블 비교 시

```sql
SELECT ENAME, JOB, HIREDATE, SAL
FROM EMP E
WHERE EXISTS (SELECT 1 FROM EMP WHERE E.EMPNO = MGR)
ORDER BY 1;
```

- EMP 두 개를 비교하기 위해 EMP E로 구분
  - 연산량 줄이기 위함
- EXISTS는 1개 열을 리턴할 경우 사용
- EMPNO 테이블 두개 열어두고 비교한다 생각하면 됨

> 다른 예시

![img](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FcxNRTb%2FbtqDFpWMmKF%2FDE2VN34PD0NVgG4gFkUXwk%2Fimg.png)

<br />

### JOIN

![img](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FwMSwV%2FbtrqM3jppvX%2F1b8V5V1DWoOR8Twfm5Ku40%2Fimg.png)

![img](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FckqNaE%2FbtrqM5hfiTC%2FiXAVmelfCO2GZDTzogcwK0%2Fimg.png)

<br />

| TOOLS          | DECRIPTION                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| INNER          | 두 개의 테이블에서 TRUE 만 RETURN, FALSE 또는 NULL은 추출되지 않음 (위 예시와 같음)                                                                                                                                                                                                                                                                                                                                                                                                            |
| OUETR (ANSI)   | ![img](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2Fb1mNip%2FbtrqOgP26CZ%2Fd3fcxsbp6YjfM1WtbJ68u0%2Fimg.png) <br /> 주 테이블은 다 나오고, 종 테이블은 TRUE 만 RETURN, 나머진 NULL                                                                                                                                                                                                                                                     |
| OUETR (ORACLE) | ![img](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2Fdjsf36%2FbtrqMRXMg68%2F1Ti5fX68Qxk0RA8Ye754x1%2Fimg.png) <br /> 주 테이블은 다 나오고, 종 테이블은 TRUE 만 RETURN, 나머진 NULL                                                                                                                                                                                                                                                     |
| NONEQUI        | 범위 구할 때 사용 <br /> SELECT E.ENAME, E.SAL, S.GRADE <br /> FROM EMP E, SALGRADE S <br /> WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL;                                                                                                                                                                                                                                                                                                                                                          |
| CROSS (ANSI)   | ![img](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FFh4SA%2FbtrqNx523j4%2FowLnEkWRC88CpvFyPvv1U1%2Fimg.png) <br /> ![img](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2F3MQG9%2FbtrqNK5nP0J%2FigtPwr0XG48Ap3lsKVotjk%2Fimg.png) <br /> FROM M,S라면 S(뒤)에서 M(앞)으로 컬럼값 비교 <br /> (두 테이블의 모든 데이터를 서로 한 번씩 조인 - 작업량은 두 테이블의 행 값을 곱한 값) |
| CROSS (ORACLE) | ![img](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2Fvz3ky%2FbtrqMv8XfNK%2FNTzP8VnQTQxGvGsH6SVe7K%2Fimg.png) <br /> FROM M,S라면 S(뒤)에서 M(앞)으로 컬럼값 비교 <br /> (작업량은 칼럼의 행 개수 곱이 됨)                                                                                                                                                                                                                               |
|                |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |

<br />

## Part 2

<br />

### Constraint

|             |                                                                                                                                                                                           |
| ----------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| NOT NULL    | NULL 값 삽입 금지 <br /> VALUE1 VARCHAR2(10) NOT NULL                                                                                                                                     |
| UNIQUE      | 동일 값 삽입 금지 (NULL은 가능하나 NULL 역시 1개만 가능) <br /> VALUE2 VARCHAR2(10) UNIQUE                                                                                                |
| PRIMARY KEY | UNIQUE와 비슷하게 고유값을 의미하지만 NULL 불가 <br /> VALUE3 VARCHAR2(10) PRIMARY KEY                                                                                                    |
| FOREIGN KEY | 타 테이블의 PRIMARY KEY여야하고 해당 테이블의 컬럼(행)에 삽입되지 않은 값은 사용 불가 <br /> VALUE4 VARCHAR2(10) REFERENCES 참조할*테이블(참조할*테이블의\_PRIMARY_KEY) ON DELETE CASCADE |
| CHECK       | 특정 범위 혹은 특정 값만 들어올 수 있게 함 <br /> VALUE5 VARCHAR2(10) CHECK(VALUE5 BETWEEN 1 AND 10) <br /> VALUE6 VARCHAR2(10) CHECK(VALUE6 IN ('A', 'B'))                               |
| DEFAULT     | NULL 삽입 시 대체 값 설정 <br /> VALUE7 VARCHAR2(10) DEFAULT '홍길동'                                                                                                                     |

<br />
 
### Table CRUD

<br />

#### Create

```sql
CREATE TABLE TEST_EMP02(사원이름, 봉급)
AS
SELECT ENAME, SAL FROM EMP;
```

<br />

#### Read

> Part1 내용이 곧 read

<br />

#### Update

<br />

```sql
--내용 변경
create table test(
id number(5) not NULL,
name char(10),
address varchar2(50));
--test라는 table 생성
--test는 id, name, address 3 가지를 인수로 가지며 id는 null이 될 수 없음

insert into TEST values(1,'1','1');
insert into TEST values(2,NULL,'1');
insert into TEST values(3,NULL,'1');
insert into TEST values(4,'1',NULL);
insert into TEST(ID, name) values(5,'5');
-- ADDRESS는 NOT NULL이 포함되지 않음
-- 마지막과 같이 값이 빌 경우 자동으로 NULL이 들어감
```

```sql
ALTER TABLE TEST RENAME TO EXAM; --Table 자체 이름 변경
```

#### Delete

```sql
DELETE FROM TEST WHERE NAME IS NULL; -- 항목 삭제

DROP TABLE TEST; -- 테이블 삭제
DROP TABLE TEST PURGE; -- 테이블 휴지통 거치지 않고 바로삭제
```

<br />

### pl/sql

<br />

#### Function

> return 값이 있는 module

```sql
CREATE OR REPLACE FUNCTION GETBONG(V_EMPNO IN EMP.EMPNO%TYPE) RETURN NUMBER
  IS
  V_SAL EMP.SAL%TYPE :=0; -- 기본 값 설정
  V_COM EMP.COMM%TYPE :=0;
  V_TOT NUMBER :=0;
  BEGIN
  SELECT SAL, COMM INTO V_SAL, V_COM
  FROM EMP WHERE EMPNO = V_EMPNO;
  V_TOT := V_SAL*12 + NVL(V_COM,0);
  RETURN V_TOT;
END GETBONG;
```

<br />

#### Procedure

> return 값이 없고 내용을 실행만 하는 module. 주로 table CRUD 사용

```sql
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
   dbms_output.put_line(v_empno||'  '||v_ename||'  '||v_sal);
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
```

<br />

#### Trigger
