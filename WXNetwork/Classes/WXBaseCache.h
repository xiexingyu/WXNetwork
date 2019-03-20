//
//  WXBaseCache.h
//  WXKit
//
//  Created by 王鑫 on 2019/3/19.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface WXBaseCache : NSObject

+ (void)insertObject:(RLMObject *)object;
+ (void)insertObject:(id)object class:(Class)class;
+ (id)getFirstObject:(Class)class;
+ (void)deleteAllObjects:(Class)class;

@end
