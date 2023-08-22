import boto3, os, sys
from botocore.exceptions import ClientError

"""
Get a secret from AWS Secrets Manager and store it in ~/.ssh/
"""

secret_name = sys.argv[1]
key_dest_path = os.path.expanduser(f'~/.ssh/{secret_name}')
region_name = "eu-central-1"

def get_secret():


    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        # For a list of exceptions thrown, see
        # https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
        raise e

    # Decrypts secret using the associated KMS key.
    return get_secret_value_response['SecretString']

# save to ~/.ssh/
f = open(key_dest_path, "w")
f.write(get_secret())
f.close()
os.chmod(key_dest_path, int('400', base=8))