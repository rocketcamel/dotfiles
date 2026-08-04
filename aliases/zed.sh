if [ -z "$@" ]; then
    zeditor -n .
else
    zeditor "$@"
fi
