import boto3
import os
import urllib3
import json
from datetime import datetime, timezone, timedelta

ec2 = boto3.client('ec2')
http = urllib3.PoolManager()

def send_slack_notification(status: str, instance_id: str) -> None:
    """
    Slackに通知を送信する
    """
    slack_channel_id = os.environ.get('SLACK_CHANNEL_ID')
    slack_bot_token = os.environ.get('SLACK_BOT_TOKEN')
    if not slack_channel_id or not slack_bot_token:
        print("SLACK_CHANNEL_ID or SLACK_BOT_TOKEN is not set")
        return

    if status == 'success':
        message = f'Instance {instance_id} を停止しました'
        color = '#36a64f'
    else:
        message = f'Instance {instance_id} の停止に失敗しました'
        color = '#ff0000'

    slack_message = {
        "channel": slack_channel_id,
        "attachments": [
            {
                "color": color,
                "title": "⏹️ Minecraft EC2インスタンス停止通知",
                "text": message,
                "fields": [
                    {
                        "title": "インスタンスID",
                        "value": instance_id,
                        "short": True
                    },
                    {
                        "title": "ステータス",
                        "value": status,
                        "short": True
                    },
                ]
            }
        ]
    }

    try:
        encoded_msg = json.dumps(slack_message).encode('utf-8')
        resp = http.request(
            'POST',
            'https://slack.com/api/chat.postMessage',
            body=encoded_msg,
            headers={
                'Content-Type': 'application/json',
                'Authorization': f'Bearer {slack_bot_token}'
            }
        )
        if resp.status == 200:
            print("Slack notification sent successfully")
        else:
            print(f"Failed to send Slack notification: {resp.status}")
    except Exception as e:
        print(f"Error sending Slack notification: {str(e)}")

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

        send_slack_notification('success', instance_id)

        return {
            'statusCode': 200,
            'body': f'Instance {instance_id} を停止しました'
        }

    except Exception as e:
        error_msg = f'Error: {str(e)}'
        print(error_msg)
        send_slack_notification('error', instance_id)
        return {
            'statusCode': 500,
            'body': error_msg
        }
