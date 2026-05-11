-- 1. Ensure we are in the correct pluggable database
ALTER SESSION SET CONTAINER = XEPDB1;

-- 2. Turn off feedback to keep the script output clean
SET FEEDBACK OFF;
SET TERMOUT OFF;

-- 3. Run the scripts in the required relational order
-- Note: We use double quotes to handle the special characters and spaces in your path.

@ "C:\Users\Alexandru\Desktop\Master\Anul_2\Semestrul_2\Integrare informațională\Datasets\SQL\Oracle\02_oracle_populate_author.sql";
@ "C:\Users\Alexandru\Desktop\Master\Anul_2\Semestrul_2\Integrare informațională\Datasets\SQL\Oracle\03_oracle_populate_publisher.sql";
@ "C:\Users\Alexandru\Desktop\Master\Anul_2\Semestrul_2\Integrare informațională\Datasets\SQL\Oracle\04_oracle_populate_lookups.sql";
@ "C:\Users\Alexandru\Desktop\Master\Anul_2\Semestrul_2\Integrare informațională\Datasets\SQL\Oracle\05_oracle_populate_book.sql";
@ "C:\Users\Alexandru\Desktop\Master\Anul_2\Semestrul_2\Integrare informațională\Datasets\SQL\Oracle\06_oracle_populate_bookauthor.sql";
@ "C:\Users\Alexandru\Desktop\Master\Anul_2\Semestrul_2\Integrare informațională\Datasets\SQL\Oracle\07_oracle_populate_country.sql";
@ "C:\Users\Alexandru\Desktop\Master\Anul_2\Semestrul_2\Integrare informațională\Datasets\SQL\Oracle\08_oracle_populate_address.sql";
@ "C:\Users\Alexandru\Desktop\Master\Anul_2\Semestrul_2\Integrare informațională\Datasets\SQL\Oracle\09_oracle_populate_customer.sql";
@ "C:\Users\Alexandru\Desktop\Master\Anul_2\Semestrul_2\Integrare informațională\Datasets\SQL\Oracle\10_oracle_populate_others.sql";
@ "C:\Users\Alexandru\Desktop\Master\Anul_2\Semestrul_2\Integrare informațională\Datasets\SQL\Oracle\11_oracle_populate_order.sql";
@ "C:\Users\Alexandru\Desktop\Master\Anul_2\Semestrul_2\Integrare informațională\Datasets\SQL\Oracle\12_oracle_populate_orderline.sql";
@ "C:\Users\Alexandru\Desktop\Master\Anul_2\Semestrul_2\Integrare informațională\Datasets\SQL\Oracle\13_oracle_populate_orderhistory.sql";

-- 4. Finalize the data insertion
COMMIT;

SET FEEDBACK ON;
SET TERMOUT ON;
PROMPT "Success: All datasets have been integrated into Oracle!";