### サービスの概要
「多肉植物に興味はあるが、育て方やイベントの参加に不安を感じる」という悩みを持つ人に  
「多肉植物の記録を共有、また多肉植物のイベント参加管理」を提供する  
「多肉植物&イベントの記録・管理」サービスです。  

### ユーザーが抱える課題
課題1. 多肉植物に新しい発見や変化を感じた時の楽しさを共有できない。育て方に不安を感じる。  
課題2. 多肉植物用のイベントに参加しようと考えるが、公式サイトがないことが多く詳細が分かりづらい為、参加をためらってしまう。

### 課題に対する仮説
課題1.
- 多肉を観察し、様子の変化に楽しさを感じる人と、交流が持てていないのではないか？
- 同じ植物を似たような条件で育てている人と、情報が共有できていないのではないか?
- 成長記録を簡単に残せるツールがないのではないか？

課題2.
- 多肉のイベントについて詳細が分かるサイトが無いため、参加を迷っているのではないか？
- どんな人が参加するかが分からず、参加するまでのハードルが上がってしまっているのではないか?

### 解決方法
課題1. 多肉の成長を記録を作成、共有して、育て方の参考にしてもらう。  
課題2. 運営またはユーザに実際のイベントに基づいた、イベントの予定をリストとして作成してもらい、参加予定の人数、行った感想がコメントで分かるようにする。

### メインターゲット
- 自宅に多肉植物に植物がある20~30代。
- 多肉に興味があるが、どう管理すればいいかわからない人。
- 多肉のイベントへ参加を考えているが、どんな植物が売られどんな価格帯で売られているか分からず参加をためらってしまっている人。

### 実現したいこと
- 一般ユーザー
    - 未登録ユーザー
        - ユーザー登録機能
        - トップ画面表示
        - 投稿(観察記録)の表示機能、検索機能 (オートコンプリート)
        - イベントの表示、検索機能、GoogleMapの表示
    - 登録ユーザー
        - ログイン、ログアウト機能 (Firabase Authenticationを使ったGoogleログイン、Passwordログイン)
        - パスワードの再設定機能
        - 投稿機能
            - 観察記録の投稿
                - タイトル、本文、カテゴリー、画像を記録として投稿できる
                - 投稿した記事に関連付けて、別の記事を作成できる
                - 投稿は、本文無しのタイトルだけでも投稿できる
                - 投稿へのお気に入り機能
                - 投稿へのコメント機能
                - 投稿へのいいね機能
                - 投稿数に応じて右のウィジェットに表示されるカウンターが変化する
            - イベントの投稿
                - タイトル、日付、場所、参考URlをイベントとして投稿できる
                - 場所はMaps JavaScript API(Place API + Geocoding API)を使って住所からオートコンプリート、マーカーの設置ができる
                - 詳細な日付や時間が決定していない場合でも投稿できる
        - 記録管理機能
            - 画面右のウィジェットに関連づいた記録、関連付けられた記録をリストとして表示
        - イベント管理機機能
            - イベントへのお気に入り機能
            - イベントへのコメント機能
            - イベントへの参加機能
            - イベント一覧画面に、過去のイベントという絞り込みの条件を表示し、一覧画面でデフォルトで表示される最近の更新や参加予定、ウィジェットで表示されるイベント一覧には過去のイベントを表示しない
            - 画面右のウィジェットに、イベントへ参加するユーザーの一覧表示
            - 画面右のウィジェットに、参加する予定のイベントの中から直近のものを表示
        - 検索機能
            - 検索機能(タグ検索時のオートコンプリート、検索した値が存在しなければ人気のタグを表示)
            - 画面右上のウィジェットからも検索ができる
        - マイページ機能
            - プロフィール(アバター画像、名前、ひとこと)
            - いいねした記録、参加予定のイベント、参加予定のイベントを表示

### なぜこのサービスを作りたいのか?
一人でも管理しやすい、多肉植物の魅力をさらに広めたい。
また、植物を通じた交流が増えて、さらに多肉のイベントが活発に行われて欲しい。

そのような思いから、多肉植物の愛好家や初心者が、簡単に植物を管理し、他の愛好家と交流できる場を提供し、多肉植物に関するイベントが盛んに開催されるシステムを形成したいと考え、このサービスを開発するに至りました。
