//
//  TYMapNavSheet.h
//  TYGDmap
//
//  Created by TianYang on 15/12/10.
//  Copyright © 2015年 Tianyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface TYMapNavSheet : UIView
/**
 LocationDic 中包括出发地的经纬度、出发地地名、目的地经纬度、目的地名称四个数据。
 其中出发地经纬度可不传（默认为当前位置经纬度）
 出发地和目的地的地名也可以不传 默认通过经纬度 反编译得到（可能会有误差）
 如果不传可能会造成误差 所以建议全部传
 所对应Key 为
      startName   endName
 */
- (void) ShowMapNavSheetSuperView:(UIViewController *)ViewColtroller withLocationDic:(NSMutableDictionary*)LocationNameDic withstartCoor:(CLLocationCoordinate2D)startCoor withendCoor:(CLLocationCoordinate2D)endCoor;

/**
 iOS8.3 一下的需要实现这个方法  把sheet 的点击事件传递回来  参数为Btn 的index
 
 */
- (void) actionSheetBtnClick:(NSInteger)BtnIndex;

@end
