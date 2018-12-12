#import "LUHUnderLineButtonView.h"

@interface LUHUnderLineButtonView ()
@property (nonatomic) NSArray *items;
@property (nonatomic) id target;
@property (nonatomic) SEL action;
@end

@implementation LUHUnderLineButtonView

- (instancetype)initWithItems:(NSArray *)items;
{
    self = [super init];
    if (self) {
        _items = items;
        [self setButtons];
        [self setInitialValue];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setButtonsFrames];
}

- (void)setButtons
{
    int i = 0;
    for (NSString *titleStr in _items) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = 1000+i;
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        i++;
    }
    
    UIView *underLine = [[UIView alloc] init];
    underLine.backgroundColor = [UIColor redColor];
    underLine.tag = kLUHUnderLineButtonUnderLineTag;
    underLine.layer.cornerRadius = kLUHUnderLineButtonUnderLineHeight/2;
    [self addSubview:underLine];
}

- (void)setInitialValue
{
    self.selectedIndex = 0;
    [self selectButtonWithIndex:0];
    
    UIButton *button = (UIButton *)[self viewWithTag:1000 + _selectedIndex];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

- (void)setButtonsFrames
{
    CGFloat width = CGRectGetWidth(self.frame)/_items.count;
    CGFloat height = CGRectGetHeight(self.frame);
    for (int i = 0; i < _items.count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:1000+i];
        if (button != nil) button.frame = CGRectMake(i*width, 0, width, height);
    }
    
    UIView *underLine = [self viewWithTag:kLUHUnderLineButtonUnderLineTag];
    CGFloat underLineW = width - 2*kLUHUnderLineButtonUnderLinePadding;
    if (underLine != nil) {
        underLine.frame = CGRectMake(self.selectedIndex*underLineW + kLUHUnderLineButtonUnderLinePadding, height-kLUHUnderLineButtonUnderLineHeight,
                                     underLineW, kLUHUnderLineButtonUnderLineHeight);
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)buttonAction:(UIButton *)button
{
    NSInteger index = button.tag-1000;
    if (index == self.selectedIndex) return;
    self.selectedIndex = index;
    if (self.action != nil) {
        [self.target performSelectorOnMainThread:self.action withObject:button waitUntilDone:NO];
    }
}

#pragma mark - private

- (void)selectButtonWithIndex:(NSInteger)index;
{
    CGFloat width = CGRectGetWidth(self.frame)/_items.count;
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat underLineW = width - 2*kLUHUnderLineButtonUnderLinePadding;
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        UIView *underLine = [weakself viewWithTag:kLUHUnderLineButtonUnderLineTag];
        if (underLine != nil) {
            underLine.frame = CGRectMake(index*width+kLUHUnderLineButtonUnderLinePadding, height-kLUHUnderLineButtonUnderLineHeight,
                                         underLineW, kLUHUnderLineButtonUnderLineHeight);
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex) return;
    
    UIButton *button = (UIButton *)[self viewWithTag:1000 + _selectedIndex];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    _selectedIndex = selectedIndex;
    
    button = (UIButton *)[self viewWithTag:1000 + _selectedIndex];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self selectButtonWithIndex:selectedIndex];
}

@end
