package influxdb.listener.models.icinga;

import com.google.gson.annotations.SerializedName;

import java.util.Arrays;

/**
 * A model for the check result contained in the check event returned by the icinga event stream
 */
public class CheckResult {
    @SerializedName("execution_end")
    private float executionEnd;
    @SerializedName("exit_status")
    private int exitStatus;
    private String output;
    @SerializedName("performance_data")
    private Object[] performanceData;
    private int state;

    public float getExecutionEnd() {
        return this.executionEnd;
    }

    public int getExitStatus() {
        return exitStatus;
    }

    public String getOutput() {
        return output;
    }

    public Object[] getPerformanceData() {
        return performanceData;
    }

    public int getState() {
        return state;
    }

    @Override
    public String toString() {
        return "CheckResult{" +
                "executionEnd=" + executionEnd +
                ", exitStatus=" + exitStatus +
                ", output='" + output + '\'' +
                ", performanceData=" + Arrays.toString(performanceData) +
                ", state=" + state +
                '}';
    }
}
