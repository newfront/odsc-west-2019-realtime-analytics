## Workshop Material: for Near RealTime Predictive Analytics with Apache Spark Structured Streaming Workshop
Open Data Science Conference WEST 2019

[Session Information @ ODSC](http://bit.ly/odsc-west-2019-realish)

### About the Speaker
Find me on Twitter: [@newfront](https://twitter.com/newfront)
Find me on Medium [@newfrontcreative](https://medium.com/@newfrontcreative)
About Twilio: [Twilio](https://twilio.com)

## Runtime Requirments
1. Docker (at least 2 CPU cores and 8gb RAM)
2. System Terminal (iTerm, Terminal, etc)
3. Working Web Browser (Chrome or Firefox)

### Technologies Used
1. [Apache Zeppelin](https://zeppelin.apache.org/docs/latest/interpreter/spark.html)
2. [Apache Spark](http://spark.apache.org/)
3. [Redis](https://redis.io/)

### Docker
Install Docker Desktop (https://www.docker.com/products/docker-desktop)

Additional Docker Resources:
* https://docs.docker.com/get-started/
* https://hub.docker.com/

#### Docker Runtime Recommendations
1. 2 or more cpu cores.
2. 8gb/ram or higher.

## Installation
1. Install Docker (See Docker above)
2. Once Docker is installed. Open up your terminal application and `cd /path/to/odsc-west-2019-realtime-analytics/docker`
3. `./run.sh install`
4. `./run.sh start`

### Notes
The initial download can take some time depending on your WiFi connection. Expect this to take around 5-10 minutes and fingers crossed it goes faster!

#### Initialization Process
The `./run.sh init` process will 1.) download Apache Spark and untar it into `docker/spark-2.4.4` and 2.) `unzip` the wine reviews data set from `docker/data`.

#### Runtime Process
The `./run.sh start` will 1.) download the official `Apache Zeppelin` docker image, and 2.) download the official `Redis` docker image. It will then run `docker compose` on redis followed by zeppelin. Zeppelin will use the spark version (`2.4.4`) that you downloaded in the `init` phase so we are running on the latest and greatest Spark.

## Checking Zeppelin and Updating Zeppelin
1. The **Main Application** should now be running at http://localhost:8080/

### Update the Zeppelin Spark Interpreter Runtime
1. Go to http://localhost:8080/#/interpreter on your Web Browser
2. Search for `spark` in the `Search Interpreters` input field.
3. Click the `edit` button to initiate editing mode.

#### Update the Properties (under the properties section)
Add the following key/values.
1. **spark.redis.host** redis5
2. **spark.redis.port** 6379

Updated the following key/values
1. **spark.cores.max** 2
2. **spark.executor.memory** 8g

#### Update the Dependencies (under the dependencies section)
1. Add `com.redislabs:spark-redis:2.4.0`
2. Click `Save` and these settings will be applied to the Zeppelin Runtime.

#### Sending User Book Likes via Redis Streams
~~~
docker exec -it redis5 redis-cli
~~~
~~~
xadd books-liked * userId 1 bookId 3
~~~

These events will now be preocessed in spark-2.4.4 `foreachBatch`