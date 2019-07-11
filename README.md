## ArmV8 Kafka2.1.1 Docker镜像移植
----
### 测试验证
> 如需要修改配置，请修改config文件夹对应的文件

```bash
# 配置文件中设置了zookeeper.connect=zookeeper:2181，直接使用的--link属性来做kafka, zookeeper的连接
[root@arm ~]$ sudo docker pull zookeeper:3.4.10
[root@arm ~]$ sudo docker build -t kafka:2.1.1 .
# 启动zookeeper
[root@arm ~]$ sudo docker run --name zookeeper -itd -p 2181:2181 zookeeper:3.4.10
# 启动kafka, 注意link zookeeper, 可在kafka容器内ping 通 zookeeper:2181
[root@arm ~]$ sudo docker run --name kafka -itd -p 9092:9092 --link zookeeper kafka:2.1.1
# 验证容器启动成功, 进程正常，Logs无错误
[root@arm ~]$ sudo docker ps | grep zookeeper 
[root@arm ~]$ sudo docker ps | grep kafka
[root@arm ~]$ sudo docker logs zookeeper 
[root@arm ~]$ sudo docker logs kafka

#测试验证
# 控制台1:shell 1 进入容器创建topic
[root@arm ~] sudo docker exec -it kafka bash
[root@arm ~]$ bin/kafka-topics.sh --create --zookeeper zookeeper:2181 --replication-factor 1 --partitions 1 --topic test
# 控制台1:shell 1 创建生产数据,并发送几条消息
[root@arm ~]$ bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test

# 在另外一个终端执行操作
# 控制台2:shell 2 进入容器创建topic
[root@arm ~] sudo docker exec -it kafka bash
# 控制台2：shell 2 消费者接受数据
[root@arm ~]$ bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning
```
