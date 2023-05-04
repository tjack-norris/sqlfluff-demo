SELECT column1, 
count(*) as column2, column3
,column4
    FROM
{{ foo }}
WHERE column1 = 'bar' 