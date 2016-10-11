//
//  ChartConverter.h
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 08/01/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "ChartConverter.h"

@import Charts;

#ifndef ChartConverter_h
#define ChartConverter_h


@interface ChartConverter : NSObject



- (BarChartData *)setData:(BarChartDataSet *)set1 set2:(BarChartDataSet *)set2 xVals:(NSMutableArray *)xVals;

@end

#endif /* ChartConverter_h */
