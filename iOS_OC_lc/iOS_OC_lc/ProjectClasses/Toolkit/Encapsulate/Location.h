//
//  Location.h
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/18.
//  Copyright © 2020 lc. All rights reserved.
//

/* 定位和打开三方地图 */
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^geocodeResult)(CLPlacemark *placemark);

@interface Location : NSObject <CLLocationManagerDelegate>

// 定位结果
@property (nonatomic, weak) void (^locationResult)(CLLocation *location);

// 获取模块单例
+ (instancetype)sharedInstance;
// 定位：YES表示开启定位服务，NO表示关闭定位服务
- (void)locationService:(BOOL)start;
// 测试距离：目标位置，返回值单位米
- (CGFloat)distance:(CLLocation *)location;
// 地理编码，根据地名确定地理坐标
- (void)coordinateFromAddress:(NSString *)address result:(geocodeResult)result;
// 反地理编码，根据地理坐标取得地名
- (void)addressFromCLLocation:(CLLocation *)location result:(geocodeResult)result;

#pragma mark - 打开第三方地图，传入目标位置
// 苹果地图
+ (void)appleMapWithEndLocation:(CLLocationCoordinate2D)endLocation;
// 百度地图
/* 注意：需要配置 URL Schemes：baidumap */
+ (BOOL)baiduMapWithEndLocation:(CLLocationCoordinate2D)endLocation;
// 高德地图
/* 注意：需要配置 URL Schemes：iosamap */
+ (BOOL)gaodeMapWithEndLocation:(CLLocationCoordinate2D)endLocation;
// 谷歌地图
/* 注意：需要配置 URL Schemes：comgooglemaps */
+ (BOOL)googleMapWithEndLocation:(CLLocationCoordinate2D)endLocation;
// 腾讯地图
/* 注意：需要配置 URL Schemes：qqmap */
+ (BOOL)tencentMapWithEndLocation:(CLLocationCoordinate2D)endLocation;

@end

NS_ASSUME_NONNULL_END
