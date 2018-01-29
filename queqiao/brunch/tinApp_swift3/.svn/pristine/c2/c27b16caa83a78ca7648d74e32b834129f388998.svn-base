//
//  AlbumPhotoOCsolution.m
//  touzhong
//
//  Created by Richard.q.x on 2016/11/25.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

#import "AlbumPhotoOCsolution.h"

@implementation AlbumPhotoOCsolution

+ (BOOL)checkAccess:(AlbumPhotoOCsolutionDone)denied {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted:
            denied();
            return NO;
        case PHAuthorizationStatusNotDetermined:
            return YES;
        default:
            return YES;
    }
}

+ (BOOL)checkHasPhoto:(PHFetchResult *)album {
    id collection = [album firstObject];
    if ([collection isKindOfClass:PHAssetCollection.class]) {
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        if (result.count > 0) {
            return YES;
        }
    }
    return NO;
}


+ (void)fetchAlbums:(AlbumPhotoOCsolutionArrDone)done {
    
    NSMutableArray *fetchResult = [NSMutableArray new];
    
    AlbumPhotoOCsolutionDone success = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            done(fetchResult, YES);
        });
    };
    AlbumPhotoOCsolutionDone failed = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            done(fetchResult, NO);
        });
    };
    
    if ([self checkAccess:^{
        failed();
    }]) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                
                PHFetchResult *all = [PHAsset fetchAssetsWithOptions:nil];
                AlbumReslut *allRes = [AlbumReslut new];
                allRes.album = all;
                [fetchResult addObject:allRes];
                
                PHFetchResult *album = [PHAssetCollection fetchAssetCollectionsWithType: PHAssetCollectionTypeAlbum subtype: PHAssetCollectionSubtypeAny options:nil];
                if ([album count] > 0  && [self checkHasPhoto:album]) {
                    AlbumReslut *albumRes = [AlbumReslut new];
                    albumRes.album = album;
                    [fetchResult addObject:albumRes];
                }
                
                PHFetchResult *favorite = [PHAssetCollection fetchAssetCollectionsWithType: PHAssetCollectionTypeSmartAlbum subtype: PHAssetCollectionSubtypeSmartAlbumFavorites options:nil];
                if ([favorite count] > 0  && [self checkHasPhoto:favorite]) {
                    AlbumReslut *favoriteRes = [AlbumReslut new];
                    favoriteRes.album = favorite;
                    [fetchResult addObject:favoriteRes];
                }
                success();
            } else {
                if (status != PHAuthorizationStatusNotDetermined) {
                    failed();
                }
            }
        }];
        
    }
}

+ (void)asycGetThumbImage:(AlbumPhoto *)model size:(CGSize)size done: (AlbumPhotoOCsolutionImageDone)done {
    PHAsset *asset = model.asset;
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat width = size.width;
    CGSize _size = CGSizeMake(width * scale, width * scale);
    PHImageRequestOptions *opt = [PHImageRequestOptions new];
    opt.synchronous = NO;
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:_size contentMode:PHImageContentModeAspectFill options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        done(result);
    }];
}

@end
