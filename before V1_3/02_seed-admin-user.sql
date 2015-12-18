-- SCRIPTS
	DO $$ 
	BEGIN 
	IF NOT EXISTS (
	    SELECT 1
	    FROM  "user" 
	    WHERE  username = 'admin'
	    ) THEN
	  insert into "user" (username, password, sys) values ('admin','welcome', true);
	END IF;
	END$$;