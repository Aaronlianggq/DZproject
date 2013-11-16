//
//  MapViewController.h
//  DZproject
//
//  Created by lianggq on 13-11-14.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *myMapVIew;
@property (nonatomic,retain) NSDictionary *dataDic;

@property (strong, nonatomic) IBOutlet UIButton *samllBut;

- (IBAction)zoomSamll:(id)sender;

//@property (strong, nonatomic) IBOutlet UIButton *bigBut;

//- (IBAction)zoomBig:(id)sender;

@end
