CREATE procedure [dbo].[pair]
as 
begin 
declare 
@prevpair int,
@NOLC int,
@NORC int,
@lchild int,
@rchild int,
@TopNodel hierarchyid, 
@TopNoder hierarchyid,

@pairincome decimal(18,2),
@t_pair int,
@temp int,
@i int,
@ASSID int,
@Max_No int,
@Min_No int,
@Result_No int

	begin transaction 
	begin try



/********************declare an imaginary table to take all ASSID************************/

Declare @client_Info TABLE(
							RowIds       INT    IDENTITY ( 1 , 1 ),    
							ClientId	 varchar(100)
							
						)
	/********************insert into imaginary table  all ASSID ************************/
	
INSERT into @client_Info Select ASSID  from TBL_PAIRMASTER  	 

	/********************select no of rows in  imaginary table************************/
	
Select @temp= COUNT(*)FROM @client_Info  
		SET @i = 1 
		WHILE (@i <=@temp) 
			BEGIN   

SELECT @ASSID = ClientId FROM @client_Info WHERE RowIds = @i 

set @rchild=null;
set @lchild=null;
set @NOLC=null;
set @NOLC=null;
set @TopNodel=null;
set @TopNoder=null;
set @t_pair=null;
set @prevpair=null;
set @pairincome=null;

		if exists(select * from contact where id=@ASSID)			
			begin			
		
		       select @prevpair =ISNULL(PAIR,0) from TBL_PAIRMASTER where ASSID=@ASSID
					
			-- ****************   left side calculation
				select @lchild = [Contact_id] from [Agent_Sponsor_Details] where [Sponsor_ID]=@ASSID and [Placed_Team]='L'						
				select @TopNodel = AdvisorHierarchyNode from Organisation where ASSID = @lchild 
				select   @NOLC=isnull(COUNT(*),0) from Organisation where AdvisorHierarchyNode.IsDescendantOf(@TopNodel) = 1 
				
			-- ***************  Right Side Calculation	
				select @rchild = [Contact_id] from [Agent_Sponsor_Details] where [Sponsor_ID]=@ASSID and [Placed_Team]='R'				
				select @TopNoder = AdvisorHierarchyNode from Organisation where ASSID = @rchild  
				select   @NORC=isnull(COUNT(*),0) from Organisation where AdvisorHierarchyNode.IsDescendantOf(@TopNoder) = 1 
				
				PRINT @NOLC
			    PRINT @NORC
				
				
				--**Pair Calculation**
				
				if(@NOLC>=@NORC)
				begin
				
				set @Max_No=@NOLC
				set @Min_No=@NORC
				
				end
				else			
				begin
				
				set @Max_No=@NORC
				set @Min_No=@NOLC
				
				end
				
				
				set @Result_No=@Max_No
				
				if(@Result_No<=@Min_No)
				begin
								
				set @t_pair=@Result_No
								
				end
				else			
				begin		
						
				set @t_pair=@Min_No		
				
				end 
              
               		
						update TBL_PAIRMASTER set PAIR=@t_pair,LEFT_CHILD=@NOLC,RIGHT_CHILD=@NORC 
						where ASSID=@ASSID
						
				
			end		
		
		 SET @i = @i + 1

            end	
		commit tran	
end try
begin catch	
		rollback tran	
end catch
	
end