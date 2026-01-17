import boto3
import os

ec2 = boto3.client('ec2')

def handler(event, context):
    """
    EC2停止処理

    1. Minecraftサービスを停止（ExecStop でバックアップ実行）
    2. EC2インスタンスを停止
    """
    instance_id = os.environ['INSTANCE_ID']

    try:
        print(f"Instance {instance_id} を停止しています...")

        # EC2インスタンスを停止（Minecraftサービスの停止により自動的にバックアップが実行される）
        ec2.stop_instances(InstanceIds=[instance_id])

        print(f"Instance {instance_id} の停止コマンドを発行しました")

        return {
            'statusCode': 200,
            'body': f'Instance {instance_id} を停止しました'
        }

    except Exception as e:
        error_msg = f'エラーが発生しました: {str(e)}'
        print(error_msg)
        return {
            'statusCode': 500,
            'body': error_msg
        }
