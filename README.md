focalboard Docker images [![build](https://github.com/nicoulaj/focalboard-docker/actions/workflows/build.yaml/badge.svg)](https://github.com/nicoulaj/focalboard-docker/actions/workflows/build.yaml)
=========================

Cross platform Docker images for [focalboard](https://www.focalboard.com).

The images are available at Dockerhub: [`nicoulaj/focalboard`](https://hub.docker.com/r/nicoulaj/focalboard).

Usage
-----

### docker

```
docker run -p 8000:8000 nicoulaj/focalboard
```

### docker-compose

* `config.json`:

    ```
    {
        ["serverRoot": "http://focalboard.tld",]
        "port": 8000,
        "dbtype": "sqlite3",
        "dbconfig": "/var/lib/focalboard/focalboard.db",
        "postgres_dbconfig": "dbname=focalboard sslmode=disable",
        "useSSL": false,
        "webpath": "./pack",
        "filespath": "/var/lib/focalboard/files",
        "telemetry": false,
        "session_expire_time": 2592000,
        "session_refresh_time": 18000,
        "localOnly": false,
        "enableLocalMode": true,
        "localModeSocketLocation": "/var/tmp/focalboard_local.socket"
    }
    ```

* `docker-compose.yml`:

    ```
    services:
      focalboard:
        image: nicoulaj/focalboard
        volumes:
        - ./config.json:/opt/focalboard/config.json
        - /var/lib/focalboard:/var/lib/focalboard
    ```
