output "repo_arn" {
  value = aws_ecr_repository.different.*.arn
}

output "repo_url" {
  value = aws_ecr_repository.different.*.repository_url
}
