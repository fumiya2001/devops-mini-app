resource "aws_s3_bucket" "ansible_ssm" {
  bucket_prefix = "devops-mini-ansible-ssm-"

  tags = {
    Name = "devops-mini-ansible-ssm"
  }
}

resource "aws_s3_bucket_public_access_block" "ansible_ssm" {
  bucket = aws_s3_bucket.ansible_ssm.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}