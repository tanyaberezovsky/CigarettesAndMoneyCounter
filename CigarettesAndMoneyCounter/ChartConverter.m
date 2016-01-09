//
//  ChartConverter.m
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 08/01/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartConverter.h"



@implementation ChartConverter : NSObject


- (BarChartData *)setData:(BarChartDataSet *)set1 set2:(BarChartDataSet *)set2 xVals:(NSMutableArray *)xVals
{
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    [dataSets addObject:set2];
    
    BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
    data.groupSpace = 0.8;
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
    
    return data;
}


@end