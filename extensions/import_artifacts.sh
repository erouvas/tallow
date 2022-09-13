
CODE=$(curl -sSL -w '%{http_code}' -o binary.tar.gz https://myserver.com/binary.tar.gz)
if [[ "$CODE" =~ ^2 ]]; then
    # Server returned 2xx response
    # do_something_with binary.tar.gz
elif [[ "$CODE" = 404 ]]; then
    # Server returned 404, so compiling from source
    # compile_from_source
else
    echo "ERROR: server returned HTTP code $CODE"
    exit 1
fi
