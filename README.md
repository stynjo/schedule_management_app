## スケジュール管理アプリ  
従業員の勤怠管理と、予約スケジュールを登録、閲覧できるアプリケーションです。  
SPAによるチャーと描画により、手早く簡単にスケジュール確認ができます。  

## セットアップ手順 
```markdown  
開発環境: cloud9  
OS: Amazon Linux 2  
 ```
 
 ```markdown.rb
* Railsをインストール  
`gem install rails -v 6.0.3` 

* アプリケーションを新規作成  
`rails _6.0.3_ new アプリ名`  
`bundle install`  

* yarnインストール  
`npm install -g yarn`  

* webpackerをインストール  
`rails webpacker install`  

* config/environments/development.rbにhostを追加  

Rails.application.configure do
（中略）
  config.hosts << "<許可したいホスト名>"
（中略）
end
```  

## 使用技術  
Ruby on Rails `v6.0.3`  
Vue.js `@2.6.11`
