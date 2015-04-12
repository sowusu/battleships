//
//  shipView.h
//  battle
//
//  Created by Nana Kwame Owusu on 3/27/15.
//  Copyright (c) 2015 Nana Kwame Owusu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardCell.h"

@interface shipView : UIView{
    
}

-(void)clearPositions;

-(void)loadPositions:(int)s_idx;

-(void)setStartIdx:(int)a_start_idx;

-(int)getStartIdx;


-(bool)canPlaceShip:(shipView*)the_ship atStart:(int)start;

-(void)setSize:(int)a_size;

-(int)getSize;

-(void)colorPositions:(UIColor *)color;

-(void)setOnDefense:(bool) def_state;
-(bool)isOnDefense;

-(void)setHoriz:(bool) horiz_state;

-(bool)isHoriz;

-(void)setID:(int)an_id;
-(int)getID;
-(void)toggleEnabled;
-(bool)isEnabled;
-(void)setX:(CGFloat) x_val withY:(CGFloat) y_val;
-(void)allocate_locs;

@property UIView* main_view;
@property UIView* defense_board;
@property NSInteger* defenseCellSide;
@property NSMutableArray* defenseCells;
@property CGPoint* init_loc;//within ship_dock

@property NSInteger* cells_on_side;

@end
