using System;
using UnityEngine;
using System.Runtime.InteropServices;

public class NativeDatePickerManager : MonoBehaviour
{
    public static NativeDatePickerManager Instance;
    public Action<DateTime> OnDateSelected;
    
    #if UNITY_ANDROID
    private AndroidJavaClass unityClass;
    private AndroidJavaObject unityActivity;
    private AndroidJavaObject pluginInstance;
    private PluginCallback pluginCallback;
    #endif
    
    #if UNITY_IOS
    [DllImport("__Internal")] private static extern void cOpenDatePicker();
    #endif

    private void Awake()
    {
        if (Instance != null) Destroy(Instance);
        Instance = this;
    }

    private void Start()
    {
        #if UNITY_ANDROID && !UNITY_EDITOR
        InitializePlugin("com.plugin.datepickerlibrary.DatePicker");
        pluginCallback = new PluginCallback {manager = this};
        SetPluginCallback(pluginCallback);
        #endif
    }

    private void InitializePlugin(string pluginName)
    {
        #if UNITY_ANDROID && !UNITY_EDITOR
        unityClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
        unityActivity = unityClass.GetStatic<AndroidJavaObject>("currentActivity");
        pluginInstance = new AndroidJavaObject(pluginName);
        if (pluginInstance == null)
        {
            Debug.Log("Plugin instance Null!!");
            return;
        }

        pluginInstance.CallStatic("ReceiveUnityActivity", unityActivity);
        #endif
    }

    private void SetPluginCallback(PluginCallback callback)
    {
        #if UNITY_ANDROID && !UNITY_EDITOR
        pluginInstance.Call("SetPluginCallback", callback);
        #endif
    }

    public void PickDate(Action<DateTime> onDateSelected)
    {
        OnDateSelected = onDateSelected;
        #if UNITY_EDITOR
        OnDateSelected?.Invoke(new DateTime(2000, 12, 04));
        return;
        #endif
        #if UNITY_ANDROID
        pluginInstance.Call("PickDate");
        #endif
        #if UNITY_IOS
        cOpenDatePicker();  
        #endif
    }
    
    public void OnDatePicked(string date)
    {
        DateTime selectedDate = DateTime.Parse(date);
        OnDateSelected?.Invoke(selectedDate);
        Debug.Log($"IOS Date Picked : {date}");
    }
}

public class PluginCallback : AndroidJavaProxy
{
    public PluginCallback() : base("com.plugin.datepickerlibrary.PluginCallback")
    {
    }

    public NativeDatePickerManager manager;

    public void OnDatePicked(int year, int month, int day)
    {
        Debug.Log("Android Date Picked: " + year + "/" + month + "/" + day);
        DateTime selectedDate = new DateTime(year, month, day);
        manager.OnDateSelected?.Invoke(selectedDate);
    }
}