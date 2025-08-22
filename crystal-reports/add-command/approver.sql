---Click on Database Expert and add command

SELECT  DISTINCT T5."U_NAME",T1."DocEntry"
			FROM  OWDD T1 
			RIGHT JOIN WDD1 T2 ON T2."WddCode" = T1."WddCode" AND T2."Status" ='Y'
			INNER JOIN OUSR T5 ON T5."USERID" = T2."UserID"
			INNER JOIN OWTM T3 ON T3."WtmCode" = T1."WtmCode"
			INNER JOIN WTM2 T4 ON T4."WtmCode" = T3."WtmCode" AND T2."StepCode" = T4."WstCode"
			WHERE  T1."ObjType"='59'AND T4."SortId" = '1' 
			AND T2."UpdateDate" is not null