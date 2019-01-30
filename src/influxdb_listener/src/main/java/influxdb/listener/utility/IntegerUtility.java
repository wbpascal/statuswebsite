package influxdb.listener.utility;

public class IntegerUtility {
    public static boolean isInteger(String str) {
        if (str == null || str.isEmpty()) return false;

        int i = 0;
        if (str.charAt(0) == '-') {
            if (str.length() == 1) return false;
            i = 1;
        }
        for (; i < str.length(); i++) {
            char c = str.charAt(i);
            if (c < '0' || c > '9') return false;
        }
        return true;
    }
}
