--Query to generate withholding report

    SELECT

        'AP Invoice' as DocType,

        T0.DocNum AS [INVOICE NUMBER], T0.U_CUInvNo as [CU INVOICE NO.],

        T2.LicTradNum  AS [PIN OF WITHHOLDEE (SUPPLIER)],

        T2.CardName AS "NAME OF THE SUPPLIER",

        T0.NumatCard AS "SUPPLIER REFERENCE",

        CONVERT(varchar, T0.DocDate, 103) AS [INVOICE DATE],

        (T0.DocTotal - T0.VatSum) AS "INVOICE AMOUNT (NET VAT)",

        CONVERT(varchar, T4.DocDate, 103) AS [OUTGOING PAYMENT DATE] ,

        T5.[WTAmnt] AS "WTH AMOUNT ON INVOICE",

        Round(T3.WtAppld,2) AS [WTH AMOUNT PAID],

        T0.VatSum AS "VAT AMOUNT"



    FROM OPCH T0

        LEFT OUTER JOIN OCRD T2 ON T2.CardCode = T0.CardCode

        LEFT OUTER JOIN VPM2 T3 ON T0.DocEntry = T3.DocEntry

        LEFT OUTER JOIN OVPM T4 ON T3.DocNum = T4.DocEntry

        INNER JOIN PCH5 T5 ON T5.[AbsEntry] = T0.[DocEntry]

    WHERE  T3.InvType = 18

        AND T4.DocDate BETWEEN  '[%0]' AND '[%1]'

        AND T2.CardName = '[%2]'

        AND T4.Canceled = 'N'



UNION ALL



    SELECT

        'AP Credit Note' as DocType,

        T0.DocNum AS [INVOICE NUMBER], T0.U_CUInvNo as [CU INVOICE NO.],

        T2.LicTradNum  AS [PIN OF WITHHOLDEE (SUPPLIER)],

        T2.CardName AS "NAME OF THE SUPPLIER",

        T0.NumatCard AS "SUPPLIER REFERENCE",

        CONVERT(varchar, T0.DocDate, 103) AS [INVOICE DATE],

        (T0.DocTotal - T0.VatSum) AS "INVOICE AMOUNT (NET VAT)",

        CONVERT(varchar, T4.DocDate, 103)  AS [OUTGOING PAYMENT DATE] ,

        T5.[WTAmnt] AS "WTH AMOUNT ON INVOICE",

        Round(T3.WtAppld,2) AS [WTH AMOUNT PAID],

        T0.VatSum AS "VAT AMOUNT"



    FROM ORPC T0

        LEFT OUTER JOIN OCRD T2 ON T2.CardCode = T0.CardCode

        LEFT OUTER JOIN VPM2 T3 ON T0.DocEntry = T3.DocEntry

        LEFT OUTER JOIN OVPM T4 ON T3.DocNum = T4.DocEntry

        INNER JOIN RPC5 T5 ON T5.[AbsEntry] = T0.[DocEntry]

    WHERE  T3.InvType = 19

        AND T4.DocDate BETWEEN  '[%0]' AND '[%1]'

        AND T2.CardName = '[%2]'

        AND T4.Canceled = 'N'

UNION ALL



    SELECT

        'AP Downpayment' as DocType,

        T0.DocNum AS [INVOICE NUMBER], T0.U_CUInvNo as [CU INVOICE NO.],

        T2.LicTradNum  AS [PIN OF WITHHOLDEE (SUPPLIER)],

        T2.CardName AS "NAME OF THE SUPPLIER",

        T0.NumatCard AS "SUPPLIER REFERENCE",

        CONVERT(varchar, T0.DocDate, 103) AS [INVOICE DATE],

        (T0.DocTotal - T0.VatSum) AS "INVOICE AMOUNT (NET VAT)",

        CONVERT(varchar, T4.DocDate, 103)  AS [OUTGOING PAYMENT DATE] ,

        T5.[WTAmnt] AS "WTH AMOUNT ON INVOICE",

        Round(T3.WtAppld,2) AS [WTH AMOUNT PAID],

        T0.VatSum AS "VAT AMOUNT"





    FROM ODPO T0

        LEFT OUTER JOIN OCRD T2 ON T2.CardCode = T0.CardCode

        LEFT OUTER JOIN VPM2 T3 ON T0.DocEntry = T3.DocEntry

        LEFT OUTER JOIN OVPM T4 ON T3.DocNum = T4.DocEntry

        INNER JOIN DPO5 T5 ON T5.[AbsEntry] = T0.[DocEntry]

    WHERE  T3.InvType = 204

        AND T4.DocDate BETWEEN '[%0]' AND '[%1]'

        AND T2.CardName = '[%2]'

        AND T4.Canceled = 'N'

what do I have to change to remove the BP selection criteria