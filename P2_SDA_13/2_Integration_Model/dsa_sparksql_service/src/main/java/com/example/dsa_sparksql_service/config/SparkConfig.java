package com.example.dsa_sparksql_service.config;

import org.apache.spark.sql.SparkSession;
import org.apache.spark.sql.hive.thriftserver.HiveThriftServer2;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SparkConfig {

    @Bean
    public SparkSession sparkSession() {
        System.setProperty("hadoop.home.dir", "C:\\temp");

        SparkSession spark = SparkSession.builder()
                .appName("J4DI_Integration_Engine")
                .master("local[*]")
                .config("spark.driver.bindAddress", "127.0.0.1")
                .config("spark.driver.host", "127.0.0.1")
                //SINCE  OS IS WINDOWS SELECTING TEMP AS WAREHOUSE
                .config("spark.sql.warehouse.dir", "file:///C:/temp/")
                .config("spark.ui.enabled", "false")
                // MORE RESOURCES FOR THE INTEROGATIONS
                .config("spark.driver.memory", "4g")
                .config("spark.executor.memory", "4g")
                .config("spark.driver.maxResultSize", "2g")
                .config("spark.network.timeout", "800s")
                .config("spark.executor.heartbeatInterval", "60s")
                // ACTIVARE HIVE SUPPORT pentru JDBC
                .enableHiveSupport()
                .config("hive.server2.thrift.port", "10000")
                .config("hive.server2.authentication", "NONE")
                .getOrCreate();

        // PORNIRE PROGRAMATICĂ A THRIFT SERVER
        // Aceasta permite serviciului 8085 să se conecteze la 8084 via JDBC
        HiveThriftServer2.startWithContext(spark.sqlContext());

        return spark;
    }
}