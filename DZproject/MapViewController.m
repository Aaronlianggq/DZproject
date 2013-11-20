//
//  MapViewController.m
//  DZproject
//
//  Created by lianggq on 13-11-14.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import "MapViewController.h"
#import "MapLocation.h"

#define  ZOOMDATA  0.001224  //0.001表示地图清晰度 最好
#define  MAXCOUNT  10  // 地图缩小次数临界值
#define ZOOMLEVEL 0.003457 //缩放度  mapVIew没有缩放等级

@interface MapViewController ()

@end

@implementation MapViewController{
    //CLLocationCoordinate2D Coordinate; //经纬度
    //MKCoordinateSpan span ; //经纬度差
    NSUInteger count; //地图缩小次数
    CLLocationDegrees myLatitude;  //维度坐标
    CLLocationDegrees myLongitude; //经度坐标
    
}
@synthesize myMapVIew;
@synthesize dataDic;
@synthesize samllBut;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    myMapVIew.mapType =MKMapTypeStandard;
    myMapVIew.delegate =self;
    count =0;
    [self loadMapAddress];
}

#pragma mark 根据经纬度解析地址
-(void)loadMapAddress
{
    
    if([self dataDic]){
        @try {

        myLatitude =[(NSNumber *)[dataDic objectForKey:@"latitude"] doubleValue];
        myLongitude =[(NSNumber *)[dataDic objectForKey:@"longitude"] doubleValue];
        CLLocationCoordinate2D myCenter ={myLatitude,myLongitude};
        MKCoordinateSpan mySpan =MKCoordinateSpanMake(ZOOMDATA, ZOOMDATA);
        MKCoordinateRegion mapRegion ={myCenter,mySpan};
        MKCoordinateRegion region = [myMapVIew regionThatFits:mapRegion ];
        [myMapVIew setRegion:region animated:YES]; //设置地图中心
        //[bigBut setHidden:YES];
        //解析经纬度为地址信息
        CLLocation *location =[[CLLocation alloc]initWithLatitude:myLatitude longitude:myLongitude];
        
        CLGeocoder *geocoder =[[CLGeocoder alloc]init];
        //解析地址
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray * placemarks,NSError *err){
            if([placemarks count]>0){
                CLPlacemark *placemark=[placemarks objectAtIndex:0];
                
                NSLog(@"Country = %@", placemark.country);
                NSLog(@"Postal Code = %@", placemark.postalCode);
                NSLog(@"Locality = %@", placemark.locality); //城市
                NSLog(@"administrativeArea=%@",placemark.administrativeArea); //直辖市
                //NSLog(@"dic = %@", placemark.addressDictionary ); 地址信息
                
                NSDictionary *addreDic =placemark.addressDictionary;
                // 自定义标记
                MapLocation *annotation =[[MapLocation alloc] initCustomeAnnotation:myCenter];
                annotation.mapTitle =@"商户位置";
                annotation.subName =[addreDic objectForKey:@"Name"];
               // annotation.subName =placemark.name;
//                annotation.streetAddress =[addreDic objectForKey:@"Street"];
//                annotation.city =[addreDic objectForKey:@"City"];
//                annotation.subLocality =[addreDic objectForKey:@"SubLocality"];
               
                [myMapVIew addAnnotation:annotation];
                
            }
        }];
        }@catch (NSException *e) {
            NSLog(@"未知错误:经纬度超出范围");
        }
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"数据获取失败"
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [alert show];
    }
         

}



#pragma mark Map View Delegate Methods
- (MKAnnotationView *) mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>) annotation {
    
    static NSString *pin_anno =@"PIN_ANNOTATION";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[myMapVIew dequeueReusableAnnotationViewWithIdentifier:pin_anno];
    if(annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pin_anno] ;
    }
    annotationView.canShowCallout = YES;//指定标注上的插图，点击图钉有气泡显示。
    //annotationView.image = nil;
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"love.png"] ];
    //    imageView.frame = CGRectMake(-13, -1, 30, 30);
    //
    //    [annotationView addSubview: imageView];
    annotationView.pinColor = MKPinAnnotationColorPurple;
    annotationView.animatesDrop = YES;
    annotationView.highlighted = YES;
    annotationView.draggable = NO;
    
    return annotationView;
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)theMapView withError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"地图加载错误"
                          message:[error localizedDescription]
                          delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil];
    [alert show];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)zoomSamll:(id)sender {
    
    MKCoordinateRegion currt =[myMapVIew region];
    //5次小缩放
    if(currt.span.latitudeDelta <(ZOOMLEVEL*5)||currt.span.longitudeDelta<(ZOOMLEVEL*5)){
        currt.span.latitudeDelta +=ZOOMLEVEL;
        currt.span.longitudeDelta +=ZOOMLEVEL;
    }else if(currt.span.latitudeDelta <(ZOOMLEVEL*MAXCOUNT)||currt.span.longitudeDelta<(ZOOMLEVEL*MAXCOUNT)){
        //继续5次 缩放扩大
        currt.span.latitudeDelta +=(ZOOMLEVEL*MAXCOUNT);
        currt.span.longitudeDelta +=(ZOOMLEVEL*MAXCOUNT);
    }else{
        //继续扩大
        currt.span.latitudeDelta +=(ZOOMLEVEL*MAXCOUNT*5);
        currt.span.longitudeDelta +=(ZOOMLEVEL*MAXCOUNT*5);
    }
    if(currt.span.latitudeDelta>5.01||currt.span.longitudeDelta>5.01){
        //基本显示
        return;
    }
    [myMapVIew setRegion:currt animated:YES];
    
}

//- (IBAction)zoomBig:(id)sender {
//    count --;
//    
//    MKCoordinateRegion currt =[myMapVIew region];
//    if(count>=5){
//        currt.span.latitudeDelta -=(1+ZOOMLEVEL);
//        currt.span.longitudeDelta -=(1+ZOOMLEVEL);
//    }else{
//        currt.span.latitudeDelta -=ZOOMLEVEL;
//        currt.span.longitudeDelta -=ZOOMLEVEL;
//    }
//    if (currt.span.latitudeDelta<ZOOMDATA) {
//        currt.span.latitudeDelta=ZOOMDATA;
//    }
//    if (currt.span.longitudeDelta<ZOOMDATA) {
//        currt.span.longitudeDelta =ZOOMDATA;
//    }
//    [myMapVIew setRegion:currt animated:YES];
//    if(count<=0){
//        count=0;
//        [bigBut setHidden:YES];
//        return;
//    }
//}
@end
