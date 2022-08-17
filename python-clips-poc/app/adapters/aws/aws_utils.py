import io

import boto3


def loading_clips_files_from_s3():
    s3_client = boto3.client("s3")

    s3 = boto3.resource('s3',
                        aws_access_key_id='ACCESS_KEY',
                        aws_secret_access_key='SECRET_KEY')

    s3_bucket_name = 'antifraud-knowledgebase'
    my_bucket = s3.Bucket(s3_bucket_name)

    temporary_folder = "/tmp"
    files = []
    for file in my_bucket.objects.all():
        if file.key.endswith(".clp") or file.key.endswith(".bat"):
            obj = s3_client.get_object(Bucket=s3_bucket_name, Key=file.key)
            file_content = obj["Body"].read()

            file_in_memory = io.BytesIO(file_content)

            full_pathfile = f"{temporary_folder}/{file.key}"
            with open(full_pathfile, "wb") as f:
                f.write(file_in_memory.read())

            files.append(full_pathfile)

    return files
