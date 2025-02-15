#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UnityInterface.h"

@interface DatePickerPlugin : NSObject

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIViewController *viewController;

+ (instancetype)sharedInstance;
- (void)openDatePicker;

@end

@implementation DatePickerPlugin

+ (instancetype)sharedInstance {
    static DatePickerPlugin *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DatePickerPlugin alloc] init];
    });
    return sharedInstance;
}

- (void)openDatePicker {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.viewController = keyWindow.rootViewController;
    
    self.containerView = [[UIView alloc] initWithFrame:self.viewController.view.bounds];
    self.containerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker)];
    [self.containerView addGestureRecognizer:tapGesture];
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    if (@available(iOS 13.4, *)) {
        self.datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    self.datePicker.backgroundColor = [UIColor blackColor];
    // Set the text color to white
    [self.datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    self.datePicker.frame = CGRectMake(0, self.viewController.view.bounds.size.height - 250, self.viewController.view.bounds.size.width, 250);
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.viewController.view.bounds.size.height - 290, self.viewController.view.bounds.size.width, 40)];
    self.toolbar.barTintColor = [UIColor blackColor];
    self.toolbar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped)];
    self.toolbar.items = @[flexSpace, doneButton];
    
    [self.viewController.view addSubview:self.containerView];
    [self.containerView addSubview:self.datePicker];
    [self.containerView addSubview:self.toolbar];
}

- (void)doneButtonTapped {
    NSDate *selectedDate = self.datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    
    UnitySendMessage("NativeDatePickerManager", "OnDatePicked", [dateString UTF8String]);
    [self dismissDatePicker];
}

- (void)dismissDatePicker {
    [self.datePicker removeFromSuperview];
    [self.toolbar removeFromSuperview];
    [self.containerView removeFromSuperview];
}

@end

#ifdef __cplusplus
extern "C" {
#endif

void cOpenDatePicker() {
    [[DatePickerPlugin sharedInstance] openDatePicker];
}

#ifdef __cplusplus
}
#endif
