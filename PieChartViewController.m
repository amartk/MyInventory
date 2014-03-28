//
//  PieChartViewController.m
//  myInventory
//
//  Created by amar tk on 15/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import "PieChartViewController.h"
#import "InventoryCategory.h"

@interface PieChartViewController ()

@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTTheme *selectedTheme;

@property (nonatomic, strong) NSArray *availableCategories;
@end

@implementation PieChartViewController

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
    [self initPieChart];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"Category";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Pie Chart DataSource -

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    NSString *categoryFile = [NSString stringWithFormat:@"%@/%@", [self applicationDocumentsDirectory], CATEGORY_FILE];
    if ([[NSFileManager defaultManager] fileExistsAtPath:categoryFile]) {
        _availableCategories = [NSKeyedUnarchiver unarchiveObjectWithFile:categoryFile];
        return _availableCategories.count;
    }
    
    return 0;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    return [NSNumber numberWithInt:12];
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx
{
    static CPTMutableTextStyle *labelText = nil;
	if (!labelText) {
		labelText= [[CPTMutableTextStyle alloc] init];
		labelText.color = [CPTColor grayColor];
	}
	// 5 - Create and return layer with label text
    InventoryCategory *inventoryCategory = [_availableCategories objectAtIndex:idx];
    NSString *label;
    if ([inventoryCategory.name length] <= 9) {
        label = inventoryCategory.name;
    } else {
        label = [NSString stringWithFormat:@"%@...",[inventoryCategory.name substringToIndex:6]];
    }
	return [[CPTTextLayer alloc] initWithText:label style:labelText];
}

-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx
{
    InventoryCategory *inventoryCategory = [_availableCategories objectAtIndex:idx];
    NSString *legendTitle;
    if ([inventoryCategory.name length] <= 12) {
        legendTitle = inventoryCategory.name;
    } else {
        legendTitle = [NSString stringWithFormat:@"%@...",[inventoryCategory.name substringToIndex:8]];
    }
	return legendTitle;
}

#pragma mark - Pie Chart Delegate -

-(void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)idx withEvent:(UIEvent *)event
{
}


#pragma mark - Chart Methods -

-(void)initPieChart
{
    [self configureHost];
    [self configureGraph];
    [self configureChart];
    [self configureLegend];
}

-(void)configureHost
{
    CGRect parentRect = self.view.bounds;
    parentRect.origin.y = parentRect.origin.y + self.navigationController.navigationBar.frame.size.height;
    parentRect.size.height = parentRect.size.height - self.navigationController.navigationBar.frame.size.height;
    _hostView = [[CPTGraphHostingView alloc] initWithFrame:parentRect];
    [self.view addSubview:_hostView];
}

-(void)configureGraph
{
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:_hostView.bounds];
    _hostView.hostedGraph = graph;
    
    graph.paddingBottom = graph.paddingLeft = graph.paddingRight = graph.paddingTop = 0.0f;
    
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor grayColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    
    graph.title = @"Number of items in each category";
    graph.titleTextStyle = titleStyle;
    graph.titleDisplacement = CGPointMake(0, -50);

}

-(void)configureChart
{
    CPTGraph *graph = _hostView.hostedGraph;
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.delegate = self;
    pieChart.dataSource = self;
    pieChart.pieRadius = _hostView.bounds.size.width * 0.3;
    pieChart.centerAnchor = CGPointMake(0.5, 0.6);
    [graph addPlot:pieChart];
    pieChart.labelOffset = 2.0f;
}

-(void)configureLegend
{
    CPTGraph *graph = _hostView.hostedGraph;
    CPTLegend *legend = [CPTLegend legendWithGraph:graph];
    legend.numberOfColumns = 3;

    //Add legend to graph
    graph.legend = legend;
    graph.legendAnchor = CPTRectAnchorRight;
    graph.legendDisplacement = CGPointMake(-10.0, -150.0);
    

}

-(NSString *) applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
