SET @start_d:='20141001';
SET @end_d:='20150930';

SELECT SQL_BIG_RESULT distcode,p1.check_hosp as HOSPCODE,p1.CID,p1.name,p1.lname,p1.birth,p1.check_typearea,n1.CID cid1,n1.DATE_SERV,
if(TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d) IN(18,30),'10',
if(TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 1 MONTH) IN(18,30),'11',
if(TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 2 MONTH) IN(18,30),'12',
if(TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 3 MONTH) IN(18,30),'01',
if(TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 4 MONTH) IN(18,30),'02',
if(TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 5 MONTH) IN(18,30),'03',
if(TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 6 MONTH) IN(18,30),'04',
if(TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 7 MONTH) IN(18,30),'05',
if(TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 8 MONTH) IN(18,30),'06',
if(TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 9 MONTH) IN(18,30),'07',
if(TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 10 MONTH) IN(18,30),'08',
if(TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 11 MONTH) IN(18,30),'09',0
)))))))))))) as age_ok
FROM (
SELECT SQL_BIG_RESULT 
			p.*,age(DATE_FORMAT(CONCAT(@b_year,'0701'),'%Y%m%d'),birth,'y') as age_y
		FROM
			t_person_db p
		WHERE LENGTH(TRIM(p.cid))=13 AND p.TYPEAREA in('1','3')
		ORDER BY  p.D_UPDATE DESC ,p.TYPEAREA ASC
) p1
left join chospital h on p1.HOSPCODE=h.hoscode
LEFT JOIN
(
SELECT n.CID,max(n.DATE_SERV) DATE_SERV
FROM (select pn.cid,nt.* from nutrition nt left join person pn on nt.HOSPCODE=pn.HOSPCODE and nt.pid=pn.pid) n
WHERE n.DATE_SERV BETWEEN @start_d AND @end_d AND n.CHILDDEVELOP in ('1','2','3')
GROUP BY n.CID
) n1 ON p1.CID=n1.CID
WHERE check_typearea in('1','3') AND p1.DISCHARGE='9' AND LENGTH(trim(p1.CID))=13 AND
(TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d) IN(18,30) OR
TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 1 MONTH) IN(18,30) OR
TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 2 MONTH) IN(18,30) OR
TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 3 MONTH) IN(18,30) OR
TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 4 MONTH) IN(18,30) OR
TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 5 MONTH) IN(18,30) OR
TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 6 MONTH) IN(18,30) OR
TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 7 MONTH) IN(18,30) OR
TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 8 MONTH) IN(18,30) OR
TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 9 MONTH) IN(18,30) OR
TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 10 MONTH) IN(18,30) OR
TIMESTAMPDIFF(MONTH,p1.BIRTH,@start_d + INTERVAL 11 MONTH) IN(18,30)
)
GROUP BY p1.check_hosp,p1.CID
order by date_serv desc