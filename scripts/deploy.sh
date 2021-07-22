name: Pages Pipeline

on:
  push:
    branches: [master]

jobs:
  deploy-to-staging:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: AWS Credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.AWS_REGION }}
      - name: Configure EKS
        run: |
          aws eks --region ap-south-1 update-kubeconfig --name dees-cloud

      - name: Install Kubectl
        uses: actions/checkout@v2
      - name: Check kubectl
        run: |
          ls
          bash ./scripts/install-kubectl.sh
      - name: Install Helm3
        run: |
          bash ./scripts/install-helm.sh
      - name: Deploy to staging
        run: |
          bash ./scripts/deploy.sh ${{ secrets.STAGING_NAMESPACE }} ${{ secrets.RELEASE_NAME }}
