# EAP_Hydrogels_Exhibit_Emergent_Learning_When_Embodied_in_a_Simulated_Game-Environment
This repository contains all code and data used within the experiments described in the paper “EAP Hydrogels Exhibit Emergent Learning When Embodied in a Simulated Game-Environment”. All data analysis was performed using code written in the Matlab environment, using Matlab packages, and datasets constructed in Matlab. The MEA control software was written in Python. This repository is available on Zenodo. This repository is organised into folders according to the languages used and sections of the paper.

## Matlab
### "Memory Mechanics Through Ion Migration Conductivity Measurement"
* "memory data.mat" - The dataset of current over time recorded from the adjacent electrode pair arrangement

* "MemoryDataPlot.m" - Generates figure of current over time from memoryData dataset

### "EAP Hydrogel Embodied Simulated Game-world"
* "ballDist.mat" - The datasets of simulated ball positions over time, there are 3 main datasets: ballDist_NoPaddle for no paddle so always hitting the back wall, ballDist_Paddle for a paddle that always hits the ball, ballDist_Paddle_RatioComb for a paddle that hits as much as the maximum learning paddle did in experimentation (combined form 2 smaller datasets)
* "current data 2.mat" - The datasets of recorded current for all experimental runs of the Pong game, the combined dataset of all runs is in the cell structure CombinedCurrentPlus
* "current_data_mutual_info_3.mat" - The dataset of recorded current for all experimental runs of the Pong game with additionally generated datasets for paddle anf ball positions over time though the Pong game runs
* "pong data both.mat" - The datasets of all Pong game runs performance, showing hits, misses, and rally lengths, the combined dataset of all runs is in the cell structure CombinedTablePlus

* "ballDistMatGen.m" - Generates the datasets of ball distributions
* "ballDistPlotterRatio.m" - Generates the figure of ball distributions for simulated dataset of paddle hitting ball
* "combinedPongRallyTrend.m" - Generates the trend of rally lengths with standard deviation and error
* "currentPlot.m" - Generates plot of current from each sensed region
* "CurrentPlotFull.m" - Runs GenCurrentData if needed then currentPlot
* "extractHits.m" - Counts and returns the number of hits at a given region from the provided dataset
* "GenCurrentData.m" - Takes combined current dataset and generates split raw dataset for use by currentPlot
* "paddleRandDistPlot.m" - Generates the figure of ball distributions for simulated dataset of paddle randomly hitting ball
* "stateHistogrames3D.m" - Generates heat plot of paddle states over course of Pong games
* "stateHisVar2.m" - Generates plot of number fo unique stats in the paddle and the state frequency for both the paddle and ball
* "windowAverage.m" - Applies averaging window of given size to data provided

### "Supplementary Information"
* "ballDist.mat" - The datasets of simulated ball positions over time, there are 3 main datasets: ballDist_NoPaddle for no paddle so always hitting the back wall, ballDist_Paddle for a paddle that always hits the ball, ballDist_Paddle_RatioComb for a paddle that hits as much as the maximum learning paddle did in experimentation (combined form 2 smaller datasets)
* "current data 2.mat" - The datasets of recorded current for all experimental runs of the Pong game, the combined dataset of all runs is in the cell structure CombinedCurrentPlus
* "pong baseline data.mat" - The datasets of all Pong game runs performance when the electrode placements were rearranged for a baseline comparison, showing hits, misses, and rally lengths, the combined dataset of all runs is in the cell structure CombinedTablePlus
* "pong data both.mat" - The datasets of all Pong game runs performance, showing hits, misses, and rally lengths, the combined dataset of all runs is in the cell structure CombinedTablePlus

* "ballDistMatGen.m" - Generates the datasets of ball distributions
* "ballDistPlotterRatio.m" - Generates the figure of ball distributions for simulated dataset of paddle hitting ball
* "extractHits.m" - Counts and returns the number of hits at a given region from the provided dataset
* "GenPaddleData2.m" - Generates datasets of paddle positions over time and standard deviation of paddle positions
* "hitLocs.m" - Generates plot of how many times each region is hit over the course of the Pong game runs
* "paddleTracking.m" - Plots the paddle positions and standard deviation generated from GenPaddleData2
* "pongTrendSampleSize.m" - Generates plots of data standard deviation with different number of experimental runs to show how sample size affects consistency
* "pongTrendWindowCom.m" - Generates plots showing affect of different sized averaging windows
* "rallyTrend1Ttest.m" - Generates histograms of ball positions when paddle always hits and always misses
* "stateHistogrames.m" - Generates histograms of paddle state distributions at different time instances
* "windowAverage.m" - Applies averaging window of given size to data provided

## Python
* Pong_MEA_Control - The full control code that runs the threaded Pong game and serial interface
    * "ball.py"
    * "config.py"
    * "paddle.py"
    * "plotter.py"
    * "pong.py"
    * "region.py"
    * "threadedPong.py"
* "Serial_plot2.py" - The serial data plotter used to record initial current values from the sense regions for use as a baseline

# Matlab Figure Commands list
This is a list of the figures present in the paper and the accompanying Matlab function/commands that render them.

## Memory Mechanics Through Ion Migration and Conductivity Measurement
* EAP Muscle Memory - Fig 2
    * `load('memory data.mat')`
    * `MemoryDataPlot`

## EAP Hydrogel Embodied in a Simulated Game-world
* Current Draw Learning - Fig 5.A
    * `load('current data 2.mat');`
    * `CurrentPlotFull`
* Current Draw Learning - Fig 5.B
    * `load('pong data both.mat')`
    * `combinedPongRallyTrend(CombinedTablePlus,1)`
* Paddle State Comparison Distribution - Fig 6.A
    * `load('current_data_mutual_info_3.mat')`
    * `stateHistogrames3D(paddleDataSep2, 0)`
* Paddle State Comparison Distribution - Fig 6.B.i
    * `ballDistMatGen`
    * `load('ballDist.mat')`
    * `paddleRandDistPlot(paddleRandomDist)`
* Paddle State Comparison Distribution - Fig 6.B.ii
    * `ballDistMatGen`
    * `load('ballDist.mat')`
    * `ballDistPlotterRatio(ballDist_Paddle_RatioComb,3)`
* Entropy and Variance - Fig 7
    * `load('current_data_mutual_info_3.mat')`
    * `stateHisVar2(paddleDataSep2, ballDataSep3, 0)`

## Supplementary Information
* Hit Distribution - Fig S4
    * `load('pong data both.mat')`
    * `hitLocs(CombinedTablePlus);`
* Averaging Window Sizes - Fig S5
    * `load('pong data both.mat')`
    * `pongTrendWindowCom(CombinedTablePlus)`
* Standard Deviation Stability - Fig S6
    * `load('pong data both.mat')`
    * `pongTrendSampleSize(CombinedTable)`
* Distribution Histogram - Fig S8
    * `load('pong data both.mat');`
    * `rallyTrend1Ttest(CombinedTablePlus);`
* Paddle State Distribution - Fig S9
    * `load('current_data_mutual_info_3.mat')`
    * `stateHistogrames(paddleDataSep2, 0)`
* Position of Paddle - Fig S10
    * `load('current data 2.mat');`
    * `paddleData = GenPaddleData2(CombinedCurrentPlus,defults);`
    * `paddleTracking(paddleData);`
* Standard Deviation Stability Baseline - Fig S11
    * `load('pong baseline data.mat')`
    * `pongTrendSampleSize(CombinedTable)`
* Simulated Hit and Miss - Fig S12.A
    * `ballDistMatGen`
    * `load('ballDist.mat')`
    * `ballDistPlotterRatio(ballDist_NoPaddle,2)`
* Simulated Hit and Miss - Fig S12.B
    * `ballDistMatGen`
    * `load('ballDist.mat')`
    * `ballDistPlotterRatio(ballDist_Paddle,1)`
* Baseline Learning - Fig S13
    * `load('pong baseline data.mat')`
    * `combinedPongRallyTrend(CombinedBaseTable,0)`
