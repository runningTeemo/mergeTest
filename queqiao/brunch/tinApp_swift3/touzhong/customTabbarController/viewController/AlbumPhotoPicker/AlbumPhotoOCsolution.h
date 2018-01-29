//
//  AlbumPhotoOCsolution.h
//  touzhong
//
//  Created by Richard.q.x on 2016/11/25.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^AlbumPhotoOCsolutionDone)();
typedef void (^AlbumPhotoOCsolutionArrDone)(NSArray *albums, BOOL success);
typedef void (^AlbumPhotoOCsolutionImageDone)(UIImage *image);

#import "AlbumReslut.h"
#import "AlbumPhoto.h"

@interface AlbumPhotoOCsolution : NSObject

+ (BOOL)checkAccess:(AlbumPhotoOCsolutionDone)denied;

+ (BOOL)checkHasPhoto:(PHFetchResult *)album;

+ (void)fetchAlbums:(AlbumPhotoOCsolutionArrDone)done;

+ (void)asycGetThumbImage:(AlbumPhoto *)model size:(CGSize)size done: (AlbumPhotoOCsolutionImageDone)done;


@end
