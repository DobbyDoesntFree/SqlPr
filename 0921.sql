--숫자 함수, 날짜함수, 변환 함수, 서브쿼리
/* 숫자함수
ROUND_반올림, TRUNC_버림, MOD(M,N)_나머지, ABS_절대값
FLOOR_가우스 내림, CEIL_가우스 올림
SIGN, POWER(M,N)_제곱
*/

--Q1~2) ROUND, TRUNC, FLOOR, CEIL
SELECT TRUNC('3.141592',1),FLOOR('3.141592'),CEIL('3.141592'),ROUND('3.141592',3)
FROM DUAL;

--Q3) MOD 사원 테이블에서 급여 30으로 나눈 나머지를 출력. 이름과 급여 결과까지
SELECT E.ENAME, SAL, MOD(SAL,30) 결과
FROM SCOTT.EMP E;



--Q4)날짜함수 서식
SELECT VALUE
FROM NLS_SESSION_PARAMETERS -- KEY-VALUE 초기 DB 포맷 관리
WHERE PARAMETER ='NLS_DATE_FORMAT'; --RR/MM/DD(00~49, 2000년대), DD/MON/RR(50~99:1900년대)
/* 날짜함수
이하 7개를 상수로 >> CENTURY, YEAR, MONTH, DAY, HOURS, MINUTS, SECONDS >> 7BYTES로 표현
Ex1) 2011년 6월 7일 오전 3시 15분 47초 >> 07-JUN-11을 RETURN하며
  CENTURY, YEAR, MONTH, DAY, HOURS, MINUTS, SECONDS
  20        11    06     07   3       15      47  << 이게 MEMORY에 들어감. 즉 산술연산이 "가능"
*/
--Q5) 날짜형식 연산
SELECT ENAME, TO_CHAR(HIREDATE,'YYYY-MM-DD-Dy'), HIREDATE+3 --Dy 대신 DAY면 "월요일" 같은 형태로 출력됨
FROM SCOTT.EMP
WHERE DEPTNO=20;
--Q6) 날짜형식 추출
SELECT EXTRACT (YEAR FROM SYSDATE)
FROM DUAL;

SELECT ENAME, EXTRACT(MONTH FROM HIREDATE)
FROM SCOTT.EMP
WHERE DEPTNO=20;

--Q7) 사원테이블에서 사원의 현재까지의 근무일수 몇주 며칠인지 조회
/*
MONTHS_BETWEEN(D1,D2) : 날자 사이 개월 수  (유일하게 숫자 RETURN)
ADD_MONTH(D1,N) : D1에 N만큼 더한 월
NEXTT_DAY(D1,'CHAR') : D1 이후 지정한 요일에 해당하는 날짜
LAST_DAY : 해당 월의 마지막 날짜
*/
SELECT ENAME, HIREDATE, SYSDATE, TRUNC(SYSDATE-HIREDATE) AS "TOTAL DAY", TRUNC((SYSDATE-HIREDATE)/7,0) AS "WEEKS",ROUND(MOD((SYSDATE-HIREDATE),7),0) DAYS
FROM SCOTT.EMP
ORDER BY 4 DESC;

--Q8) 사원테이블에서 10번 부서의 사원들이 현재까지의 근무 월수
SELECT ENAME, HIREDATE, SYSDATE, TRUNC(MONTHS_BETWEEN(SYSDATE, HIREDATE),0),-- TO_DATE(HIREDATE,'YYYY-MM-DD')는 문자열을 날짜로 바꾸는 방법으로 작동하지만, TO_DATE(SYSDATE,'MM-DD-YYYY')는 이미 변환된 날짜를 날짜로 변환할 수 없다.
FROM SCOTT.EMP
WHERE DEPTNO=10
ORDER BY 4 DESC;

--Q9) 사원테이블에서 10,30번 부서 사원들의 입사일로부터 5개월이 지난 후 날짜 계산, 출력
SELECT ENAME, HIREDATE, ADD_MONTHS(HIREDATE,5) A_MONTH
FROM SCOTT.EMP
WHERE DEPTNO IN (10,30)
ORDER BY 2 DESC;

--Q10) 사원테이블에서 10번 부서사원들의 입사일로부터 돌아오는 금요일 계산
SELECT ENAME, HIREDATE, NEXT_DAY(HIREDATE, 6)
FROM SCOTT.EMP
WHERE DEPTNO=10;

--Q11)  다음 문장의 실행 결과를 알아보자.
--날짜에 사용하면 지정형식 모델에 따라 함수가 반올림되거나 버려지므로 날짜를 가장 가까운 연도 또는 달로 반올림할 수 있다.
/*
ROUND : 일을 반올림 할때 정오를 넘으면 다음날 자정을 리턴하고, 넘지 않으면 그날 자정을 리턴한다. 
        월 : 15일 이상이면 다음달 1을 출력 / 넘지 않으면  현재 달 1을 리턴
        년도: 6월을 넘으면 다음해 1월1일 리턴 / 넘지 않으면 현재 1월 1일 리턴
        
TRUNC : 일을 절삭하면 그날 자정출력, 월을 절삭 그 달 1을출력, 년도를 절삭하면 금년 1월1일 리턴          

*/
SELECT   to_char(sysdate, 'YY/MM/DD HH24:MI:SS') normal, 
          to_char(trunc(sysdate), 'YY/MM/DD HH24:MI:SS') trunc, 
          to_char(round(sysdate), 'YY/MM/DD HH24:MI:SS') round 
          FROM  dual;

SELECT to_char(hiredate, 'YY/MM/DD HH24:MI:SS') hiredate, 
to_char(round(hiredate,'dd'), 'YY/MM/DD') round_dd, 
to_char(round(hiredate,'MM'), 'YY/MM/DD') round_mm, 
to_char(round(hiredate,'YY'), 'YY/MM/DD') round_yy
FROM  SCOTT.EMP     
WHERE  ENAME='SCOTT';

SELECT TO_CHAR(TO_DATE('98','RR'),'YYYY') test1, --RR/MM/DD(00~49, 2000년대), DD/MON/RR(50~99:1900년대)
TO_CHAR(TO_DATE('05','RR'),'YYYY') test2, 
TO_CHAR(TO_DATE('98','YY'),'YYYY') test3, 
TO_CHAR(TO_DATE('05','YY'),'YYYY') test4 
FROM  dual;

SELECT   '000123',  to_number('000123')  FROM  dual;

--Q12)  다음 문장의 실행 결과를 알아보자.
SELECT   to_timestamp_tz ('2004-8-20 1:30:00 -3:00', 'YYYY-MM-DD HH:MI:SS TZH:TZM')
FROM dual;-- CHAR, VARCHAR2 데이터 타입을 TIMESTAMP WITH TIME ZONE 데이터 타입으로 리턴  

SELECT to_timestamp('2004-8-20 1:30:00', 'YYYY-MM-DD HH:MI:SS') 
FROM dual;-- CHAR, VARCHAR2 데이터 타입을 TIMESTAMP데이터 타입으로 리턴 

SELECT sysdate, sysdate+to_yminterval('01-03') "15Months later" 
FROM  dual;  ---- CHAR, VARCHAR2 데이터 타입을 INTERVAL YEAR TO MONTH 데이터 타입으로 리턴 

SELECT  sysdate, sysdate+to_dsinterval('003 17:00:00') as "3days 17hours later" 
FROM dual; ---- CHAR, VARCHAR2 데이터 타입을 INTERVAL DAY TO SECOND 데이터 타입으로 리턴 

--Q13)  다음 문장의 실행 결과를 알아보자.
 --EMP 테이블의 사원이름,  매니저 번호, 매니저번호가 null이면 ‘대표’ 로 표시하고, 매니저번호가 있으면 '프로'으로 표시. 
 SELECT ename, mgr, NVL2(mgr, mgr||'프로','대표') 
 FROM SCOTT.EMP;


--Q14) EMP 테이블의 사원이름 , 업무, 업무가 'CLERK‘ 인 경우 NULL로 나오도록 리턴.
SELECT  ename, job, NULLIF(job,'CLERK') AS result 
FROM  SCOTT.EMP;


--Q15)EMP테이블에서 이름, 보너스,연봉, 보너스가 null 아닌 경우 보너스를, 보너스가 null인 경우엔 연봉을,
--모두 null인 경우엔 50으로 리턴.
SELECT ename, comm,sal, COALESCE(comm,sal,50) result 
FROM SCOTT.EMP;
--Q16) decode함수를 이용하여 급여가 1000보다 작으면 ‘A’, 1000이상 2500미만이면 ‘B’, 2500이상이면 ‘C’로 표시하라.
SELECT  ename, sal, DECODE(SIGN(sal-1000),-1,'A', DECODE(SIGN(sal-2500),-1,'B','C')) grade 
FROM  SCOTT.EMP;

--Q17)case 함수를 이용하여 급여가 1000보다 작으면 ‘A’, 1000이상 2500미만이면 ‘B’, 2500이상이면 ‘C’로 표시하라. 
SELECT ename,sal, 
        CASE WHEN sal < 1000 THEN 'A' 
             WHEN sal>=1000 AND sal<2500 
             THEN 'B' ELSE 'C' END  AS grade 
FROM SCOTT.EMP ORDER BY grade;

--Q18) ROLLUP, CUBE : 그룹핑한 결과를 상호 참조열에 따라 상위집계 산출 [소계]
/*
ROLLUP : 정규 그룹화 행, 하위포함하는 결과(요약본) 리턴
        - GROUP BY 절에 () 이용 > 오른쪽에서 왼쪽으로 1개씩 그룹화 [아래 소계]
        - N+1 개의 SELECT 문을 UNION ALL로 지정
CUBE : ROLLUP 결과를 교차 도표화 행을 포함하는 집합 리턴 [위 소계]
        - GROUPBY 확장 기능
        - 집계 연산 시 결과 집합에 추가 행 생성
        - GROUP BY 절에 N개의 열이 있을 경우 상위집계 조합수는 2의 N승
* ROLLUP은 소계 시 하위 조합의 일부에 합을 나타냄, CUBE는 소계 시 하위 조합의 모든 그룹의 합과 총계를 나타냄        
*/
SELECT DEPTNO, COUNT(*), SUM(SAL)
FROM SCOTT.EMP
GROUP BY ROLLUP(DEPTNO);

--Q19) 사원 테이블에서 부서별, 직업별 급여 합 조회 시 ROLLUP 집게
SELECT DEPTNO,JOB, COUNT(*), SUM(SAL)
FROM SCOTT.EMP
GROUP BY ROLLUP (DEPTNO, JOB); --이러면 DEPTNO 아래에 JOB (우측에서 좌측 순서로 그룹화)

--Q20) 사원 테이블에서 부서, 직급별 급여 합 조회시 CUBE
SELECT DEPTNO,JOB, COUNT(*), SUM(SAL)
FROM SCOTT.EMP
GROUP BY CUBE (DEPTNO, JOB); --이러면 DEPTNO 아래에 JOB (좌측에서 우측 순서로 그룹화)

--Q21) GROUPING 함수는 ROLLUP, CUBE와 같이 사용
/*
- 하나의 열을 인수로 갖는다
- 이때 인수는 GROUP BY 절에 컬럼과 같아야 한다
  - 0(해당 열을 그대로 사용하여 집계 값을 계산 OR 해당 열의 NULL 값이 저장된 것을 의미)
  - 1(해당 열을 그대로 사용하지 않고 집계 값을 계산 OR 해당 열의 NULL 값이 그룹화의 결과로 ROLLUP 또는 CUBE에 RETURN 값으로 구현)
- SELECT 문 뒤에 지정함
- 소계 행을 1로 빠르게 찾을 수 있음 + 그룹화 가능
*/
SELECT DEPTNO, JOB, COUNT(*), SUM(SAL), GROUPING(DEPTNO), GROUPING(JOB)
FROM SCOTT.EMP
GROUP BY CUBE (DEPTNO, JOB);

--Q22) GROUPING SETS : GROUP BY 뒤에 작성
--(DEPTNO, JOG, MGR) (DEPTNO,MGR) (JOB, MGR)
SELECT DEPTNO, JOB, MGR, AVG(SAL) --칼럼 수 4
FROM SCOTT.EMP
GROUP BY DEPTNO, JOB, MGR
UNION ALL --UNION ALL 사용으로 묶음
SELECT DEPTNO, NULL, MGR, AVG(SAL)--칼럼 수 4
FROM SCOTT.EMP
GROUP BY DEPTNO, MGR
UNION ALL --UNION ALL 사용으로 묶음
SELECT NULL, JOB, MGR, AVG(SAL)--칼럼 수 4
FROM SCOTT.EMP
GROUP BY JOB, MGR; --마지막은 NULL 없음

SELECT DEPTNO, JOB, MGR, AVG(SAL)
FROM SCOTT.EMP
GROUP BY GROUPING SETS ((DEPTNO, JOB, MGR),(DEPTNO, MGR), (JOB,MGR));


--Q23)
SELECT DEPTNO,JOB, MGR, SUM(SAL)
FROM SCOTT.EMP
GROUP BY ROLLUP (DEPTNO, (JOB, MGR)); --조합열 (JOB, MGR)

/*
    1)GROUP BY  GROUPING SETS(A,B,C)  =  GROUP BY  A  UNION ALL     
                                         GROUP BY  B  UNION ALL 
                                         GROUP BY  C  UNION ALL 
                                         
    2)GROUP BY  GROUPING SETS(A,B,(B,C))=  GROUP BY  A  UNION ALL   
                                           GROUP BY  B  UNION ALL 
                                           GROUP BY  B,C
                                           
    3)GROUP BY  GROUPING SETS((A,B,C))=  GROUP BY A,B,C 
    
    4)GROUP BY  GROUPING SETS(A,(B),()) =  GROUP BY A   UNION ALL   
                                           GROUP BY B   UNION ALL   
                                           GROUP BY ()
*/
--Q24) 분석함수 : MAX, MIN, COUNT, LEAD, RANK, RATIO_TO_REPORT, ROW_NUMBER, SUM, AVG
/*
ARGS는 최대 3개까지
[형식] 테이블에서 몇줄에서 몇출까지 그룹핑 - 분석함수의 결과 RETURN
  테이블-선택행-그룹핑-정렬-집계 리턴
  
  SELECT 분석함수 (ARGS) OVER(
  [PARTITION BY] 1차 정렬
  [ORDER BY] 2차 정렬
  ])
*/

--사원번호. 사원이름, qn서번호, 봉그, 부서내 급여 많은 순위부터 RANK
SELECT EMPNO, ENAME, DEPTNO, SAL, DENSE_RANK() OVER(partition by DEPTNO ORDER BY SAL DESC) "RANK"
FROM SCOTT.EMP;

--Q25)CUME_DIST(): 누적된 분산정도 출력
--20번 부서 사원 이름, 봉급, 누적분산 출력
SELECT ENAME, SAL, CUME_DIST() OVER (ORDER BY SAL) "RANK"
FROM SCOTT.EMP
WHERE DEPTNO=20;

--Q26) NTILE(N) : 버킷 분할
-- 사원 봉급기준 4등분
SELECT ENAME, SAL, NTILE(4) OVER (ORDER BY SAL) "RES"
FROM SCOTT.EMP

--Q27) 사원이름, 부서번호, 봉급, 전체 봉급 합계, 부서별 봉급 합계
SELECT ENAME, SAL, DEPTNO, SUM(SAL) OVER () "TOTAL_SUM", SUM(SAL) OVER (PARTITION BY DEPTNO) "DEPT SUM"
FROM SCOTT.EMP;

--Q28) 사원이름, 직업, 봉급, 직업별 평균, 직업 중 최대 급여
SELECT ENAME, JOB, SAL, DEPTNO, AVG(SAL) OVER (PARTITION BY JOB) "AVG SAL", MAX(SAL) OVER (PARTITION BY JOB) "MAX SAL"
FROM SCOTT.EMP;

--Q29) 사원이름, 부서번호, 봉급 합계를 3줄씩 더한 결과, 누적합계 출력
SELECT ENAME, DEPTNO, SAL, SUM(SAL) OVER (ORDER BY SAL ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) "SUM1", SUM(SAL) OVER (ORDER BY SAL ROWS UNBOUNDED PRECEDING)"SUM2"
FROM SCOTT.EMP;

--Q30) RATIO_TO_REPORT 이용해서 해당 구간이 차지하는 비율 RETURN
SELECT ENAME, SAL, RATIO_TO_REPORT(SAL) OVER() AS "비율"
FROM SCOTT.EMP;
--총 인건비를 50000으로 설정 시 기준 비율에 따른 다른 직급의 봉급
SELECT ENAME, SAL, TRUNC(RATIO_TO_REPORT(SAL) OVER()*50000) AS "인상예정금"
FROM SCOTT.EMP;

--Q31) LAG : GROUPING 내에서 상대적 ROW 참조. 기본값, 정렬 컬럼보다 작은 값
SELECT ENAME, DEPTNO, SAL, LAG(SAL, 1, 0) OVER (ORDER BY SAL) AS NEXT_SAL01,
LAG(SAL, 1, SAL) OVER (ORDER BY SAL) AS NEXT_SAL02,
LAG(SAL, 1, SAL) OVER (PARTITION BY DEPTNO ORDER BY SAL) AS NEXT_SAL03
FROM SCOTT.EMP;

--Q32) LEAD : GROUPING 내에서 상대적 ROW 참조. 기본값, 정렬 컬럼보다 큰 값
SELECT ENAME, DEPTNO, SAL, LEAD(SAL, 1, 0) OVER (ORDER BY SAL) AS NEXT_SAL01,
LEAD(SAL, 1, SAL) OVER (ORDER BY SAL) AS NEXT_SAL02,
LEAD(SAL, 1, SAL) OVER (PARTITION BY DEPTNO ORDER BY SAL) AS NEXT_SAL03
FROM SCOTT.EMP;


select job, DEPTNO, count(*)
from EMP
group by grouping sets(job,deptno)
having count(*)>2;