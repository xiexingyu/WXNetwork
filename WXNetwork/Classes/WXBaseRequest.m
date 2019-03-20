//
//  WXBaseRequest.m
//  WXCommonLib
//
//  Created by wangxin on 17/2/6.
//  Copyright © 2017年 wangxin. All rights reserved.
//

#import "WXBaseRequest.h"
#import "WXBaseCache.h"
#import <WXBaseKit/WXBase.h>
#import <YYKit/YYKit.h>
#import <AFNetworking/AFNetworking.h>
#import <Realm/Realm.h>

@implementation WXBaseRequest

- (NSString *)keyValueStringWithDict:(NSDictionary *)dict {
    if (dict == nil) {
        return nil;
    }
    NSMutableString *string = [NSMutableString stringWithString:@""];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [string appendFormat:@"%@=%@&", key, [obj isKindOfClass:[NSDictionary class]] ? [obj modelToJSONString] : obj];
    }];
    
    if ([string rangeOfString:@"&"].length) {
        [string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
    }
    return string;
}

- (NSString *)ip {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"]];
    return dict[@"RootIP"];
}

- (NSURL *)getRequestURL {
    NSString *s = [NSString stringWithFormat:@"%@/%@?%@", self.ip, self.interface, [self keyValueStringWithDict:self.params]];
    NSURL *URL = [NSURL URLWithString:[s stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@", [URL absoluteString]);
    return URL;
}

- (AFURLSessionManager *)getManager  {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    manager.responseSerializer = responseSerializer;
    return manager;
}

- (void)getDataTask:(void(^)(id responseObject))block {
    AFURLSessionManager *manager = [self getManager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[self getRequestURL]];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        block(responseObject);
    }];
    [dataTask resume];
}

- (void)get:(Class)class block:(void(^)(id datas))block {
    [self getDataTask:^(id responseObject) {
        WXBaseObject *obj = [WXBaseObject modelWithJSON:responseObject];
        if (obj) {
            if ([obj.state isEqualToString:@"1"]) {
                if (obj.result) {
                    if ([obj.result isKindOfClass:[NSArray class]]) {
                        block([NSArray modelArrayWithClass:class json:obj.result]);
                    } else {
                        block([class modelWithJSON:obj.result]);
                    }
                } else if (obj.jsonList) {
                    block([NSArray modelArrayWithClass:class json:obj.jsonList]);
                }
            } else {
                NSString *title;
                if ([obj.meg isNotBlank]) {
                    title = obj.meg;
                } else {
                    title = @"服务器返回异常";
                }
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }
        }
    }];
}

- (void)get:(Class)class saveCache:(void(^)(void))block {
    [self getDataTask:^(id responseObject) {
        WXBaseObject *obj = [WXBaseObject modelWithJSON:responseObject];
        if (obj) {
            if ([obj.state isEqualToString:@"1"]) {
                if (obj.result) {
                    [WXBaseCache insertObject:obj.result class:class];
                    block();
                } else if (obj.jsonList) {
                    [WXBaseCache insertObject:obj.jsonList class:class];
                    block();
                }
            } else {
                NSString *title;
                if ([obj.meg isNotBlank]) {
                    title = obj.meg;
                } else {
                    title = @"服务器返回异常";
                }
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }
        }
    }];
}

@end
