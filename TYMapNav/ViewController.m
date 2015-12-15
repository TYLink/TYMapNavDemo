//
//  ViewController.m
//  TYMapNav
//
//  Created by TianYang on 15/12/11.
//  Copyright © 2015年 Tianyang. All rights reserved.
//

#import "ViewController.h"

#import "TYMapNavSheet.h"

#define TYSCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width

#define TYSCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height


@interface ViewController ()<UIActionSheetDelegate>
{
    TYMapNavSheet * TYNavSheet;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TYNavSheet = [[TYMapNavSheet alloc]init];
    
    UIButton * TYBtn = [[UIButton alloc] init];
    TYBtn.frame = CGRectMake((TYSCREEN_WIDTH - 200)/2, 100, 200, 50);
    TYBtn.backgroundColor = [UIColor redColor];
    [TYBtn setTitle:@"点击调用导航" forState:UIControlStateNormal];
    [TYBtn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:TYBtn];

}

-(void)BtnClick{
    
    NSMutableDictionary * Dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"起点",@"startName",@"终点",@"endName", nil];
    [TYNavSheet ShowMapNavSheetSuperView:self withLocationDic:Dic withstartCoor:CLLocationCoordinate2DMake(31.205511, 121.595181) withendCoor:CLLocationCoordinate2DMake(31.209511, 121.597181)];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [TYNavSheet actionSheetBtnClick:buttonIndex];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
