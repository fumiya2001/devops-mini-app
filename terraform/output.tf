output "instance_id" {
    description = "EC2 instance id"
    value       = aws_instance.web.id
}

output "ansible_ssm_bucket" {
    value = aws_s3_bucket.ansible_ssm.bucket
}