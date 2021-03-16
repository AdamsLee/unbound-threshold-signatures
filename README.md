# unbound-threshold-signatures-demo

本docker镜像用于演示unbound-tech的开源项目[2方门限签名](https://github.com/unbound-tech/blockchain-crypto-mpc.git) 
- 启动容器，docker-compose会启动两个容器，分别代表两个参与方，其中一方作为协调服务方
```
docker-compose up -d
```
- 进入门限签名参与者同时作为服务方的容器
```
docker-compose exec threashold-sig-server bash
```
- 启动生成密钥的程序
```
python3.7 /usr/share/blockchain-crypto-mpc/python/mpc_demo.py --out_file /usr/share/blockchain-crypto-mpc/data/key_share_server.bin --server --host threashold-sig-server
```

- 进入门限签名参与者另外一方的容器
```
docker-compose exec threashold-sig-client bash
```
- 启动生成密钥的程序
```
python3.7 /usr/share/blockchain-crypto-mpc/python/mpc_demo.py --type EDDSA --command generate --out_file /usr/share/blockchain-crypto-mpc/data/key_share_client.bin --host threashold-sig-server
```
- 成功完成密钥生成，验证宿主机crypto-mpc-data目录下已经新创建了key_share_client.bin和key_share_server.bin两个文件
- 回到服务方容器，进行签名
```
python3.7 /usr/share/blockchain-crypto-mpc/python/mpc_demo.py --in_file /usr/share/blockchain-crypto-mpc/data/key_share_server.bin --data_file /usr/share/blockchain-crypto-mpc/data/data.dat --server --host threashold-sig-server 
```
- 回到另一方容器进行签名
```
python3.7 /usr/share/blockchain-crypto-mpc/python/mpc_demo.py --type EDDSA --command sign --in_file /usr/share/blockchain-crypto-mpc/data/key_share_client.bin --data_file /usr/share/blockchain-crypto-mpc/data/data.dat --host threashold-sig-server --out_file /usr/share/blockchain-crypto-mpc/data/sign_client.bin
```
- 完成签名，验证宿主机crypto-mpc-data目录下已经生成了签名文件sign_client.bin