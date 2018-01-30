# LIVY ENVIRONMENT VARIABLES
#
# - JAVA_HOME       Java runtime to use. By default use "java" from PATH.
# - HADOOP_CONF_DIR Directory containing the Hadoop / YARN configuration to use.
# - SPARK_HOME      Spark which you would like to use in Livy.
# - SPARK_CONF_DIR  Optional directory where the Spark configuration lives.
#                   (Default: $SPARK_HOME/conf)
# - LIVY_LOG_DIR    Where log files are stored. (Default: ${LIVY_HOME}/logs)
# - LIVY_PID_DIR    Where the pid file is stored. (Default: /tmp)
# - LIVY_SERVER_JAVA_OPTS  Java Opts for running livy server (You can set jvm related setting here,
#                          like jvm memory/gc algorithm and etc.)
# - LIVY_IDENT_STRING A name that identifies the Livy server instance, used to generate log file
#                     names. (Default: name of the user starting Livy).
# - LIVY_MAX_LOG_FILES Max number of log file to keep in the log directory. (Default: 5.)
# - LIVY_NICENESS   Niceness of the Livy server process when running in the background. (Default: 0.)
SPARK_HOME=/spark
SPARK_CONF_DIR=$SPARK_HOME/conf
