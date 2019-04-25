resource "aws_codepipeline" "pipeline" {
  name     = "rf-codepipeline-${var.name}"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "${var.artefact_bucket_name}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["terraform_project"]

      configuration = {
        Owner                = "${var.github_org}"
        Repo                 = "${var.repo}"
        PollForSourceChanges = "true"
        Branch               = "${var.branch}"
        OAuthToken           = "${data.aws_ssm_parameter.github_oauth_token.value}"
        PollForSourceChanges = "true"
      }
    }
  }

  stage {
    name = "Apply-Staging"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["terraform_project"]
      version         = "1"

      configuration = {
        ProjectName = "${var.buildcode_target_staging}"
      }
    }
  }

  stage {
    name = "Production-Aproval"

    action {
      name = "Approve"
      category = "Approval"
      owner = "AWS"
      provider = "Manual"
      version = "1"
    }
  }

  stage {
    name = "Apply-Production"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["terraform_project"]
      version         = "1"

      configuration = {
        ProjectName = "${var.buildcode_target_production}"
      }
    }
  }
}