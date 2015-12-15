//
//  CustomCell.m
//  Demo
//
//  Created by Jeff on 12/13/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)awakeFromNib
{
    if (self.textLabel)
    {
        self.textLabel.font = [UIFont fontWithName:@"Avenir-Book" size:17];
        self.textLabel.textColor = [UIColor blackColor];
    }
    if (self.detailTextLabel)
    {
        self.detailTextLabel.font = [UIFont fontWithName:@"Avenir-Light" size:17];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    _textField.font = [UIFont fontWithName:@"Avenir-Book" size:17];
    _lblSwitchLabel.font = [UIFont fontWithName:@"Avenir-Book" size:17];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_delegate textfieldTextWasChanged:self newText:textField.text];
    return YES;
}

- (IBAction)handleSliderValueChange:(UISlider *)sender
{
    [_delegate sliderDidChangeValue:[NSString stringWithFormat:@"%d", (int)sender.value]];
}

- (IBAction)handleSwitchStateChange:(UISwitch *)sender
{
    [_delegate maritalStatusSwitchChangedState:sender.on];
}

- (IBAction)setDate:(UIButton *)sender
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateStyle = NSDateFormatterLongStyle;
    [_delegate dateWasSelected:[dateFormatter stringFromDate:_datePicker.date]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end




























