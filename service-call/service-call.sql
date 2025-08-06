-----SERVICE CALL: MANDATORY FIELDS-----------------------------------------------------------------
IF (@object_type = '191') AND (@transaction_type IN ('A', 'U'))
BEGIN
    DECLARE @CallID INT
    SELECT @CallID = CAST(@list_of_cols_val_tab_del AS INT)

    -- Check Origin
    IF EXISTS (
        SELECT 1 FROM OSCL WHERE CallID = @CallID AND ISNULL(Origin, -1) = -1
    )
    BEGIN
        SELECT @error = 1701, @error_message = 'Origin field cannot be empty. Please select a valid origin.'
    END
	-- Check Problem Type
    IF EXISTS (
        SELECT 1 FROM OSCL WHERE CallID = @CallID AND ISNULL(ProblemTyp, -1) = -1
    )
    BEGIN
        SELECT @error = 1702, @error_message = 'Problem Type field cannot be empty. Please select a valid problem type.'
    END
	-- Check Problem Subtype
    IF EXISTS (
        SELECT 1 FROM OSCL WHERE CallID = @CallID AND ISNULL(ProSubType, -1) = -1
    )
    BEGIN
        SELECT @error = 1703, @error_message = 'Problem Subtype field cannot be empty. Please select a valid problem subtype.'
    END
	-- Check Call Type
    IF EXISTS (
        SELECT 1 FROM OSCL WHERE CallID = @CallID AND ISNULL(CallType, -1) = -1
    )
    BEGIN
        SELECT @error = 1704, @error_message = 'Call Type field cannot be empty. Please select a valid call type.'
    END
    -- Check Technician
    IF EXISTS (
        SELECT 1 FROM OSCL WHERE CallID = @CallID AND ISNULL(Technician, -1) = -1
    )
    BEGIN
        SELECT @error = 1705, @error_message = 'Technician field cannot be empty. Please assign a technician.'
    END
END



/*How to Use
1. On your company database, open storedProcedures on programmability folder and add the above code.
Note: The above query is used to prevent users from adding a service call with origin, problem type, 
problem subtype, call type, technician and priority fields empty.
*/