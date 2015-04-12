//
//  optionsController.h
//  battle
//
//  Created by Nana Kwame Owusu on 3/28/15.
//  Copyright (c) 2015 Nana Kwame Owusu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface optionsController : UIViewController{
    IBOutlet UISegmentedControl *game_choice;
    
}

@property (nonatomic, strong) NSMutableArray* p1_attackCells;
@property (nonatomic, strong) NSMutableArray* p1_defenseCells;
@property (nonatomic, strong) NSMutableArray* p2_attackCells;
@property (nonatomic, strong) NSMutableArray* p2_defenseCells;
@property (nonatomic, strong) NSMutableArray* p1_ship_sizes;
@property (nonatomic, strong) NSMutableArray* p2_ship_sizes;
@property (nonatomic, strong) NSString* player1;
@property (nonatomic, strong) NSString* player2;

@property (nonatomic, strong) NSMutableArray* computer_hits;


@end
