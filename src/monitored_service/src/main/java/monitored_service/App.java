/*
 * This Java source file was generated by the Gradle 'init' task.
 */
package monitored_service;

public class App {
    public static void main(String[] args) throws InterruptedException  {
        while (true) {
            System.out.println("Hello");
            Thread.sleep(10000);
        }
    }
}