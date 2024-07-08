from minio import Minio

client = Minio(
    "minio:9000",
    access_key="lccmhTzfaNCPsIO2oaRk",
    secret_key="6YthtpBbxgAcWGODphGIOiTJfcHbmBpny73eOvAC",
    secure=False
)

# Read the documentations for more information
# Link : https://min.io/docs/minio/linux/developers/python/API.html

# Log in to : http://localhost:8900/buckets
# With credentials in docker-compose.local.yml
# Click to " Create bucket "
# After that, set Access Policy to " Public "
#
# Go to http://localhost:8900/access-keys
# Click to " Create access key" and get your credentials