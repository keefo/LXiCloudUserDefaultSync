# LXiCloudUserDefaultSync
A clean and simple class to sync NSUserDefaults to iCloud automatically.

#How to use?

Drag the two classes and #import the header file in your Application Delegate 

```objc
#import "LXiCloudUserDefaultSync.h"
```
and Call

```objc
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	....
	[LXiCloudUserDefaultSync startSyncKeys:@[key1, key2]];
	....
}
```

#How to confirm if it works?

After first sync, doing some UserDefault value change through your app. then use the following lines to see if the value is updated.

```objc
NSUbiquitousKeyValueStore *iCloudStore = [NSUbiquitousKeyValueStore defaultStore];
NSLog(@"key1=%@", [iCloudStore objectForKey:key1]);
```
