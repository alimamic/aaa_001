## bot

### Install

```
apt install -y protobuf-compiler
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest
```

### Database

```
mysql -h127.0.0.1 -u test_user -ptest_password bot_db
```

```
psql -h 127.0.0.1 -U test_user -p 5466 -W  bot_db
```

### 需要的secret

数据库的 url、账号密码
```
BOT_DB_HOST
BOT_DB_USER
BOT_DB_PASSWORD
```

```
BOT_BOTMAN_TOKEN
```

手续费地址盐
```
BOT_RECIPIENT_SALT
```

KMS地址
```
BOT_API_SECRET
```

### 需要的环境变量
```
BOT_DB_NAME
BOT_DB_PORT
```

```
BOT_API_KEYMANAGE
```


## bot-task
### 需要的secret

数据库的 url、账号密码
```
BOT_DB_HOST
BOT_DB_USER
BOT_DB_PASSWORD
```

KMS地址
```
BOT_API_SECRET
```

手续费地址盐(需要与bot一致)
```
BOT_RECIPIENT_SALT
```

### 需要的环境变量

KMS地址

```
BOT_API_KEYMANAGE
```

```
BOT_DB_NAME
BOT_DB_PORT
```
