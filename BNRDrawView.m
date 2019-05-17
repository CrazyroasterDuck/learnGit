//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by sharen on 2019/5/10.
//  Copyright © 2019年 QingShuXueTang. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"

@interface BNRDrawView()<UIGestureRecognizerDelegate>
@property (nonatomic,strong)NSMutableDictionary *linesInProgress;
@property (nonatomic,strong)NSMutableArray *finishedLines;
@property (nonatomic,strong) UIPanGestureRecognizer* moveRecognizer;
@property (nonatomic,weak)BNRLine *selectedLine;
@end

@implementation BNRDrawView

- (instancetype) initWithFrame:(CGRect)r
{
    self=[super initWithFrame:r];
    if(self){
        self.linesInProgress=[[NSMutableDictionary alloc] init];
        self.finishedLines=[[NSMutableArray alloc]init];
        self.backgroundColor=[UIColor grayColor];
        self.multipleTouchEnabled=YES;//可以识别出多手势
        //识别双击手势
        UITapGestureRecognizer *doubleTapRecognizer=
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired=2;
        doubleTapRecognizer.delaysTouchesBegan=YES;
        [self addGestureRecognizer:doubleTapRecognizer];
        //识别单击手势
        UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tapRecognizer.delaysTouchesBegan=YES;
        [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        [self addGestureRecognizer:tapRecognizer];
        //识别出长按手势
        UILongPressGestureRecognizer *pressRecognizer=
        [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:pressRecognizer];
        //识别出拖动手势
        self.moveRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveLine:)];
        self.moveRecognizer.delegate=self;
        self.moveRecognizer.cancelsTouchesInView=NO;
        [self addGestureRecognizer:_moveRecognizer];
    }
    return self;
}
-(void)strokeLine:(BNRLine*)line
{
    UIBezierPath *bp=[UIBezierPath bezierPath];
    bp.lineWidth=10;
    bp.lineCapStyle=kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
    
}

-(void)drawRect:(CGRect)rect
{
    [[UIColor blackColor] set];//黑色表示已经完成的线条
    for(BNRLine* line in self.finishedLines){
        [self strokeLine:line];
    }
    
    
    //用红色表示正在绘制的线条
    [[UIColor redColor]set];
    for(NSValue *key in self.linesInProgress){
        [self strokeLine:self.linesInProgress[key]];
    }
    
    //用绿色绘制选中的线条
    if(self.selectedLine){
        [[UIColor greenColor]set];
        [self strokeLine:self.selectedLine];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    for(UITouch *t in touches){
        CGPoint location=[t locationInView:self];
        BNRLine  *line=[[BNRLine alloc]init];
        line.begin=location;
        line.end=location;
        NSValue *key=[NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key]=line;
    }
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    for(UITouch *t in touches){
        NSValue *key=[NSValue valueWithNonretainedObject:t];
        BNRLine *line=self.linesInProgress[key];
        line.end=[t locationInView:self];
    }
    [self setNeedsDisplay];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
     NSLog(@"%@",NSStringFromSelector(_cmd));
    for(UITouch *t in touches){
        NSValue *key=[NSValue valueWithNonretainedObject:t];
        BNRLine *line=self.linesInProgress[key];
        
        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}
//双击删除所有的线段
- (void)doubleTap:(UITapGestureRecognizer*)gr
{
    NSLog(@"Recognized Double Tap");
    
    [self.linesInProgress removeAllObjects];
    [self.finishedLines removeAllObjects];
    [self setNeedsDisplay];
}
//单击手势你对应的动作
- (void)tap:(UIGestureRecognizer*)gr
{
    NSLog(@"Recognized tap");
    CGPoint point=[gr locationInView:self];
    self.selectedLine=[self lineAtPoint:point];
    
    if(self.selectedLine){
        [self becomeFirstResponder];//是视图成为UIMenuItem动作的目标
        UIMenuController *menu=[UIMenuController sharedMenuController];
        
        UIMenuItem *deleteItem=[[UIMenuItem alloc]initWithTitle:@"Delete" action:@selector(deleteLine:)];
        menu.menuItems=@[deleteItem];
        
        [menu setTargetRect:CGRectMake(point.x,point.y, 2, 3) inView:self];
        [menu setMenuVisible:YES animated:YES];
    }else{
        [[UIMenuController sharedMenuController]setMenuVisible:NO animated:YES];
    }
    [self setNeedsDisplay];
}

//根据传入的位置选中距离最近的BNRline对象
-(BNRLine*)lineAtPoint:(CGPoint)p
{
    //找出离p最近的BNRLINE对象
    for(BNRLine *l in self.finishedLines){
        CGPoint start=l.begin;
        CGPoint end=l.end;
        
        //检查线条的若干点
        for(float t=0.0;t<=1.0;t+=0.05){
            float x=start.x+t*(end.x-start.x);
            float y=start.y+t*(end.y-start.y);
            
            if(hypot(x-p.x, y-p.y)<20.0){
                return l;
            }
        }
    }
    return nil;
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void) deleteLine:(id)sender
{
    //从已经完成的线条中删除选中的线条
    [self.finishedLines removeObject:self.selectedLine];
    [self setNeedsDisplay];
    
}

-(void)longPress:(UIGestureRecognizer*)gr
{
    if(gr.state==UIGestureRecognizerStateBegan){
        CGPoint point=[gr locationInView:self];
        self.selectedLine=[self lineAtPoint:point];
        if(self.selectedLine){
            [self.linesInProgress removeAllObjects];
        }
    }else if(gr.state==UIGestureRecognizerStateEnded){
        self.selectedLine=nil;
    }
    [self setNeedsDisplay];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(gestureRecognizer==self.moveRecognizer){
        return YES;
    }
    return NO;
}

-(void)moveLine:(UIPanGestureRecognizer*)gr
{
    if(!self.selectedLine) return;
    if(gr.state==UIGestureRecognizerStateChanged){
        CGPoint translation=[gr translationInView:self];//获取手指的拖移距离
        
        CGPoint begin=self.selectedLine.begin;
        CGPoint end=self.selectedLine.end;
        begin.x+=translation.x;
        begin.y+=translation.y;
        end.x+=translation.x;
        end.y+=translation.y;
        
        self.selectedLine.begin=begin;
        self.selectedLine.end=end;
        
        [self setNeedsDisplay];
        [gr setTranslation:CGPointZero inView:self];
    }
}
@end
