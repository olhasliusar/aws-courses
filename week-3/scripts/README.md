## Run .sql

```shell
psql \
   --host=terraform-20210609.us-west-2.rds.amazonaws.com \
   --port=5432 \
   --username=postgres \
   -a -f rds-script.sql
```
