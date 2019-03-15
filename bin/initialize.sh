#! /bin/bash -e
GIT_BASE_DIR=`git rev-parse --show-toplevel`
SCRIPT_DIR=$(cd $(dirname $0); pwd)

source $GIT_BASE_DIR/bin/export_ssh_keys.sh
source $GIT_BASE_DIR/.env

vagrant up
# ゲスト側で接続許可されている公開鍵一覧に記載がなければ追記する
# いろいろ実験したけど、ホスト側のコマンドの実行結果をゲスト側に渡すには以下の書き方しかうまくいかなかった
# ゲスト側でチルダを使おうとしても、先に展開されるようでホスト側のパスが返ってしまう
ssh_key_pub_body=`cat ~/.ssh/id_ecdsa_vagrant.pub`
vagrant ssh -c "if ! grep '${ssh_key_pub_body}' /home/vagrant/.ssh/authorized_keys > /dev/null 2>&1; then echo '${ssh_key_pub_body}' >> /home/vagrant/.ssh/authorized_keys;fi"

# vagrant ssh は256色が適用されないので使いたくないが、そうすると ssh-forward が利用できなくなるので、普段使っている鍵ファイルをコピーしておく
hostname=`vagrant ssh-config | grep 'HostName ' | sed -e 's/ *HostName *//g'`
port=`vagrant ssh-config | grep 'Port ' | sed -e 's/ *Port *//g'`
user=`vagrant ssh-config | grep 'User ' | sed -e 's/ *User *//g'`

# 環境の再構築などでフィンガープリントが変化した場合、接続できないので再生成する
ssh-keygen -R [${hostname}]:${port}

scp -o StrictHostKeyChecking=no -P $port -i $COMMON_SSH_PRIVATE_KEY ~/.ssh/id_rsa $user@$hostname:/home/vagrant/.ssh/

# ssh-config ファイルを読み込ませる
if ! grep "Include ~/.ssh/conf.d/hosts/*" ~/.ssh/config > /dev/null; then
  echo "Include ~/.ssh/conf.d/hosts/*" >> ~/.ssh/config;
fi
mkdir -p ~/.ssh/conf.d/hosts/
# 専用の ssh-config ファイルがない場合は共通設定付きで新規作成
if [ ! -e $VM_SSH_CONFIG ]; then
  echo "Host *" > $VM_SSH_CONFIG
  echo "  IdentityFile    ~/.ssh/id_ecdsa_vagrant" >> $VM_SSH_CONFIG
fi
vm_hostname=`grep 'hostname' Vagrantfile | sed -r "s/^.*hostname * = ['\"](.*)['\"]/\1/g"`
# Host 定義がない場合は先頭に追記(後勝ちなので、共通設定は最後に残しておく)
if ! grep "Host ${vm_hostname}" $VM_SSH_CONFIG; then
  sed -i "1s/^/  User            ${user}\n/" $VM_SSH_CONFIG
  sed -i "1s/^/  Port            ${port}\n/" $VM_SSH_CONFIG
  sed -i "1s/^/  HostName        ${hostname}\n/" $VM_SSH_CONFIG
  sed -i "1s/^/Host ${vm_hostname}\n/" $VM_SSH_CONFIG
fi

echo -e "\e[30;42mplease use follow ssh command. ssh ${vm_hostname} \e[m"
