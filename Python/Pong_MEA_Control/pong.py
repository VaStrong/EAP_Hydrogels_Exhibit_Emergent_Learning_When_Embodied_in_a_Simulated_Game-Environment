# Import the pygame library and initialise the game engine
import pygame
from paddle import Paddle
from ball import Ball
from region import Region
import config
from os.path import exists
from datetime import date
import time
import numpy as np;
import scipy.optimize as opt;
from random import randint

BLACK  = (0  ,0  ,0  )
WHITE  = (255,255,255)
BLUE   = (51 ,146,255)
ORANGE = (232,176,7  )

class Pong():
    def __init__(self, Size):
        pygame.init()
        self.lastRawData = ""
 
        # Open a new window
        self.size = Size #(1000, 1000)
        self.screen = pygame.display.set_mode(self.size)
        pygame.display.set_caption("Pong")
        
        #setup file path
        filePathCount = 0
        while ( exists("Data\pongData_"+str(date.today())+"_"+str(filePathCount)+".txt") ): filePathCount += 1
        self.filePath = "Data\pongData_"+str(date.today())+"_"+str(filePathCount)+".txt"
        print('Stored pong data file path is: '+self.filePath)
        self.epoch_time = float(time.time())
        
        self.ballFilePath = "Data"+"\\"+"ballPos_"+str(date.today())+"_"+str(filePathCount)+".txt"
        print('Stored ball position data file path is: '+self.ballFilePath)
        self.lastBallPosTime = -0.5
 
        #in papaer paddle is 0.41810344827 height of feild and 0.01508620689 width and sitting in by 0.00215517241 width, ball is 0.03663793103 size of feild
        self.paddleHeight = round(self.size[1]/3)
        self.paddle = Paddle(WHITE, round(self.size[0]*0.015), self.paddleHeight, self.size) #40, 300
        self.paddle.rect.x = round(self.size[0]*0.002) #20
        self.paddle.rect.y = round(self.size[1]/2)
 
        self.ball = Ball(WHITE,round(self.size[1]*0.03663793103),round(self.size[1]*0.03663793103)) #50,50
        self.ball.reset(round(self.size[0]/2),round(self.size[1]/2))
        

        #create discreet ball and paddle Regions
        self.ballRegions = [Region] * 6
        for i in range(6):
            self.ballRegions[i] = Region(BLUE,(self.size[0])/2,self.size[1]/3)
            self.ballRegions[i].rect.x = i%2*((self.size[0])/2)
            self.ballRegions[i].rect.y = i%3*self.size[1]/3
            
        #self.paddleRegions = [Region] * 3
        #for i in range(3):
        #    self.paddleRegions[i] = Region(ORANGE,60,self.size[1]/3)
        #    self.paddleRegions[i].rect.x = 0
        #    self.paddleRegions[i].rect.y = i%3*self.size[1]/3
         
        #This will be a list that will contain all the sprites we intend to use in our game.
        self.all_sprites_list = pygame.sprite.Group()
         
        #Add the paddle and the ball to the list of objects
        for i in range(6):
            self.all_sprites_list.add(self.ballRegions[i])

        #for i in range(3):
        #    self.all_sprites_list.add(self.paddleRegions[i])
            
        self.all_sprites_list.add(self.paddle)
        self.all_sprites_list.add(self.ball)
         
        #Initialise player scores
        self.score = 0
        
        self.carryOn = True
        
    def getScore(self):
        return self.score
    
    def clearScore(self):
        self.score = 0
    
    def close(self):
        self.carryOn = False
    
    def extractPosition(self, rawData):
        temp = rawData.split(',')
        currents = [float(temp[0]),float(temp[1]),float(temp[2])]
        #minCurrent = -5
        #maxCurrent = 5
        
        origTop = 0.93 #black
        origMid = 0.91 #brown
        origBot = 0.81 #red
        upRangeC = 3#0.75
        lowRangeC = 0.75#3
        
        
        # negative stimulation
        #curTop =  self.mapCurrent(currents[0], origTop-lowRangeC, origTop+upRangeC)#black
        #curMid =  self.mapCurrent(currents[1], origMid-lowRangeC, origTop+upRangeC)#brown
        #curBot =  self.mapCurrent(currents[2], origBot-lowRangeC, origTop+upRangeC)#red
        
        # positive stimulation
        curTop =  self.mapCurrent(currents[0], origTop+upRangeC, origTop-lowRangeC)#black
        curMid =  self.mapCurrent(currents[1], origMid+upRangeC, origMid-lowRangeC)#brown
        curBot =  self.mapCurrent(currents[2], origBot+upRangeC, origBot-lowRangeC)#red
        
        #convert current measurments into a trend
        # This is the function we are trying to fit to the data.
        def func(x, a, b, c):
            return a*np.power(x,2) + b*x + c
        
        xdata = np.array([int(self.size[0]/6), int((3*self.size[0])/6), int((5*self.size[0])/6)])
        ydata = np.array([curTop, curMid, curBot])
        optimizedParameters, pcov = opt.curve_fit(func, xdata, ydata);
        dispX = np.linspace(0, self.size[0], self.size[0])
        dispY = func(dispX, *optimizedParameters)
        pos = np.argmax(dispY)-self.paddleHeight
        self.paddle.setPos(pos)
        print("black: "+"{:.2f}".format(curTop)+" ,brown: "+"{:.2f}".format(curMid)+" ,red: "+"{:.2f}".format(curBot)+" ,pos: "+str(pos))
        #print("pong setting: "+rawData+" pos: "+str(pos))
    
    def mapCurrent(self, current, maxC, minC):
        #minCurrent = 0
        #maxCurrent = 2
        temp =  ((current - minC) / (maxC-minC))
        if temp > 1:
            temp = 1
        elif temp < 0:
            temp = 0
        return temp
    
    def directCovert(self, stim):
        #direction = 1
        if stim == 0:
            return 0
        else:
            return -1
    
    # -------- Main Program Loop -----------
    def gameLoop(self):
        clock = pygame.time.Clock()
        tempRegion = [False] * 6
        hitFlag = False
        scoreFlag = False
        resetFlag = False
        print("Pong game loop started")
        while self.carryOn:
            # --- Main event loop
            for event in pygame.event.get(): # User did something
                if event.type == pygame.QUIT: # If user clicked close
                    self.carryOn = False # Flag that we are done so we exit this loop
                elif event.type==pygame.KEYDOWN:
                    if event.key==pygame.K_x: #Pressing the x Key will quit the game
                        self.carryOn=False
            
            #paddle motion
            if not config.SenseQ == "":
                rawData = config.SenseQ
                #print(rawData)
                if not self.lastRawData == rawData:
                    self.extractPosition(rawData)
                    self.lastRawData = rawData
            #Moving the paddles when the use uses the arrow keys (player A) or "W/S" keys (player B) 
#             keys = pygame.key.get_pressed()
#             if keys[pygame.K_w]:
#                 self.paddle.moveUp(5)
#             if keys[pygame.K_s]:
#                 self.paddle.moveDown(5) 
         
            # --- Game logic should go here
            self.all_sprites_list.update()
            
            #ball position recording
            #if not (self.lastBallPos == self.ball.getPos()) :
            #print( (float(time.time())-self.epoch_time) - self.lastBallPosTime )
            if ((float(time.time())-self.epoch_time)-self.lastBallPosTime) >= 0.5 :
                file = open(self.ballFilePath, "a")
                file.write(str(round(float(time.time())-self.epoch_time,2))+','+self.ball.getPos()+"\n")
                file.close()
                self.lastBallPosTime = float(time.time())-self.epoch_time
                
                
            
            #Check if the ball is bouncing against any of the 4 walls:
            if self.ball.rect.x>=self.size[0]-40:#right wall
                self.ball.velocity[0] = -abs(self.ball.velocity[0])
                #self.ball.velocity[1] = randint(-8,8)#for random bouncing-----------
            if self.ball.rect.x<=0: #missed by paddle, left wall
                self.clearScore()
                scoreFlag = True
                resetFlag = True
                #self.ball.velocity[0] = abs(self.ball.velocity[0])                #self.ball.velocity[1] = randint(-8,8)#for random bouncing-----------
            if self.ball.rect.y>self.size[1]-40:#bottom wall
                #self.ball.velocity[1] = -abs(randint(-8,8))#for random bouncing-----------
                self.ball.velocity[1] = -abs(self.ball.velocity[1])
            if self.ball.rect.y<0:#top wall
                #self.ball.velocity[1] = abs(randint(-8,8))#for random bouncing-----------
                self.ball.velocity[1] = abs(self.ball.velocity[1])
         
            #Detect collisions between the ball and the paddles
            if pygame.sprite.collide_mask(self.ball, self.paddle) and not hitFlag:
                #ball.bounce()
                hitFlag = True
                self.ball.velocity[0] = abs(self.ball.velocity[0])
                #self.ball.velocity[1] = randint(-8,8)#for random bouncing-----------
                self.score+=1
                scoreFlag = True
            elif not pygame.sprite.collide_mask(self.ball, self.paddle) and hitFlag:
                hitFlag = False
                
            RegionStim = [False] * 6
            for i in range(6):
                if pygame.sprite.collide_mask(self.ball, self.ballRegions[i]):
                    self.ballRegions[i].activate()
                    RegionStim[i] = True
                else :
                    self.ballRegions[i].deactivate()
                    RegionStim[i] = False
                    
            if scoreFlag:
                hitSpot = ""
                if (RegionStim[0] == True):
                    hitSpot += "top"
                if (RegionStim[4] == True):
                    hitSpot += "mid"
                if (RegionStim[2] == True):
                    hitSpot += "bot"
                if (hitSpot == ""):
                    hitSpot = "error"

                file = open(self.filePath, "a")
                file.write(hitSpot+','+str(self.score)+','+str(round(float(time.time())-self.epoch_time,2))+"\n")
                file.close()
                
                if resetFlag :
                    self.ball.reset(round(self.size[0]/2),round(self.size[1]/2))#reset ball to center
                    resetFlag = False
                
                scoreFlag = False
                    
            #print(RegionStim)
            #print(tempRegion)
            #print("---------")
            #direction = 1
            if not RegionStim == tempRegion :
                #normal operation - used for learning
                RegionStimString = str(self.directCovert(int(RegionStim[0])))+","+str(self.directCovert(int(RegionStim[1])))+","+str(self.directCovert(int(RegionStim[2])))+","+str(self.directCovert(int(RegionStim[3])))+","+str(self.directCovert(int(RegionStim[4])))+","+str(self.directCovert(int(RegionStim[5])))
                
                #mixed up operation 1
                #RegionStimString = str(self.directCovert(int(RegionStim[2])))+","+str(self.directCovert(int(RegionStim[5])))+","+str(self.directCovert(int(RegionStim[4])))+","+str(self.directCovert(int(RegionStim[1])))+","+str(self.directCovert(int(RegionStim[0])))+","+str(self.directCovert(int(RegionStim[3])))
                
                #mixed up operation 2 - used for baseline
                #RegionStimString = str(self.directCovert(int(RegionStim[4])))+","+str(self.directCovert(int(RegionStim[3])))+","+str(self.directCovert(int(RegionStim[0])))+","+str(self.directCovert(int(RegionStim[5])))+","+str(self.directCovert(int(RegionStim[2])))+","+str(self.directCovert(int(RegionStim[1])))
                
                #print(RegionStimString)
                config.RelayQ = RegionStimString
            tempRegion = RegionStim[:]
            
            #for i in range(3):
            #    if pygame.sprite.collide_mask(self.paddle, self.paddleRegions[i]):
            #        self.paddleRegions[i].activate()
            #    else :
            #        self.paddleRegions[i].deactivate()
            
            # --- Drawing code should go here
            # First, clear the screen to black. 
            self.screen.fill(BLACK)
            
            #Now let's draw all the sprites in one go. (For now we only have 2 sprites!)
            self.all_sprites_list.draw(self.screen) 
         
            #Display scores:
            font = pygame.font.Font(None, 74)
            text = font.render(str(self.score), 1, WHITE)
            self.screen.blit(text, (self.size[0]*0.5,10))
         
            # --- Go ahead and update the screen with what we've drawn.
            pygame.display.flip()
             
            # --- Limit to 60 frames per second
            clock.tick(60)
         
        #Once we have exited the main program loop we can stop the game engine:
            
        print("closing pong game")
        pygame.display.quit()
        pygame.quit()