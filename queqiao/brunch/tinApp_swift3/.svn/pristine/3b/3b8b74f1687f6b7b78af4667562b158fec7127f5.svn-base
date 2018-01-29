//
//  AlbumReslut.h
//  Demo
//
//  Created by Richard.q.x on 2016/11/25.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "AlbumPhotoOCsolution.h"

@interface AlbumReslut : NSObject

@property (nonatomic, strong) PHFetchResult *album;

- (NSInteger)getPhotoCount;
- (NSString *)getTitleForIdx:(NSInteger)idx;
- (AlbumReslut *)getAlbumForIdx:(NSInteger)idx;


- (void)asycGetFirstImage:(AlbumPhotoOCsolutionImageDone)done;

@end
