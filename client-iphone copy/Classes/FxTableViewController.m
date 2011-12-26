
#import "FxTableViewController.h"

#import "FxExceptions.h"
#import "FxAssert.h"

#import "FxStringTools.h"
#import "FxDumper.h"

#import "FxUiTextFieldCell.h"
#import "FxTextBlockTableViewCell.h"
#import "FxTextFieldTableViewCell.h"
#import "FxButtonTableViewCell.h"
#import "FxItemTableViewCell.h"

#import "FxUiTextBlockCell.h"
#import "FxUiTextFieldCell.h"
#import "FxUiButtonCell.h"
#import "FxUiItemCell.h"

@interface FxTableViewController()

- (FxUiSection *) _sectionForCell:(FxUiCell *)cell;

- (BOOL) _isLastSectionCell:(FxUiCell *)cell;

- (void) _refreshPage;
- (void) _startObservingPageRefreshTrggers;
- (void) _stopObservingPageRefreshTrggers;

- (UITableViewCell          *) _cellForTableView:(UITableView *)tableView uiCell         :(FxUiCell          *)uiCell;
- (FxTextBlockTableViewCell *) _cellForTableView:(UITableView *)tableView uiTextBlockCell:(FxUiTextBlockCell *)uiCell;
- (FxTextFieldTableViewCell *) _cellForTableView:(UITableView *)tableView uiTextFieldCell:(FxUiTextFieldCell *)uiCell;
- (FxButtonTableViewCell    *) _cellForTableView:(UITableView *)tableView uiButtonCell   :(FxUiButtonCell    *)uiCell;
- (FxItemTableViewCell      *) _cellForTableView:(UITableView *)tableView uiItemCell     :(FxUiItemCell      *)uiCell;

+ (FxTextBlockTableViewCell *) _getReusableTextBlockCellForTableView:(UITableView *)tableView;
+ (FxTextFieldTableViewCell *) _getReusableTextFieldCellForTableView:(UITableView *)tableView;
+ (FxButtonTableViewCell    *) _getReusableButtonCellForTableView   :(UITableView *)tableView;
+ (FxItemTableViewCell      *) _getReusableItem1CellForTableView    :(UITableView *)tableView;
+ (FxItemTableViewCell      *) _getReusableItem2CellForTableView    :(UITableView *)tableView;

@end

@implementation FxTableViewController

static NSInteger _TEXT_BLOCK_HEIGHT_CHAMPION                  = 21; // Based onr 17px content font
static NSInteger _TEXT_BLOCK_CAPTION_TOP_CHAMPION             =  5;  // 12px font alligned with 17px font
static NSInteger _TEXT_BLOCK_CAPTION_WIDTH_CHAMPION           = 95;
static NSInteger _TEXT_BLOCK_CAPTION_HEIGHT_CHAMPION          = 15; // optimal for 12px
static NSInteger _TEXT_BLOCK_CAPTION_DELIMITER_WIDTH_CHAMPION =  4;
static NSInteger _TEXT_BLOCK_DELIMITER_HEIGHT_CHAMPION        =  2;

+ (UIColor *) _TEXT_BLOCK_CAPTION_TEXT_COLOR_CHAMPION
{
    return [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
}
+ (UIColor *) _TEXT_BLOCK_CONTENT_TEXT_COLOR_CHAMPION
{
    return [UIColor blackColor];
}

//UITableViewCellStyleSubtitle:
//
//textLabel: Helvetica Bold, size: labelFontSize+1 (18 px)
//detailsLabel: Helvetica, size: systemFontSize (14 px)
//
//UITableViewCellStyleValue1:
//
//textLabel: Helvetica Bold, size: labelFontSize (17 px)
//detailsLabel: Helvetica Bold, size: systemFontSize+1 (15 px)
//
//UITableViewCellStyleValue2:
//
//textLabel: Helvetica Bold, size: smallSystemFontSize (12 px)
//detailsLabel: Helvetica, size: labelFontSize (17 px)

+ (UIFont *) _TEXT_BLOCK_CAPTION_FONT
{
    return [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]]; // 12px
}
+ (UIFont *) _TEXT_BLOCK_CONTENT_FONT
{
    return [UIFont systemFontOfSize:[UIFont labelFontSize]]; // 17px
}

static NSInteger _BUTTON_HEIGHT_CHAMPION = 37;
static NSInteger _BUTTON_DELIMITER_HEIGHT_CHAMPION = 4;


@synthesize backTitle          = _backTitle;
@synthesize sections           = _sections;

- (id) firstResponderCell
{
    for (FxUiSection *section in self.sections)
    {
        for (FxUiCell *cell in section.cells)
        {
            if (cell.canBecomeFirstResponder)
            {
                return cell;
            }
        }
    }
    
    return nil;
}

- (FxUiSection *) _sectionForCell:(FxUiCell *)cell
{
    for (FxUiSection *section in self.sections)
    {
        for (FxUiCell *sectionCell in section.cells)
        {
            if (cell == sectionCell)
            {
                return section;
            }
        }
    }

    @throw [NSException exceptionWithName:@"Invalid cell" reason:nil userInfo:nil];
}
- (BOOL) _isLastSectionCell:(FxUiCell *)cell
{
    FxUiSection *section = [self _sectionForCell:cell];
    
    return cell == [section.cells lastObject];
}

- (id) init
{
    if (_isInitStarted_FxTableViewController)
    {
        return [super init];
    }
    else
    {
        return [self initWithStyle:UITableViewStyleGrouped];
    }
}
- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (_isInitStarted_FxTableViewController)
    {
        return [super initWithCoder:aDecoder];
    }
    else
    {
        @throw [NSException exceptionWithName:@"Init wit coder is not supported" reason:nil userInfo:nil];
    }
}
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (_isInitStarted_FxTableViewController)
    {
        return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    }
    else
    {
        @throw [NSException exceptionWithName:@"Init with nib name and bundle is not supported" reason:nil userInfo:nil];
    }
}
- (id) initWithStyle:(UITableViewStyle)style
{
    _isInitStarted_FxTableViewController = YES;

    self = [super initWithStyle:style];
    
    if (!self) @throw [NSException exceptionWithName:@"Init failed" reason:nil userInfo:nil];

    _sections                 = [[NSMutableArray alloc] init];
    _pageRefreshTriggers      = [[NSMutableArray alloc] init];
    _canAddPageRefreshTrigger = NO;
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavigationBar.png"]];

    return self;
}

- (void) refreshPage
{
    [self _refreshPage];
}
- (void) onPageRefresh { }

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    for (NSArray *trigger in _pageRefreshTriggers)
    {
        [FxAssert isValidState:[trigger count] == 2];
        
        NSObject *boundObject = [trigger objectAtIndex:0];
        NSString *propertyKey = [trigger objectAtIndex:1];
        
        [FxAssert isNotNullValue:boundObject];
        [FxAssert isNotNullValue:propertyKey];
        
        if ([keyPath isEqual:propertyKey])
        {
            [self _refreshPage];
        }
    }
    
    //[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self _refreshPage];

    if (self.backTitle != nil)
    {
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle: self.backTitle style: UIBarButtonItemStyleBordered target: nil action: nil] autorelease];
    }
    else
    {
        self.navigationItem.backBarButtonItem = nil;
    }
    
    [super viewWillAppear:animated];
}
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //self.title     = nil;
    //self.backTitle = nil;
    
    [self removeAllPageRefreshTriggers];
    [self removeAllSections           ];
    
}
- (void) viewDidUnload
{
    [super viewDidUnload];

    self.navigationItem.backBarButtonItem = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (FxUiSection *) sectionAtIndex:(NSInteger)index
{
    return [self.sections objectAtIndex:index];
}
- (FxUiSection *) addSection
{
    FxUiSection *section = [[[FxUiSection alloc] init] autorelease];
    
    [_sections addObject:section];
    
    return section;
}
- (FxUiSection *) addSectionWithCaption:(NSString *)caption
{
    FxUiSection *section = [[[FxUiSection alloc] initWithCaption:caption] autorelease];
    
    [_sections addObject:section];
    
    return section;
}
- (void) removeAllSections
{
    [_sections removeAllObjects];
}

- (void) addPageRefreshTriggerWithBoundObject:(NSObject *)boundObject propertyKey:(NSString *)propertyKey
{
    [FxAssert         isNotNullArgument:boundObject withName:@"boundObject"];
    [FxAssert isNotNullNorEmptyArgument:propertyKey withName:@"propertyKey"];
    
    [FxAssert isValidState:_canAddPageRefreshTrigger reason:@"Adding page refresh trigger is allowed in onPageRefresh method only."];
    
    NSArray *trigger = [NSArray arrayWithObjects:boundObject, propertyKey, nil];
    
    [_pageRefreshTriggers addObject:trigger];
}
- (void) removeAllPageRefreshTriggers
{
    [self _stopObservingPageRefreshTrggers];
    
    [_pageRefreshTriggers removeAllObjects];  
}

- (FxUiCell *) cellAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self sectionAtIndex:indexPath.section] cellAtIndex:indexPath.row];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self sectionAtIndex:section].caption;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self sectionAtIndex:section].cells.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self cellAtIndexPath:indexPath] class] == [FxUiTextBlockCell class] && ![self _isLastSectionCell:[self cellAtIndexPath:indexPath]])
    {
        return [self cellAtIndexPath:indexPath].height + _TEXT_BLOCK_DELIMITER_HEIGHT_CHAMPION;
    }
    else if ([[self cellAtIndexPath:indexPath] class] == [FxUiButtonCell class] && ![self _isLastSectionCell:[self cellAtIndexPath:indexPath]])
    {
        return [self cellAtIndexPath:indexPath].height + _BUTTON_DELIMITER_HEIGHT_CHAMPION;
    }
    else
    {
        return [self cellAtIndexPath:indexPath].height;
    }
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self _cellForTableView:tableView uiCell:[self cellAtIndexPath:indexPath]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self cellAtIndexPath:indexPath] didSelect];
}

- (void) pushViewController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void) flipViewController:(UIViewController *)viewController
{
    UINavigationController *navigationController = self.navigationController;
    [[self retain] autorelease];
    
    [UIView beginAnimations:nil context:nil];
    {
        [UIView setAnimationDuration: 0.50];
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:navigationController.view cache:YES];
        
        [navigationController setViewControllers:[NSArray arrayWithObject:viewController]];
    }
    [UIView commitAnimations];
}
- (void) showMadalViewController:(UIViewController *)viewController
{
    //    viewController.delegate = self;

    UINavigationController *hostController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    
    [self presentModalViewController:hostController animated:YES];
}
- (void) popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) dealloc
{
    [_backTitle           release];
    [_sections            release];
    [_pageRefreshTriggers release];
    
    [super dealloc];
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Page refresh triggers helpers
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (void) _refreshPage
{
    [self removeAllPageRefreshTriggers];
    [self removeAllSections           ];
    
    _canAddPageRefreshTrigger = YES;
    {
        [self onPageRefresh];
    }
    _canAddPageRefreshTrigger = NO;
    
    [self _startObservingPageRefreshTrggers];
    
    [self.tableView reloadData];
}

- (void) _startObservingPageRefreshTrggers
{
    for (NSArray *trigger in _pageRefreshTriggers)
    {
        [FxAssert isValidState:[trigger count] == 2];

        NSObject *boundObject = [trigger objectAtIndex:0];
        NSString *propertyKey = [trigger objectAtIndex:1];

        [FxAssert isNotNullValue:boundObject];
        [FxAssert isNotNullValue:propertyKey];

        [boundObject addObserver:self forKeyPath:propertyKey options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    }
}
- (void) _stopObservingPageRefreshTrggers
{
    for (NSArray *trigger in _pageRefreshTriggers)
    {
        [FxAssert isValidState:[trigger count] == 2];
        
        NSObject *boundObject = [trigger objectAtIndex:0];
        NSString *propertyKey = [trigger objectAtIndex:1];
        
        [FxAssert isNotNullValue:boundObject];
        [FxAssert isNotNullValue:propertyKey];
        
        [boundObject removeObserver:self forKeyPath:propertyKey];
    }
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Static helpers
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (UITableViewCell          *) _cellForTableView:(UITableView *)tableView uiCell         :(FxUiCell          *)uiCell
{
    if ([uiCell class] == [FxUiTextBlockCell class])
    {
        return [self _cellForTableView:tableView uiTextBlockCell:(FxUiTextBlockCell *)uiCell];
    }
    if ([uiCell class] == [FxUiTextFieldCell class])
    {
        return [self _cellForTableView:tableView uiTextFieldCell:(FxUiTextFieldCell *)uiCell];
    }
    if ([uiCell class] == [FxUiButtonCell class])
    {
        return [self _cellForTableView:tableView uiButtonCell:(FxUiButtonCell *)uiCell];
    }
    if ([uiCell class] == [FxUiItemCell class])
    {
        return [self _cellForTableView:tableView uiItemCell:(FxUiItemCell *)uiCell];
    }
    
    @throw [NSException exceptionWithName:@"Invalid cell class" reason:nil userInfo:nil];
}

- (FxTextBlockTableViewCell *) _cellForTableView:(UITableView *)tableView uiTextBlockCell:(FxUiTextBlockCell *)uiCell
{
    FxTextBlockTableViewCell *tableViewCell = [FxTableViewController _getReusableTextBlockCellForTableView:tableView];
    {
        tableViewCell.captionLabel.text = [FxStringTools joinValues:[NSArray arrayWithObjects:uiCell.caption, @":", nil]];
        
        [tableViewCell bindToBoundObject:uiCell.boundObject withPropertyKey:uiCell.propertyKey displayPropertyKey:uiCell.displayPropertyKey];
    }
    
    return tableViewCell;
}
- (FxTextFieldTableViewCell *) _cellForTableView:(UITableView *)tableView uiTextFieldCell:(FxUiTextFieldCell *)uiCell
{
    FxTextFieldTableViewCell *tableViewCell = [FxTableViewController _getReusableTextFieldCellForTableView:tableView];
    {
        tableViewCell.textField.placeholder     = uiCell.placeHolder;
        tableViewCell.textField.text            = [uiCell.boundObject valueForKey:uiCell.propertyKey];

        tableViewCell.textField.secureTextEntry = uiCell.isPassword;
        
        if (uiCell.isEmail)
        {
            tableViewCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            tableViewCell.textField.autocorrectionType     = UITextAutocorrectionTypeNo;
            tableViewCell.textField.keyboardType           = UIKeyboardTypeEmailAddress;
        }
        else
        {
            tableViewCell.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            tableViewCell.textField.autocorrectionType     = UITextAutocorrectionTypeDefault;
            tableViewCell.textField.keyboardType           = UIKeyboardTypeDefault;
        }

        if (uiCell == self.firstResponderCell)
        {
            [tableViewCell.textField becomeFirstResponder];
        }

        [tableViewCell bindToTarget:uiCell action:@selector(_textFieldValueChanged:)];
    }
    
    return tableViewCell;
}
- (FxButtonTableViewCell    *) _cellForTableView:(UITableView *)tableView uiButtonCell   :(FxUiButtonCell    *)uiCell
{
    FxButtonTableViewCell *tableViewCell = [FxTableViewController _getReusableButtonCellForTableView:tableView];
    {
        [tableViewCell.button setTitle :uiCell.caption      forState:UIControlStateNormal];

        [tableViewCell bindToTarget:uiCell.targetObject action:uiCell.action];
    }
    
    return tableViewCell;
}
- (FxItemTableViewCell      *) _cellForTableView:(UITableView *)tableView uiItemCell     :(FxUiItemCell      *)uiCell
{
    if (uiCell.styleCode == 1)
    {
        FxItemTableViewCell *tableViewCell = [FxTableViewController _getReusableItem1CellForTableView:tableView];
        {
            [tableViewCell bindToCaptionBoundObject:uiCell.captionBoundObject withCaptionPropertyKey:uiCell.captionPropertyKey toContentBoundObject:uiCell.contentBoundObject withContentPropertyKey:uiCell.contentPropertyKey];
            
            tableViewCell.accessoryType = uiCell.accesoryType;
        }
        
        return tableViewCell;
    }
    if (uiCell.styleCode == 2)
    {
        FxItemTableViewCell *tableViewCell = [FxTableViewController _getReusableItem2CellForTableView:tableView];
        {
            [tableViewCell bindToCaptionBoundObject:uiCell.captionBoundObject withCaptionPropertyKey:uiCell.captionPropertyKey toContentBoundObject:uiCell.contentBoundObject withContentPropertyKey:uiCell.contentPropertyKey];

            tableViewCell.accessoryType = uiCell.accesoryType;
        }
        
        return tableViewCell;
    }
    
    @throw [FxException invalidStateExceptionWithReason:@"Invalid item style code"];
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Static helpers
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

static NSString *_TEXT_BLOCK_CELL_IDENTIFIER = @"Fx-TextBlockCell";
static NSString *_TEXT_FIELD_CELL_IDENTIFIER = @"Fx-TextFieldCell";
static NSString *_BUTTON_CELL_IDENTIFIER     = @"Fx-ButtonCell";
static NSString *_ITEM_1_CELL_IDENTIFIER     = @"Fx-Item1Cell";
static NSString *_ITEM_2_CELL_IDENTIFIER     = @"Fx-Item2Cell";

+ (FxTextBlockTableViewCell *) _getReusableTextBlockCellForTableView:(UITableView *)tableView
{
    FxTextBlockTableViewCell *cell = (FxTextBlockTableViewCell *)[tableView dequeueReusableCellWithIdentifier:_TEXT_BLOCK_CELL_IDENTIFIER];
    
    if (cell == nil)
    {
        cell = [[[FxTextBlockTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_TEXT_BLOCK_CELL_IDENTIFIER] autorelease];
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundView = [[[UIView alloc] initWithFrame: CGRectZero] autorelease];
        }

        cell.captionLabel = [[[UILabel alloc] init] autorelease];
        {
            cell.captionLabel.autoresizingMask = UIViewAutoresizingNone;
            cell.captionLabel.backgroundColor  = [UIColor clearColor];
            cell.captionLabel.textAlignment    = UITextAlignmentRight;
            cell.captionLabel.frame            = CGRectMake(0, _TEXT_BLOCK_CAPTION_TOP_CHAMPION, _TEXT_BLOCK_CAPTION_WIDTH_CHAMPION, _TEXT_BLOCK_CAPTION_HEIGHT_CHAMPION);
            cell.captionLabel.textColor        = [FxTableViewController _TEXT_BLOCK_CAPTION_TEXT_COLOR_CHAMPION];
            cell.captionLabel.font             = [FxTableViewController _TEXT_BLOCK_CAPTION_FONT];
        }
        cell.contentLabel = [[[UILabel alloc] init] autorelease];
        {
            cell.contentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            cell.contentLabel.backgroundColor  = [UIColor clearColor];
            cell.contentLabel.frame            = CGRectMake(_TEXT_BLOCK_CAPTION_WIDTH_CHAMPION + _TEXT_BLOCK_CAPTION_DELIMITER_WIDTH_CHAMPION, 0, CGRectGetWidth(cell.contentView.bounds) - _TEXT_BLOCK_CAPTION_WIDTH_CHAMPION - _TEXT_BLOCK_CAPTION_DELIMITER_WIDTH_CHAMPION, _TEXT_BLOCK_HEIGHT_CHAMPION);
            cell.contentLabel.textColor        = [FxTableViewController _TEXT_BLOCK_CONTENT_TEXT_COLOR_CHAMPION];
            cell.contentLabel.font             = [FxTableViewController _TEXT_BLOCK_CONTENT_FONT];
        }
        
        [cell.contentView addSubview:cell.captionLabel];
        [cell.contentView addSubview:cell.contentLabel];
    }
    
    return cell;
}
+ (FxTextFieldTableViewCell *) _getReusableTextFieldCellForTableView:(UITableView *)tableView
{
    FxTextFieldTableViewCell *cell = (FxTextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:_TEXT_FIELD_CELL_IDENTIFIER];
    
    if (cell == nil)
    {
        cell = [[[FxTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_TEXT_FIELD_CELL_IDENTIFIER] autorelease];
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textField = [[[UITextField alloc] init] autorelease];
        {
            cell.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;

            NSInteger padding = 11;
            cell.textField.frame = CGRectMake(padding, padding, CGRectGetWidth(cell.contentView.bounds) - (2 * padding), CGRectGetHeight(cell.contentView.bounds) - (2 * padding));
        }

        [cell.contentView addSubview:cell.textField];
    }
    
    return cell;
}
+ (FxButtonTableViewCell    *) _getReusableButtonCellForTableView   :(UITableView *)tableView
{
    FxButtonTableViewCell *cell = (FxButtonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:_BUTTON_CELL_IDENTIFIER];
    
    if (cell == nil)
    {
        cell = [[[FxButtonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_BUTTON_CELL_IDENTIFIER] autorelease];
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundView = [[[UIView alloc] initWithFrame: CGRectZero] autorelease];
            //[cell.backgroundView setNeedsDisplay];
        }
        
        cell.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        {
            cell.button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            cell.button.frame = CGRectMake(0, 0, cell.contentView.bounds.size.width, _BUTTON_HEIGHT_CHAMPION);

//            NSInteger verticalPadding = 2;
//            cell.button.frame = CGRectMake(0, verticalPadding, CGRectGetWidth(cell.contentView.bounds), CGRectGetHeight(cell.contentView.bounds) - (2 * verticalPadding));
        }

        [cell.contentView addSubview:cell.button];
    }
    
    return cell;
}
+ (FxItemTableViewCell      *) _getReusableItem1CellForTableView     :(UITableView *)tableView
{
    FxItemTableViewCell *cell = (FxItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:_ITEM_1_CELL_IDENTIFIER];
    
    if (cell == nil)
    {
        cell = [[[FxItemTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:_ITEM_1_CELL_IDENTIFIER] autorelease];
        {
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}
+ (FxItemTableViewCell      *) _getReusableItem2CellForTableView     :(UITableView *)tableView
{
    FxItemTableViewCell *cell = (FxItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:_ITEM_2_CELL_IDENTIFIER];
    
    if (cell == nil)
    {
        cell = [[[FxItemTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:_ITEM_2_CELL_IDENTIFIER] autorelease];
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    return cell;
}

@end

//UISwitch *switchObj = [[[UISwitch alloc] initWithFrame:CGRectMake(1.0, 1.0, 20.0, 20.0)] autorelease];
//{
//    switchObj.on = YES;
//    [switchObj addTarget:self action:@selector(toggleSoundEffects:) forControlEvents:(UIControlEventValueChanged | UIControlEventTouchDragInside)];
//}
