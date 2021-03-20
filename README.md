## スケジュール管理アプリ  
従業員の勤怠管理と、予約スケジュールを登録、閲覧できるアプリケーションです。  
SPAによるチャート描画により、手早く簡単にスケジュール確認ができます。  


#### スケジュール管理アプリ  
https://salty-ridge-38735.herokuapp.com/users/1  


![B22C0299-B1C0-4B1B-9E0C-DE021102C0DE_1_105_c](https://user-images.githubusercontent.com/47071757/111869924-fa3f9b80-89c4-11eb-9f0f-955705b773ee.jpeg)

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
```markdown 
Ruby on Rails `v6.0.3`  
Vue.js `@2.6.11`
```
