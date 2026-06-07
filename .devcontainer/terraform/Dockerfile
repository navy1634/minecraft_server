FROM hashicorp/terraform:latest

WORKDIR /terraform

# 必要なツールとパッケージをインストール
RUN apk add --no-cache \
    wget \
    unzip \
    curl \
    ca-certificates \
    aws-cli

# TFLintのインストール
ENV TFLINT_VERSION="0.60.0"
RUN wget -O /tmp/tflint.zip https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip && \
    unzip /tmp/tflint.zip -d /usr/local/bin && \
    rm /tmp/tflint.zip && \
    chmod +x /usr/local/bin/tflint

# terraform-docsのインストール
ENV TFDOCS_VERSION="0.21.0"
RUN wget -O /tmp/terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v${TFDOCS_VERSION}/terraform-docs-v${TFDOCS_VERSION}-linux-amd64.tar.gz && \
    tar -xzf /tmp/terraform-docs.tar.gz -C /tmp && \
    mv /tmp/terraform-docs /usr/local/bin/ && \
    rm /tmp/terraform-docs.tar.gz && \
    chmod +x /usr/local/bin/terraform-docs

# 作業ディレクトリを設定
WORKDIR /workspace

# 環境変数の設定
ENV PATH="/usr/local/bin:${PATH}"

# バージョン確認コマンド
RUN terraform --version && \
    tflint --version && \
    terraform-docs --version

# フォルダをコピー
COPY . .
