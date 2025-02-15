package com.plugin.datepickerlibrary;

import android.app.Activity;
import android.app.DatePickerDialog;

import java.util.Calendar;

public class DatePicker {
    private static Activity unityActivity;
    private PluginCallback pluginCallback;

    public static void ReceiveUnityActivity(Activity activity) {
        unityActivity = activity;
    }

    public void SetPluginCallback(PluginCallback pluginCallback) {
        this.pluginCallback = pluginCallback;
    }

    public void PickDate() {
        if (unityActivity == null) {
            return;
        }

        Calendar calendar = Calendar.getInstance();
        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH);
        int day = calendar.get(Calendar.DAY_OF_MONTH);

        DatePickerDialog datePickerDialog = new DatePickerDialog(unityActivity, R.style.DialogTheme, this::OnDateSet, year, month, day);
        datePickerDialog.show();
    }

    private void OnDateSet(android.widget.DatePicker view, int selectedYear, int selectedMonth, int selectedDay) {
        if (pluginCallback != null) {
            pluginCallback.OnDatePicked(selectedYear, selectedMonth + 1, selectedDay);
        }
    }
}
