//
//  ViewController.m
//  battle
//
//  Created by Nana Kwame Owusu on 3/27/15.
//  Copyright (c) 2015 Nana Kwame Owusu. All rights reserved.
//
//another change here

#import "ViewController.h"
#import "transitionsView.h"
#import "optionsController.h"



@implementation ViewController


@synthesize attack_board;

@synthesize defense_board;

@synthesize p1_defenseCells;
@synthesize p1_attackCells;
@synthesize p2_attackCells;
@synthesize p2_defenseCells;
@synthesize p1_ship_sizes;
@synthesize p2_ship_sizes;
@synthesize nextViewbutton;
@synthesize currentPlayer;

@synthesize player1;
@synthesize player2;

@synthesize computer_hits;
@synthesize ship_dock;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //create and position board
    
    //board* myBoard = [[board alloc] initWithFrame:CGRectMake(100, 100, board_size, board_size)];
    
    //CGRect frame = CGRectMake(100, 300, 40, 40);
    //BoardCell* myCell = [[BoardCell alloc]initWithFrame:frame];
   
    
    NSString *sink_path = [NSString stringWithFormat:@"%@/sink.wav", [[NSBundle mainBundle] resourcePath]];
    NSURL *sinkUrl = [NSURL fileURLWithPath:sink_path];
    NSString *win_path = [NSString stringWithFormat:@"%@/win.wav", [[NSBundle mainBundle] resourcePath]];
    NSURL *winUrl = [NSURL fileURLWithPath:win_path];
    
    NSError* error_win;
    NSError* error_sink;
    // Create audio player object and initialize with URL to sound
    sink_sound = [[AVAudioPlayer alloc] initWithContentsOfURL:sinkUrl error:&error_sink];
    
    if (sink_sound == nil){
        NSLog(@"%@", error_sink.localizedFailureReason);
    }
    
    win_sound = [[AVAudioPlayer alloc] initWithContentsOfURL:winUrl error:&error_win];
    if (win_sound == nil){
        NSLog(@"%@", error_win.localizedFailureReason);
    }
    
    [sink_sound setVolume:0.5];
    [win_sound setVolume:0.5];
    if ([sink_sound prepareToPlay]){
        NSLog(@"sink is ready");
    }
    else{
        NSLog(@"prep failed");
    }
    if ([win_sound prepareToPlay]){
        NSLog(@"win is ready");
    }
    else{
        NSLog(@"prep failed");
    }
    
    if (isSinglePlayer) {//if single player it is always player 1's turn
        player_turn = YES;
    }
    
    cells_on_side = 11;
    attackCellSide = attack_board.bounds.size.width/cells_on_side;
    defenseCellSide = defense_board.bounds.size.width/cells_on_side;
    NSLog(@"%f", attack_board.bounds.size.width);
    NSLog(@"%d", cells_on_side);
    if (player_turn){
        
        currentPlayer.text = [NSString stringWithFormat:@"%@'s turn", player1];
        if (is_init_turn_1){
            
            if (isSinglePlayer){
                ////////    computer initialize     ///////
                [self computer_init_turn];
                
                //////
            }
            
            
            
            p1_ships = [[NSMutableArray alloc]init];
            //add ships to array
            
            CGRect scaff = CGRectMake(18, 18, 200, 40);
            shipView* five   = [[shipView alloc]initWithFrame:scaff];
            //[five setID:0];
            [ship_dock addSubview:five];
            [p1_ships addObject:five];
            [p1_ship_sizes addObject:[NSNumber numberWithInt:5]];
            
            scaff.origin.y = 88;
            scaff.size.width = 160;
            shipView* four   = [[shipView alloc]initWithFrame:scaff];
            //[four setID:1];
            [ship_dock addSubview:four];
            [p1_ships addObject:four];
            [p1_ship_sizes addObject:[NSNumber numberWithInt:4]];
            
            scaff.origin.y = 158;
            scaff.size.width = 120;
            shipView* three_1   = [[shipView alloc]initWithFrame:scaff];
            //[three_1 setID:2];
            [ship_dock addSubview:three_1];
            [p1_ships addObject:three_1];
            [p1_ship_sizes addObject:[NSNumber numberWithInt:3]];
            
            scaff.origin.y = 228;
            scaff.size.width = 120;
            shipView* three_2   = [[shipView alloc]initWithFrame:scaff];
            //[three_2 setID:3];
            [ship_dock addSubview:three_2];
            [p1_ships addObject:three_2];
            [p1_ship_sizes addObject:[NSNumber numberWithInt:3]];
            
            scaff.origin.y = 298;
            scaff.size.width = 80;
            shipView* two   = [[shipView alloc]initWithFrame:scaff];
            //[two setID:4];
            [ship_dock addSubview:two];
            [p1_ships addObject:two];
            [p1_ship_sizes addObject:[NSNumber numberWithInt:2]];
            
            attackCellSide = attack_board.bounds.size.width/cells_on_side;
            defenseCellSide = defense_board.bounds.size.width/cells_on_side;
            
            
            /*five_init_loc = five.frame.origin;//within ship_dock
             four_init_loc = four.frame.origin;//within ship_dock
             three_1_init_loc = three_1.frame.origin;
             three_2_init_loc = three_2.frame.origin;
             two_init_loc = two.frame.origin;
             */
            
            //[self.view addSubview:myCell];
            
            
            [self build_board:attackCellSide forView:attack_board attViews:YES storedCells:p1_attackCells];
            [self build_board:defenseCellSide forView:defense_board attViews:NO storedCells:p1_defenseCells];
            
            for (int i = 0; i < [p1_ships count]; i++)
            {
                shipView* a_ship = [p1_ships objectAtIndex:i];
                a_ship.layer.zPosition = 2;
                [a_ship setID:i];
                [a_ship setMain_view:self.view];
                [a_ship setDefense_board:defense_board];
                [a_ship setDefenseCellSide:&defenseCellSide];
                [a_ship setDefenseCells:p1_defenseCells];
                CGFloat the_x = a_ship.frame.origin.x;
                CGFloat the_y = a_ship.frame.origin.y;
                NSLog(@"setting frame: %f, %f", the_x, the_y);
                [a_ship setX:the_x withY:the_y];//set initial locations of the ships so they can snap back after wrong placement
                //[a_ship setInit_loc:&temp];
                [a_ship setCells_on_side:&cells_on_side];
                
                [a_ship setOnDefense:NO];
                
                [a_ship setHoriz:YES];
                
                [a_ship allocate_locs];
                
                //set ship size
                switch (i){
                    case 0:
                        [a_ship setSize:5];
                        break;
                    case 1:
                        [a_ship setSize:4];
                        break;
                    case 2:
                        [a_ship setSize:3];
                        break;
                    case 3:
                        [a_ship setSize:3];
                        break;
                    case 4:
                        [a_ship setSize:2];
                        break;
                }
                
                //ADD GESTURE RECOGNIZER
                UITapGestureRecognizer* tapper = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rotateShip:)];
                
                tapper.numberOfTapsRequired = 2;
                tapper.numberOfTouchesRequired = 1;
                //tapper.enabled = YES;
                //NSLog(@"WAS CALLED");
                [a_ship addGestureRecognizer:tapper];
                
                
            }
            
            
        }
        else{
            
            if (isSinglePlayer){
                ////////    computer simulate turn     ///////
                [self computer_simulate_turn];
            
                //////
            
            }
            
            
            attack_cell_chosen = NO;
            NSLog(@"in player 1 calling show");
            NSLog(@"%d cells in array", [p1_defenseCells count]);
            NSLog(@"%d cells in array", [p1_attackCells count]);
            
            [self showMessageWithString:@"Click a cell to make a play and press the 'Finish turn' button to complete turn.\nPlease select only 1 cell!"];
            
            ship_dock.hidden = YES;
            
            [self.nextViewbutton setTitle:@"Finish turn" forState:UIControlStateNormal];
            
            [self show_board:attackCellSide forView:attack_board attViews:YES storedCells:p1_attackCells];
            [self show_board:defenseCellSide forView:defense_board attViews:NO storedCells:p1_defenseCells];
        }
    }
    else{
        //player 2's turn
        
        currentPlayer.text = [NSString stringWithFormat:@"%@'s turn", player2];
        
        if ([self getSinglePlayer]){
            
            if (is_init_turn_2){
                /*
                [p2_ship_sizes addObject:[NSNumber numberWithInt:5]];
                [p2_ship_sizes addObject:[NSNumber numberWithInt:4]];
                [p2_ship_sizes addObject:[NSNumber numberWithInt:3]];
                [p2_ship_sizes addObject:[NSNumber numberWithInt:3]];
                [p2_ship_sizes addObject:[NSNumber numberWithInt:2]];
                
                [self build_board:attackCellSide forView:attack_board attViews:YES storedCells:p2_attackCells];
                [self build_board:defenseCellSide forView:defense_board attViews:NO storedCells:p2_defenseCells];
                
                [self computer_place_ships];
                 */
            }
            else{
                
                /*
                attack_cell_chosen = YES;
                NSLog(@"in computer calling show");
                NSLog(@"%d cells in array", [p2_defenseCells count]);
                NSLog(@"%d cells in array", [p2_attackCells count]);
                
                [self showMessageWithString:@"Click a cell to make a play and press the 'Finish turn' button to complete turn.\nPlease select only 1 cell!"];
                
                ship_dock.hidden = YES;
                
                [self.nextViewbutton setTitle:@"Finish turn" forState:UIControlStateNormal];
                
                [self show_board:attackCellSide forView:attack_board attViews:YES storedCells:p2_attackCells];
                [self show_board:defenseCellSide forView:defense_board attViews:NO storedCells:p2_defenseCells];
                
                [self computer_play];
                
                if ([self hasWon:player_turn]){
                    [self showMessageWithString:@"You've won!\nPress 'New Game' to go back to the setup page to start a new game!"];
                    [win_sound play];
                    nextViewbutton.hidden = YES;
                }
                 
                 */
                
            }
            
            
        }
        else{
            //let player2 play
            if (is_init_turn_2){
                //NSLog(@"in here!");
                
                
                p2_ships = [[NSMutableArray alloc]init];
                //add ships to array
                
                CGRect scaff = CGRectMake(18, 18, 200, 40);
                shipView* five   = [[shipView alloc]initWithFrame:scaff];
                //[five setID:0];
                [ship_dock addSubview:five];
                [p2_ships addObject:five];
                [p2_ship_sizes addObject:[NSNumber numberWithInt:5]];
                
                scaff.origin.y = 88;
                scaff.size.width = 160;
                shipView* four   = [[shipView alloc]initWithFrame:scaff];
                //[four setID:1];
                [ship_dock addSubview:four];
                [p2_ships addObject:four];
                [p2_ship_sizes addObject:[NSNumber numberWithInt:4]];
                
                scaff.origin.y = 158;
                scaff.size.width = 120;
                shipView* three_1   = [[shipView alloc]initWithFrame:scaff];
                //[three_1 setID:2];
                [ship_dock addSubview:three_1];
                [p2_ships addObject:three_1];
                [p2_ship_sizes addObject:[NSNumber numberWithInt:3]];
                
                scaff.origin.y = 228;
                scaff.size.width = 120;
                shipView* three_2   = [[shipView alloc]initWithFrame:scaff];
                //[three_2 setID:3];
                [ship_dock addSubview:three_2];
                [p2_ships addObject:three_2];
                [p2_ship_sizes addObject:[NSNumber numberWithInt:3]];
                
                scaff.origin.y = 298;
                scaff.size.width = 80;
                shipView* two   = [[shipView alloc]initWithFrame:scaff];
                //[two setID:4];
                [ship_dock addSubview:two];
                [p2_ships addObject:two];
                [p2_ship_sizes addObject:[NSNumber numberWithInt:2]];
                
                attackCellSide = attack_board.bounds.size.width/cells_on_side;
                defenseCellSide = defense_board.bounds.size.width/cells_on_side;
                
                
                /*five_init_loc = five.frame.origin;//within ship_dock
                 four_init_loc = four.frame.origin;//within ship_dock
                 three_1_init_loc = three_1.frame.origin;
                 three_2_init_loc = three_2.frame.origin;
                 two_init_loc = two.frame.origin;
                 */
                
                
                
                [self build_board:attackCellSide forView:attack_board attViews:YES storedCells:p2_attackCells];
                [self build_board:defenseCellSide forView:defense_board attViews:NO storedCells:p2_defenseCells];
                
                for (int i = 0; i < [p2_ships count]; i++)
                {
                    shipView* a_ship = [p2_ships objectAtIndex:i];
                    a_ship.layer.zPosition = 2;
                    [a_ship setID:i];
                    [a_ship setMain_view:self.view];
                    [a_ship setDefense_board:defense_board];
                    [a_ship setDefenseCellSide:&defenseCellSide];
                    [a_ship setDefenseCells:p2_defenseCells];
                    CGFloat the_x = a_ship.frame.origin.x;
                    CGFloat the_y = a_ship.frame.origin.y;
                    NSLog(@"setting frame: %f, %f", the_x, the_y);
                    [a_ship setX:the_x withY:the_y];//set initial locations of the ships so they can snap back after wrong placement
                    //[a_ship setInit_loc:&temp];
                    [a_ship setCells_on_side:&cells_on_side];
                    
                    [a_ship setOnDefense:NO];
                    
                    [a_ship setHoriz:YES];
                    
                    [a_ship allocate_locs];
                    
                    //set ship size
                    switch (i){
                        case 0:
                            [a_ship setSize:5];
                            break;
                        case 1:
                            [a_ship setSize:4];
                            break;
                        case 2:
                            [a_ship setSize:3];
                            break;
                        case 3:
                            [a_ship setSize:3];
                            break;
                        case 4:
                            [a_ship setSize:2];
                            break;
                    }
                    
                    //ADD GESTURE RECOGNIZER
                    UITapGestureRecognizer* tapper = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rotateShip:)];
                    
                    tapper.numberOfTapsRequired = 2;
                    tapper.numberOfTouchesRequired = 1;
                    //tapper.enabled = YES;
                    //NSLog(@"WAS CALLED");
                    [a_ship addGestureRecognizer:tapper];
                    
                    
                }
                
                
            }
            else{
                attack_cell_chosen = NO;
                NSLog(@"in player 2 calling show");
                NSLog(@"%d cells in array", [p2_defenseCells count]);
                NSLog(@"%d cells in array", [p2_attackCells count]);
                
                [self showMessageWithString:@"Click a cell to make a play and press the 'Finish turn' button to complete turn.\nPlease select only 1 cell!"];
                
                ship_dock.hidden = YES;
                
                [self.nextViewbutton setTitle:@"Finish turn" forState:UIControlStateNormal];
                
                [self show_board:attackCellSide forView:attack_board attViews:YES storedCells:p2_attackCells];
                [self show_board:defenseCellSide forView:defense_board attViews:NO storedCells:p2_defenseCells];
                
                
                
            }
        }
        
    }
    

    
}

-(void)computer_init_turn{
    [p2_ship_sizes addObject:[NSNumber numberWithInt:5]];
    [p2_ship_sizes addObject:[NSNumber numberWithInt:4]];
    [p2_ship_sizes addObject:[NSNumber numberWithInt:3]];
    [p2_ship_sizes addObject:[NSNumber numberWithInt:3]];
    [p2_ship_sizes addObject:[NSNumber numberWithInt:2]];
    
    [self build_board:attackCellSide forView:attack_board attViews:YES storedCells:p2_attackCells];
    [self build_board:defenseCellSide forView:defense_board attViews:NO storedCells:p2_defenseCells];
    
    [self computer_place_ships];
}

-(void)computer_simulate_turn{
    
    NSLog(@"in computer calling show");
    NSLog(@"%d cells in array", [p2_defenseCells count]);
    NSLog(@"%d cells in array", [p2_attackCells count]);
    
    [self showMessageWithString:@"Click a cell to make a play and press the 'Finish turn' button to complete turn.\nPlease select only 1 cell!"];
    
    ship_dock.hidden = YES;
    
    [self.nextViewbutton setTitle:@"Finish turn" forState:UIControlStateNormal];
    
    [self show_board:attackCellSide forView:attack_board attViews:YES storedCells:p2_attackCells];
    [self show_board:defenseCellSide forView:defense_board attViews:NO storedCells:p2_defenseCells];
    
    [self computer_play];
    
    if ([self hasWon:NO]){
        [self showMessageWithString:@"You've won!\nPress 'New Game' to go back to the setup page to start a new game!"];
        [win_sound play];
        nextViewbutton.hidden = YES;
    }
    

}

-(void)computer_play{
    NSArray* ship_names = [[NSArray alloc]initWithObjects:@"Aircraft carrier", @"Battleship", @"Submarine", @"Destroyer", @"Patrol Boat", nil];
    
    NSLog(@"in computer play");
    int idx_to_play = -1;
    bool outerbreak = YES;
    for (int i = 0; i < 5; i++){
        NSLog(@"checking ship %d hits", i);
        if ([[computer_hits objectAtIndex:i] count] > 0){
            //hits have been made on ship i
            NSLog(@"ship %d has some hits", i);
            if ([[computer_hits objectAtIndex:i] count] < [self sizeforID:i]){
                //there are still more cells to be hit
                NSMutableArray* i_hits =[computer_hits objectAtIndex:i];
                for (int j = 0; j < [i_hits count]; j++) {
                    NSLog(@"checking idx %d", j);
                    idx_to_play = [self check_neighbours:[[i_hits objectAtIndex:j] intValue]];
                    if ( idx_to_play != -1){
                        NSLog(@"this check was successful. play made");
                        
                        BoardCell* def_sunken = [p1_defenseCells objectAtIndex: idx_to_play];
                        int prev_size = [[p1_ship_sizes objectAtIndex:[def_sunken getShipID]] intValue];
                        if (prev_size > 0){
                            [p1_ship_sizes setObject:[NSNumber numberWithInt:(prev_size - 1)] atIndexedSubscript:[def_sunken getShipID]];
                            if (prev_size == 1){
                                //ship was sunk
                                [self showMessageWithString:[NSString stringWithFormat:@"You sunk the %@!", [ship_names objectAtIndex:[def_sunken getShipID]] ]];
                                [sink_sound play];
                            }
                            else{
                                [self showMessageWithString:[NSString stringWithFormat:@"You hit the %@!", [ship_names objectAtIndex:[def_sunken getShipID]] ]];
                                
                            }
                        }
                        else{
                            NSLog(@"ship has already been sunken");
                        }
                        return;
                        
                    }
                }
                
            }
            else{
                NSLog(@"all cells have been hit");
            }
        }
        if (!outerbreak){
            break;
        }
    }
    
    if (idx_to_play == -1)
    {//no hits to be followed up on
        //idx_to_play = -10;
        while ( true  ){
            
            idx_to_play = arc4random() % 100;
            //idx_to_play += 10;
            if (idx_to_play >= 0 && idx_to_play <100){
                BoardCell* toAttack_def = [p1_defenseCells objectAtIndex:idx_to_play];
                BoardCell* toAttack_att = [p2_attackCells objectAtIndex:idx_to_play];
                if ([toAttack_def getOccupied] ){
                    if (![toAttack_def isAttacked]){
                        NSLog(@"possible hit!");
                        [toAttack_def markX];
                        [toAttack_att markX];
                        [toAttack_def toggleAttacked];
                        NSLog(@"you hit ship with id: %d", [toAttack_def getShipID]);
                        [[computer_hits objectAtIndex:[toAttack_def getShipID]] addObject:[NSNumber numberWithInt:idx_to_play]];
                        int prev_size = [[p1_ship_sizes objectAtIndex:[toAttack_def getShipID]] intValue];
                        if (prev_size > 0){
                            [p1_ship_sizes setObject:[NSNumber numberWithInt:(prev_size - 1)] atIndexedSubscript:[toAttack_def getShipID]];
                            if (prev_size == 1){
                                //ship was sunk
                                [self showMessageWithString:[NSString stringWithFormat:@"Computer sunk the %@!", [ship_names objectAtIndex:[toAttack_def getShipID]] ]];
                                [sink_sound play];
                            }
                            else{
                                [self showMessageWithString:[NSString stringWithFormat:@"Computer hit the %@!", [ship_names objectAtIndex:[toAttack_def getShipID]] ]];
                                
                            }
                        }
                        else{
                            NSLog(@"ship has already been sunken");
                        }
                        break;
                    
                    }
                    //else it has already been attacked. guess again
                    
                }
                else{//not occupied by ship
                    if (![toAttack_def isAttacked]){
                        NSLog(@"miss!");
                        [toAttack_att markO];
                        [toAttack_def toggleAttacked];
                        [toAttack_def setBackgroundColor:[UIColor grayColor]];
                        break;
                    }
                    //else it has already been attacked. guess again
                }
                
            }
            
        }
        
    }
    //determined hit is made in check neighbour
    
}

-(int)check_neighbours:(int)idx{
    NSLog(@"checking neighbours");
    int left = idx - 1;
    int right = idx + 1;
    int top = idx - 10;
    int bottom = idx + 10;
    
    NSLog(@"left: %d, right: %d, top: %d, bottom: %d", left, right, top, bottom);
    
    if (left >= 0 && left <100){
        NSLog(@"checking left cell");
        BoardCell* toAttack = [p1_defenseCells objectAtIndex:left];
        BoardCell* toShow = [p2_attackCells objectAtIndex:left];
        if ([toAttack getOccupied] && ![toAttack isAttacked]){
            NSLog(@"in here");
            [toAttack markX];
            [toAttack toggleAttacked];
            [toShow markX];
            [[computer_hits objectAtIndex:[toAttack getShipID]] addObject:[NSNumber numberWithInt:left]];
            return left;
        }
        else if ([toAttack getOccupied] && ![toAttack isAttacked]){
            
            [toShow markO];
            [toAttack toggleAttacked];
            return left;
        }
        
    }
    
    
    if (right >= 0 && right <100){
        BoardCell* toAttack = [p1_defenseCells objectAtIndex:right];
        BoardCell* toShow = [p2_attackCells objectAtIndex:right];
        if ([toAttack getOccupied] && ![toAttack isAttacked]){
            [toAttack markX];
            [toAttack toggleAttacked];
            [toShow markX];
            [[computer_hits objectAtIndex:[toAttack getShipID]] addObject:[NSNumber numberWithInt:right]];
            return right;
        }
        else if ([toAttack getOccupied] && ![toAttack isAttacked]){
            
            [toShow markO];
            [toAttack toggleAttacked];
            return right;
        }
    }
    
    if (top >= 0 && top <100){
        BoardCell* toAttack = [p1_defenseCells objectAtIndex:top];
        BoardCell* toShow = [p2_attackCells objectAtIndex:top];
        if ([toAttack getOccupied] && ![toAttack isAttacked]){
            [toAttack markX];
            [toAttack toggleAttacked];
            [toShow markX];
            [[computer_hits objectAtIndex:[toAttack getShipID]] addObject:[NSNumber numberWithInt:top]];
            return top;
        }
        else if ([toAttack getOccupied] && ![toAttack isAttacked]){
            
            [toShow markO];
            [toAttack toggleAttacked];
            return top;
        }

    }
    
    if (bottom >= 0 && bottom <100){
        BoardCell* toAttack = [p1_defenseCells objectAtIndex:bottom];
        BoardCell* toShow = [p2_attackCells objectAtIndex:bottom];
        if ([toAttack getOccupied] && ![toAttack isAttacked]){
            [toAttack markX];
            [toAttack toggleAttacked];
            [toShow markX];
            [[computer_hits objectAtIndex:[toAttack getShipID]] addObject:[NSNumber numberWithInt:bottom]];
            return bottom;
        }
        else if ([toAttack getOccupied] && ![toAttack isAttacked]){
            
            [toShow markO];
            [toAttack toggleAttacked];
            return bottom;
        }

    }
    
    return -1;
}

-(bool)allShipsPlaced:(NSMutableArray *)player_ships{
    
    for (shipView* ship in player_ships){
        if ([ship isOnDefense]){
            
        }
        else{
            return NO;
        }
    }
    return YES;
}


-(void)setTurn:(bool)the_turn{
    player_turn = the_turn;
}

-(bool)hasWon:(bool)player{
    
    NSMutableArray* opponent_ships = p1_ship_sizes;
    
    if (player){
        opponent_ships = p2_ship_sizes;
    }
    
    int total_remaining = 0;
    for (NSNumber* num in opponent_ships){
        total_remaining += [num intValue];
    }
    return (total_remaining == 0);
}

-(bool)getTurn{
    return player_turn;
}

-(void)set_isInitForP1:(bool)isInitP1 ForP2:(bool)isInitP2{
    is_init_turn_1 = isInitP1;
    is_init_turn_2 = isInitP2;
}

-(void)rotateShip:(UITapGestureRecognizer *) sender{
    shipView* my_ship = (shipView *)[sender view];
    bool new_orient = ![my_ship isHoriz];
    
    
   
    
    //initial stored positions are removed in ships touchesbegan
    
    //add new positions if in defense board
    
    NSLog(@"placing ship with id: %d, size: %d, at starting idx: %d", [my_ship getID], [self sizeforID: [my_ship getID]], [my_ship getStartIdx]);
    bool placeship = [self canPlaceShip:[self sizeforID: [my_ship getID]] atStart:[my_ship getStartIdx] orient:new_orient];
    if (placeship) {
        NSLog(@"place ship is a GO");
    }
    if (![my_ship isOnDefense]){//not on board
        
        CGRect new_frame = my_ship.frame;
        CGFloat oldWidth = new_frame.size.width;
        CGFloat oldHeight= new_frame.size.height;
        new_frame.size.height = oldWidth;
        new_frame.size.width = oldHeight;
        [my_ship setFrame:new_frame];
        [my_ship setHoriz:new_orient];
        
    }
    else{
        
        if (placeship){//ship can be placed
            [my_ship setHoriz:new_orient];
            CGRect new_frame = my_ship.frame;
            CGFloat oldWidth = new_frame.size.width;
            CGFloat oldHeight= new_frame.size.height;
            new_frame.size.height = oldWidth;
            new_frame.size.width = oldHeight;
            [my_ship setFrame:new_frame];
            
            [my_ship clearPositions];
            [my_ship loadPositions:[my_ship getStartIdx]];
            
        }
        else{
            NSLog(@"ship was not rotated!");
        }
        
    }
    
    
}

-(void)computer_place_ships{
    
    NSLog(@"placing ships");
    for (int i = 0; i < 5; i++){
        NSLog(@"placing ship with id: %d", i);
        [self computer_place_ship_withID:i];
    }
    
    
}

-(void)computer_place_ship_withID:(int)shipid{
    int orient = arc4random() % 2;
    bool ori = YES;
    if (orient == 0){
        ori = NO;
    }
    int start = arc4random() % 99;
    NSLog(@"start idx: %d", start);
    while (![self canPlaceShip_computer:[self sizeforID:shipid] atStart:start orient:ori]){
        int orient = arc4random() % 2;
        ori = YES;
        if (orient == 0){
            ori = NO;
        }
        
        start = arc4random() % 99;
        NSLog(@"start idx: %d", start);
    }
    
    [self loadPositions:start withID:shipid orient:ori];
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

-(void)loadPositions:(int)start_idx withID:(int)shipID orient:(bool)isHoriz{
    
    //find and add occupied positions
    
    int next_add;
    if (isHoriz){
        next_add = 1;
    }
    else{
        next_add = 10;
    }
    int added = 0;
    int ship_idx = start_idx;
    while (added < [self sizeforID:shipID]){
        NSLog(@"setting pos: %d", ship_idx);
        
        BoardCell* toAdd = [p2_defenseCells objectAtIndex:ship_idx];
        [toAdd setOccupied:YES];
        
        [toAdd setShipID:shipID];
        NSLog(@"just set ship id: %d", [toAdd getShipID]);
        toAdd.backgroundColor  = [UIColor blackColor];
        added++;
        ship_idx += next_add;
    }
    
    
}

-(bool)canPlaceShip:(int)size atStart:(int)start orient:(bool)isHoriz{
    NSMutableArray* def_cells = p2_defenseCells;
    if (player_turn){
        def_cells = p1_defenseCells;
    }
    int next_val = 10;
    int ship_size = size;
    if(isHoriz){
        next_val = 1;
    }
    int cell_loc = start;
    int ctr = 0;
    while (ctr < ship_size){
        //check if index is on board
        NSLog(@"checking postion %d", cell_loc);
        if (cell_loc >= 100){//vertical check
            NSLog(@"out of bounds");
            return NO;
        }
        
        
        
        if ( next_val == 1){//horizontal check
            int cur_row = start / 10;
            for (int i = start; i < start + ship_size; i++){
                if ( (i / 10) != cur_row){
                    NSLog(@"horizontal check fail");
                    return NO;
                }
            }
        }
        
        if ([[def_cells objectAtIndex:cell_loc] getOccupied] && cell_loc != start){
            NSLog(@"conflict fail");
            return NO;
        }
        ctr++;
        cell_loc += next_val;
    }
    
    
    return YES;
}

-(bool)canPlaceShip_computer:(int)size atStart:(int)start orient:(bool)isHoriz{
    int next_val = 10;
    int ship_size = size;
    if(isHoriz){
        next_val = 1;
    }
    int cell_loc = start;
    int ctr = 0;
    while (ctr < ship_size){
        //check if index is on board
        NSLog(@"checking postion %d", cell_loc);
        if (cell_loc >= 100){//vertical check
            NSLog(@"out of bounds");
            return NO;
        }
        
        
        
        if ( next_val == 1){//horizontal check
            int cur_row = start / 10;
            for (int i = start; i < start + ship_size; i++){
                if ( (i / 10) != cur_row){
                    NSLog(@"horizontal check fail");
                    return NO;
                }
            }
        }
        
        if ([[p2_defenseCells objectAtIndex:cell_loc] getOccupied] && cell_loc != start){
            NSLog(@"conflict fail");
            return NO;
        }
        ctr++;
        cell_loc += next_val;
    }
    
    
    return YES;
}


-(void)show_board:(int)cellSide forView:(UIView*)myview attViews:(bool) doit storedCells:(NSMutableArray*)source{
    int asciiCode = 65;//lettering begins from 'A'
    int rowNumber = 1;//numbering begins from 1
    int arrayidx = 0;
    for (int i = 0; i < cells_on_side*cells_on_side; i++){
        //NSLog(@"%d, %d", [self getRow:i], [self getColumn:i]);
        
        float x_val = myview.bounds.origin.x + [self getColumn:i]*cellSide;
        float y_val = myview.bounds.origin.y + [self getRow:i]*cellSide;
        CGRect frame = CGRectMake(x_val, y_val, cellSide, cellSide);
        BoardCell* new_cell = [[BoardCell alloc] initWithFrame:frame];
        [new_cell setAttack:doit];
        
        
        
        
        //set edge of board values
        if ([self getRow:i] == 0){
            if ([self getColumn:i] != 0){
                [new_cell.mark setText:[NSString stringWithFormat:@" %c", asciiCode]];
                asciiCode++;
            }
            [new_cell toggleEnabled];
            [myview addSubview:new_cell];
        }
        
        if ([self getColumn:i] == 0){
            if ([self getRow:i] != 0){
                [new_cell toggleEnabled];
                if (rowNumber <= 9){
                    [new_cell.mark setText:[NSString stringWithFormat:@" %d", rowNumber]];
                }
                else{
                    [new_cell.mark setText:[NSString stringWithFormat:@"%d", rowNumber]];
                }
                rowNumber++;
                [myview addSubview:new_cell];
            }
        }
        
        
        
        
        
        if ( [self getColumn:i] != 0 && [self getRow:i] != 0){
            
            if (doit){//save as attack cell
                //add outlet buttons to attack views
                BoardCell* cellView = [source objectAtIndex:arrayidx];
                UIButton* cellButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                
                
                [cellButton addTarget:self action:@selector(cellSelected:) forControlEvents:UIControlEventTouchUpInside];
                [cellView addSubview:cellButton];
                cellButton.frame = cellView.bounds;
                cellButton.layer.zPosition = 4;
                cellButton.tag = [cellView getID];
                [myview addSubview:cellView];
                
            }
            else{//save as defense cell
                [myview addSubview:[source objectAtIndex:arrayidx]];
            }
            arrayidx++;
        }
        
        
        
    }
}

-(void)cellSelected:(id)sender{
    NSArray* ship_names = [[NSArray alloc]initWithObjects:@"Aircraft carrier", @"Battleship", @"Submarine", @"Destroyer", @"Patrol Boat", nil];
    if(!attack_cell_chosen){
        NSMutableArray* attack_field = p2_attackCells;
        NSMutableArray* opponent_defense_field = p1_defenseCells;
        NSMutableArray* opponent_ships = p1_ship_sizes;
        
        if (player_turn){
            attack_field = p1_attackCells;
            opponent_defense_field = p2_defenseCells;
            opponent_ships = p2_ship_sizes;
            
        }
        BoardCell* def_sunken = [opponent_defense_field objectAtIndex:[sender tag]];
        BoardCell* att_sunken = [attack_field objectAtIndex:[sender tag]];
        if (![att_sunken isAttacked]){
            NSLog(@"id of att cell that was hit: %d", [att_sunken getShipID]);
            NSLog(@"id of def cell that was hit: %d", [def_sunken getShipID]);
            if ([def_sunken getOccupied]){
                [att_sunken markX];
                
                [def_sunken markX];
                
                
                int prev_size = [[opponent_ships objectAtIndex:[def_sunken getShipID]] intValue];
                if (prev_size > 0){
                    [opponent_ships setObject:[NSNumber numberWithInt:(prev_size - 1)] atIndexedSubscript:[def_sunken getShipID]];
                    if (prev_size == 1){
                        //ship was sunk
                        [self showMessageWithString:[NSString stringWithFormat:@"You sunk the %@!", [ship_names objectAtIndex:[def_sunken getShipID]] ]];
                        [sink_sound play];
                    }
                    else{
                        [self showMessageWithString:[NSString stringWithFormat:@"You hit the %@!", [ship_names objectAtIndex:[def_sunken getShipID]] ]];
                        
                    }
                }
                else{
                    NSLog(@"ship has already been sunken");
                }
                
                //check for game completion
                //winning message should append
                
                if ([self hasWon:player_turn]){
                    [self showMessageWithString:@"You've won!\nPress 'New Game' to go back to the setup page to start a new game!"];
                    [win_sound play];
                    nextViewbutton.hidden = YES;
                }
                
                
                
                
                
            }
            else{
                [att_sunken markO];
                [def_sunken setBackgroundColor:[UIColor grayColor]];
            }
            [att_sunken toggleAttacked];
            
            attack_cell_chosen = !attack_cell_chosen;
        }
    }
}

-(void)build_board:(int)cellSide forView:(UIView*)myview attViews:(bool)doit storedCells:(NSMutableArray *)sink{
    
    int asciiCode = 65;//lettering begins from 'A'
    int rowNumber = 1;//numbering begins from 1
    int arrayidx = 0;
    for (int i = 0; i < cells_on_side*cells_on_side; i++){
        //NSLog(@"%d, %d", [self getRow:i], [self getColumn:i]);
        
        float x_val = myview.bounds.origin.x + [self getColumn:i]*cellSide;
        float y_val = myview.bounds.origin.y + [self getRow:i]*cellSide;
        CGRect frame = CGRectMake(x_val, y_val, cellSide, cellSide);
        BoardCell* new_cell = [[BoardCell alloc] initWithFrame:frame];
        [new_cell setAttack:doit];
        
        
        
        
        //set edge of board values
        if ([self getRow:i] == 0){
            if ([self getColumn:i] != 0){
                [new_cell.mark setText:[NSString stringWithFormat:@" %c", asciiCode]];
                asciiCode++;
            }
            [new_cell toggleEnabled];
        }
        
        if ([self getColumn:i] == 0){
            if ([self getRow:i] != 0){
                [new_cell toggleEnabled];
                if (rowNumber <= 9){
                    [new_cell.mark setText:[NSString stringWithFormat:@" %d", rowNumber]];
                }
                else{
                    [new_cell.mark setText:[NSString stringWithFormat:@"%d", rowNumber]];
                }
                rowNumber++;
            }
        }
        
        
        
        [myview addSubview:new_cell];
        
        if ( [self getColumn:i] != 0 && [self getRow:i] != 0){
            [new_cell setID:arrayidx];
            if (doit){//save as attack cell
                
                [sink addObject:new_cell];
            }
            else{//save as defense cell
                [sink addObject:new_cell];
            }
            arrayidx++;
        }
        
        
        
    }
    
}

-(bool)getSinglePlayer
{
    return isSinglePlayer;
}

-(void)setSinglePlayer:(bool)player_state{
    isSinglePlayer = player_state;
}


-(int)getColumn:(int)arrayIdx{
    
    return arrayIdx % cells_on_side;
}

-(int)getRow:(int)arrayIdx{
    
    return arrayIdx / cells_on_side;
}

/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch* atouch = [touches anyObject];
    CGPoint curpos = [atouch locationInView:ship_dock];
    NSLog(@"started: %f, %f", curpos.x, curpos.y);
    
    [self set_ship_touched:curpos];
    
    
}

*/
-(void) set_ship_touched:(CGPoint) touchPoint{
    
    
    for (int i = 0; i < [p1_ships count]; i++){
        
        
        /*
         NSLog(@"topleft: (%f, %f), bottomleft: (%f, %f), topright: (%f, %f), bottomright: (%f, %f)", aframe.origin.x, aframe.origin.y, aframe.origin.x, aframe.origin.y + aframe.size.height, aframe.origin.x + aframe.size.width, aframe.origin.y, aframe.origin.x + aframe.size.width, aframe.origin.y+ aframe.size.height);
         */
        if (CGRectContainsPoint([[p1_ships objectAtIndex:i] frame], touchPoint)){
            
            //NSLog(@"ship %d was touched!", i);
            ship_chosen = i;
        }
        
    }
}

/*
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (ship_chosen != -1){
        UITouch* atouch = [touches anyObject];
        CGPoint endpnt = [atouch locationInView:self.view];
        
        UIView* tobeplaced = [ships objectAtIndex:ship_chosen];
        CGPoint offset = [atouch locationInView:tobeplaced];
        CGPoint target_pnt = CGPointMake(endpnt.x - offset.x, endpnt.y - offset.y);//corner position of ship to be placed/being moved
        
        CGRect orig = [defense_board frame];
        //set frame of cells where ship can be placed on board
        CGRect destframe = CGRectMake(orig.origin.x + defenseCellSide, orig.origin.y + defenseCellSide, orig.size.width - defenseCellSide, orig.size.height - defenseCellSide);
        if (CGRectContainsPoint(destframe, target_pnt)){//check if top-left corner of ship falls within playable part of defense board
            
            float deltaX = (target_pnt.x - defense_board.frame.origin.x);
            float deltaY = (target_pnt.y - defense_board.frame.origin.y);
            int snap_dest_col = ((int) deltaX)/defenseCellSide;
            int snap_dest_row = ((int)deltaY)/defenseCellSide;
            
            UIView* target_view = [defenseCells objectAtIndex:((snap_dest_row - 1)*(cells_on_side - 1) + (snap_dest_col - 1))];
            
            //target_view.backgroundColor = [UIColor blackColor];
            
            [defense_board addSubview:tobeplaced];
            
            CGRect new_tobeplaced_frame = tobeplaced.frame;
            new_tobeplaced_frame.origin.x = target_view.frame.origin.x;
            new_tobeplaced_frame.origin.y = target_view.frame.origin.y;
            [tobeplaced setFrame:new_tobeplaced_frame];
            
        }
        else{
            //snap ship back
            CGRect newframe = tobeplaced.frame;
            switch (ship_chosen){
                case 0://
                    newframe.origin = five_init_loc;
                    break;
                case 1:
                    newframe.origin = four_init_loc;
                    break;
                case 2:
                    newframe.origin = three_1_init_loc;
                    break;
                case 3:
                    newframe.origin = three_2_init_loc;
                    break;
                case 4:
                    newframe.origin = two_init_loc;
                    break;
            }
            
            [tobeplaced setFrame:newframe];
            
        }
        //NSLog(@"ended: %f, %f", curpos.x, curpos.y);
        ship_chosen = -1;
    }
    
    
}
 
*/

/*
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (ship_chosen != -1){//move ships
        UIView* ismoving = [ships objectAtIndex: ship_chosen];
        UITouch* atouch = [touches anyObject];
        CGPoint currentloc = [atouch locationInView:self.view];
        CGPoint prevloc = [atouch previousLocationInView:self.view];
        CGRect newframe = ismoving.frame;
        newframe.origin.x += currentloc.x - prevloc.x;
        newframe.origin.y += currentloc.y - prevloc.y;
        
        [ismoving setFrame:newframe];
        
        
    }
}
*/

-(void)showMessageWithString:(NSString* ) the_string{
    instructions.text = the_string;
    instructions.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"toTransView"]) {
        
        
        if (isSinglePlayer){
            if (is_init_turn_1){
                if ([self allShipsPlaced:p1_ships]){
                    return YES;
                }
                else {
                    instructions.text = @"Battle Update!\nUh-oh! You forgot to place all your ships!";
                    instructions.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0];
                    
                    return NO;
                }
            }
            else{
                if (attack_cell_chosen){
                    return YES;
                }
                else{
                    instructions.text = @"Battle Update!\nUh-oh! You forgot to choose a cell!";
                    instructions.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0];
                    
                    return NO;
                }
            }
            
        }
        else{
            if (is_init_turn_1 || is_init_turn_2){
                
                NSMutableArray* player_ships;
                if (is_init_turn_1 & player_turn) {
                    player_ships = p1_ships;
                }
                
                if (is_init_turn_2 & !player_turn){
                    player_ships = p2_ships;
                }
                
                if ([self allShipsPlaced:player_ships]){
                    return YES;
                }
                else {
                    instructions.text = @"Battle Update!\nUh-oh! You forgot to place all your ships!";
                    instructions.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0];
                    
                    return NO;
                }
                
            }
            else{
                if (attack_cell_chosen){
                    return YES;
                }
                else{
                    instructions.text = @"Battle Update!\nUh-oh! You forgot to choose a cell!";
                    instructions.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0];
                    
                    return NO;
                }
            }
        }
        
        
        
        
        
        
        
    }
    
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"toTransView"]){
        transitionsView* trans_controller = [segue destinationViewController];
        
        if (is_init_turn_1 && player_turn){
            for (shipView* ship in p1_ships){
                [ship colorPositions:[UIColor blackColor]];
            }
            is_init_turn_1 = NO;
        }
        else{
            if (is_init_turn_2 && !player_turn){
                for (shipView* ship in p2_ships){
                    [ship colorPositions:[UIColor blackColor]];
                }
                is_init_turn_2 = NO;
            }
        }
        
        [trans_controller setP1_attackCells:p1_attackCells];
        [trans_controller setP1_defenseCells:p1_defenseCells];
        [trans_controller setP2_attackCells:p2_attackCells];
        [trans_controller setP2_defenseCells:p2_defenseCells];
        [trans_controller setP1_ship_sizes:p1_ship_sizes];
        [trans_controller setP2_ship_sizes:p2_ship_sizes];
        
        [trans_controller setPlayer1:player1];
        [trans_controller setPlayer2:player2];
        
        [trans_controller setComputer_hits:computer_hits];
        
        [trans_controller setGameType:isSinglePlayer];
        
        if (isSinglePlayer){//if single player game, it always player 1's turn
            [trans_controller setTurn:YES];
        }
        else{
            [trans_controller setTurn:!player_turn];
        }
        
        
        [trans_controller set_isInitForP1:is_init_turn_1 ForP2:is_init_turn_2];
    }
    
    
    
}

@end
