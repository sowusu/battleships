//
//  BoardCell.m
//  battle
//
//  Created by Nana Kwame Owusu on 3/27/15.
//  Copyright (c) 2015 Nana Kwame Owusu. All rights reserved.
//

#import "BoardCell.h"

@implementation BoardCell{
    bool enabled;
    int cellId;
    bool isAttack;
    bool isOccupied;
    int shipID;
    bool has_been_attacked;
    
}


@synthesize mark;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)setOccupied:(bool)occCond{
    isOccupied = occCond;
}

-(bool)getOccupied{
    return isOccupied;
}

-(void)setAttack:(bool)attCond{
    isAttack = attCond;
}

-(bool)getAtt{
    return isAttack;
}

-(void)setID:(int)an_id{
    cellId = an_id;
}

-(int)getID{
    return cellId;
}

-(void)setShipID:(int)an_id{
    shipID = an_id;
}

-(int)getShipID{
    return shipID;
}

-(void)toggleEnabled{
    enabled = !enabled;
}

-(bool)isEnabled{
    return enabled;
}

-(void)toggleAttacked{
    has_been_attacked = !has_been_attacked;
}

-(bool)isAttacked{
    return has_been_attacked;
}

-(void)markX{
    [mark setTextColor:[UIColor blackColor]];
    if (!isAttack){
       [mark setTextColor:[UIColor whiteColor]];
    }
    [mark setText:@" X"];
    [mark setFont:[UIFont fontWithName:@"Trebuchet MS" size:38]];
}

-(void)markO{
    [mark setTextColor:[UIColor blackColor]];
    if (!isAttack){
        [mark setTextColor:[UIColor whiteColor]];
    }
    [mark setText:@" O"];
    [mark setFont:[UIFont fontWithName:@"Trebuchet MS" size:38]];
}


-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame: frame]){
        enabled = YES;
        shipID = -1;//no ship
        has_been_attacked = NO;
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 2.0f;
        self.backgroundColor = [UIColor whiteColor];
        isOccupied = NO;
        CGRect labelFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        mark = [[UILabel alloc]initWithFrame:labelFrame];
        //mark.backgroundColor = [UIColor yellowColor];
        [mark setTextColor:[UIColor blackColor]];
        [mark setText:@" "];
        [mark setFont:[UIFont fontWithName:@"Trebuchet MS" size:38]];
        [self addSubview:mark];
        
        return self;
    }
    return nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (enabled){
        //self.backgroundColor = [UIColor yellowColor];
        [self toggleEnabled];
        //NSLog(@"%d", [self getID]);
    }
    
    
}


@end
