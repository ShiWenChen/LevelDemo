//
//  ViewController.m
//  水平仪
//
//  Created by admin on 2016/10/13.
//  Copyright © 2016年 racer. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

#import "LevelView.h"
/* 弧度转角度 */
#define RADIANS_TO_DEGREES(radian) \
((radian) * (180.0 / M_PI))
///角度转弧度
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
@interface ViewController ()
{
    float _lastRoll;
}

@property (nonatomic , strong) CMMotionManager *motionManager;
@property (nonatomic , weak) IBOutlet LevelView *levelView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _levelView.layer.cornerRadius = 100;
    _levelView.layer.masksToBounds = YES;
//    UIView *testView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    testView.backgroundColor = [UIColor redColor];
//    [_levelView addSubview:testView];
//    UIView *test2VIew = [[UIView alloc] initWithFrame:CGRectMake(100, 0, 100, 100)];
//    test2VIew.backgroundColor = [UIColor orangeColor];
//    [_levelView addSubview:test2VIew];
    
    
    self.motionManager = [[CMMotionManager alloc]init];
    self.motionManager.deviceMotionUpdateInterval = 1/60;
    [self.motionManager startDeviceMotionUpdatesToQueue: [[NSOperationQueue alloc] init] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        //空间位置的欧拉角（通过欧拉角可以算得手机两个时刻之间的夹角，比用角速度计算精确地多）
        CMAttitude *attitude = motion.attitude;
        double pitch = attitude.pitch;
        double yaw = attitude.yaw;
        dispatch_async(dispatch_get_main_queue(), ^{
             [_levelView setTransform:CGAffineTransformMakeRotation(-attitude.roll)];
            _levelView.centerPosition = [self getCenterPosithion:RADIANS_TO_DEGREES(pitch)];
            [_levelView setNeedsDisplay];
            NSLog(@"%f",RADIANS_TO_DEGREES(pitch));
        });


        
    }];
}
-(float)getCenterPosithion:(float)pitch{
    ///本来应除以90但陀螺仪pitch值很难找到90，为了更好显示，这里用85
    float centerPosition = -170 + 170/85*pitch;
    return centerPosition;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
