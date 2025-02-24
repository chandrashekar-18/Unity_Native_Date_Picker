# Unity Native Date Picker Plugin

A native plugin for Unity to integrate the system date picker on both Android and iOS. This plugin leverages platform-specific native UI components to provide a consistent date selection experience in your Unity projects.

## Features

- **Android Integration:** Uses a Java plugin (provided as an AAR file in the Plugins/Android folder with the fully qualified name `com.plugin.datepickerlibrary.DatePicker`) to open the native Android date picker. See the Unity C# integration in [NativeDatePickerManager.cs](&#8203;:contentReference[oaicite:0]{index=0}).
- **iOS Integration:** Implements an Objective-C plugin ([DatePickerPlugin.m](&#8203;:contentReference[oaicite:1]{index=1})) that displays the native UIDatePicker.
- **Editor Simulation:** In the Unity Editor, a dummy date is returned for quick testing.
- **Simple API:** Easily trigger the date picker and receive the selected date via callbacks, as demonstrated in [DemoUI.cs](&#8203;:contentReference[oaicite:2]{index=2}).

## Installation & Integration

### 1. Clone or Download the Repository

Clone this repository into your project folder or download it as a ZIP file and extract it.

### 2. Import Scripts into Unity

- **Scripts:**  
  Place the following scripts into your Unity project’s `Scripts/` folder (or a folder of your choice):
  - [NativeDatePickerManager.cs](&#8203;:contentReference[oaicite:3]{index=3})
  - [DemoUI.cs](&#8203;:contentReference[oaicite:4]{index=4})

- **iOS Plugin:**  
  Copy the [DatePickerPlugin.m](&#8203;:contentReference[oaicite:5]{index=5}) file into the `Plugins/iOS/` folder. Unity will include this file when building for iOS.

- **Android Plugin:**  
  Place the provided Java plugin AAR file (e.g., `DatePickerLibrary-release.aar`) into the `Plugins/Android/` folder. This AAR file contains the implementation for the native Android date picker. You will also need to configure the following Gradle files:
  
  - **gradleTemplate.properties:**  
    This file should contain the following line:
    ```
    android.useAndroidX=true
    ```
  
  - **mainTemplate.gradle:**  
    Inside the `dependencies` section of your `mainTemplate.gradle`, add:
    ```
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    ```
  
  Additionally, set the **Minimum SDK** to **24** in your Unity Player Settings.

### 3. Android Integration Steps

- **Java Plugin:**  
  The Unity C# code calls into the Java plugin by using `AndroidJavaObject` to invoke methods such as `PickDate` and pass the current Unity activity. The Java plugin is provided as an AAR file in the `Plugins/Android/` folder and must contain the implementation for `com.plugin.datepickerlibrary.DatePicker`.

- **Gradle Configuration:**  
  Configure your Gradle build files as follows:
  - In **gradleTemplate.properties**, include `android.useAndroidX=true`.
  - In **mainTemplate.gradle**, add the dependency `implementation 'androidx.constraintlayout:constraintlayout:2.1.4'` inside the dependencies block.
  - Ensure that your project's **Minimum SDK** is set to **24** under Unity Player Settings.

### 4. iOS Integration Steps

- **Objective-C Plugin:**  
  The [DatePickerPlugin.m](&#8203;:contentReference[oaicite:6]{index=6}) file contains the native code to display a UIDatePicker with a custom toolbar. When the user taps the "OK" button, the plugin sends the selected date back to Unity using `UnitySendMessage`.

- **Xcode Project:**  
  When you build for iOS, ensure that Xcode includes the DatePickerPlugin.m file. This file should be part of your Xcode project under the Plugins/iOS directory.

## Usage

1. **Attach the Manager:**  
   Make sure that `NativeDatePickerManager` is attached to a GameObject in your scene (or create one at runtime). This manager handles the communication with the native date picker.

2. **Set Up UI:**  
   Use the provided [DemoUI.cs](&#8203;:contentReference[oaicite:7]{index=7}) as an example. In this demo, a button click triggers the date picker and the selected date is displayed on a TextMeshPro label.

   ```csharp
   public void OnPickDateButtonClicked()
   {
       NativeDatePickerManager.Instance.PickDate(OnDateSelected);
   }

   private void OnDateSelected(DateTime date)
   {
       _selectedDateText.text = date.ToString("dd/MM/yyyy");
   }

3. **Testing:**
 - Unity Editor:
  Clicking the pick date button in the Unity Editor will simulate a date (December 4, 2000).

 - Android & iOS Devices:
  On actual devices, the native date picker UI will be displayed, allowing for real date selection.

## Screenshots
Below are sample screenshots showing the native date picker on Android and iOS.

| **Android** | **iOS** |
| --- | --- |
| <img src="https://github.com/user-attachments/assets/300dcd67-038b-4920-b33a-4445e9d75e0d" alt="Android Date Picker" width="195" height="422"> | <img src="https://github.com/user-attachments/assets/1edf1a0a-7150-477b-98bd-70e2a34c4045" alt="iOS Date Picker" width="195" height="422"> |
