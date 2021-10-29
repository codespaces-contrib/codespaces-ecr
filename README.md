# GitHub Codespaces using images from Amazon Elastic Container Registry

While GitHub Codespaces supports using secrets as a way to log into private registries using persisted secrets, Amazon Elastic Container Registry only supports 12 hour access tokens. This sample works around this issue by using the `initializeCommand` in `devcontainer.json` to login using the AWS CLI instead.

To use the sample:

1. Fork this repository

2. [Configure the following secrets](https://docs.github.com/en/codespaces/managing-your-codespaces/managing-encrypted-secrets-for-your-codespaces) with the appropriate values and be sure to give your forked **repository access to them**:

    - `ECR_ACCOUNT_ID` - The appropriate AWS account ID for the ECR instance (basically the start of the server URL).
    - `ECR_REGION` - AWS region that contains the ECR instance you want to log into.
    - `AWS_ACCESS_KEY_ID` - A generated AWS access key ID for a user with access to the ECR instance. Using a service account with minimal access to AWS is recommended.
    - `AWS_SECRET_ACCESS_KEY` - Secret for the access key.

3. Update the `image` property in `.devcontainer/devcontainer.json` to an image in your ECR.

4. Create a codespace. Note that if you already have a codespace and just want to rebuild instead, you may first need to stop the codespace (<kbd>F1</kbd> or <kbd>ctrl/cmd</kbd>+<kbd>shift</kbd>+<kbd>p</kbd> and select **Codespaces: Stop Current Codespace**) and restart it before any new secrets will be picked up.

Since you may need to have different secret names for different AWS services you need to connect to, you can change the expected secret names by passing them into the `initalizeCommand` in `devcontainer.json`. For example:

```json
"initializeCommand": "bash .devcontainer/ecr-login.sh ACCOUNT_ID_SECRET_NAME REGION_SECRET_NAME ACCESS_KEY_ID_SECRET_NAME SECRET_ACCESS_KEY_SECRET_NAME",
```

To adapt this to your own repository, just grab `.devcontainer/ecr-login.sh`, place it in your repository, and update your `devcontainer.json` file with the `initializeCommand` from this sample.