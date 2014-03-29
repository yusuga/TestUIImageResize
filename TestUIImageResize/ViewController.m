//
//  ViewController.m
//  TestUIImageResize
//
//  Created by Yu Sugawara on 2014/03/24.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "ViewController.h"
#import <YSProcessTimer/YSProcessTimer.h>
#import <NYXImagesKit/NYXImagesKit.h>
#import <GPUImage/GPUImage.h>

static NSUInteger const kNumberOfTrials = 300;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic) UIImage *image;
@property (nonatomic) CGSize sizeSmall;
@property (nonatomic) CGSize sizeNormal;

@property (atomic) NSUInteger backgroundCount;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.image = [UIImage imageNamed:@"cat"];
    self.sizeSmall = CGSizeMake(50.f, 50.f);
    self.sizeNormal = CGSizeMake(450.f, 450.f);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startProcessTimerWithProcessName:(NSString*)name process:(void(^)(void))process
{
    YSProcessTimer *timer = [[YSProcessTimer alloc] initWithProcessName:name];
    [timer startWithComment:nil];
    process();
    [timer stopWithComment:nil];
}

- (NSTimeInterval)startProcessAverageTimerWithProcessName:(NSString*)name process:(void(^)(void))process
{
    YSProcessTimer *timer = [[YSProcessTimer alloc] initWithProcessName:name];
    for (int i = 0; i < kNumberOfTrials; i++) {
        @autoreleasepool {
            [timer startAverageTime];
            process();
            [timer stopAverageTime];
        }
    }
    return [timer averageTime];
}

#pragma mark - CIImage

- (UIImage*)resizeImageInCoreImageWithImage:(UIImage*)image size:(CGSize)size useGPU:(BOOL)useGPU
{
    CIImage *ciImg = [[CIImage alloc] initWithCGImage:image.CGImage];
    
    CGFloat imageScale = image.scale;
    CGRect imgRect = [ciImg extent];
    CGPoint scale = CGPointMake(size.width / imgRect.size.width * imageScale,
                                size.height / imgRect.size.height * imageScale);
    
    CIImage *filteredImg = [ciImg imageByApplyingTransform:CGAffineTransformMakeScale(scale.x,scale.y)];
    filteredImg = [filteredImg imageByCroppingToRect:CGRectMake(0,
                                                                0,
                                                                size.width * imageScale,
                                                                size.height * imageScale)]  ;
    
    NSDictionary *options;
    if (useGPU) {
        options = @{kCIContextUseSoftwareRenderer : @NO};
    }
    CIContext *ciContext = [CIContext contextWithOptions:options];
    
    CGImageRef imgRef = [ciContext createCGImage:filteredImg fromRect:[filteredImg extent]];
    UIImage *resizedImg  = [UIImage imageWithCGImage:imgRef scale:image.scale orientation:UIImageOrientationUp];
    CGImageRelease(imgRef);
    
    return resizedImg;
}

- (IBAction)clearImageButtonDidPush:(id)sender
{
    self.imageView.image = nil;
}

- (IBAction)ciImageGPUButtonDidPush:(id)sender
{
    __block UIImage *img;
    [self startProcessTimerWithProcessName:@"set CIImage(GPU)" process:^{
        img = [self resizeImageInCoreImageWithImage:self.image size:self.sizeNormal useGPU:YES];
    }];
    self.imageView.image = img;
}

- (IBAction)testCiImageGPU:(id)sender
{
    [self averageCiImageWithImage:self.image size:self.sizeSmall useGPU:YES];
    [self averageCiImageWithImage:self.image size:self.sizeNormal useGPU:YES];
}

- (IBAction)ciImageCPUButtonDidPush:(id)sender
{
    __block UIImage *img;
    [self startProcessTimerWithProcessName:@"set CIImage(CPU)" process:^{
        img = [self resizeImageInCoreImageWithImage:self.image size:self.sizeNormal useGPU:NO];
    }];
    self.imageView.image = img;
}

- (IBAction)averageTestCiImageCPU:(id)sender
{
    [self averageCiImageWithImage:self.image size:self.sizeSmall useGPU:NO];
    [self averageCiImageWithImage:self.image size:self.sizeNormal useGPU:NO];
}

- (NSTimeInterval)averageCiImageWithImage:(UIImage*)image size:(CGSize)size useGPU:(BOOL)useGPU
{
    return [self startProcessAverageTimerWithProcessName:[NSString stringWithFormat:@"average CIImage(%@), size = %@", useGPU ? @"GPU" : @"CPU", NSStringFromCGSize(size)] process:^{
        [self resizeImageInCoreImageWithImage:image size:size useGPU:YES];
    }];
}

#pragma mark - CoreGraphics

- (UIImage*)resizeImageInCoreGraphicsWithImage:(UIImage*)image size:(CGSize)size qualityHigh:(BOOL)qualityHigh
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, qualityHigh ? kCGInterpolationHigh : kCGInterpolationLow);
    [image drawInRect:CGRectMake(0.f, 0.f, size.width, size.height)];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

- (IBAction)coreGraphicsLowButtonDidPush:(id)sender
{
    __block UIImage *img;
    [self startProcessTimerWithProcessName:@"set CoreGraphics(Low)" process:^{
        img = [self resizeImageInCoreGraphicsWithImage:self.image size:self.sizeNormal qualityHigh:NO];
    }];
    self.imageView.image = img;
}

- (IBAction)testCoreGraphicsLow:(id)sender
{
    [self averageCoreGraphicsWithImage:self.image size:self.sizeSmall qualityHigh:NO];
    [self averageCoreGraphicsWithImage:self.image size:self.sizeNormal qualityHigh:NO];
}

- (IBAction)coreGraphicsHighButtonDidPush:(id)sender
{
    __block UIImage *img;
    [self startProcessTimerWithProcessName:@"set CoreGraphics(High)" process:^{
        img = [self resizeImageInCoreGraphicsWithImage:self.image size:self.sizeNormal qualityHigh:YES];
    }];
    self.imageView.image = img;
}

- (IBAction)averageTestCoreGraphicsHigh:(id)sender
{
    [self averageCoreGraphicsWithImage:self.image size:self.sizeSmall qualityHigh:YES];
    [self averageCoreGraphicsWithImage:self.image size:self.sizeNormal qualityHigh:YES];
}

- (NSTimeInterval)averageCoreGraphicsWithImage:(UIImage*)image size:(CGSize)size qualityHigh:(BOOL)qualityHigh
{
    return [self startProcessAverageTimerWithProcessName:[NSString stringWithFormat:@"average CoreGraphics(%@), quality: %@", qualityHigh ? @"High" : @"Low", NSStringFromCGSize(size)] process:^{
        [self resizeImageInCoreGraphicsWithImage:self.image size:size qualityHigh:qualityHigh];
    }];
}

#pragma mark - NYXImagesKit

- (IBAction)NYXImagesKitButtonDidPush:(id)sender
{
    [self startProcessTimerWithProcessName:@"set NYXImagesKit" process:^{
        self.imageView.image = [self.image scaleToFitSize:self.sizeNormal];
    }];
}

- (IBAction)averageTestNYXImagesKit:(id)sender
{
    [self averageNYXImagesKit];
}

- (NSTimeInterval)averageNYXImagesKit
{
    return [self startProcessAverageTimerWithProcessName:@"average NYXImagesKit" process:^{
        [self.image scaleToFitSize:self.sizeNormal];
    }];
}

#pragma mark - GPUImage

- (IBAction)GPUImageButtonDidPush:(id)sender
{
    [self startProcessTimerWithProcessName:@"set GPUImage" process:^{
        self.imageView.image = [self resizeImageInGPUImageWithImage:self.image size:self.sizeNormal];
    }];
}

- (UIImage*)resizeImageInGPUImageWithImage:(UIImage*)image size:(CGSize)size
{
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageFilter *filter = [[GPUImageFilter alloc] init];
    [filter forceProcessingAtSizeRespectingAspectRatio:size];
    
    [stillImageSource addTarget:filter];
    [filter useNextFrameForImageCapture];
    [stillImageSource processImage];
    
    UIImage *resizedImg = [filter imageFromCurrentFramebuffer];
    return resizedImg;
}

- (IBAction)averageTestGPUImage:(id)sender
{
    [self averageGPUImage];
}

- (NSTimeInterval)averageGPUImage
{
    return [self startProcessAverageTimerWithProcessName:@"average GPUImage" process:^{
        [self resizeImageInGPUImageWithImage:self.image size:self.sizeNormal];
    }];
}

#pragma mark - background test

- (IBAction)backgroundTestCoreImage:(id)sender
{
    [self backgroundTestWithProcessName:@"background test CoreImage" process:^{
        [self resizeImageInCoreImageWithImage:self.image size:self.sizeNormal useGPU:YES];
    }];
}

- (IBAction)backgroundTestCoreGraphics:(id)sender
{
    [self backgroundTestWithProcessName:@"background test CoreGraphics" process:^{
        [self resizeImageInCoreGraphicsWithImage:self.image size:self.sizeNormal qualityHigh:YES];
    }];
}

- (IBAction)backgroundTestNYXImagesKit:(id)sender
{
    [self backgroundTestWithProcessName:@"background test NYXImagesKit" process:^{
        [self.image scaleToFitSize:self.sizeNormal];
    }];
}

- (IBAction)backgroundTestGPUImage:(id)sender
{
    [self backgroundTestWithProcessName:@"background test GPUImage" process:^{
        [self resizeImageInGPUImageWithImage:self.image size:self.sizeNormal];
    }];
}

- (void)backgroundTestWithProcessName:(NSString*)name process:(void(^)(void))process
{
    self.backgroundCount = 0;
    
    YSProcessTimer *timer = [[YSProcessTimer alloc] initWithProcessName:name];
    [timer startWithComment:nil];
    for (int i = 0; i < kNumberOfTrials; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                process();
                @synchronized(self) {
                    self.backgroundCount++;
                }
            }
        });
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        while (self.backgroundCount != kNumberOfTrials) {
            NSLog(@"wait... %@", @(self.backgroundCount));
            [NSThread sleepForTimeInterval:1.];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"[finish] backgroundCount: %@", @(self.backgroundCount));
            [timer stopWithComment:nil];
        });
    });
}

- (IBAction)compareAllAverage:(id)sender
{
    [self ciImageGPUButtonDidPush:nil];
    [self ciImageCPUButtonDidPush:nil];
    [self coreGraphicsLowButtonDidPush:nil];
    [self coreGraphicsHighButtonDidPush:nil];
    [self NYXImagesKitButtonDidPush:nil];
    [self GPUImageButtonDidPush:nil];
    
    UIImage *img = self.image;
    CGSize size = self.sizeNormal;

#if 1
    NSTimeInterval ciImageGPUTime = [self averageCiImageWithImage:img size:size useGPU:YES];
    NSTimeInterval ciImageCPUTime = [self averageCiImageWithImage:img size:size useGPU:NO];
    NSTimeInterval coreGraphicsLowTime = [self averageCoreGraphicsWithImage:img size:size qualityHigh:NO];
    NSTimeInterval coreGraphicsHighTime = [self averageCoreGraphicsWithImage:img size:size qualityHigh:YES];
    NSTimeInterval NYXImagesKitTime = [self averageNYXImagesKit];
    NSTimeInterval GPUImageTime = [self averageGPUImage];
#else
    NSTimeInterval GPUImageTime = [self averageGPUImage];
    NSTimeInterval NYXImagesKitTime = [self averageNYXImagesKit];
    NSTimeInterval coreGraphicsHighTime = [self averageCoreGraphicsWithImage:img size:size qualityHigh:YES];
    NSTimeInterval coreGraphicsLowTime = [self averageCoreGraphicsWithImage:img size:size qualityHigh:NO];
    NSTimeInterval ciImageCPUTime = [self averageCiImageWithImage:img size:size useGPU:NO];
    NSTimeInterval ciImageGPUTime = [self averageCiImageWithImage:img size:size useGPU:YES];
#endif
    NSLog(@"\nCoreImage(GPU) %f\nCoreImage(CPU) %f\nCoreGraphics(Low) %f\nCoreGraphics(High) %f\nNYXImagesKit %f\nGPUImage %f", ciImageGPUTime, ciImageCPUTime, coreGraphicsLowTime, coreGraphicsHighTime, NYXImagesKitTime, GPUImageTime);
}

@end
