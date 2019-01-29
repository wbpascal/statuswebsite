/*
 * This Java source file was generated by the Gradle 'init' task.
 */
package monitored_service;

import org.flywaydb.core.Flyway;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class App {
    public static void main(String[] args) {
        Flyway flyway = Flyway.configure().dataSource("jdbc:mysql://mariadb:3306/monitored_services", "root", System.getenv("MYSQL_ROOT_PASS")).load();
        // flyway.validate();
        flyway.migrate();
        SpringApplication.run(App.class, args);
    }
}
