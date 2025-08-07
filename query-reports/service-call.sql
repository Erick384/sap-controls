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