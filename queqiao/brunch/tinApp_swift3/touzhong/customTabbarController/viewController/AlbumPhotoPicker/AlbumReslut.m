//
//  AlbumReslut.m
//  Demo
//
//  Created by Richard.q.x on 2016/11/25.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

#import "AlbumReslut.h"

@implementation AlbumReslut

- (NSInteger)getPhotoCount {
    return self.album.count;
}

- (NSString *)getTitleForIdx:(NSInteger)idx {
    PHAssetCollection *collection = (PHAssetCollection *)self.album[idx];
    PHFetchResult *res = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    
    NSMutableString *mStr = [NSMutableString new];
    NSString *title = collection.localizedTitle;
    if (title == nil) {
        title = @"未知相册";
    }
    [mStr appendString:title];
    [mStr appendString:@"("];
    [mStr appendFormat:@"%lu", (unsigned long)res.count];
    [mStr appendString:@")"];
    
    return [mStr copy];
}

- (void)asycGetFirstImage:(AlbumPhotoOCsolutionImageDone)done {
    if (self.album.count > 0) {
        id first = self.album.firstObject;
        if ([first isKindOfClass:PHAsset.class]) {
            PHAsset *asset = (PHAsset *)first;
            AlbumPhoto *model = [AlbumPhoto new];
            model.asset = asset;
            CGFloat w = [[UIScreen mainScreen] scale] * 50;
            [AlbumPhotoOCsolution asycGetThumbImage:model size:CGSizeMake(w, w) done:done];
        } else {
            done(nil);
        }
    } else {
        done(nil);
    }
}

- (AlbumReslut *)getAlbumForIdx:(NSInteger)idx {
    
//    if !collection.isKind(of: PHAssetCollection.self) { return }
    
    PHAssetCollection *collection = (PHAssetCollection *)self.album[idx];
    PHFetchResult *res = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    AlbumReslut *albumReslut = [AlbumReslut new];
    albumReslut.album = res;
    return albumReslut;
}

@end
