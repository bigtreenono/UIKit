//
//  ViewController.m
//  Demo
//
//  Created by Jeff on 12/13/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "ViewController.h"
#import "UIView+NSPTools.h"
#import "CustomCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, CustomCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cellDescriptors;
@property (nonatomic, strong) NSMutableArray *visibleRowsPerSection;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [_tableView registerNib:[UINib nibWithNibName:@"NormalCell" bundle:nil] forCellReuseIdentifier:@"NormalCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TextFieldCell" bundle:nil] forCellReuseIdentifier:@"TextFieldCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"DatePickerCell" bundle:nil] forCellReuseIdentifier:@"DatePickerCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ValuePickerCell" bundle:nil] forCellReuseIdentifier:@"ValuePickerCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SliderCell" bundle:nil] forCellReuseIdentifier:@"SliderCell"];

    _visibleRowsPerSection = [NSMutableArray array];
    _cellDescriptors = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CellDescriptor.plist" ofType:nil]];
    [self getIndicesOfVisibleRows];
    [_tableView reloadData];
}

- (void)getIndicesOfVisibleRows
{
    [_visibleRowsPerSection removeAllObjects];
    for (NSArray *currentSectionCells in _cellDescriptors)
    {
        NSMutableArray *visibleRows = [NSMutableArray array];
        [currentSectionCells enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"isVisible"] boolValue])
            {
                [visibleRows addObject:@(idx)];
            }
        }];
        [_visibleRowsPerSection addObject:visibleRows];
    }
}

- (id)getCellDescriptorForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger indexOfVisibleRow = [_visibleRowsPerSection[indexPath.section][indexPath.row] integerValue];
    return _cellDescriptors[indexPath.section][indexOfVisibleRow];;
}

- (void)dateWasSelected:(NSString *)selectedDateString
{
    [_cellDescriptors[0][3] setValue:selectedDateString forKey:@"primaryTitle"];
    [_tableView reloadData];
}

- (void)maritalStatusSwitchChangedState:(BOOL)isOn
{
    [_cellDescriptors[0][6] setValue:@(isOn) forKey:@"value"];
    [_cellDescriptors[0][5] setValue:isOn ? @"Married" : @"Single" forKey:@"primaryTitle"];
    [_tableView reloadData];
}

- (void)textfieldTextWasChanged:(CustomCell *)customCell newText:(NSString *)newText
{
    NSIndexPath *parentCellIndexPath = [_tableView indexPathForCell:customCell];
    NSString *currentFullname = _cellDescriptors[0][0][@"primaryTitle"];
    NSArray *fullnameParts = [currentFullname componentsSeparatedByString:@" "];
    NSString *newFullname = @"";
    if (parentCellIndexPath.row == 1)
    {
        if (fullnameParts.count == 2)
        {
            newFullname = [NSString stringWithFormat:@"%@ %@", newText, fullnameParts[1]];
        }
        else
        {
            newFullname = newText;
        }
    }
    else
    {
        newFullname = [NSString stringWithFormat:@"%@ %@", fullnameParts[0], newText];
    }
    [_cellDescriptors[0][0] setValue:newFullname forKey:@"primaryTitle"];
    [_tableView reloadData];
}

- (void)sliderDidChangeValue:(NSString *)newSliderValue
{
    [_cellDescriptors[2][0] setValue:newSliderValue forKey:@"primaryTitle"];
    [_cellDescriptors[2][1] setValue:newSliderValue forKey:@"value"];

    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger indexOfTappedRow = [_visibleRowsPerSection[section][indexPath.row] integerValue];
    NSDictionary *cellDescriptor = _cellDescriptors[section][indexOfTappedRow];
    if ([cellDescriptor[@"isExpandable"] boolValue])
    {
        BOOL shouldExpandAndShowSubRows = NO;
        if (![cellDescriptor[@"isExpanded"] boolValue])
        {
            shouldExpandAndShowSubRows = YES;
        }
        [_cellDescriptors[section][indexOfTappedRow] setValue:@(shouldExpandAndShowSubRows) forKey:@"isExpanded"];
        for (NSInteger i = indexOfTappedRow + 1; i < indexOfTappedRow + [cellDescriptor[@"additionalRows"] integerValue] + 1; ++i)
        {
            [_cellDescriptors[section][i] setValue:@(shouldExpandAndShowSubRows) forKey:@"isVisible"];
        }
    }
    else if ([cellDescriptor[@"cellIdentifier"] isEqualToString:@"ValuePickerCell"])
    {
        NSInteger indexOfParentCell = 0;
        for (NSInteger i = indexOfTappedRow - 1; i >= 0; --i)
        {
            if (_cellDescriptors[section][i][@"isExpandable"])
            {
                indexOfParentCell = i;
                break;
            }
        }
        [_cellDescriptors[section][indexOfParentCell] setValue:[_tableView cellForRowAtIndexPath:indexPath].textLabel.text forKey:@"primaryTitle"];
        [_cellDescriptors[section][indexOfParentCell] setValue:@0 forKey:@"isExpanded"];
        
        for (int i = 1; i < [_cellDescriptors[section][indexOfParentCell][@"additionalRows"] integerValue]; ++i)
        {
            [_cellDescriptors[section][i] setValue:@0 forKey:@"isVisible"];
        }
    }
    [self getIndicesOfVisibleRows];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *currentCellDescriptor = [self getCellDescriptorForIndexPath:indexPath];
    NSString *cellIdentifier = currentCellDescriptor[@"cellIdentifier"];
    CustomCell *customCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    customCell.delegate = self;
    if ([cellIdentifier isEqualToString:@"NormalCell"])
    {
        NSLog(@"customCell.textField %@", customCell.textField);
        customCell.textLabel.text = currentCellDescriptor[@"primaryTitle"];
        customCell.detailTextLabel.text = currentCellDescriptor[@"secondaryTitle"];
    }
    else if ([cellIdentifier isEqualToString:@"TextFieldCell"])
    {
        NSLog(@"customCell.textField2 %@", customCell.textField);

        customCell.textField.placeholder = currentCellDescriptor[@"primaryTitle"];
    }
    else if ([cellIdentifier isEqualToString:@"SwitchCell"])
    {
        NSLog(@"customCell.textField3 %@", customCell.textField);

        customCell.lblSwitchLabel.text = currentCellDescriptor[@"primaryTitle"];
        customCell.swMaritalStatus.on = [currentCellDescriptor[@"value"] boolValue];
    }
    else if ([cellIdentifier isEqualToString:@"ValuePickerCell"])
    {
        customCell.textLabel.text = currentCellDescriptor[@"primaryTitle"];
    }
    else if ([cellIdentifier isEqualToString:@"SliderCell"])
    {
        customCell.slExperienceLevel.value = [currentCellDescriptor[@"value"] floatValue];
    }
    return customCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_visibleRowsPerSection[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cellDescriptors.count;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Personal";
    }
    else if (section == 1)
    {
        return @"Preferences";
    }
    else
    {
        return @"Work Experience";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *currentCellDescriptor = [self getCellDescriptorForIndexPath:indexPath];
    NSString *cellIdentifier = currentCellDescriptor[@"cellIdentifier"];
    if ([cellIdentifier isEqualToString:@"NormalCell"])
    {
        return 60;
    }
    if ([cellIdentifier isEqualToString:@"DatePickerCell"])
    {
        return 270.0;
    }
    return 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
