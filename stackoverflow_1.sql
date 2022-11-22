DO $$
  declare
    result record;
BEGIN
    FOR result IN Select * FROM (VALUES ('one'), ('two'), ('three')) AS t (path) LOOP 
        RAISE NOTICE 'path: ~/Desktop/%.csv', result.path;
    END LOOP;
END; $$;
