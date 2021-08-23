Сборка docker образа microtick для akash
```
docker build -t bloqhub/mtm-ssh:0.1 --build-arg password=sshpassword ./
```
sshpassword - пароль ssh для root аккаунта и размещаем образ на dockerhub   
помещаем собранный образ в docker hub
```
docker push bloqhub/mtm-ssh:0.2.3
```
