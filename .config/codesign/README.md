```bash
openssl req -new -newkey rsa:2048 -x509 -days 3650 -nodes -config ./lldb_codesign.cfg -extensions codesign_reqext -batch -out lldb_codesign.cer -keyout lldb_codesign.key
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain lldb_codesign.cer
sudo security import lldb_codesign.key -A -k /Library/Keychains/System.keychain
codesign -s llvm_codesign $(which llvm)
sudo pkill -f /usr/libexec/taskgated # restart(reload) taskgated daemon

sudo security authorizationdb write system.privilege.taskport allow # need once
DevToolsSecurity -enable # need once
```
