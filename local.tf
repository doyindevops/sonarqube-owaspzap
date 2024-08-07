locals {
  script = templatefile("${path.module}/scripts/script.tpl.sh", {})

  script_github = templatefile("${path.module}/scripts/script-github.sh", {
    runner_registration_token = var.runner_registration_token
    github_repo = var.github_repo
  })
}

output "script" {
  value = local.script
}

output "script-github" {
  value = local.script_github
  sensitive = true
}
