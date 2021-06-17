output "valheim_security_groups" {
    value = [aws_security_group.valheim_sg.id]
}