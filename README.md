kkfoodstuff
======================
レシピ本の食材検索アプリ  
MySQL InnoDBの全文検索機能をつかっているので、MySQLは5.6.4以上です。  
MeCabで形態素解析とngramでのBoolean Full-Text Searchesを使っています。

## 動かしてみる場合
MySQLは5.6.4以上を用意  
my.cnfに下記追加  
```
    [mysqld]
    innodb_ft_min_token_size = 1
```
mecabとmecab-ipadicをインストール  
後はdatabase.yml.sampleをコピペしてdatabase.ymlを作って、いつもどおりな感じで。
