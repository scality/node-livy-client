# Node-Livy-Client

A comprehensive client in Node.js for [Apache Livy](http://livy.incubator.apache.org/). Livy is a REST service
for Apache Spark.

## Usage

`npm install node-livy-client`

``` js
const LivyClient =  require('node-livy-client');

const client = new LivyClient({ host: 'localhost' });

client.postSession({}, (err, res) => {
    // will create a spark session by default
    console.log("res: ", res);    
});
```

See tests/functional/client.js for further API call examples. 

All Livy API calls should be supported. Please open an issue if you discover any missing.

See lib/client.js for available options.

## Test

You must have Livy installed and running locally to run tests. 

Download Livy [here](http://livy.incubator.apache.org/download/).

Go to directory where Livy has been downloaded.

`export SPARK_HOME=${YOUR SPARK PATH}/libexec`

Please make sure that in your livy.conf file, you include: 

`livy.file.local-dir-whitelist=${PATH TO NODE-LIVY-CLIENT DIRECTORY}`

`mkdir logs`

`./bin/livy-server`

From within your node-livy-client directory:
`npm test`



