# Grafana Influx go stack from Source
All Containers are based on Alpine-Linux 
You can setup different versions by changing the variables within the docker files

Build golang:1.6, influx and finally grafana
# run influx
``` 
docker run -itd -p 8083:8083 -p 8086:8086 -p 2003:2003 -p 4242:4242 -p 25827:25827 --name influx influx
```
# run grafana
```
docker run -dti -p 3000:3000 --link influx  grafana
```

now logon to http://localhost:3000 and setup your datasource

Influx Admin runs on http://localhost:8083
