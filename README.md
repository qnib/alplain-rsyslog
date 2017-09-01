# alplain-rsyslog
Alpine image holding rsyslog


```bash
$ docker stack deploy --compose-file docker-compose.yml rsyslog
Creating service rsyslog_kibana
Creating service rsyslog_ubuntu
Creating service rsyslog_rsyslog
Creating service rsyslog_elasticsearch
$ sleep 30 && open http://localhost:5601
```

## Push a Message

```bash
$ docker exec -ti $(docker ps -qf label=com.docker.swarm.service.name=rsyslog_ubuntu) \
                  logger --server tasks.rsyslog --port 514 Test$(date +%s)
```
