locals {
  script = templatefile("${path.module}/scripts/script.tpl", {
  })
}

locals {
  script-github = templatefile("${path.module}/scripts/script-github.tpl", {
    # we are passing the registration_token value to the script, for the github-runner register command
    runner_registration_token = var.runner_registration_token
    github_repo = var.github_repo
  })
}

output "script" {
  value = local.script
}

output "script-github" {
  value = local.script-github
  # sensitive, cuz registration_token is marked sensitive and script output will not be displayed now
  sensitive = true 
}
