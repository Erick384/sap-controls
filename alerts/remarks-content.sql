SELECT 
    C.CardCode, C.CardName, O.DocEntry AS 'SalesOrder', O.Remarks, R.DocNum AS 'ReceiptNo', R.DocDate
FROM 
    ORDR O
    INNER JOIN OCRD C ON C.CardCode = O.CardCode
    INNER JOIN ORCT R ON R.CardCode = O.CardCode
WHERE 
    O.Remarks LIKE '%HOLD%' 
    AND R.DocDate = CONVERT(DATE, GETDATE())  -- payment posted today


/*
This alerts is used to find the sales order that has a remark "HOLD" and the payment is posted today.
*/