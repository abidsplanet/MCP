//
//  DestinationViewController.m
//  MCP
//
//  Created by Rafay Hasan on 11/11/15.
//  Copyright © 2015 Nascenia. All rights reserved.
//

#import "DestinationViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DestinationTableViewCell.h"
#import "AppDelegate.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "DestinationDetailsViewController.h"
#import "DestinationObject.h"
#import "IntroTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface DestinationViewController ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,RHWebServiceDelegate>
{
    AppDelegate *appDelegate;
}


@property (nonatomic) CGFloat titleHeight;

@property (nonatomic) CGFloat contentHeight;

@property (strong,nonatomic) NSArray *destinationArray;

@property (strong,nonatomic) RHWebServiceManager *myWebservice;


- (IBAction)menuButtonAction:(id)sender;




@property (weak, nonatomic) IBOutlet UITableView *destinationTableView;






@end

@implementation DestinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    
}


-(void) viewWillAppear:(BOOL)animated
{
    
    self.titleHeight = 0.0;
    
    self.contentHeight = 0.0;
    
    [self CallDestinationWebservice];
}


-(void) viewDidAppear:(BOOL)animated
{
    [self setUpMenuView];
    
    
    
}

#pragma mark Webservice Methods

-(void) CallDestinationWebservice
{
    
    NSString *urlStr = [[NSUserDefaults standardUserDefaults]valueForKey:@"destinationUrl"];
    
    
    self.myWebservice = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypDestination Delegate:self];
    
    [self.myWebservice getDataFromWebURL:urlStr];
    
    self.view.userInteractionEnabled = NO;
}



-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    
    self.view.userInteractionEnabled = YES;
    
    if(self.myWebservice.requestType == HTTPRequestTypDestination)
    {
        self.destinationArray = [[NSArray alloc]initWithArray:(NSArray *)responseObj];
        
        [self. destinationTableView reloadData];
        
    }
    
}

-(void) dataFromWebReceiptionFailed:(NSError*) error
{
    
    
    [SVProgressHUD dismiss];
    
    self.view.userInteractionEnabled = YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Data is not available. Please check internet connectivity." preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    
    
    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    
    if(self.titleHeight > 0)
    {
        ;
    }
    
    
    aWebView.frame = frame;
    

    
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    
    frame.size = fittingSize;
    aWebView.frame = frame;
    
    
    if(aWebView.tag == 1001)
    {
        NSString *bodyStyle = @"document.getElementsByTagName('body')[0].style.textAlign = 'center';";
        
        [aWebView stringByEvaluatingJavaScriptFromString:bodyStyle];
        
        self.titleHeight = fittingSize.height + 10;
    }
    else
    {
        self.contentHeight = fittingSize.height + 10;
    }
    
    [self.destinationTableView beginUpdates];
    
    [self.destinationTableView endUpdates];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.destinationArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
    //http://stackoverflow.com/questions/2226615/how-to-download-pdf-and-store-it-locally-on-iphone
    
    ///http://iosameer.blogspot.com/2012/08/reading-and-downloading-pdf-in-ios-app.html
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"introCell";
        
        IntroTableViewCell *cell =(IntroTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[IntroTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:[appDelegate loadAppropriateXibFile:@"IntroTableViewCell"] owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        
        NSString *imageUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"destinationHomeImageUrlStr"];
        
        if(imageUrl.length > 0)
        {
            //[cell.introImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"restaurentPlaceholderImage"]];
        }
        else
        {
            //cell.introImageView.image = nil;
        }
        
        
        NSString *titleStr = [[NSUserDefaults standardUserDefaults]valueForKey:@"destinationTitle"];
        
        NSString *contentStr = [[NSUserDefaults standardUserDefaults]valueForKey:@"destinationContent"];
        
        titleStr = [NSString stringWithFormat:@"<html> \n"
                    "<head> \n"
                    "<style type=\"text/css\"> \n"
                    "body {font-family: \"%@\"; font-size: %@;}\n"
                    "</style> \n"
                    "</head> \n"
                    "<body>%@</body> \n"
                    "</html>", @"HelveticaNeue-Bold", [NSNumber numberWithInt:19], titleStr];
        
        cell.introTitleView.opaque = NO;
        
        cell.introTitleView.backgroundColor = [UIColor clearColor];
        
        [cell.introTitleView loadHTMLString:[NSString stringWithFormat:@"<div style='font-family:HelveticaNeue-Bold;color:#009EFF;'>%@",titleStr] baseURL:nil];
        
        cell.introTitleView.tag = 1001;
        
        cell.introTitleView.delegate = self;
        
        cell.introTitleView.scrollView.scrollEnabled = NO;

        
        
        cell.introDetailsWebView.opaque = NO;
        
        cell.introDetailsWebView.backgroundColor = [UIColor clearColor];
        
        [cell.introDetailsWebView loadHTMLString:[NSString stringWithFormat:@"<div style='font-family:Helvetica Neue;color:#000000;'>%@",contentStr] baseURL:nil];
        
        cell.introDetailsWebView.scrollView.scrollEnabled = NO;
        
        cell.introDetailsWebView.tag = 1002;
        
        cell.introDetailsWebView.delegate = self;
        
        cell.introDetailsWebView.scrollView.scrollEnabled = NO;

        
        return cell;

    }
    else
    {
        static NSString *CellIdentifier = @"destinationCell";
        
        DestinationTableViewCell *cell =(DestinationTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[DestinationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:[appDelegate loadAppropriateXibFile:@"DestinationTableViewCell"] owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        DestinationObject *object = [self.destinationArray objectAtIndex:indexPath.section - 1];
        
        cell.destinationTitleWebview.opaque = NO;
        
        cell.destinationTitleWebview.backgroundColor = [UIColor clearColor];
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height == 736)
        {
            NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
                                           "<head> \n"
                                           "<style type=\"text/css\"> \n"
                                           "body {font-family: \"%@\"; font-size: %@;}\n"
                                           "</style> \n"
                                           "</head> \n"
                                           "<body>%@</body> \n"
                                           "</html>", @"HelveticaNeue-Bold", [NSNumber numberWithInt:18], object.destinationTitle];
            
            [cell.destinationTitleWebview loadHTMLString:[NSString stringWithFormat:@"<div style = color:#3f3f3f;'>%@",myDescriptionHTML] baseURL:nil];
        }
        else if(result.height == 667)
        {
            NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
                                           "<head> \n"
                                           "<style type=\"text/css\"> \n"
                                           "body {font-family: \"%@\"; font-size: %@;}\n"
                                           "</style> \n"
                                           "</head> \n"
                                           "<body>%@</body> \n"
                                           "</html>", @"HelveticaNeue-Bold", [NSNumber numberWithInt:17], object.destinationTitle];
            
            [cell.destinationTitleWebview loadHTMLString:[NSString stringWithFormat:@"<div style = color:#3f3f3f;'>%@",myDescriptionHTML] baseURL:nil];
        }
        else
        {
            NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
                                           "<head> \n"
                                           "<style type=\"text/css\"> \n"
                                           "body {font-family: \"%@\"; font-size: %@;}\n"
                                           "</style> \n"
                                           "</head> \n"
                                           "<body>%@</body> \n"
                                           "</html>", @"HelveticaNeue-Bold", [NSNumber numberWithInt:14], object.destinationTitle];
            
            [cell.destinationTitleWebview loadHTMLString:[NSString stringWithFormat:@"<div style = color:#3f3f3f;'>%@",myDescriptionHTML] baseURL:nil];
        }
        
        cell.destinationTitleWebview.scrollView.scrollEnabled = NO;
        
        
        
        
        cell.destinationContentWebview.opaque = NO;
        
        cell.destinationContentWebview.backgroundColor = [UIColor clearColor];
        
        
        if(result.height == 736)
        {
            NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
                                           "<head> \n"
                                           "<style type=\"text/css\"> \n"
                                           "body {font-family: \"%@\"; font-size: %@;}\n"
                                           "</style> \n"
                                           "</head> \n"
                                           "<body>%@</body> \n"
                                           "</html>", @"HelveticaNeue-Bold", [NSNumber numberWithInt:15], object.destinationContentDetails];
            
            [cell.destinationContentWebview loadHTMLString:[NSString stringWithFormat:@"<div style = color:#545454;'>%@",myDescriptionHTML] baseURL:nil];
        }
        else if(result.height == 667)
        {
            NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
                                           "<head> \n"
                                           "<style type=\"text/css\"> \n"
                                           "body {font-family: \"%@\"; font-size: %@;}\n"
                                           "</style> \n"
                                           "</head> \n"
                                           "<body>%@</body> \n"
                                           "</html>", @"HelveticaNeue-Bold", [NSNumber numberWithInt:14], object.destinationContentDetails];
            
            [cell.destinationContentWebview loadHTMLString:[NSString stringWithFormat:@"<div style = color:#545454;'>%@",myDescriptionHTML] baseURL:nil];
        }
        else
        {
            NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
                                           "<head> \n"
                                           "<style type=\"text/css\"> \n"
                                           "body {font-family: \"%@\"; font-size: %@;}\n"
                                           "</style> \n"
                                           "</head> \n"
                                           "<body>%@</body> \n"
                                           "</html>", @"HelveticaNeue-Bold", [NSNumber numberWithInt:11], object.destinationContentDetails];
            
            [cell.destinationContentWebview loadHTMLString:[NSString stringWithFormat:@"<div style = color:#545454;'>%@",myDescriptionHTML] baseURL:nil];
        }
        
        cell.destinationContentWebview.scrollView.scrollEnabled = NO;
        
        
        
        NSString *imageUrlStr = object.destinationImageUrlStr;
        
        
        if(imageUrlStr.length > 0)
        {
            imageUrlStr = [imageUrlStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            //[cell.destinationImageView setImageWithURL:[NSURL URLWithString:imageUrlStr]];
        }
        else
        {
            //cell.destinationImageView.image = nil;
        }
        
        
        cell.destinationImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        cell.destinationImageView.clipsToBounds = YES;
        
        cell.detailsButton.tag = 1000 + (indexPath.section - 1 );
        
        [cell.detailsButton addTarget:self action:@selector(detailsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;

    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DestinationDetailsViewController *vc = [[DestinationDetailsViewController alloc]initWithNibName:[appDelegate loadAppropriateXibFile:@"DestinationDetailsViewController"] bundle:nil];
    
    
    vc.detailsArray = [self.destinationArray objectAtIndex:indexPath.section - 1];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return self.titleHeight + self.contentHeight + 147;
    }
    else
    {
        return 140.00;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    if(result.height == 736)
        return 14.0;
    else if(result.height == 667)
        return 12.0;
    else
        return 10.0;
    
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}



-(void) detailsButtonAction: (UIButton *) sender
{
    //DestinationObject *object = [self.destinationArray objectAtIndex:sender.tag - 1000];
    
    DestinationDetailsViewController *vc = [[DestinationDetailsViewController alloc]initWithNibName:[appDelegate loadAppropriateXibFile:@"DestinationDetailsViewController"] bundle:nil];
    
    
    vc.detailsArray = [self.destinationArray objectAtIndex:sender.tag - 1000];
    
    [self.navigationController pushViewController:vc animated:YES];

    
}



- (IBAction)menuButtonAction:(id)sender {
    
    [self menuButtonActionn:nil];
}
@end
