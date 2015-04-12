//
//  BoardCell.h
//  battle
//
//  Created by Nana Kwame Owusu on 3/27/15.
//  Copyright (c) 2015 Nana Kwame Owusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardCell : UIView

@property (nonatomic, strong) UILabel* mark;
-(void)setAttack:(bool)attCond;
-(bool)getAtt;
-(void)setID:(int)an_id;
-(int)getID;
-(void)toggleEnabled;
-(bool)isEnabled;
-(void)setOccupied:(bool)occCond;

-(void)setShipID:(int)an_id;

-(int)getShipID;

-(bool)getOccupied;

-(void)markX;

-(void)markO;

-(void)toggleAttacked;

-(bool)isAttacked;

@end
