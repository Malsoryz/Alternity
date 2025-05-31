# Tips

## Mariadb Container

Build Container and start
```bash
podman run -d --name sql_server -p 3306:3306 -e MYSQL_ROOT_PASSWORD=rootpass -v /home/aru/.mariadb/data:/var/lib/mysql mariadb:latest
```

Start Container
```bash
podman start sql_server
```


