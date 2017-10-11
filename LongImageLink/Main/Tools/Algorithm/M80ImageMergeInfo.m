//
//  M80ImageMergeInfo.m
//  M80Image
//
//  Created by amao on 11/18/15.
//  Copyright © 2015 Netease. All rights reserved.
//

#import "M80ImageMergeInfo.h"
#import "M80Defs.h"

@implementation M80ImageMergeInfo

+ (instancetype)infoBy:(UIImage *)firstImage
           secondImage:(UIImage *)secondImage
                  type:(M80FingerprintType)type
{
    M80ImageMergeInfo *info = [[M80ImageMergeInfo alloc] init];
    info.firstImage = firstImage;
    info.secondImage = secondImage;
    
    
    M80ImageFingerprint *firstFingerprint = [M80ImageFingerprint fingerprint:firstImage type:type];
    M80ImageFingerprint *secondFingerprint= [M80ImageFingerprint fingerprint:secondImage type:type];
    
    NSArray *firstLines = [firstFingerprint lines];
    NSArray *secondLines= [secondFingerprint lines];
    
    NSInteger firstLinesCount = (NSInteger)[firstLines count];
    NSInteger secondLinesCount = (NSInteger)[secondLines count];
    
    //初始化动态规划所需要的数组
    int **matrix = (int **)malloc(sizeof(int *) * 2);
    for (int i = 0; i < 2; i++)
    {
        matrix[i] = (int *)malloc(sizeof(int) * (size_t)secondLinesCount);
    }
    for (NSInteger j = 0; j < secondLinesCount; j++)
    {
        matrix[0][j] = matrix[1][j] = 0;
        
    }
    
    
    
    //遍历并合并
    NSInteger length = 0,x = 0,y = 0;
    for (NSInteger i = M80ImageIgnoreOffset; i < firstLinesCount; i ++)
    {
        for (NSInteger  j = M80ImageIgnoreOffset; j < secondLinesCount; j++)
        {
            int64_t firstValue = [firstLines[i] longLongValue];
            int64_t secondValue = [secondLines[j] longLongValue];
            
            if (M80PixelValueEqual(firstValue,secondValue))
            {
                int value = 0;
                if (j != 0)
                {
                    value = matrix[(i + 1) % 2][j-1] + 1;
                }
                matrix[i % 2][j] = value;
                
                if (value > length)
                {
                    length = value;
                    x = i;
                    y = j;
                }
            }
            else
            {
                matrix[i % 2][j] = 0;
            }
        }
    }
    
    //清理
    for (int i = 0; i < 2; i++)
        free(matrix[i]);
    free(matrix);
    
    
    //更新数据
    info.length = length;
    info.firstOffset = firstImage.size.height - (x - length + 1);
    info.secondOffset= secondImage.size.height - (y - length + 1);
    
    return info;
}

@end


