set -o allexport
source .env
set +o allexport

flutter build web --dart-define API_KEY="$API_KEY"