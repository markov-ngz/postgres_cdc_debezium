-- 1. Set the wal level for logical decoding
ALTER SYSTEM SET wal_level = logical ; 
-- => restart database

--  2. Create a user and set permissions
CREATE USER <username> PASSWORD '<password>' ; 
ALTER ROLE <username> REPLICATION LOGIN ; 

-- 3. Create logical replication slot
SELECT * FROM pg_create_logical_replication_slot('<slot_name>','pgoutput') ;
-- 4. Create publication
CREATE PUBLICATION <publication_name> FOR ALL TABLES ; 
-- 5. Create table
CREATE TABLE ref_sol_ail ( sol_id int, ail_id int ) ;  -- sol : sale order line , ail : account invoice line

-- 6. As there is no pk 
ALTER TABLE ref_sol_ail REPLICA IDENTITY FULL ; 
-- 7. Do some transactions
INSERT INTO ref_sol_ail ( sol_id, ail_id) VALUES (1,21) ; 
-- 8. get changes 
SELECT * FROM pg_logical_slot_get_binary_changes('<slot_name>',NULL,NULL, 'proto_version','1','publication_names','<publication_name>'); 