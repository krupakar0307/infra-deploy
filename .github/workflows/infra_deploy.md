name: terraform build and deployment

on: 
  push:
    branches:
      - main
  pull_request:

env:
  AWS_REGION: "us-east-1"
  GITHUB_ROLE_ARN: "arn:aws:iam::342914800082:role/github_oidc_role_expensive-tracker"

permissions:
  id-token: write  # This is required for requesting the JWT
  contents: read   # This is required for actions/checkout

jobs:
    service-build:
      runs-on: ubuntu-latest
      steps:
        - name: Set up Python
          uses: actions/setup-python@v4
          with:
            python-version: '3.12'

        - name: Install dependencies
          run: |
              ls -al
              cd $GITHUB_WORKSPACE
              ls -al
              python -m pip install --upgrade pip
              pip install -r service/requirements.txt -t service/python/

  