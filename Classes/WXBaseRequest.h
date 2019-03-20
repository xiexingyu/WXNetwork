//
//  WXBaseRequest.h
//  WXCommonLib
//
//  Created by wangxin on 17/2/6.
//  Copyright © 2017年 wangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXBaseRequest : NSObject

@property (strong, nonatomic) NSString *ip;
@property (strong, nonatomic) NSString *interface;
@property (strong, nonatomic) NSDictionary *params;

- (void)get:(Class)class block:(void(^)(id datas))block;
- (void)get:(Class)class saveCache:(void(^)(void))block;

@end
