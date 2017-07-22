conda inspect linkages postgresql-client
if [ "$(uname)" == "Darwin" ]; then
    conda inspect objects postgresql-client
fi

pg_config
psql --help
