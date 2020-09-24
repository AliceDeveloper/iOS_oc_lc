//
//  Location.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/18.
//  Copyright © 2020 lc. All rights reserved.
//

#import "Location.h"

@interface Location ()

@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) CLLocation *location;

@end

@implementation Location

// 获取模块单例
+ (instancetype)sharedInstance {
    
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Location alloc] init];
    });
    
    return instance;
}

// 管理类
- (CLLocationManager *)manager {
    
    if (_manager == nil) {
        _manager = [[CLLocationManager alloc] init];
    }
    
    return _manager;
}

// 定位：YES表示开启定位服务，NO表示关闭定位服务
- (void)locationService:(BOOL)start {
    
    if (start == YES) {
        [self.manager requestWhenInUseAuthorization];
        self.manager.delegate = self;
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
        self.manager.distanceFilter = 10.0;
        [self.manager startUpdatingLocation];
    } else {
        [self.manager stopUpdatingLocation];
    }
}

// 定位成功，每次位置发生变化即会执行（只要定位到相应位置）
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    if (locations.count > 0 && self.locationResult) {
        self.location = [locations lastObject];
        self.locationResult([locations lastObject]);
    }
}

// 定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
}

// 监听授权状态的改变
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways: // 用户允许任何情况下定位
        case kCLAuthorizationStatusAuthorizedWhenInUse: // 用户允许在使用中定位
            [self locationService:YES];
            break;
        case kCLAuthorizationStatusNotDetermined: // 用户未决定
        case kCLAuthorizationStatusRestricted: // 访问受限制
        case kCLAuthorizationStatusDenied: // 用户禁止或设置中未开启定位服务
            [self locationService:NO];
            break;
        default:
            [self locationService:NO];
            break;
    }
}

// 测试距离：目标位置，返回值单位米
- (CGFloat)distance:(CLLocation *)location {
    
    return [self.location distanceFromLocation:location];
}

// 地理编码，根据地名确定地理坐标
- (void)coordinateFromAddress:(NSString *)address result:(geocodeResult)result {
    
    if (address == nil || address.length <= 0) {
        return;
    }
    [[[CLGeocoder alloc] init] geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        if (result) {
            result(placemark);
        }
    }];
}

// 反地理编码，根据地理坐标取得地名
- (void)addressFromCLLocation:(CLLocation *)location result:(geocodeResult)result {
    
    [[[CLGeocoder alloc] init] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        if (result) {
            result(placemark);
        }
    }];
}

#pragma mark - 打开第三方地图，传入目标位置

// 苹果地图
+ (void)appleMapWithEndLocation:(CLLocationCoordinate2D)endLocation {
    
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:endLocation addressDictionary:nil]];
    NSArray *items = @[currentLoc,toLocation];
    NSDictionary *dic = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                          MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                          MKLaunchOptionsShowsTrafficKey : @(YES)};
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}

// 百度地图
/* 注意：需要配置 URL Schemes：baidumap */
+ (BOOL)baiduMapWithEndLocation:(CLLocationCoordinate2D)endLocation {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSString *str = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02", endLocation.latitude, endLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
        return YES;
    } else {
        return NO;
    }
}

// 高德地图
/* 注意：需要配置 URL Schemes：iosamap */
+ (BOOL)gaodeMapWithEndLocation:(CLLocationCoordinate2D)endLocation {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSString *str = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"], [NSString stringWithFormat:@"%@_gaodeMap", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]], endLocation.latitude, endLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
        return YES;
    } else {
        return NO;
    }
}

// 谷歌地图
/* 注意：需要配置 URL Schemes：comgooglemaps */
+ (BOOL)googleMapWithEndLocation:(CLLocationCoordinate2D)endLocation {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSString *str = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"], [NSString stringWithFormat:@"%@_googleMap", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]], endLocation.latitude, endLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
        return YES;
    } else {
        return NO;
    }
}

// 腾讯地图
/* 注意：需要配置 URL Schemes：qqmap */
+ (BOOL)tencentMapWithEndLocation:(CLLocationCoordinate2D)endLocation {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSString *str = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0", endLocation.latitude, endLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
        return YES;
    } else {
        return NO;
    }
}

@end
