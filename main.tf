provider "aws" {
  region = "us-east-1" # Change to your desired region
}

# Create an SNS Topic
data "aws_s3_bucket" "fpp" {
  bucket = "fpp-accordios"
}

# Create S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "fpp-at"

  tags = {
    Name = "S3 Sync Bucket"
  }
}

resource "aws_sns_topic" "s3_event_topic" {
  name = "s3-event-notifications"
}

# Subscribe an email to the SNS Topic
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.s3_event_topic.arn
  protocol  = "email"
  endpoint  = "teterine@me.com" # Change to your email
}

# Attach an S3 Event Notification to SNS
resource "aws_s3_bucket_notification" "s3_to_sns" {
  bucket = aws_s3_bucket.my_bucket.id

  topic {
    topic_arn = aws_sns_topic.s3_event_topic.arn
    events    = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_sns_topic_policy.sns_policy] # Ensure policy is applied first
}

# Attach a policy to allow S3 to publish events to SNS
resource "aws_sns_topic_policy" "sns_policy" {
  arn = aws_sns_topic.s3_event_topic.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.s3_event_topic.arn
        Condition = {
          ArnLike = {
            "aws:SourceArn" = aws_s3_bucket.my_bucket.arn
          }
        }
      }
    ]
  })
}
