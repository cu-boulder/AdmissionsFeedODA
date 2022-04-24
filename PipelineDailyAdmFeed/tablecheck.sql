
declare counter number;

begin
	select count(*) 
		into counter 
	from 
		user_tables 
	where 
		table_name = 'ADMDAILYODA';
	if counter <> 0 then 
		execute immediate 'drop table ADMDAILYODA';
	end if;
end;
