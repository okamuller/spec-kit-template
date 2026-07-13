# Spec Kit Template

GitHub Spec Kitを使った、クラウド実行向けの仕様駆動開発テンプレートです。GitHub Codespaces、Codexクラウドタスク、Codex CLIを同じリポジトリ構成と標準コマンドで運用できます。

## このテンプレートの方針

- Codespace作成時は、開発ツールと依存関係だけを準備します。
- リポジトリ固有の初期化は、明示的に`make init`を一度だけ実行します。
- Spec Kitは`.specify-version`で固定した公式リリースから導入します。
- 非自明な機能は、仕様、設計、タスク、実装、収束確認の順で進めます。
- セットアップ、検査、テストは`scripts/`配下の共通コマンドに集約します。

## 新規プロジェクトの開始

1. GitHubで **Use this template** からリポジトリを作成します。
2. 作成したリポジトリをCodespacesで開きます。
3. ターミナルで次を実行します。

```bash
make init
```

4. Codexに次を依頼して、プロジェクト原則を作成します。

```text
$speckit-constitutionを実行し、このプロジェクトの品質、テスト、UX、性能、安全性の原則を定義してください。
```

5. 初期化結果を確認します。

```bash
make ci
git status
git add -A
git commit -m "chore: initialize spec-driven development"
git push
```

`make init`は`.template-initialized`を作成するため、別のCodespaceで誤って再初期化しても何も変更しません。

## 日常的に使うコマンド

```bash
make setup             # プロジェクト依存関係をインストール
make check             # 静的検査とテンプレート整合性確認
make test              # 利用可能なテストを実行
make ci                # checkとtestを実行
make speckit-status    # Spec Kit統合状態を確認
```

Spec Kitを更新する場合は、更新専用の変更として実施します。

```bash
make speckit-update VERSION=vX.Y.Z
make ci
```

## クラウドタスク運用

- 開発要求はGitHub Issueを起点にします。
- 1機能につき、1 Issue、1 feature branch、1 `specs/NNN-feature/`、1 Draft PRを基本単位とします。
- 仕様策定だけのタスクと、実装タスクを分けます。
- 実装完了後は`$speckit-converge`と`make ci`で収束確認します。

具体的な依頼文は[docs/CLOUD_TASKS.md](docs/CLOUD_TASKS.md)、工程の詳細は[docs/SPEC_DRIVEN_DEVELOPMENT.md](docs/SPEC_DRIVEN_DEVELOPMENT.md)を参照してください。

## テンプレートリポジトリ設定

このテンプレート元リポジトリでは、GitHubの **Settings > General** を開き、`Template repository`を一度だけ有効にしてください。続けてPull Requests設定でsquash mergeだけを有効にし、マージ後のブランチ自動削除を有効にします。

Codespacesの自動認証トークンは通常、リポジトリ設定を変更する`Administration: write`権限を持たないため、Codespace内の`make github-config`はHTTP 403になることがあります。

`make github-config`を使う場合は、対象リポジトリへの`Administration: Read and write`権限を持つfine-grained personal access tokenをCodespaces secretの`GH_ADMIN_TOKEN`として登録してから実行してください。
