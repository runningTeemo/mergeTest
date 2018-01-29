//
//  OCDatamanager.m
//  touzhong
//
//  Created by zerlinda on 2016/10/27.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

#import "OCDatamanager.h"

@implementation OCDatamanager

+ (void)setupContext: (JSContext *)ctx forKey: (NSString *)key toDo: (void (^)(NSString *text))todo {
    ctx[key] = ^(NSString *t) {
        todo(t);
    };
}

@end
