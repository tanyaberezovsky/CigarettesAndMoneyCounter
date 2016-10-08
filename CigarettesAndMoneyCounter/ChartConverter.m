//
//  ChartConverter.m
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 08/01/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "ChartConverter.h"


//@import UIKit;
@import Charts;

@implementation ChartConverter : NSObject


- (BarChartData *)setData:(BarChartDataSet *)set1 set2:(BarChartDataSet *)set2 xVals:(NSMutableArray *)xVals
{
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    [dataSets addObject:set2];
    
    ///BarChartData *data = [[BarChartData alloc] initWithX:xVals dataSets:dataSets];
    BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
    data.barWidth = 0.9f;
   

 ///   data.groupSpace = 0.8;
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
    
    return data;
}


@end
