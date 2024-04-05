[![Version](https://img.shields.io/cocoapods/v/Apptics-SDK.svg?style=flat)](https://cocoapods.org/pods/Apptics-SDK)
[![License](https://img.shields.io/cocoapods/l/Apptics-SDK.svg?style=flat)](https://cocoapods.org/pods/Apptics-SDK)
[![Platform](https://img.shields.io/cocoapods/p/Apptics-SDK.svg?style=flat)](https://cocoapods.org/pods/Apptics-SDK)

# Apptics

Apptics is a library that enables your app to send in-app usage reports and data securly to our servers. You can track Sessions, Screens, and we also offer Crash Reporting. With minimal initialization of the framework, you get these features without doing any other configuration.

## Development Requirements:

The minimum support is for iOS 9.0, macOS 10.9, tvOS 9.0 and watchOS 3.0. Supported Swift version - 4.0. Supported devices - iPhone, iPod, iPad, Mac, Apple Watch and Apple TV. min Pod version - 1.5.3 min Xcode version 9.0

## Getting Started

* All you need to do is create a project in the Apptics console using this link [link](https://apptics.zoho.com/ac/admin/setup).
* You can use CocoaPods to install Apptics in your project.
* Your Podfile should look something like this.

  ```plaintext
      source 'https://github.com/CocoaPods/Specs.git'
      
      target 'TARGET NAME' do
        pod 'Apptics-SDK'
        
        # Pre build script will register the app version, upload dSYM file to the server and add apptics specific information to the main info.plist which will be used by the SDK.
        script_phase :name => 'Apptics pre build', :script => 'sh "./Pods/Apptics-SDK/scripts/run --upload-symbols-for-configurations="Release, AppStore"', :execution_position => :before_compile                        
        
      end
  ```

  Usage:

  ```plaintext
   run --upload-symbols-for-configurations="Release, Appstore" --config-file-path="YOUR_PATH/apptics-config.plist" --app-group-identifier="group.com.company.application [Optional]"
  ```

  Parameters:
  * `--upload-symbols-for-configurations` String - Provide the configurations separated by comma for which the dSYM files should be uploaded.
  * `--config-file-path` String - Provide the path of apptics-config.plist file if to any sub directory instead of root.
  * `--app-group-identifier` String - App group identifier to support app extensions.
* Run `pod install` and make sure you are connected to the LAN or wifi to access the Git repo.
* Create a new application or select an existing application from the Quickstart page to download the `apptics-config.plist`. Move the config file to the root of your Xcode project and add it to the necessary targets.
* In your `Appdelegate` class make sure you call the initialize method in the app launch.

  ```plaintext
    Apptics.initialize(withVerbose: true)
  ```
* To use Apptics in your Extensions, please refer to this [link](https://www.zoho.com/apptics/resources/SDK/iOS/app_extensions.html)

**_Note: The analytic data of App-Extensions will be sent by the main application based on the network availability._**

## **Important**:

To get proper symbolicated crashes, make sure your build settings have the following when you ship your app.

* Debug information format - **Dwarf with dSYM file**

# Features

## Session Tracking:

A session is a single period of user interaction with your app. For example, when a user opens the app for the first time and the app goes to the background, that is considered a session.

Sessions are automatically tracked in Apptics, once you have integrated our SDK and called the initialization method.

## In-app Event Tracking:

Events help you track all the user actions within your app. For example, sign up, purchase made, feedback given, and so on. Events analytics and the associated data help you understand your users. \
\
**Event types**

Zoho Apptics provides two types of event analytics; **Defined events and Custom events.** 

**Defined events**: These are the default events that are available for your use once you have integrated our SDK.

**Custom events**: These are the events that you want to capture using our SDK.

### Logging custom events

**\
Objective C**

```plaintext
[APEvent trackEvent:<#(nonnull NSString *)#> andGroupName:<#(nonnull NSString *)#>]
```

**Swift**

```plaintext
APEvent.trackEvent(<#T##eventName: String##String#>, withGroupName: <#T##String#>)
```

Make sure that **the event name and group name** follow the below norms, or else the event won't be logged within the SDK.

* should not be more than 100 characters.
* should start with an alphabet.
* should not contain any space or special characters apart from underscore (_).
* cannot start with 'ap_' or 'AP_'. These are reserved for the defined events.

An example of a valid event name: 'helloworld', 'Hello_world', 'helloWorld'\
An example of an invalid event name: '_helloworld', '1hello', \`Hello World\`, 'ap_helloworld\`\
\
For more details, please visit our SDK guide for [In-App-Events](https://www.zoho.com/apptics/resources/SDK/iOS/in_app_events.html)

## Screen Tracking:

Screens are content that your users view in your app. Using Zoho Apptics' screen tracking, you can measure the screen views and associate the screen data with events. This helps you to understand user engagement and behavior. 

* Make sure that you have integrated Apptics with your app. Refer to the [integration guide](https://www.zoho.com/apptics/resources/SDK/iOS/integration.html) for detailed steps.
* Once the integration is done, you can track the screens either manually or automatically.

### Manual screen tracking

* You can track the screens manually and also provide custom screen names using Apptics. 
* Use the below method to view the controller class that you want to track.\
  \
  To track the entry of the view, call the method viewDidAppear.\
  \
  **Objective C**

  ```plaintext
  [APScreentracker trackViewEnter:<#(nonnull NSString *)#>];
  ```

  **Swift**

  ```plaintext
  APScreentracker.trackViewEnter(<#T##screenName: String##String#>)
  ```

  To track the exit of the view, call the method viewWillDisappear.\
  \
  **Objective C**

  ```plaintext
  [APScreentracker trackViewExit:<#(nonnull NSString *)#>];
  ```

  **Swift**

  ```plaintext
  APScreentracker.trackViewExit(<#T##screenName: String##String#>)
  ```

\
**NOTE:** Make sure that **the screen name** follows the below norms, or else the event won't be logged within the SDK.

* screen name is mandatory and cannot be nil or empty.
* screen name should not be more than 250 characters.
* should start with an alphabet.
* only numbers, spaces, dots, and underscore are allowed after the first letter.
* cannot start with 'ap_' or 'AP_'. These are reserved for the defined events.

### Crash Reporting:

Crashes are automatically tracked and symbolicated by Apptics. To get proper symbolicated reports please make sure to configure your build settings correctly.

The crashes will not be captured if the debugger is attached at the launch, please follow the below steps.

* Run your app from Xcode and install it on your simulator or device.
* Quit the app using the stop button.
* Launch the app from the home screen and try to crash the app by invoking our ready-made method `Apptics.crash()`.
* Run the app again in order to push the crash to the server and get symbolicated.

Check the web console, you should find the crash listed in the console.

#### Missing a dSYM?

Apptics includes a script to upload your project's dSYM automatically. The script is executed through the run-script in your project build phases during the onboarding process. There are some cases where dSYM upload fails because of network interruptions or improper configuration of the run script. Missing dSYMs can be uploaded by following the below steps.

#### Finding your dSYM

While archiving your project, build dSYMs are placed inside the xarchive directory. To view, open the Xcode organizer window, ctrl+click, or right-click on the list to go to the directory in Finder. ctrl+click to view its content, Inside the content, you will find a directory called "dSYMs" which will contain dSYMs files. Also, that is the location where dSYMs are placed when you hit "download dSYM" in the Xcode organizer.

#### Uploading dSYMs

On the "Manage dSYM page" (Left menu -> Quality -> dSYM), upload the dSYMs.zip that you have downloaded from the iTunes connect for bitcode enabled or the one you find in xarchive directory.

## Theme

You can use our protocols to customize the Analytics Settings, App updates and Feedback screens. Just create a swift/Obj class in the name of ThemeManager and extend those protocols to implement the required methods [link](https://prezoho.zohocorp.com/apptics/resources/SDK/iOS/customtheme.html).

## Callbacks

Get callbacks for all the events at a single point by extending `APCustomHandler`. It deals with user consent , crash consent, feedback, and ratings & reviews.

## Feedback and BugReporting

A separate module that does "Shake to Feedback", Please check if it suits your needs [here](https://prezoho.zohocorp.com/apptics/resources/SDK/iOS/in_app_feedback.html).

## App Updates

Now you can prompt users to update to the latest version of your app from the App Store.

Please check our guide before you start [here](https://prezoho.zohocorp.com/apptics/resources/SDK/iOS/in_app_updates.html).

## Ratings and Reviews

Engage with your users and learn about their experience. Promote them to rate your app after they have fulfilled the configured criteria.

Check how to configure automatic ratings [here](https://prezoho.zohocorp.com/apptics/resources/SDK/iOS/in_app_ratings.html).

## To know more!

For more information about how Apptics works, check out the below links.

* [Getting Started](https://prezoho.zohocorp.com/apptics/resources/user-guide/getting-started.html)
* [iOS user guide](https://prezoho.zohocorp.com/apptics/resources/SDK/iOS/integration.html)
* [Sample app](https://github.com/zoho/Apptics/tree/master/Examples)

For any assistance, contact Apptics at [support@zohoapptics.com](support@zohoapptics.com)
