//
//  WXBaseCache.m
//  WXKit
//
//  Created by 王鑫 on 2019/3/19.
//

#import "WXBaseCache.h"

@implementation WXBaseCache

+ (void)insertObject:(RLMObject *)object {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:object];
    }];
}

+ (void)insertObject:(id)object class:(Class)class {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [class createInDefaultRealmWithValue:object];
    }];
}

+ (id)getFirstObject:(Class)class {
    RLMResults *array = [class allObjects];
    if ([array count] > 0) {
        return [array firstObject];
    }
    return nil;
}

+ (void)deleteAllObjects:(Class)class {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        RLMResults *array = [class allObjects];
        [realm deleteObjects:array];
    }];
}

@end
