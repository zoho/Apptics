# Apptics 
Apptics is a library that enables your app to send in-app usage reports and data securly to our servers. You can track Sessions, Screens, and we also offer Crash Reporting. With minimal initialization of the framework, you get these features without doing any other configuration.

## Development Requirements: 

The minimum support is for iOS 9.0, macOS 10.9, tvOS 9.0 and watchOS 3.0. 
Supported Swift version - 4.0.
Supported devices - iPhone, iPod, iPad, Mac, Apple watch and Apple tv.
min Pod version - 1.5.3 
min Xcode version 9.0
 
## Getting Started

* All you need to do is create a project in the Apptics console using this link [link](https://apptics.zoho.com/ac/admin/setup).

* You can use cocoapods to install Apptics in your project. 

* Your Podfile should look something like this.
    
          target '[TARGET NAME]' do
            pod 'Apptics-SDK'
          end

          post_install do |installer|
            puts system("sh ./Pods/Apptics-SDK/native/scripts/postinstaller --prefix=\"AP\" --target-name=\"[MAIN TARGET NAME STRING]\" --config-file-path=\"apptics-config.plist\"")    
          end
          
     Parameters:
     * `--project-name`       String - Provide the name of the project
     * `--target-name`         String - Provide the name of the target
     * `--project-file`            String - Provide the path of the xcproject file
     * `--prefix`                    String - **AppticsExtension.* will be prefixed by this value
     * `--use-swift`              Void - Generate class for swift
     * `--help`                      Show help banner of specified command
     * `----config-file-path` String - Provide the path of apptics-config.plist file if to any sub directory instead of root.
     
     The script `postinstaller` will add **AppticsExtension file(s) to your project, the class will have the events meta data.  
     
* Run `pod install` and make sure you are connected to the Zoho-corp lan or wifi to access the Git repo. 

* Create a new application or select an existing application from the quickstart page to download  the `apptics-config.plist`. Move the `apptics-config.plist` to the root of your Xcode project and add it to the necessary targets.


* In your `Appdelegate` class make sure you call the initialize method in app launch.

        Apptics.initialize(withVerbose: true)

* For AppExtensions call `Apptics.startExtensionSession("APP_GROUP_IDENTIFIER")` on start and `Apptics.stopExtensionSession()` at the end. 

***Note : The analytic data of App-Extensions will be sent by the main application based on the network availability.***  


## **Important**:
To get proper symbolicated crashes, make sure your build settings have the following when you ship your app.
 
* Strip Build Symbols During Copy - **NO**
* Strip Linked Product - **NO**
* Strip Style - **Debugging Symbols**
* Debug information format - **Dwarf with dSYM file**

Create a run script 
* Add these lines to your Podfile 

        target '[TARGET NAME]' do
            
            pod 'Apptics-SDK' 
            
            script_phase :name => 'Apptics pre build', :script => 'sh "./Pods/Apptics-SDK/scripts/regappversion" --target-name="[TARGET NAME STRING] --config-file-path="apptics-config.plist"', :execution_position => :before_compile  
            
            script_phase :name => 'Apptics post build', :script => 'bash "./Pods/Apptics-SDK/scripts/run" --upload-symbols=[STATUS BOOL] --release-configurations="[CONFIGURATIONS COMMA SEPARATED STRING]"', :execution_position => :after_compile
            
        end        

* `--project-name`       String - Provide the name of the project
* `--target-name`         String - Provide the name of the target
* `--project-file`       String - Provide the path of the xcproject file 
* `--upload-symbols` based on this parameter we decide to upload dsym to the server. 
* `--release-configurations` is a optional param, pass your configuration name Debug, Release or your custom name with comma separated for which the dSYMs will be uploaded without any prompt during App store submission process via CI, CT and CD.
* `----config-file-path` String - Provide the path of apptics-config.plist file if to any sub directory instead of root.

# Features

## Session Tracking:

A session is considered when the app goes from foreground to background.  

## In-app Event Tracking: 

In-app event is tracking the post-install activities using the custom events.

## Screen Tracking: 

Screens are automatically tracked and the time spent on each screen is noted in iOS and tvOS. You can track screens manually using our [apis](https://prezoho.zohocorp.com/apptics/resources/iOS/screens.html)    
***Note: Viewcontrollers aren't tracked properly if you use third party containment controllers like DDMenuController, IIViewdeckController etc. To ensure to get a proper tracking of viewcontroller override `viewDidAppear` and `viewWillDisappear` in all your viewcontrollers.***

## Crash Reporting: 

Crashes are automatically tracked and symbolicated. To get proper symbolicated reports please make sure to configure your build settings correctly. 

The crashes will not be captured if the debugger is attached at the launch, please follow the below steps. 

  * Run your app from Xcode and install it on your simulator or device.
  * Quit the app using the stop button.
  * Launch the app from home screen and try to crash the app by invoking our readymade method `Apptics.crash()`.
  * Run the app again in order to push the crash to the server and get symbolicated.

Check the web console, you should find the crash listed in the console.

#### Missing a dSYM? 

Apptics includes a script to upload your project's dSYM automatically. The script is executed through the run-script in your projects build phases during the on-boarding process. There are some cases where dSYM upload fails because of network interruptions or if you have enabled bit code in your project. Missing dSYMs can be uploaded by following the below steps. 

#### Finding your dSYM 

While archiving your project build dSYMs are placed inside the xarchive directory. To view, open Xcode organizer window, ctrl+click or right click on the list to go to the dir in Finder. ctrl+click to view its content, inside the content you will find a dir called "dSYMs" which will contain dSYMs files, also that is the location where dSYMs are placed when you hit "download dSYM" in Xcode organizer. 

For Bitcode enabled applications the first step would be to check in iTunes connect whether you have enabled bit-code for your application. For bit-code enabled builds Apple generates new dSYMs. You will have to download the dsyms from ituneconnect or from the Xcode's organizer and upload to Apptics server. 

#### To download the dSYM files from iTunes Connect: 
* Log in to Apple [iTunes Connect](https://itunesconnect.apple.com/login).
* Select My Apps > (selected app) > Activity.
* From the list of builds for your application, select the build number you need for the dSYM.
* Select Download dSYM.

#### Uploading dSYMs 

On "Manage dSYM page" (Left menu -> Quality -> dSYM), upload the dSYMs .zip that you have downloaded from the iTunes connect for bitcode enabled or the one you find in xarchive directory.

## Theme 

You can use our protocols to customize the Analytics Settings, App updates and Feedback screens. Just create a swift/Obj class in the name of ThemeManager and extend those protocols to implement required methods [link]().

## Callbacks 

Get callbacks for all the events at a single point by extending `ZACustomHandler`. It deals with user consent , crash consent, feedback, and ratings & reviews.

## Feedback and BugReporting

A seperate module that does "Shake to Feedback", please check if it suits your needs [here](https://prezoho.zohocorp.com/apptics/resources/iOS/inapp-feedback.html).
        
## App Updates 

Now you can prompt user to update to the latest version of your app from the App Store.  

Please check our  guide before you start [here](https://prezoho.zohocorp.com/apptics/resources/iOS/inapp-updates.html).

## Ratings and Reviews

Engage with your users and learn about their experience. Promopt them to rate your app after they have fulfilled the configured criteria.

Check how to configure automatic ratings [here](https://prezoho.zohocorp.com/apptics/resources/iOS/inapp-ratings.html).

    
