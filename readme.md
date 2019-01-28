```sh
cd boxes/
cp -ar foo test_foo
cd test_foo
vi Vagrantfile
  edit: config.vm.hostname = "foo"
  edit: vb.name = "bar"
bash ../../bin/initialize.sh
ssh foo
```
