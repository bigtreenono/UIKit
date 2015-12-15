//
//  CustomCell.h
//  Demo
//
//  Created by Jeff on 12/13/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomCell;

@protocol CustomCellDelegate <NSObject>

- (void)dateWasSelected:(NSString *)selectedDateString;
- (void)maritalStatusSwitchChangedState:(BOOL)isOn;
- (void)textfieldTextWasChanged:(CustomCell *)customCell newText:(NSString *)newText;
- (void)sliderDidChangeValue:(NSString *)newSliderValue;

@end

@interface CustomCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, weak) id <CustomCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISlider *slExperienceLevel;
@property (weak, nonatomic) IBOutlet UISwitch *swMaritalStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblSwitchLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
