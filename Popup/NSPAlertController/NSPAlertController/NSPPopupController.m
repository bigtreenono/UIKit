//
//  NSPPopupController.m
//  NSPAlertController
//
//  Created by Jeff on 1/3/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import "NSPPopupController.h"
#import "NSPPopupNavigationBar.h"
#import "NSPPopupLeftBarButtonItem.h"
#import "UIViewController+NSPPopup.h"

static NSMutableSet *_retainedPopupControllers;

@interface NSPPopupContainerVC : UIViewController

@end

@implementation NSPPopupContainerVC

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.childViewControllers.count || !self.presentingViewController)
    {
        return [super preferredStatusBarStyle];
    }
    return [self.presentingViewController preferredStatusBarStyle];
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return self.childViewControllers.lastObject;
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.childViewControllers.lastObject;
}

- (void)showDetailViewController:(UIViewController *)vc sender:(id)sender
{
    if (!CGSizeEqualToSize(vc.contentSizeInPopup, CGSizeZero) ||
        !CGSizeEqualToSize(vc.landscapeContentSizeInPopup, CGSizeZero))
    {
        UIViewController *childViewController = self.childViewControllers.lastObject;
        [childViewController.popupController pushViewController:vc animated:YES];
    }
    else
    {
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)showViewController:(UIViewController *)vc sender:(id)sender
{
    if (!CGSizeEqualToSize(vc.contentSizeInPopup, CGSizeZero) ||
        !CGSizeEqualToSize(vc.landscapeContentSizeInPopup, CGSizeZero))
    {
        UIViewController *childViewController = self.childViewControllers.lastObject;
        [childViewController.popupController pushViewController:vc animated:YES];
    }
    else
    {
        [self presentViewController:vc animated:YES completion:nil];
    }
}

@end

@interface NSPPopupController () <UIViewControllerTransitioningDelegate, NSPPopupNavigationBarDragEventDelegate, UIViewControllerAnimatedTransitioning>
{
    NSMutableArray *_viewControllers;
    NSPPopupContainerVC *_containerVC;
    UIView *_backgroundView;
    UIView *_containerView;
    UIView *_contentView;
    NSPPopupNavigationBar *_navigationBar;
    UILabel *_defaultTitleLabel;
    NSPPopupLeftBarButtonItem *_defaultleftBarButtonItem;
    BOOL _observing;
    NSDictionary *_keyboardInfo;
}
@end

@implementation NSPPopupController

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _retainedPopupControllers = [NSMutableSet new];
    });
}

- (void)dealloc
{
    NSLog(@"%@ dealloc dealloc dealloc dealloc dealloc", self.class);
    [self destroyObservers];
    for (UIViewController *vc in _viewControllers)
    {
        [vc setValue:nil forKey:@"popupController"];
        [self destroyObserversOfViewController:vc];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _viewControllers = [NSMutableArray array];
        
        _containerVC = [NSPPopupContainerVC new];
        _containerVC.view.backgroundColor = [UIColor clearColor];
        _containerVC.modalPresentationStyle = UIModalPresentationCustom;
        _containerVC.transitioningDelegate = self;
        
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackgroundView:)]];
        [_containerVC.view insertSubview:_backgroundView atIndex:0];
//        [_containerVC.view addSubview:_backgroundView];

//        [_containerVC.view addSubview:({
//            _backgroundView = [UIView new];
//            _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
//            _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//            [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackgroundView:)]];
//            _backgroundView;
//        })];
        
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.clipsToBounds = YES;
        [_containerVC.view addSubview:_containerView];
        
//        [_containerVC.view addSubview:({
//            _containerView = [UIView new];
//            _containerView.backgroundColor = [UIColor whiteColor];
//            _containerView.clipsToBounds = YES;
//            _containerView;
//        })];
        
        _contentView = [UIView new];
        [_containerView addSubview:_contentView];
        
//        [_containerView addSubview:({
//            _contentView = [UIView new];
//            _contentView;
//        })];
        
        _navigationBar = [NSPPopupNavigationBar new];
        _navigationBar.dragDelegate = self;
        [_containerView addSubview:_navigationBar];
        
//        [_containerView addSubview:({
//            _navigationBar = [NSPPopupNavigationBar new];
//            _navigationBar.dragDelegate = self;
//            _navigationBar;
//        })];
        
        _defaultTitleLabel = [UILabel new];
        _defaultleftBarButtonItem = [[NSPPopupLeftBarButtonItem alloc] initWithTarget:self action:@selector(didTapLeftBarButtonItem:)];
    }
    return self;
}

- (nonnull instancetype)initWithRootViewController:(nonnull UIViewController *)rootViewController
{
    if (self = [self init])
    {
        [self pushViewController:rootViewController animated:NO];
    }
    return self;
}

#pragma mark - transitions
- (void)pushViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *topViewController = _viewControllers.lastObject;
    
    [viewController setValue:self forKey:@"popupController"];
    [_viewControllers addObject:viewController];
    
    if (self.presented)
    {
        [self transitFromViewController:topViewController toViewController:viewController animated:animated];
    }
    [self setupObserversForViewController:viewController];
}

- (void)transitFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController animated:(BOOL)animated
{
    [fromViewController beginAppearanceTransition:NO animated:animated];
    [toViewController beginAppearanceTransition:YES animated:animated];
    
    [fromViewController willMoveToParentViewController:nil];
    [_containerVC addChildViewController:toViewController];
    if (animated)
    {
        CGRect fromVCBounds = fromViewController.view.bounds;
        CGSize fromVCSize = fromVCBounds.size;
        UIGraphicsBeginImageContextWithOptions(fromVCSize, NO, [UIScreen mainScreen].scale);
        [fromViewController.view drawViewHierarchyInRect:fromVCBounds afterScreenUpdates:NO];
        UIImageView *capturedView = [[UIImageView alloc] initWithImage:UIGraphicsGetImageFromCurrentImageContext()];
        UIGraphicsEndImageContext();
        
        capturedView.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, fromVCSize.width, fromVCSize.height);
        [_containerView insertSubview:capturedView atIndex:0];
        
        [fromViewController.view removeFromSuperview];
        
        _containerView.userInteractionEnabled = NO;
        toViewController.view.alpha = 0;
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [weakSelf layoutContainerView];
            [_contentView addSubview:toViewController.view];
            capturedView.alpha = 0;
            toViewController.view.alpha = 1;
            [_containerVC setNeedsStatusBarAppearanceUpdate];
        } completion:^(BOOL finished) {
            [capturedView removeFromSuperview];
            [fromViewController removeFromParentViewController];
            
            _containerView.userInteractionEnabled = YES;
            [toViewController didMoveToParentViewController:_containerVC];
            
            [fromViewController endAppearanceTransition];
            [toViewController endAppearanceTransition];
        }];
        
        [self updateNavigationBarAniamted:animated];
    }
    else
    {
        [self layoutContainerView];
        [_containerView addSubview:toViewController.view];
        [_containerVC setNeedsStatusBarAppearanceUpdate];
        [self updateNavigationBarAniamted:animated];
        
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:_containerVC];
        
        [fromViewController endAppearanceTransition];
        [toViewController endAppearanceTransition];
    }
}

- (void)presentInViewController:(nonnull UIViewController *)viewController
{
    [self presentInViewController:viewController completion:nil];
}

- (void)presentInViewController:(nonnull UIViewController *)viewController completion:(void (^__nullable)(void))completion
{
    if (!self.presented)
    {
        [self setupObservers];
        [_retainedPopupControllers addObject:self];
        [viewController presentViewController:_containerVC animated:YES completion:completion];
    }
}

- (void)dismiss
{
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void (^__nullable)(void))completion
{
    if (self.presented)
    {
        [self destroyObservers];
        [_containerVC dismissViewControllerAnimated:YES completion:^{
            [_retainedPopupControllers removeObject:self];
            !completion ?: completion();
        }];
    }
}

- (void)popViewControllerAnimated:(BOOL)animated
{
    if (_viewControllers.count < 2)
    {
        [self dismiss];
    }
    else
    {
        UIViewController *topVC = _viewControllers.lastObject;
        [topVC setValue:nil forKey:@"popupController"];
        [self destroyObserversOfViewController:topVC];
        [_viewControllers removeObject:topVC];
        if ([self presented])
        {
            [self transitFromViewController:topVC toViewController:_viewControllers.lastObject animated:animated];
        }
    }
}

- (void)layoutContainerView
{
    _backgroundView.frame = _containerVC.view.bounds;
    
    UINavigationController *temp = [UINavigationController new];
    CGFloat preferredNavigationBarHeight = temp.navigationBar.bounds.size.height;
    
    CGFloat navigationBarHeight = _navigationBarHidden ? 0 : preferredNavigationBarHeight;
    
    UIViewController *topVC = _viewControllers.lastObject;
    CGSize contentSizeOfTopView = CGSizeZero;
    if ( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ||
        [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight )
    {
        contentSizeOfTopView = topVC.landscapeContentSizeInPopup;
        if (CGSizeEqualToSize(contentSizeOfTopView, CGSizeZero))
        {
            contentSizeOfTopView = topVC.contentSizeInPopup;
        }
    }
    else
    {
        contentSizeOfTopView = topVC.contentSizeInPopup;
    }
    NSAssert(!CGSizeEqualToSize(contentSizeOfTopView, CGSizeZero), @"contentSizeInPopup should not be zero");
    
    CGFloat containerViewWidth = contentSizeOfTopView.width;
    CGFloat containerViewHeight = contentSizeOfTopView.height + navigationBarHeight;
    
    CGFloat containerViewY = (_containerVC.view.bounds.size.height - containerViewHeight) / 2;
    if (_style == NSPPopupStyleBottomSheet)
    {
        containerViewY = _containerVC.view.bounds.size.height - containerViewHeight;
        containerViewHeight += 80;
    }
    
    _containerView.frame = CGRectMake((_containerVC.view.bounds.size.width - containerViewWidth) / 2, containerViewY, containerViewWidth, containerViewHeight);
    _navigationBar.frame = CGRectMake(0, 0, containerViewWidth, preferredNavigationBarHeight);
    _contentView.frame = CGRectMake(0, navigationBarHeight, containerViewWidth, contentSizeOfTopView.height);
    
    topVC.view.frame = _contentView.bounds;
}

- (void)updateNavigationBarAniamted:(BOOL)animated
{
    UIViewController *topViewController = _viewControllers.lastObject;

    UIView *lastTitleView = _navigationBar.topItem.titleView;
    _navigationBar.items = @[ [UINavigationItem new] ];
    _navigationBar.topItem.leftBarButtonItems = topViewController.navigationItem.leftBarButtonItems ?: topViewController.navigationItem.hidesBackButton ? nil : @[ _defaultleftBarButtonItem ];
    _navigationBar.topItem.rightBarButtonItems = topViewController.navigationItem.rightBarButtonItems;
    
    if (animated)
    {
        UIView *fromTitleView, *toTitleView;
        if (lastTitleView == _defaultTitleLabel)    {
            UILabel *tempLabel = [[UILabel alloc] initWithFrame:_defaultTitleLabel.frame];
            tempLabel.textColor = _defaultTitleLabel.textColor;
            tempLabel.font = _defaultTitleLabel.font;
            tempLabel.attributedText = [[NSAttributedString alloc] initWithString:_defaultTitleLabel.text ? : @""
                                                                       attributes:_navigationBar.titleTextAttributes];
            fromTitleView = tempLabel;
        }
        else {
            fromTitleView = lastTitleView;
        }
        
        if (topViewController.navigationItem.titleView) {
            toTitleView = topViewController.navigationItem.titleView;
        }
        else {
            NSString *title = (topViewController.title ? : topViewController.navigationItem.title) ? : @"";
            _defaultTitleLabel = [UILabel new];
            _defaultTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:title
                                                                                attributes:_navigationBar.titleTextAttributes];
            [_defaultTitleLabel sizeToFit];
            toTitleView = _defaultTitleLabel;
        }
        
        [_navigationBar addSubview:fromTitleView];
        _navigationBar.topItem.titleView = toTitleView;
        toTitleView.alpha = 0;
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            fromTitleView.alpha = 0;
            toTitleView.alpha = 1;
        } completion:^(BOOL finished) {
            [fromTitleView removeFromSuperview];
        }];
    }
    else {
        if (topViewController.navigationItem.titleView)
        {
            _navigationBar.topItem.titleView = topViewController.navigationItem.titleView;
        }
        else
        {
            NSString *title = (topViewController.title ? : topViewController.navigationItem.title) ? : @"";
            _defaultTitleLabel = [UILabel new];
            _defaultTitleLabel.attributedText = [[NSAttributedString alloc]
                                                 initWithString:title
                                                     attributes:_navigationBar.titleTextAttributes];
            [_defaultTitleLabel sizeToFit];
            _navigationBar.topItem.titleView = _defaultTitleLabel;
        }
    }
    _defaultleftBarButtonItem.tintColor = _navigationBar.tintColor;
    [_defaultleftBarButtonItem setType:_viewControllers.count > 1 ? NSPPopupLeftBarButtonItemTypeArrow : NSPPopupLeftBarButtonItemTypeCross animated:animated];
}

- (void)adjustContainerViewOrigin
{
    if (!_keyboardInfo)
    {
        return;
    }

    UIView<UIKeyInput> *currentTextInput = [self currentTextInPutViewInView:_containerView];
    if (!currentTextInput)
    {
        return;
    }
    
    CGAffineTransform lastTransform = _containerView.transform;
    _containerView.transform = CGAffineTransformIdentity; // Set transform to identity for calculating a correct "minOffsetY"
    
    CGFloat textFieldBottomY = [currentTextInput convertPoint:CGPointZero toView:_containerVC.view].y + currentTextInput.bounds.size.height;
    CGFloat keyboardHeight = [_keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    // For iOS 7
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1 &&
        (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight))
    {
        keyboardHeight = [_keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.width;
    }
    
    CGFloat offsetY = 0;
    if (_style == NSPPopupStyleBottomSheet)
    {
        offsetY = keyboardHeight;
    }
    else
    {
        CGFloat spacing = 5;
        offsetY = _containerView.frame.origin.y + _containerView.bounds.size.height - (_containerVC.view.bounds.size.height - keyboardHeight - spacing);
        if (offsetY <= 0)
        { // _containerView can be totally shown, so no need to reposition
            return;
        }
        
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        
        if (_containerView.frame.origin.y - offsetY < statusBarHeight)
        { // _containerView will be covered by status bar if it is repositioned with "offsetY"
            offsetY = _containerView.frame.origin.y - statusBarHeight;
            // currentTextField can not be totally shown if _containerView is going to repositioned with "offsetY"
            if (textFieldBottomY - offsetY > _containerVC.view.bounds.size.height - keyboardHeight - spacing)
            {
                offsetY = textFieldBottomY - (_containerVC.view.bounds.size.height - keyboardHeight - spacing);
            }
        }
    }
    
    NSTimeInterval duration = [_keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [_keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    _containerView.transform = lastTransform; // Restore transform
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:duration];
    
    _containerView.transform = CGAffineTransformMakeTranslation(0, -offsetY);
    
    [UIView commitAnimations];
}

#pragma mark - notifications
- (void)setupObservers
{
    if (_observing)
    {
        return;
    }
    _observing = YES;
    
    [_navigationBar addObserver:self forKeyPath:NSStringFromSelector(@selector(tintColor)) options:NSKeyValueObservingOptionNew context:nil];
    [_navigationBar addObserver:self forKeyPath:NSStringFromSelector(@selector(titleTextAttributes)) options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientationNotification) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
#warning 11
    
}

- (void)destroyObservers
{
    if (_observing)
    {
        _observing = NO;
        [_navigationBar removeObserver:self forKeyPath:NSStringFromSelector(@selector(tintColor))];
        [_navigationBar removeObserver:self forKeyPath:NSStringFromSelector(@selector(titleTextAttributes))];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    UIViewController *topVC = _viewControllers.lastObject;
    if (object == _navigationBar || object == topVC.navigationItem)
    {
        [self updateNavigationBarAniamted:NO];
    }
    else if (object == topVC && topVC.isViewLoaded && topVC.view.superview)
    {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [weakSelf layoutContainerView];
        } completion:nil];
    }
}

- (void)setupObserversForViewController:(UIViewController *)viewController
{
    [viewController addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSizeInPopup)) options:NSKeyValueObservingOptionNew context:nil];
    [viewController addObserver:self forKeyPath:NSStringFromSelector(@selector(landscapeContentSizeInPopup)) options:NSKeyValueObservingOptionNew context:nil];
    [viewController.navigationItem addObserver:self forKeyPath:NSStringFromSelector(@selector(title)) options:NSKeyValueObservingOptionNew context:nil];
    [viewController.navigationItem addObserver:self forKeyPath:NSStringFromSelector(@selector(titleView)) options:NSKeyValueObservingOptionNew context:nil];
    [viewController.navigationItem addObserver:self forKeyPath:NSStringFromSelector(@selector(leftBarButtonItem)) options:NSKeyValueObservingOptionNew context:nil];
    [viewController.navigationItem addObserver:self forKeyPath:NSStringFromSelector(@selector(leftBarButtonItems)) options:NSKeyValueObservingOptionNew context:nil];
    [viewController.navigationItem addObserver:self forKeyPath:NSStringFromSelector(@selector(rightBarButtonItem)) options:NSKeyValueObservingOptionNew context:nil];
    [viewController.navigationItem addObserver:self forKeyPath:NSStringFromSelector(@selector(rightBarButtonItems)) options:NSKeyValueObservingOptionNew context:nil];
    [viewController.navigationItem addObserver:self forKeyPath:NSStringFromSelector(@selector(hidesBackButton)) options:NSKeyValueObservingOptionNew context:nil];
}

- (void)destroyObserversOfViewController:(UIViewController *)viewController
{
    [viewController removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentSizeInPopup))];
    [viewController removeObserver:self forKeyPath:NSStringFromSelector(@selector(landscapeContentSizeInPopup))];
    [viewController.navigationItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];
    [viewController.navigationItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(titleView))];
    [viewController.navigationItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(leftBarButtonItem))];
    [viewController.navigationItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(leftBarButtonItems))];
    [viewController.navigationItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(rightBarButtonItem))];
    [viewController.navigationItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(rightBarButtonItems))];
    [viewController.navigationItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(hidesBackButton))];
}

- (void)keyboardWillShowNotification:(NSNotification *)notify
{
    UIView<UIKeyInput> *currentTextInPutView = [self currentTextInPutViewInView:_containerView];
    if (!currentTextInPutView)
    {
        return;
    }
    _keyboardInfo = notify.userInfo;
    [self adjustContainerViewOrigin];
}

- (void)keyboardWillHideNotification:(NSNotification *)notify
{
    _keyboardInfo = nil;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:[notify.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    _containerView.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

- (void)didChangeStatusBarOrientationNotification
{
    [_containerView endEditing:YES];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _containerView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf layoutContainerView];
        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _containerView.alpha = 1;
        } completion:nil];
    }];
}

#pragma mark - navigationBarHidden
- (void)setNavigationBarHidden:(BOOL)navigationBarHidden
{
    [self setNavigationBarHidden:navigationBarHidden animated:NO];
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden animated:(BOOL)animated
{
    _navigationBarHidden = navigationBarHidden;
    _navigationBar.alpha = navigationBarHidden ? 1 : 0;
    if (animated)
    {
        if (!navigationBarHidden)
        {
            _navigationBar.hidden = navigationBarHidden;
        }
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _navigationBar.alpha = navigationBarHidden ? 0 : 1;
            [weakSelf layoutContainerView];
        } completion:^(BOOL finished) {
            _navigationBar.hidden = navigationBarHidden;
        }];
    }
    else
    {
        [self layoutContainerView];
        _navigationBar.hidden = navigationBarHidden;
    }
}

#pragma mark - private methods
- (void)didTapLeftBarButtonItem:(NSPPopupLeftBarButtonItem *)button
{
    if (_defaultleftBarButtonItem.type == NSPPopupLeftBarButtonItemTypeCross)
    {
        [self dismiss];
    }
    else
    {
        [self popViewControllerAnimated:YES];
    }
}

- (UIView<UIKeyInput> *)currentTextInPutViewInView:(UIView *)view
{
    if ([view conformsToProtocol:@protocol(UIKeyInput)] && view.isFirstResponder)
    {
        return (UIView<UIKeyInput> *)view;
    }
    for (UIView *subView in view.subviews)
    {
        UIView<UIKeyInput> *inputView = [self currentTextInPutViewInView:subView];
        if (inputView)
        {
            return inputView;
        }
    }
    return nil;
}

- (BOOL)presented
{
    return _containerVC.presentingViewController != nil;
}

- (void)tappedBackgroundView:(UITapGestureRecognizer *)tap
{
//    _containerVC end
}

#pragma mark - NSPPopupNavigationBarDragEventDelegate
- (void)popupNavigationBar:(NSPPopupNavigationBar *)navigationBar isMovingWithOffset:(CGFloat)offset
{
    [_containerView endEditing:YES];
    if (_style == NSPPopupStyleBottomSheet && offset < -80)
    {
        return;
    }
    _containerView.transform = CGAffineTransformMakeTranslation(0, offset);
}

- (void)popupNavigationBar:(NSPPopupNavigationBar *)navigationBar endMovingWithOffset:(CGFloat)offset
{
    __weak typeof(self) weakSelf = self;
    if (offset > 150)
    {
        NSPPopupTransitionStyle transitionStyle = _transitionStyle;
        _transitionStyle = NSPPopupTransitionStyleSlideVertical;
        [self dismissWithCompletion:^{
            weakSelf.transitionStyle = transitionStyle;
        }];
    }
    else
    {
        [_containerView endEditing:YES];
        [UIView animateWithDuration:.4 delay:0 usingSpringWithDamping:.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _containerView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (toViewController == _containerVC)
    {
        return 0.5;
    }
    else
    {
        return self.transitionStyle == NSPPopupTransitionStyleFade ? 0.4 : 0.7;
    }
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    toViewController.view.frame = fromViewController.view.frame;
    
    UIViewController *topViewController = _viewControllers.lastObject;
    
    if (toViewController == _containerVC)
    {
        [fromViewController beginAppearanceTransition:NO animated:YES];
        
        [[transitionContext containerView] addSubview:toViewController.view];
        
        [topViewController beginAppearanceTransition:YES animated:YES];
        [toViewController addChildViewController:topViewController];
        
        [self layoutContainerView];
        [_contentView addSubview:topViewController.view];
        [toViewController setNeedsStatusBarAppearanceUpdate];
        [self updateNavigationBarAniamted:NO];
        
        CGAffineTransform lastTransform = _containerView.transform;
        _containerView.transform = CGAffineTransformIdentity; // Set transform to identity for getting a correct origin.y
        
        CGFloat originY = _containerView.frame.origin.y;
        
        _containerView.transform = lastTransform;
        
        switch (_transitionStyle)
        {
            case NSPPopupTransitionStyleFade:
            {
                _containerView.alpha = 0;
                _containerView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            }
                break;
            case NSPPopupTransitionStyleSlideVertical:
            default:
            {
                _containerView.alpha = 1;
                _containerView.transform = CGAffineTransformMakeTranslation(0, _containerVC.view.bounds.size.height - originY);
            }
                break;
        }
        
        CGFloat lastBackgroundViewAlpha = _backgroundView.alpha;
        _backgroundView.alpha = 0;
        _containerView.userInteractionEnabled = NO;
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _backgroundView.alpha = lastBackgroundViewAlpha;
            _containerView.alpha = 1;
            _containerView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            _containerView.userInteractionEnabled = YES;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            
            [topViewController didMoveToParentViewController:toViewController];
            
            [fromViewController endAppearanceTransition];
        }];
    }
    else
    {
        [toViewController beginAppearanceTransition:YES animated:YES];
        
        [topViewController beginAppearanceTransition:NO animated:YES];
        [topViewController willMoveToParentViewController:nil];
        
        CGAffineTransform lastTransform = _containerView.transform;
        _containerView.transform = CGAffineTransformIdentity; // Set transform to identity for getting a correct origin.y
        
        CGFloat originY = _containerView.frame.origin.y;
        
        _containerView.transform = lastTransform;
        
        CGFloat lastBackgroundViewAlpha = _backgroundView.alpha;
        _containerView.userInteractionEnabled = NO;
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _backgroundView.alpha = 0;
            switch (weakSelf.transitionStyle)
            {
                case NSPPopupTransitionStyleFade:
                {
                    _containerView.alpha = 0;
                    _containerView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                }
                    break;
                case NSPPopupTransitionStyleSlideVertical:
                default:
                {
                    _containerView.transform = CGAffineTransformMakeTranslation(0, _containerVC.view.bounds.size.height - originY + _containerView.frame.size.height);
                }
                    break;
            }
        } completion:^(BOOL finished) {
            _containerView.userInteractionEnabled = YES;
            _containerView.transform = CGAffineTransformIdentity;
            [fromViewController.view removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            
            [topViewController.view removeFromSuperview];
            [topViewController removeFromParentViewController];
            
            [toViewController endAppearanceTransition];
            
            _backgroundView.alpha = lastBackgroundViewAlpha;
        }];
    }
}

@end





























