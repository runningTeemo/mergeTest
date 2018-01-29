//
//  JYMemoryLabel.m
//  ArtBox
//
//  Created by weijingyun on 16/4/25.
//  Copyright © 2016年 zhaoguogang. All rights reserved.
//

#import "JYMemoryLabel.h"
#import "mach/mach.h"

#define kSize CGSizeMake(60, 20)
@implementation JYMemoryLabel {
    NSTimeInterval _lastTime;
    UIFont *_font;
    UIFont *_subFont;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = kSize;
    }
    if (self = [super initWithFrame:frame]){
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(show) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)show{
    self.text = [self memUsage];
}

vm_size_t usedMemory(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    return (kerr == KERN_SUCCESS) ? info.resident_size : 0; // size in bytes
}

vm_size_t freeMemory(void) {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    (void) host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    return vm_stat.free_count * pagesize;
}

-(NSString *)memUsage{
    // compute memory usage and log if different by >= 100k
//    static long prevMemUsage = 0;
    long curMemUsage = usedMemory();
//    long memUsageDiff = curMemUsage - prevMemUsage;
//    prevMemUsage = curMemUsage;
    CGFloat memory = curMemUsage / 1024.f/1024.f/2.f;
    UIColor *color = [UIColor colorWithHue:0.27 * (1 - memory / 150.0f) saturation:1 brightness:0.9 alpha:1];
    self.textColor = color;
    NSString *str = [NSString stringWithFormat:@"%3.2f MB", memory];
    return str;
}


@end
