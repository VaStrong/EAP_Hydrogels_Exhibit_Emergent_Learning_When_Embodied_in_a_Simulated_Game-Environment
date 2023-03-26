ballDist_NoPaddle = ballPosDist(false);
ballDist_Paddle = ballPosDist(true);
ballDist_Paddle_Ratio = ballPosDist(0.98,0.58,0.86);
ballDist_Paddle_Ratio2 = ballPosDist(0.98,0.58,0.86);
ballDist_Paddle_RatioComb = [ballDist_Paddle_Ratio;ballDist_Paddle_Ratio2];
paddleRandomDist = paddleRandDist();