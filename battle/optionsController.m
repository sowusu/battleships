//
//  optionsController.m
//  battle
//
//  Created by Nana Kwame Owusu on 3/28/15.
//  Copyright (c) 2015 Nana Kwame Owusu. All rights reserved.
//

#import "optionsController.h"
#import "transitionsView.h"

@interface optionsController ()

@end

@implementation optionsController

@synthesize p1_defenseCells;
@synthesize p1_attackCells;
@synthesize p2_attackCells;
@synthesize p2_defenseCells;
@synthesize p1_ship_sizes;
@synthesize p2_ship_sizes;
@synthesize player1;
@synthesize player2;
@synthesize computer_hits;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    transitionsView* trans_controller = [segue destinationViewController];
    bool report;
    
    if (game_choice.selectedSegmentIndex == 0){
        report = YES;
    }
    else{
        report = NO;
    }
    
    p1_attackCells = [[NSMutableArray alloc] init];
    p1_defenseCells = [[NSMutableArray alloc] init];
    p2_attackCells = [[NSMutableArray alloc] init];
    p2_defenseCells = [[NSMutableArray alloc] init];
    p1_ship_sizes   = [[NSMutableArray alloc]init];
    p2_ship_sizes   = [[NSMutableArray alloc]init];
    computer_hits = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 5; i++){
        [computer_hits addObject:[[NSMutableArray alloc]init]];
    }
    
    player1 = @"Player 1";
    player2 = @"Player 2";
    
    [trans_controller setP1_attackCells:p1_attackCells];
    [trans_controller setP1_defenseCells:p1_defenseCells];
    [trans_controller setP2_attackCells:p2_attackCells];
    [trans_controller setP2_defenseCells:p2_defenseCells];
    [trans_controller setP1_ship_sizes:p1_ship_sizes];
    [trans_controller setP2_ship_sizes:p2_ship_sizes];
    
    
    [trans_controller setComputer_hits:computer_hits];
    [trans_controller setPlayer1:player1];
    [trans_controller setPlayer2:player2];
    
    
    [trans_controller setGameType:report];
    bool turn = NO;
    //randomize starter
    int choice = arc4random() % 2;
    
    if (choice == 0){
        turn = YES;
    }
    
    
    
    [trans_controller setTurn:NO];
    [trans_controller set_isInitForP1:YES ForP2:YES];
}


@end
