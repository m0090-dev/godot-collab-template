# Godot の注意書き

このテンプレに同梱されている Godot まわり一式と、固有の注意。

## 同梱されているもの

- `.github/workflows/pages.yml` — Web 書き出し → GitHub Pages 公開。
  main への push はルート `/` へ、作業ブランチへの push は `/<ブランチ名>/` へ公開する。
  公開先は gh-pages ブランチ（Pages の Source を「Deploy from a branch: gh-pages / root」に設定）。
- `.github/workflows/cleanup-preview.yml` — ブランチ削除時に、そのブランチの公開フォルダを消す。
- プロジェクト雛形 — `project.godot`（1280×720、Compatibility レンダラ、日本語フォント指定済み）、
  `scenes/main.tscn` ＋ `scripts/main.gd` の最小サンプル（ボタンでセリフが進み、途中1回揺れる）、
  `export_presets.cfg`（Web プリセット）、`icon.svg`。
- `tools/make_dummies.py` — 本番と同名・同寸法のダミー画像生成（Pillow 依存）。
- `assets_manifest.txt` — 必要素材リストの雛形（= リソース担当の TODO）。

## バージョンの固定

- Godot のバージョンは **4.7.2** に固定する。バージョンが書いてある場所は2か所:
  ワークフロー（`.github/workflows/pages.yml` の `GODOT_VERSION`）と
  `project.godot` の `config/features`。
- バージョンを上げるときは、この2か所と書き出しテンプレートを揃える。
  プロジェクトを開くエディタの版と書き出しの版がずれると、書き出しが失敗したり
  シーンの形式が勝手に変換されたりする。

## Web 書き出しの前提（重要）

- スクリプトは **GDScript** で書く。C# プロジェクトは Web に書き出せない。
- レンダラは **Compatibility**（`project.godot` で設定済み）。Web で動くのはこれだけ。
- `export_presets.cfg` の `variant/thread_support=false`（4.3 以降の既定）により、
  COOP/COEP ヘッダを付けられない GitHub Pages でもそのまま動く。
- 書き出し一式の中心は `index.wasm`（圧縮前で約40MB）。Pages のサイト全体上限 1GB が
  実質の制約になるので、素材の容量とブランチ公開の数に注意する。

## Godot 固有の注意

- 日本語フォントはプロジェクトに同梱する。雛形では `assets/fonts/` に置き、
  `project.godot` の `gui/theme/default_font` で指定済み。
  既定フォントには日本語グリフがなく、そのままだと日本語が表示されない。
- シーン（`.tscn`）とスクリプト（`.gd`）はどちらもテキスト形式。
  AI が直接読み書きできるのが Godot の強み。手で大きく書き換えた後は、
  必ず読み込みチェック（CI のインポート工程）を通すこと。
- `.godot/` フォルダはインポートのキャッシュで、再生成できるのでコミットしない
  （`.gitignore` 済み）。一方、素材ファイルの横にできる `*.import` ファイルは
  インポート設定そのものなので、素材と一緒にコミットする。
- Web 版はブラウザのサンドボックス内なので、実ファイルや OS には触れない。
  メタ演出は作中の仮想環境として再現する形になる。
- Web 版の更新がブラウザで反映されないときは、Service Worker ではなく
  ブラウザと CDN のキャッシュを疑う。確認はシークレットウィンドウが確実。

## ワークフローの注意（Ren'Py 版での実測を含む）

- 公開キュー（concurrency）は全ブランチ共通で「実行1本＋待ち1本」。
  短時間に複数ブランチへ push すると、真ん中の実行が押し出されてキャンセルされ、
  そのブランチだけ公開が古いままになることがある（Ren'Py 版で実測）。
  ブランチは1本ずつ push し、公開完了を確認してから次を push すること。
- Godot 本体と成果物は必ずリポジトリの外（`$RUNNER_TEMP`）に置く。
- ブランチ名は英小文字とハイフンのみ（公開 URL のフォルダ名になるため）。

## ローカルでの確認

- 書き出しと読み込みチェックは Actions が毎回行うので、普段の確認はテスト公開で足りる。
- 手元で書き出したい節目だけ、各自の環境に Godot 4.7.2 エディタを用意して
  Web プリセットで書き出す（書き出しテンプレートのインストールが初回だけ要る）。
