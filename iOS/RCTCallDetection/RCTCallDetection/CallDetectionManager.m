//
//  CallDetectionManager.m
//
//
//  Created by Pritesh Nandgaonkar on 16/06/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "CallDetectionManager.h"
@import CoreTelephony;

typedef void (^CallBack)();
@interface CallDetectionManager()

@property(strong, nonatomic) RCTResponseSenderBlock block;
@property(strong, nonatomic, nonnull) CTCallCenter *callCenter;

@end

@implementation CallDetectionManager

+ (id)allocWithZone:(NSZone *)zone {
    static CallDetectionManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
        sharedInstance.callCenter = [[CTCallCenter alloc] init];
    });
    return sharedInstance;
}

- (NSDictionary *)constantsToExport
{
    return @{
             @"Connected"   : @"Connected",
             @"Dialing"     : @"Dialing",
             @"Disconnected": @"Disconnected",
             @"Incoming"    : @"Incoming"
             };
}

- (NSArray<NSString *> *)supportedEvents {
    return @[@"PhoneCallStateUpdate"];
}

RCT_EXPORT_MODULE()

//RCT_EXPORT_METHOD(addCallBlock:(RCTResponseSenderBlock) block) {
//  // Setup call tracking
//  self.block = block;
//  self.startListener = [[CTCallCenter alloc] init];
//  __typeof(self) weakSelf = self;
//  self.callCenter.callEventHandler = ^(CTCall *call) {
//      NSDictionary *eventNameMap = @{
//                                     CTCallStateConnected    : @"Connected",
//                                     CTCallStateDialing      : @"Dialing",
//                                     CTCallStateDisconnected : @"Disconnected",
//                                     CTCallStateIncoming     : @"Incoming"
//                                     };
//
//      [weakSelf sendEventWithName:@"PhoneCallStateUpdate"
//                             body:[eventNameMap objectForKey: call.callState]];
//  };
//}

RCT_EXPORT_METHOD(startListener) {
    // Setup call tracking
//    self.callCenter = [[CTCallCenter alloc] init];
    __typeof(self) weakSelf = self;
    self.callCenter.callEventHandler = ^(CTCall *call) {
//        [weakSelf handleCall:call];
        NSLog(call.callState);
        NSDictionary *eventNameMap = @{
                                       CTCallStateConnected    : @"Connected",
                                       CTCallStateDialing      : @"Dialing",
                                       CTCallStateDisconnected : @"Disconnected",
                                       CTCallStateIncoming     : @"Incoming"
                                       };
        
        [weakSelf sendEventWithName:@"PhoneCallStateUpdate"
                               body:[eventNameMap objectForKey: call.callState]];
    };
}

RCT_EXPORT_METHOD(stopListener) {
    // Setup call tracking
//    NSLog(<#NSString * _Nonnull format, ...#>)
//    self.callCenter = nil;
}

- (void)handleCall:(CTCall *)call {
    
    NSDictionary *eventNameMap = @{
                                   CTCallStateConnected    : @"Connected",
                                   CTCallStateDialing      : @"Dialing",
                                   CTCallStateDisconnected : @"Disconnected",
                                   CTCallStateIncoming     : @"Incoming"
                                   };
    
//    self.callCenter = [[CTCallCenter alloc] init];
    __typeof(self) weakSelf = self;
    [self.callCenter setCallEventHandler:^(CTCall *call) {
        [weakSelf sendEventWithName:@"PhoneCallStateUpdate"
                                                     body:[eventNameMap objectForKey: call.callState]];
    }];
}

@end
