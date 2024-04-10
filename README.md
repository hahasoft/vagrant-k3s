# vagrant-k3s
script vagrant provision k3s on virtualbox

## Run Command
```
$ vagrant up
#wait success

$ vagrant ssh server
$ cd /tmp
$ chmod 775 server-install.sh
$ ./server-install.sh

```


#### vagrant command
```
$ vagrant up 
$ vagrant halt
$ vagrant ssh {server_name}

delete and remove
$ vagrant destroy -f & rm -rf .vagrant*
```