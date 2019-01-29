# 専用の鍵ファイル作成  
```
ssh-keygen -b 521 -t ecdsa -C 'only used by vagrant' -f ~/.ssh/id_ecdsa_vagrant
```
# 作業用vmの作成  
```sh
cd boxes/
cp -ar foo test_foo
cd test_foo
vi Vagrantfile
  edit: config.vm.hostname = "foo"
  # アンダーバーは使用できないので注意
  edit: vb.name = "bar"
bash ../../bin/initialize.sh
ssh foo
```
# 2回目以降の起動  
```sh
cd boxes/
cd test_foo
vagrant up
```
# dotfiles のインストール
https://github.com/madayo/dotfiles
