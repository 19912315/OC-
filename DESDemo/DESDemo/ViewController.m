//
//  ViewController.m
//  DESDemo
//
//  Created by 吕文彬 on 15/11/16.
//  Copyright © 2015年 MeiLiZu. All rights reserved.
//

#import "ViewController.h"
//#import "WB_Base64Code.h"
//#import "WB_Base64.h"
//#import "DESSecurity.h"
#import "WBSec.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSString * text = @"{\"userName\":\"13581936095\",\"password\":\"meilizu2015\",\"key\":\"meilizu\"} ";

    NSString * base64 = SEC(text);
    NSLog(@"%@",base64);
    NSString * text1 = DESec(base64);
    NSLog(@"%@",text1);
    
   
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
