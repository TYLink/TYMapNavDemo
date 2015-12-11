//
//  TYMapNavSheet.m
//  TYGDmap
//
//  Created by TianYang on 15/12/10.
//  Copyright © 2015年 Tianyang. All rights reserved.
//

#import "TYMapNavSheet.h"

# define IOS8                    [[[UIDevice currentDevice] systemVersion] floatValue] > 8.3
@interface TYMapNavSheet ()
{
    NSMutableArray       * TYMapSheetTitleArray;
    NSMutableDictionary  * TYMapNavMutDic;
    NSMutableDictionary  * TYMapNavDateMutDic;
    
    CLLocationCoordinate2D _startCoor;
    CLLocationCoordinate2D _endCoor;
    NSMutableDictionary  * _Dic;

}
@end


@implementation TYMapNavSheet

- (id)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void) AddMapNamewithLocationDic:(NSMutableDictionary*)LocationDataDic withstartCoor:(CLLocationCoordinate2D)startCoor withendCoor:(CLLocationCoordinate2D)endCoor
{
    TYMapSheetTitleArray = [[NSMutableArray alloc]init];
    TYMapNavDateMutDic = [[NSMutableDictionary alloc]init];
    
    _startCoor = startCoor;
    _endCoor   = endCoor;
    _Dic = [[NSMutableDictionary alloc]initWithDictionary:LocationDataDic];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        
        NSString *TYurlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:%@&destination=latlng:%f,%f|name:%@&mode=transit",
                              _startCoor.latitude,_startCoor.longitude ,[LocationDataDic objectForKey:@"startName"],_endCoor.latitude , _endCoor.longitude,[LocationDataDic objectForKey:@"toName"] ];
        NSDictionary *dic = @{@"name": @"百度地图",
                              @"url": TYurlString};
        [TYMapSheetTitleArray addObject:dic];
        
    }
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        NSString *TYurlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=applicationScheme&poiname=fangheng&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=3",
                               [LocationDataDic objectForKey:@"toName"], _endCoor.latitude, _endCoor.longitude];
        
        NSDictionary *dic = @{@"name": @"高德地图",
                              @"url": TYurlString};
        [TYMapSheetTitleArray addObject:dic];
        
    }
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        NSString *TYurlString = [NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%f,%f¢er=%f,%f&directionsmode=transit", _endCoor.latitude, _endCoor.longitude, _startCoor.latitude, _startCoor.longitude];
        
        NSDictionary *dic = @{@"name": @"谷歌地图",
                              @"url": TYurlString};
        [TYMapSheetTitleArray addObject:dic];
        
    }
}

-(void) AddSheetViewsuperView:(UIViewController *)superViewColtroller withLocationDic:(NSMutableDictionary*)TYMapLocationDic withstartCoor:(CLLocationCoordinate2D)startCoor withendCoor:(CLLocationCoordinate2D)endCoor
{
    [self AddMapNamewithLocationDic:TYMapLocationDic withstartCoor:startCoor withendCoor:endCoor];
    
    if (IOS8) {
        UIAlertController * TYMapNavSheetController = [UIAlertController alertControllerWithTitle:nil  message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [TYMapNavSheetController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //按钮触发的方法
        }]];
        [TYMapNavSheetController addAction:[UIAlertAction actionWithTitle:@"使用系统自带地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //按钮触发的方法
            MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:startCoor addressDictionary:nil]];
            //目的地的位置
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:nil ]];
            toLocation.name = @"终点";
            currentLocation.name = @"起点";
            NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
            NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
            //打开苹果自身地图应用，并呈现特定的item
            [MKMapItem openMapsWithItems:items launchOptions:options];
        }]];
        for (NSDictionary * Dic in TYMapSheetTitleArray) {
            [TYMapNavSheetController addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"使用%@导航", [Dic objectForKey:@"name"]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //按钮触发的方法
                NSDictionary *mapDic = Dic;
                NSString *urlString = mapDic[@"url"];
                urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:urlString];
                [[UIApplication sharedApplication] openURL:url];
            }]];
        }
        [superViewColtroller presentViewController:TYMapNavSheetController animated:YES completion:nil];
    }else{
        UIActionSheet * TYMapNavSheet = [[UIActionSheet alloc] init];
        [TYMapNavSheet addButtonWithTitle:@"使用系统自带地图导航"];
        for (NSDictionary * Dic in TYMapSheetTitleArray) {
            [TYMapNavSheet addButtonWithTitle:[NSString stringWithFormat:@"使用%@导航", [Dic objectForKey:@"name"]]];
        }
        [TYMapNavSheet addButtonWithTitle:@"取消"];
        TYMapNavSheet.delegate = superViewColtroller;
        [TYMapNavSheet showInView:superViewColtroller.view];
    }
}

-(void) actionsheetClick:(NSInteger)BtnIndex
{
    if (BtnIndex == 0) {
        // 调用苹果自带的地图导航
        //起点
        MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:_startCoor addressDictionary:nil]];
        //目的地的位置
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:_endCoor addressDictionary:nil ]];
        toLocation.name = [_Dic objectForKey:@"toName"];
        currentLocation.name = [_Dic objectForKey:@"startName"];
        NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
        NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
        //打开苹果自身地图应用，并呈现特定的item
        [MKMapItem openMapsWithItems:items launchOptions:options];

    } else{
        if (BtnIndex < [TYMapSheetTitleArray count]+1) {
            NSDictionary *mapDic = TYMapSheetTitleArray[BtnIndex-1];
            NSString *urlString = mapDic[@"url"];
            urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:urlString];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}



- (void) ShowMapNavSheetSuperView:(UIViewController *)ViewColtroller withLocationDic:(NSMutableDictionary*)LocationNameDic withstartCoor:(CLLocationCoordinate2D)startCoor withendCoor:(CLLocationCoordinate2D)endCoor{
    [self AddSheetViewsuperView:ViewColtroller withLocationDic:LocationNameDic withstartCoor:startCoor withendCoor:endCoor ];
}

-(void) actionSheetBtnClick:(NSInteger)BtnIndex
{
    [self actionsheetClick:BtnIndex];
}


@end
