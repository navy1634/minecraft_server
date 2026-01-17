import boto3
import os

ec2 = boto3.client('ec2')

def handler(event, context):
    """
    EC2インスタンスを起動する
    """
    instance_id = os.environ['INSTANCE_ID']

    try:
        print(f"Instance {instance_id} を起動しています...")
        ec2.start_instances(InstanceIds=[instance_id])

        return {
            'statusCode': 200,
            'body': f'Instance {instance_id} started successfully'
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Error: {str(e)}'
        }
