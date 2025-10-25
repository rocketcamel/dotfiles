config="$1"
shift

project=$(basename "$PWD")

exec doppler run -c "$config" -p "$project" "$@"
