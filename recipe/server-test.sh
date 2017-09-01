conda inspect linkages postgresql-server
if [ "$(uname)" == "Darwin" ]; then
    conda inspect objects postgresql-server
fi

postgres --help
postmaster --help
