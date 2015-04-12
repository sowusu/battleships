//
//  shipView.m
//  battle
//
//  Created by Nana Kwame Owusu on 3/27/15.
//  Copyright (c) 2015 Nana Kwame Owusu. All rights reserved.
//

#import "shipView.h"

@implementation shipView{
    bool enabled;
    bool horiz;
    bool onDefense;
    int shipId;
    int size;
    int start_idx;
    CGFloat init_x;
    CGFloat init_y;
    NSMutableArray* locs;
    
    
}

@synthesize main_view;
@synthesize defense_board;
@synthesize defenseCellSide;
@synthesize defenseCells;

@synthesize cells_on_side;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setSize:(int)a_size{
    size = a_size;
}

-(int)getSize{
    return size;
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        
        
        NSLog(@"init was called");
        self.backgroundColor = [UIColor blackColor];
        return self;
        
    }
    
    return nil;
    
}

-(void)colorPositions:(UIColor *)color{
    
    if ([self isOnDefense]){
        int ctr = [locs count];
        while( ctr > 0){
            
            BoardCell* toColor = [defenseCells objectAtIndex:[[locs objectAtIndex:ctr - 1] intValue]];
            toColor.backgroundColor = color;
            ctr--;
        }
    }
}

-(void)setStartIdx:(int)a_start_idx{
    start_idx   = a_start_idx;
}

-(int)getStartIdx{
    return start_idx;
}

-(void)allocate_locs{
    locs = [[NSMutableArray alloc]init];
}

-(void)setOnDefense:(bool) def_state{
    onDefense = def_state;
}

-(bool)isOnDefense{
    return onDefense;
}

-(void)setHoriz:(bool) horiz_state{
    horiz = horiz_state;
}

-(bool)isHoriz{
    return horiz;
}

-(void)setX:(CGFloat) x_val withY:(CGFloat) y_val{
    init_x = x_val;
    init_y = y_val;
    
}

-(void)setID:(int)an_id{
    shipId = an_id;
}

-(int)getID{
    return shipId;
}

-(void)toggleEnabled{
    enabled = !enabled;
}

-(bool)isEnabled{
    return enabled;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([self isUserInteractionEnabled]){//placed in defense board
        
        NSLog(@"Ship %d was touched!", shipId);
        
       
        
    }
    else{
        NSLog(@"user interaction disabled");
    }
    
}

-(void)loadPositions:(int)s_idx{
    
    //find and add occupied positions
    int next_add;
    if ([self isHoriz]){
        next_add = 1;
    }
    else{
        next_add = 10;
    }
    int added = 0;
    int ship_idx = s_idx;
    while (added < size){
        NSLog(@"setting pos: %d", ship_idx);
        [locs addObject:[NSNumber numberWithInt:ship_idx]];
        
        BoardCell* toAdd = [defenseCells objectAtIndex:ship_idx];
        [toAdd setOccupied:YES];
        
        [toAdd setShipID:shipId];
        NSLog(@"just set ship id: %d", [toAdd getShipID]);
        toAdd.backgroundColor  = [UIColor yellowColor];
        added++;
        ship_idx += next_add;
    }
    
    
}

-(void)clearPositions{
    while([locs count] > 0){
        int cur_size  = [locs count];
        BoardCell* toRemove = [defenseCells objectAtIndex:[[locs objectAtIndex:cur_size - 1] intValue]];
        [toRemove setOccupied:NO];
        [toRemove setShipID:-1];
        toRemove.backgroundColor = [UIColor whiteColor];
        [locs removeLastObject];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([self isOnDefense]){//has already been placed on defense board
        [self clearPositions];
    }
    //NSLog(@"unset");
    [self setOnDefense:NO];
    
    
    UITouch* atouch = [touches anyObject];
    CGPoint currentloc = [atouch locationInView:[self main_view]];
    CGPoint prevloc = [atouch previousLocationInView:[self main_view]];
    CGRect newframe = self.frame;
    newframe.origin.x += currentloc.x - prevloc.x;
    newframe.origin.y += currentloc.y - prevloc.y;
    
    [self setFrame:newframe];
}

-(int)sizeforID:(int)some_ID{
    switch (some_ID){
        case 0:
            return 5;
        case 1:
            return 4;
        case 2:
            return 3;
        case 3:
            return 3;
        case 4:
            return 2;
            
            
    }
    
    return -1;
}

-(bool)canPlaceShip:(shipView*)the_ship atStart:(int)start{
    NSLog(@"in ship method of canPlace ship");
    int next_val = 10;
    int ship_size = [self sizeforID:[the_ship getID]];
    NSLog(@"using size %d", ship_size);
    if([the_ship isHoriz]){
        next_val = 1;
    }
    int cell_loc = start;
    int ctr = 0;
    int cur_row = start / 10;
    while (ctr < ship_size){
        NSLog(@"checking location idx: %d for current ctr: %d", cell_loc, ctr);
        //check if index is on board
        if (cell_loc >= 100){//vertical check
            NSLog(@"out of bounds/vertical check");
            return NO;
        }
        else{
            NSLog(@"out of bounds passed!");
        }
        
        if ( next_val == 1){//horizontal check
            NSLog(@"doing horizontal check");
            if ( (cell_loc / 10) != cur_row){
                NSLog(@"failed horizontal");
                return NO;
            }
            
            
        }
        else{
            NSLog(@"horizontal passed!");
        }
        
        if ([[defenseCells objectAtIndex:cell_loc] getOccupied]){
            return NO;
        }
        else{
            NSLog(@"occupied passed!");
        }
        ctr++;
        cell_loc += next_val;
    }
    
    
    return YES;
}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
        UITouch* atouch = [touches anyObject];
        CGPoint endpnt = [atouch locationInView:[self main_view]];
        
        UIView* tobeplaced = self;
        CGPoint offset = [atouch locationInView:tobeplaced];
        CGPoint target_pnt = CGPointMake(endpnt.x - offset.x, endpnt.y - offset.y);//corner position of ship to be placed/being moved
        
        CGRect orig = [defense_board frame];
        //set frame of cells where ship can be placed on board
        //NSLog(@"passed d cellside: %d", *defenseCellSide);
    
        CGRect destframe = CGRectMake(orig.origin.x + *defenseCellSide, orig.origin.y + *defenseCellSide, orig.size.width - *defenseCellSide, orig.size.height - *defenseCellSide);
        if (CGRectContainsPoint(destframe, target_pnt)){//check if top-left corner of ship falls within playable part of defense board
            
            float deltaX = (target_pnt.x - defense_board.frame.origin.x);
            float deltaY = (target_pnt.y - defense_board.frame.origin.y);
            int snap_dest_col = ((int) deltaX)/ *defenseCellSide;
            int snap_dest_row = ((int)deltaY)/ *defenseCellSide;
            
            start_idx = ((snap_dest_row - 1)*(*cells_on_side - 1) + (snap_dest_col - 1));
            //NSLog(@"index: %d", start_idx);
            
            if ([self canPlaceShip:self atStart:start_idx]){//
                BoardCell* target_view = [defenseCells objectAtIndex:start_idx];
                //NSLog(@"target id: %d", [target_view getID]);
                
                //target_view.backgroundColor = [UIColor blackColor];
                
                
                
                CGRect new_tobeplaced_frame = tobeplaced.frame;
                new_tobeplaced_frame.origin.x = target_view.frame.origin.x;
                new_tobeplaced_frame.origin.y = target_view.frame.origin.y;
                [tobeplaced setFrame:new_tobeplaced_frame];
                
                [defense_board addSubview:tobeplaced];
                [self setOnDefense:YES];
                [self setX:tobeplaced.frame.origin.x withY:tobeplaced.frame.origin.y];
                NSLog(@"set");
                [self loadPositions:start_idx];
            }
            else{
                //snap ship back
                CGRect newframe = self.frame;
                
                newframe.origin = CGPointMake(init_x, init_y);
                //NSLog(@"correctly passed");
                //NSLog(@"setting frame: %f, %f", init_x, init_y);
                
                //NSLog(@"setting frame: %f, %f", newframe.origin.x, newframe.origin.y);
                
                [tobeplaced setFrame:newframe];
            }
            
            
            
            
        }
        else{
            //snap ship back
            CGRect newframe = self.frame;
            
            newframe.origin = CGPointMake(init_x, init_y);
            //NSLog(@"correctly passed");
            //NSLog(@"setting frame: %f, %f", init_x, init_y);
            
            //NSLog(@"setting frame: %f, %f", newframe.origin.x, newframe.origin.y);
            
            [tobeplaced setFrame:newframe];
            
        }
    
    
    
    
}


@end
