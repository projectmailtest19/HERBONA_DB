CREATE PROCEDURE [dbo].[ADDASSOCIATE] 
@ASSID int,
@NAME nvarchar(400),
@REFERENCE_ID int,
@SPRIL_ID int,
@SIDE nvarchar(10),
@joinamount decimal(18, 2),
@msg nvarchar(50) OUTPUT
AS
BEGIN
  DECLARE @TRANS_NO int,
          @pinstatus int,
          @ParentNode hierarchyid,
          @PRODUCTVALUE decimal(18, 2),
          @Spill_Bonus decimal(18, 2),
          @MaxChildNode hierarchyid,
          @F_Result int,
          @REFERENCE_ID_New int,
          @i int,
          @Direct_Join_Commision decimal(18, 2),
          @D_J_C decimal(18, 2),
          @S_C decimal(18, 2),
          @JOIN_DATE date = GETDATE()

  BEGIN TRANSACTION
    BEGIN TRY


      SELECT
        @D_J_C = Direct_Joining,
        @S_C = Chain
      FROM TBL_Commision_Extra



      IF NOT EXISTS (SELECT
          *
        FROM TBL_ASSOCIATEMASTER
        WHERE ASSID = @ASSID)
      BEGIN



        INSERT TBL_ASSOCIATEMASTER (ASSID, NAME, JOIN_BY)
          VALUES (@ASSID, @NAME, @REFERENCE_ID)

        INSERT TBL_RELATIONMASTER (ASSID, REFERENCE_ID, SPRIL_ID, SIDE)
          VALUES (@ASSID, @REFERENCE_ID, @SPRIL_ID, @SIDE)

        INSERT TBL_PAIRMASTER (ASSID, PAIR, LEFT_CHILD, RIGHT_CHILD)
          VALUES (@ASSID, 0, 0, 0)

        --start of insert into organisation  Hiearkey ID--

        IF (@SIDE = 'L')
        BEGIN
          SELECT
            @MaxChildNode = CAST((AdvisorHierarchyNode.ToString() + '1/') AS hierarchyid)
          FROM Organisation
          WHERE ASSID = @REFERENCE_ID
        END

        ELSE
        BEGIN
          SELECT
            @MaxChildNode = CAST((AdvisorHierarchyNode.ToString() + '2/') AS hierarchyid)
          FROM Organisation
          WHERE ASSID = @REFERENCE_ID
        END


        INSERT Organisation (ASSID, AdvisorHierarchyNode)
          VALUES (@ASSID, @MaxChildNode)



        --end of insert into organisation  Hiearkey ID--
        --  sponsorincome payment start -----
        IF (@SPRIL_ID IS NULL
          OR @SPRIL_ID = '')
        BEGIN

          SET @i = 0

          WHILE (@i <= 14)
          BEGIN


            IF EXISTS (SELECT
                *
              FROM TBL_ASSOCIATEMASTER
              WHERE ASSID = @REFERENCE_ID)
            BEGIN


              IF (@i < 14)
              BEGIN
                IF (@i = 0)
                BEGIN

                  INSERT TBL_BUSINESSMASTER (TRANS_NO, ASSID, FOR_ID, AMOUNT, BUSS_TYPE, STATUS, DATE)
                    VALUES (@TRANS_NO, @REFERENCE_ID, @ASSID, @D_J_C, 'Joining', 'unpaid', @JOIN_DATE)
                END
                ELSE
                BEGIN
                  --SELECT
                  --  @Direct_Join_Commision = Direct_Join_Commision
                  --FROM TBL_Commision
                  --WHERE Level_No = @i


                  INSERT TBL_BUSINESSMASTER (TRANS_NO, ASSID, FOR_ID, AMOUNT, BUSS_TYPE, STATUS, DATE)
                    VALUES (@TRANS_NO, @REFERENCE_ID, @ASSID, @Direct_Join_Commision, 'Joining', 'unpaid', @JOIN_DATE)
                END
              END
              --ELSE
              --BEGIN

                --SELECT
                --  @Direct_Join_Commision = Direct_Join_Commision
                --FROM TBL_Commision
                --WHERE Level_No = @i


                --INSERT TBL_Associate_FLC (TRANS_NO, ASSID, FOR_ID, AMOUNT, BUSS_TYPE, Cal_STATUS, DATE)
                --  VALUES (@TRANS_NO, @REFERENCE_ID, @ASSID, @Direct_Join_Commision, 'Joining', '0', @JOIN_DATE)

                --IF NOT EXISTS (SELECT
                --    ASSID
                --  FROM TBL_Roality_Member
                --  WHERE ASSID = @REFERENCE_ID)
                --BEGIN
                --  INSERT INTO TBL_Roality_Member (Date, ASSID)
                --    VALUES (@JOIN_DATE, @REFERENCE_ID)
                --END

              --END


              SELECT
                @REFERENCE_ID_New = JOIN_BY
              FROM TBL_ASSOCIATEMASTER
              WHERE ASSID = @REFERENCE_ID
              SET @REFERENCE_ID = NULL
              SET @REFERENCE_ID = @REFERENCE_ID_New


            END
            SET @i = @i + 1
          END

        END
        ELSE
        BEGIN

          INSERT TBL_BUSINESSMASTER (TRANS_NO, ASSID, FOR_ID, AMOUNT, BUSS_TYPE, STATUS, DATE)
            VALUES (@TRANS_NO, @SPRIL_ID, @ASSID, @S_C, 'Spill', 'unpaid', @JOIN_DATE)


        END
        --  sponsorincome payment start -----	


        EXEC pair @JOIN_DATE,
                  @TRANS_NO


        SET @msg = 'Sucessfull Entry'

      END

    COMMIT TRAN
  END TRY
  BEGIN CATCH


    SET @msg = ERROR_MESSAGE()



    ROLLBACK TRAN

  END CATCH
END