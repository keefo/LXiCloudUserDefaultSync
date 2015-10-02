//
//  LXiCloudUserDefaultSync.h
//
//  Created by Xu Lian on 15/10/1.
//  Copyright © 2015年 Beyondcow. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLXiCloudUserDefaultSyncNotification @"LXiCloudUserDefaultSyncDidUpdateToLatest"

@interface LXiCloudUserDefaultSync : NSObject

+(void)startSyncKeys:(NSArray*)keys;

@end
