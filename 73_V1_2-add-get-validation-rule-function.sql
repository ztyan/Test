SET client_min_messages TO WARNING;
DROP FUNCTION IF EXISTS get_validation_rule(
 data_validation.id%TYPE
,data_validation.category%TYPE
,"user".username%TYPE
,data_validation.status%TYPE
,data_validation.comment%TYPE
,BOOLEAN);
CREATE OR REPLACE FUNCTION get_validation_rule(
    p_id          data_validation.id%TYPE           DEFAULT      NULL
   ,p_category    data_validation.category%TYPE     DEFAULT      NULL
   ,p_creator     "user".username%TYPE              DEFAULT      NULL
   ,p_status      data_validation.status%TYPE       DEFAULT     'active'
   ,p_comment     data_validation.comment%TYPE      DEFAULT      NULL
   ,p_forreport   BOOLEAN                           DEFAULT      FALSE
)  RETURNS TABLE(
    id           data_validation.id%TYPE
   ,category     data_validation.category%TYPE
   ,sql          data_validation.sql%TYPE
   ,param        data_validation.param%TYPE
   ,status       data_validation.status%TYPE
   ,exec_order   data_validation.exec_order%TYPE
   ,comment      data_validation.comment%TYPE
   ,"cuserId"    data_validation."cuserId"%TYPE
   ,cuser_name   "user".username%TYPE
   ,"uuserId"    data_validation."uuserId"%TYPE
   ,uuser_name   "user".username%TYPE
   ,ctime        data_validation.ctime%TYPE
   ,utime        data_validation.utime%TYPE
)
AS
$$
    SELECT
       v.id
      ,v.category
      ,v.sql
      ,v.param
      ,v.status
      ,v.exec_order
      ,v.comment
      ,v."cuserId"
      ,cu.username cuser_name
      ,v."uuserId"
      ,uu.username uuser_name
      ,v.ctime
      ,v.utime
    FROM data_validation v
    LEFT JOIN "user" cu ON v."cuserId"=cu.id
    LEFT JOIN "user" uu ON v."uuserId"=uu.id
    WHERE (COALESCE(p_id,0)=0 OR v.id=p_id)
      AND (COALESCE(p_category,'')='' OR v.category=p_category)
      AND (COALESCE(p_status,'')='' OR v.status=p_status)
      AND (COALESCE(p_comment,'')='' OR v.comment LIKE '%'||p_comment||'%')
      AND (COALESCE(p_creator,'')='' OR cu.username LIKE '%'||p_creator||'%')
      AND (
            p_forreport=FALSE
            OR
            (
                p_forreport=TRUE
                AND
                EXISTS(
                    SELECT *
                    FROM validate_rule(v."id")
                )
            )
           )
      ORDER BY v.exec_order asc;
$$
LANGUAGE sql;