import boto3
import os
import urllib3
import json
from datetime import datetime, timezone, timedelta

ec2 = boto3.client('ec2')
http = urllib3.PoolManager()

def send_slack_notification(status, message):
    """
    Slackに通知を送信する
    """
    slack_webhook_url = os.environ.get('SLACK_WEBHOOK_URL')
    if not slack_webhook_url:
        print("SLACK_WEBHOOK_URL is not set")
        return False

    jst = timezone(timedelta(hours=9))
    timestamp = datetime.now(jst).strftime('%Y-%m-%d %H:%M:%S JST')

    color = '#36a64f' if status == 'success' else '#ff0000'

    payload = {
        'attachments': [
            {
                'color': color,
                'title': f'Minecraft EC2インスタンス起動通知',
                'text': message,
                'fields': [
                    {
                        'title': 'ステータス',
                        'value': status,
                        'short': True
                    },
                    {
                        'title': 'タイムスタンプ',
                        'value': timestamp,
                        'short': True
                    }
                ]
            }
        ]
    }

    try:
        encoded_msg = json.dumps(payload).encode('utf-8')
        resp = http.request('POST', slack_webhook_url, body=encoded_msg)
        if resp.status == 200:
            print("Slack notification sent successfully")
            return True
        else:
            print(f"Failed to send Slack notification: {resp.status}")
            return False
    except Exception as e:
        print(f"Error sending Slack notification: {str(e)}")
        return False

def handler(event, context):
    """
    EC2インスタンスを起動する
    """
    instance_id = os.environ['INSTANCE_ID']

    try:
        print(f"Instance {instance_id} を起動しています...")
        ec2.start_instances(InstanceIds=[instance_id])

        message = f'Instance {instance_id} を起動しました'
        send_slack_notification('success', message)

        return {
            'statusCode': 200,
            'body': message
        }
    except Exception as e:
        error_msg = f'Error: {str(e)}'
        send_slack_notification('error', error_msg)
        return {
            'statusCode': 500,
            'body': error_msg
        }
