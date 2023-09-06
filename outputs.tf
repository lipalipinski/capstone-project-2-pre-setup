output "JenkinsIpAddress" {
  value = aws_eip.jenkins-controller.public_ip
}
