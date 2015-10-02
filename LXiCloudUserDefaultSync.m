//
//  LXiCloudUserDefaultSync.m
//
//  Created by Xu Lian on 15/10/1.
//  Copyright © 2015年 Beyondcow. All rights reserved.
//

#import "LXiCloudUserDefaultSync.h"

static NSArray *lXiCloudkeys;

@implementation LXiCloudUserDefaultSync

+ (void)updateToiCloud:(NSNotification*) notificationObject {

    dispatch_queue_t syncQueue = dispatch_queue_create("lxiCloudUserDefaultSyncQueue",NULL);
    
    dispatch_async(syncQueue, ^{
        NSUserDefaults *localStore = [NSUserDefaults standardUserDefaults];

        [lXiCloudkeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            id val = [localStore objectForKey:key];
            [[NSUbiquitousKeyValueStore defaultStore] setObject:val forKey:key];
        }];

        [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    });
}

+ (void)updateFromiCloud:(NSNotification*) notificationObject {

    dispatch_queue_t syncQueue = dispatch_queue_create("lxiCloudUserDefaultSyncQueue",NULL);
    dispatch_async(syncQueue, ^{
        NSUbiquitousKeyValueStore *iCloudStore = [NSUbiquitousKeyValueStore defaultStore];
        // prevent NSUserDefaultsDidChangeNotification from being posted while we update from iCloud
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSUserDefaultsDidChangeNotification
                                                      object:nil];

        [lXiCloudkeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            id val = [iCloudStore objectForKey:key];
            [[NSUserDefaults standardUserDefaults] setObject:val forKey:key];
        }];

        [[NSUserDefaults standardUserDefaults] synchronize];

        // enable NSUserDefaultsDidChangeNotification notifications again
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateToiCloud:)
                                                     name:NSUserDefaultsDidChangeNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] postNotificationName:kLXiCloudUserDefaultSyncNotification object:nil];
    });
}

+(void)startSyncKeys:(NSArray*)keys;
{
    lXiCloudkeys = keys;
    if([NSUbiquitousKeyValueStore defaultStore]) {
        // is iCloud enabled
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateFromiCloud:)
                                                     name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateToiCloud:)
                                                     name:NSUserDefaultsDidChangeNotification object:nil];
    } else {
        NSLog(@"iCloud not enabled");
    }
}

+ (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSUserDefaultsDidChangeNotification
                                                  object:nil];
}

@end
