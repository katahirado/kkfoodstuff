kkfoodstuff
======================
レシピ本の食材検索アプリ
MySQL InnoDBの全文検索機能をつかっているので、MySQLは5.6.4以上です。

## 動かしてみる場合
my.cnfに下記追加

```
    [mysqld]
    innodb_ft_min_token_size = 2
```

後はdatabase.yml.sampleをコピペしてdatabase.ymlを作って、いつもどおりな感じで。
