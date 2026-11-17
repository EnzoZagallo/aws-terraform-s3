# -----------------------------------------------------------------------------
# TFLint Configuration
#
# TFLint is a static analysis linter for Terraform. While 'terraform validate'
# checks general HCL syntax, TFLint checks for deprecated syntax, unused
# declarations, and missing version constraints.
# -----------------------------------------------------------------------------

config {
  call_module_type = "all"
}

# Warn if any variable or output is declared without a description
rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

# Warn if any variable is declared without an explicit type
rule "terraform_typed_variables" {
  enabled = true
}

# Enforce standard naming conventions (snake_case for resources and variables)
rule "terraform_naming_convention" {
  enabled = true
}
