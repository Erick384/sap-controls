SELECT 
    T0.callID AS "Call ID",
    T0.subject AS "Subject",
    T0.createDate AS "Created On",
    T0.closeDate AS "Closed On",
    CASE 
        WHEN T0.status = -3 THEN 'Open'
        WHEN T0.status = -2 THEN 'Pending'
        WHEN T0.status = -1 THEN 'Closed'
        ELSE 'Unknown'
    END AS "Status",
    T1.firstName + ' ' + T1.lastName AS "Technician",
    T0.resolution AS "Resolution",
    T0.itemCode AS "Item Code",
    T0.itemName AS "Item Name",
    T0.custmrName AS "Customer Name"
FROM OSCL T0
LEFT JOIN OHEM T1 ON T0.technician = T1.empID
WHERE T0.createDate BETWEEN [%0] AND [%1]




--OR-----------------------------------------------
SELECT 
    T0.callID AS 'Service Call ID',
    T0.customer AS 'Customer Code',
    T0.custmrName AS 'Customer Name',
    T0.itemCode AS 'Item Code',
    T0.itemName AS 'Item Name',
    T0.subject AS 'Subject',
	T0.U_Location AS 'Location',
    T0.createDate AS 'Created Date',
    T0.closeDate AS 'Close Date',
    T1.Name AS 'Status',
    T0.technician AS 'Technician Code',
    T2.firstName + ' ' + T2.lastName AS 'Technician Name',
    T0.priority AS 'Priority',
    T0.descrption AS 'Description',
    T0.resolution AS 'Resolution'
FROM OSCL T0
INNER JOIN OSCS T1 
    ON T0.status = T1.statusID
LEFT JOIN OHEM T2
    ON T0.technician = T2.empID
WHERE T0.createDate BETWEEN [%0] AND [%1]
  AND T1.statusID = [%2]
ORDER BY T0.createDate


---SERVICE CALL DAYBOOK REPORT------------------------------------------------
-- Open Service Calls && Pending Service Calls
SELECT 
    'Open Calls' AS ReportType,
    C.callID AS [Service Call ID],
    C.subject AS [Subject],
    C.customer AS [Customer Code],
    C.custmrName AS [Customer Name],
    C.itemCode AS [Item Code],
    C.itemName AS [Item Name],
	C.U_Location AS [Location],
    C.createDate AS [Created Date],
    C.closeDate AS [Close Date],
 U.U_NAME AS [Created By SAP User],
	S.Name AS [Status],
    ISNULL(T.firstName,'') + ' ' + ISNULL(T.lastName,'') AS [Technician Name],
    C.priority AS [Priority],
    C.descrption AS [Description],
    C.resolution AS [Resolution]
FROM OSCL C
INNER JOIN OSCS S ON C.status = S.statusID
LEFT JOIN OHEM T ON C.technician = T.empID
LEFT JOIN OUSR U ON C.userSign = U.USERID
WHERE S.Name IN ('Open', 'Pending') 
  AND C.createDate BETWEEN '[%0]' AND '[%1]'

UNION ALL

-- Closed Service Calls
SELECT 
    'Closed Calls' AS ReportType,
    C.callID AS [Service Call ID],
    C.subject AS [Subject],
    C.customer AS [Customer Code],
    C.custmrName AS [Customer Name],
    C.itemCode AS [Item Code],
    C.itemName AS [Item Name],
	C.U_Location AS [Location],
    C.createDate AS [Created Date],
    C.closeDate AS [Close Date],
 U.U_NAME AS [Created By SAP User],
    S.Name AS [Status],
    ISNULL(T.firstName,'') + ' ' + ISNULL(T.lastName,'') AS [Technician Name],
    C.priority AS [Priority],
    C.descrption AS [Description],
    C.resolution AS [Resolution]
FROM OSCL C
INNER JOIN OSCS S ON C.status = S.statusID
LEFT JOIN OHEM T ON C.technician = T.empID
LEFT JOIN OUSR U ON C.userSign = U.USERID
WHERE S.Name = 'Closed'
  AND C.closeDate BETWEEN '[%0]' AND '[%1]'

ORDER BY ReportType, [Created Date];






-------------------------------------------------------------
-- Open Service Calls && Pending Service Calls
SELECT 
    'Open Calls' AS ReportType,
    C.callID AS [Service Call ID],
    C.subject AS [Subject],
    C.customer AS [Customer Code],
    C.custmrName AS [Customer Name],
    C.itemCode AS [Item Code],
    C.itemName AS [Item Name],
    C.U_Location AS [Location],
    C.createDate AS [Created Date],
    U.U_NAME AS [Created By SAP User],
    C.closeDate AS [Close Date],
    '' AS [Closed By SAP User],
    S.Name AS [Status],
    ISNULL(T.firstName,'') + ' ' + ISNULL(T.lastName,'') AS [Technician Name]
FROM OSCL C
INNER JOIN OSCS S ON C.status = S.statusID
LEFT JOIN OHEM T ON C.technician = T.empID
LEFT JOIN OUSR U ON C.userSign = U.USERID
WHERE S.Name IN ('Open', 'Pending') 
  AND C.createDate BETWEEN '[%0]' AND '[%1]'

UNION ALL

-- Closed Service Calls
SELECT 
    'Closed Calls' AS ReportType,
    C.callID AS [Service Call ID],
    C.subject AS [Subject],
    C.customer AS [Customer Code],
    C.custmrName AS [Customer Name],
    C.itemCode AS [Item Code],
    C.itemName AS [Item Name],
    C.U_Location AS [Location],
    C.createDate AS [Created Date],
    U.U_NAME AS [Created By SAP User],
    C.closeDate AS [Close Date],
    ISNULL(U2.U_NAME, 'N/A') AS [Closed By SAP User],  -- User who closed/last modified the call
    S.Name AS [Status],
    ISNULL(T.firstName,'') + ' ' + ISNULL(T.lastName,'') AS [Technician Name]
FROM OSCL C
INNER JOIN OSCS S ON C.status = S.statusID
LEFT JOIN OHEM T ON C.technician = T.empID
LEFT JOIN OUSR U ON C.userSign = U.USERID
LEFT JOIN OUSR U2 ON C.userSign2 = U2.USERID  -- User who last modified (typically who closed)
WHERE S.Name = 'Closed'
  AND C.closeDate BETWEEN '[%0]' AND '[%1]'

ORDER BY ReportType, [Created Date];



--------------------------------------------------------------------
-- Version using ASCL for precise "Closed By" tracking
-- Open Service Calls && Pending Service Calls
SELECT 
    'Open Calls' AS ReportType,
    C.callID AS [Service Call ID],
    C.subject AS [Subject],
    C.customer AS [Customer Code],
    C.custmrName AS [Customer Name],
    C.itemCode AS [Item Code],
    C.itemName AS [Item Name],
    C.U_Location AS [Location],
    C.createDate AS [Created Date],
    C.closeDate AS [Close Date],
    '' AS [Closed By SAP User],  -- Empty for open/pending calls
    U.U_NAME AS [Created By SAP User],
    S.Name AS [Status],
    ISNULL(T.firstName,'') + ' ' + ISNULL(T.lastName,'') AS [Technician Name]
FROM OSCL C
INNER JOIN OSCS S ON C.status = S.statusID
LEFT JOIN OHEM T ON C.technician = T.empID
LEFT JOIN OUSR U ON C.userSign = U.USERID
WHERE S.Name IN ('Open', 'Pending') 
 AND C.createDate BETWEEN '[%0]' AND '[%1]'
 
UNION ALL

-- Closed Service Calls with ASCL Activity Log
SELECT 
    'Closed Calls' AS ReportType,
    C.callID AS [Service Call ID],
    C.subject AS [Subject],
    C.customer AS [Customer Code],
    C.custmrName AS [Customer Name],
    C.itemCode AS [Item Code],
    C.itemName AS [Item Name],
    C.U_Location AS [Location],
    C.createDate AS [Created Date],
    U.U_NAME AS [Created By SAP User],
    C.closeDate AS [Close Date],
    ISNULL(CLOSER.U_NAME, ISNULL(U2.U_NAME, 'N/A')) AS [Closed By SAP User],
    S.Name AS [Status],
    ISNULL(T.firstName,'') + ' ' + ISNULL(T.lastName,'') AS [Technician Name]
FROM OSCL C
INNER JOIN OSCS S ON C.status = S.statusID
LEFT JOIN OHEM T ON C.technician = T.empID
LEFT JOIN OUSR U ON C.userSign = U.USERID
LEFT JOIN OUSR U2 ON C.userSign2 = U2.USERID  -- Fallback to userSign2
-- Get the specific user who changed status to "Closed"
LEFT JOIN (
    SELECT 
        A.callID,
        U_CLOSE.U_NAME,
        ROW_NUMBER() OVER (PARTITION BY A.callID ORDER BY A.updateDate DESC, A.updateTime DESC) as rn
    FROM ASCL A
    INNER JOIN OUSR U_CLOSE ON A.userSign = U_CLOSE.USERID
    INNER JOIN OSCS S_CLOSE ON A.status = S_CLOSE.statusID
    WHERE S_CLOSE.Name = 'Closed'
) CLOSER ON C.callID = CLOSER.callID AND CLOSER.rn = 1
WHERE S.Name = 'Closed'
  AND C.closeDate BETWEEN '[%0]' AND '[%1]'

ORDER BY ReportType, [Created Date];