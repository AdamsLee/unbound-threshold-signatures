# unbound-threshold-signatures-demo

本docker镜像用于演示unbound-tech的开源项目[2方门限签名](https://github.com/AdamsLee/blockchain-crypto-mpc) 
- 启动容器，docker-compose会启动两个容器，分别代表两个参与方，其中一方作为协调服务方
```
docker-compose up -d
```
- 进入门限签名参与者同时作为服务方的容器
```
docker-compose exec threashold-sig-server bash
```
- 为了方便编辑demo代码，将宿主机上的代码mount到了容器中的workspace-crypto-mpc,如果不需要编辑，可以将下面命令行中的workspace-crypto-mpc替换为bloack-crypto-mp即可

* 密钥生成
    - 启动生成密钥的程序
    ```
    python3.6 /usr/share/workspace-crypto-mpc/python/mpc_demo.py --out_file /usr/share/blockchain-crypto-mpc/data/key_share_server.bin --server --host threashold-sig-server
    ```

    - 进入门限签名参与者另外一方的容器
    ```
    docker-compose exec threashold-sig-client bash
    ```
    - 启动生成密钥的程序
    ```
    python3.6 /usr/share/workspace-crypto-mpc/python/mpc_demo.py --type ECDSA --command generate --out_file /usr/share/blockchain-crypto-mpc/data/key_share_client.bin --host threashold-sig-server
    ```
    - 成功完成密钥生成，验证宿主机crypto-mpc-data目录下已经新创建了key_share_client.bin和key_share_server.bin两个文件
* 签名    
    - 回到服务方容器，进行签名
    ```
    python3.6 /usr/share/workspace-crypto-mpc/python/mpc_demo.py --in_file /usr/share/blockchain-crypto-mpc/data/key_share_server.bin --data_file /usr/share/blockchain-crypto-mpc/data/data.txt --server --host threashold-sig-server 
    ```
    - 回到另一方容器进行签名
    ```
    python3.6 /usr/share/workspace-crypto-mpc/python/mpc_demo.py --type ECDSA --command sign --in_file /usr/share/blockchain-crypto-mpc/data/key_share_client.bin --data_file /usr/share/blockchain-crypto-mpc/data/data.txt --host threashold-sig-server --out_file /usr/share/blockchain-crypto-mpc/data/sign_client.bin
    ```
    - 完成签名，验证宿主机crypto-mpc-data目录下已经生成了签名文件sign_client.bin

* 获取公钥
    - 如要获取公钥，可以通过以下方法：回到服务方容器，
    ```
    python3.6 /usr/share/workspace-crypto-mpc/python/mpc_demo.py --in_file /usr/share/blockchain-crypto-mpc/data/key_share_server.bin --server --host threashold-sig-server --out_file /usr/share/blockchain-crypto-mpc/data/pubkey_server.txt
    ```
    - 回到另一方容器
    ```
    python3.6 /usr/share/workspace-crypto-mpc/python/mpc_demo.py --type ECDSA --command getpubkey --in_file /usr/share/blockchain-crypto-mpc/data/key_share_client.bin --host threashold-sig-server --out_file /usr/share/blockchain-crypto-mpc/data/pubkey_client.txt
    ```
    - 两方获得的公钥信息应该是一样的。另外在服务方的console输出了公钥对应的BTC的测试网地址

* 验证签名
    - 如要需要验证输出的签名，可以通过以下方法：回到服务方容器，
    ```
    python3.6 /usr/share/workspace-crypto-mpc/python/mpc_demo.py --in_file /usr/share/blockchain-crypto-mpc/data/key_share_server.bin --data_file /usr/share/blockchain-crypto-mpc/data/data.txt --server --host threashold-sig-server --sig_file /usr/share/blockchain-crypto-mpc/data/sign_client.bin
    ```
    - 回到另一方容器
    ```
    python3.6 /usr/share/workspace-crypto-mpc/python/mpc_demo.py --type ECDSA --command verify --in_file /usr/share/blockchain-crypto-mpc/data/key_share_client.bin --data_file /usr/share/blockchain-crypto-mpc/data/data.txt --host threashold-sig-server --sig_file /usr/share/blockchain-crypto-mpc/data/sign_client.bin
    ```
    - 如果验证失败console会报出异常    