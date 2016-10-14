//
//  LevelView.m
//  水平仪
//
//  Created by admin on 2016/10/13.
//  Copyright © 2016年 racer. All rights reserved.
//

#import "LevelView.h"
//角度转弧度
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
///弧度转角度
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
//圆半径
#define ROUNDRADIUS 100.0f
///小线段 长度
#define LineSegment 40
///线间距
#define LineSpacing 20

///下半部分夹角
#define LineAngle 90

@interface LevelView(){
    float _centerX;
    float _centerY;
    
}
@property (nonatomic, assign) float levelCenterX;
@property (nonatomic, assign) float levelCenterY;
@end

@implementation LevelView

-(void)drawRect:(CGRect)rect{
    
    
    self.levelCenterX = self.bounds.size.width/2;
    self.levelCenterY = self.bounds.size.height/2+self.centerPosition;
    _centerX= self.bounds.size.width/2;
    _centerY = self.bounds.size.height/2;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    ///绘制背景
    [[UIColor brownColor] setStroke];
    [[UIColor brownColor] setFill];
    CGContextSetLineWidth(context, 2.0f);
//    float angle = [self getAngle];
    CGContextAddArc(context, _centerX, _centerY, ROUNDRADIUS, 0,2 * M_PI, 1);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    ///画圆
    [[UIColor redColor] setStroke];
    [[UIColor redColor] setFill];
    CGContextSetLineWidth(context, 2.0f);
    float angle = [self getAngle];
    if (angle > -1.57079637) {
        CGContextAddArc(context, _centerX, _centerY, ROUNDRADIUS, 0 + angle,M_PI - angle, 1);
    }
    
    CGContextDrawPath(context, kCGPathFillStroke);
    [self getLineLength];
    
    
    ///绘制外边框
    [[UIColor whiteColor] setStroke];
    [[UIColor whiteColor] setFill];
    CGContextSetLineWidth(context, 2.0f);
    float lineLenth = [self getLineLength];
    CGContextMoveToPoint(context, self.levelCenterX - lineLenth, _levelCenterY);
    CGContextAddLineToPoint(context, self.levelCenterX + lineLenth, _levelCenterY);
    CGContextStrokePath(context);
    ///绘制长线上面小线段
    for (int i = 1; i <= 4; i ++) {
        CGContextMoveToPoint(context, self.levelCenterX -  LineSegment/2, _levelCenterY - i * LineSpacing);
        CGContextAddLineToPoint(context, self.levelCenterX +   LineSegment/2, _levelCenterY - i * LineSpacing);
        CGContextStrokePath(context);
    }
    for (int i = 1; i <= 3; i ++) {
        CGContextMoveToPoint(context, self.levelCenterX -  i * LineSegment/2, _levelCenterY + i * LineSpacing);
        CGContextAddLineToPoint(context, self.levelCenterX +   i * LineSegment/2, _levelCenterY + i * LineSpacing);
        CGContextStrokePath(context);
    }
    ///左边斜线
    CGContextMoveToPoint(context, self.levelCenterX, _levelCenterY );
    CGContextAddLineToPoint(context, self.levelCenterX -   4 * LineSegment/2, _levelCenterY + 4 * LineSpacing);
    CGContextStrokePath(context);
    ///又边斜线
    CGContextMoveToPoint(context, self.levelCenterX, _levelCenterY );
    CGContextAddLineToPoint(context, self.levelCenterX +   4 * LineSegment/2, _levelCenterY + 4 * LineSpacing);
    CGContextStrokePath(context);
    
   


}

-(float )getLineLength{
    if (self.levelCenterY - _centerY == 0) {
        return ROUNDRADIUS;
    }
    float RightAngleSide = fabsf(self.levelCenterY - _centerY);
    return ROUNDRADIUS * cos(asin(RightAngleSide/ROUNDRADIUS));
}
///获取当前弦的夹角
-(float )getAngle{
    float RightAngleSide = self.levelCenterY - _centerY;
    if (RightAngleSide > 0 ) {
        if (RightAngleSide >=ROUNDRADIUS) {
            return M_PI_2;
        }
        return asin(RightAngleSide/ROUNDRADIUS);
    }
    if (RightAngleSide < 0 ) {
        if (fabsf(RightAngleSide) >= ROUNDRADIUS ) {
            return -M_PI_2;
        }
        return asin(RightAngleSide/ROUNDRADIUS);
    }
    return 0;
}


@end
