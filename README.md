# EAP_Hydrogels_Exhibit_Emergent_Learning_When_Embodied_in_a_Simulated_Game-Environment
This repository contains all code and data used within the experiments described in the paper “EAP Hydrogels Exhibit Emergent Learning When Embodied in a Simulated Game-Environment”. All data analysis was performed using code written in the Matlab environment, using Matlab packages, and datasets constructed in Matlab. The MEA control software was written in Python, with Arduino code used to run the hydrogel interfacing hardware. This repository also includes an example video recording of the pong game. This repository is available on Zenodo. This repository is organised into folders according to the languages used and sections of the paper.

## Example Video
Each run of the pong game generates a screen recording of the simulated pong game. The video "Example Run.mp4" is one of the recordings generated through the experiments undertaken during the research this repository belongs to. For the purposes of storage capacity, the videos speed is quadrupled, and quality is compressed. This video shows the results of a default learning experiment, where the performance gradually improves thought he course of the game to a point.

## Matlab
### "Memory Mechanics Through Ion Migration Conductivity Measurement"
* "memory data.mat" - The dataset of current over time recorded from the adjacent electrode pair arrangement

* "MemoryDataPlot.m" - Generates figure of current over time from memoryData dataset

### "EAP Hydrogel Embodied Simulated Game-world"
* "ballDist.mat" - The datasets of simulated ball positions over time, there are 3 main datasets: ballDist_NoPaddle for no paddle so always hitting the back wall, ballDist_Paddle for a paddle that always hits the ball, ballDist_Paddle_RatioComb for a paddle that hits as much as the maximum learning paddle did in experimentation (combined form 2 smaller datasets)
* "current data 2.mat" - The datasets of recorded current for all experimental runs of the Pong game, the combined dataset of all runs is in the cell structure CombinedCurrentPlus
* "current_data_mutual_info_3.mat" - The dataset of recorded current for all experimental runs of the Pong game with additionally generated datasets for paddle and ball positions over time through the Pong game runs
* "pong data both.mat" - The datasets of all Pong game runs performance, showing hits, misses, and rally lengths, the combined dataset of all runs is in the cell structure CombinedTablePlus
* "pong baseline data.mat" - The datasets of all Pong game runs performance when the electrode placements were rearranged for a baseline comparison, showing hits, misses, and rally lengths, the combined dataset of all runs is in the cell structure CombinedTablePlus
* "simulation_data.mat" - The datasets of all Pong game runs performance when the inhibited sensing data simulation for control comparison, showing hits, misses, and rally lengths, the combined dataset of all runs is in the cell structure CombinedSimTable

* "ballDistMatGen.m" - Generates the datasets of ball distributions
* "ballDistPlotterRatio.m" - Generates the figure of ball distributions for simulated dataset of paddle hitting ball
* "combinedPongRallyTrend.m" - Generates the trend of rally lengths with standard deviation and error
* "currentPlot.m" - Generates plot of current from each sensed region
* "CurrentPlotFull.m" - Runs GenCurrentData if needed then currentPlot
* "extractHits.m" - Counts and returns the number of hits at a given region from the provided dataset
* "extractRallys.m" - Counts and returns the length of hit rallys from the provided dataset
* "gameSimulation.m" - Simulates the pong game using the surrogate dataset generated via live recorded data
* "GenCurrentData.m" - Takes combined current dataset and generates split raw dataset for use by currentPlot
* "genSimData.m" - Generates the surrogate dataset, for use in the control simulation, from the live recorded data
* "paddleRandDistPlot.m" - Generates the figure of ball distributions for simulated dataset of paddle randomly hitting ball
* "stateHistogrames3D.m" - Generates heat plot of paddle states over course of Pong games
* "stateHisVar2.m" - Generates plot of number fo unique stats in the paddle and the state frequency for both the paddle and ball
* "windowAverage.m" - Applies averaging window of given size to data provided

### "Supplementary Information"
* "ballDist.mat" - The datasets of simulated ball positions over time, there are 3 main datasets: ballDist_NoPaddle for no paddle so always hitting the back wall, ballDist_Paddle for a paddle that always hits the ball, ballDist_Paddle_RatioComb for a paddle that hits as much as the maximum learning paddle did in experimentation (combined form 2 smaller datasets)
* "current data 2.mat" - The datasets of recorded current for all experimental runs of the Pong game, the combined dataset of all runs is in the cell structure CombinedCurrentPlus
* "pong baseline data.mat" - The datasets of all Pong game runs performance when the electrode placements were rearranged for a baseline comparison, showing hits, misses, and rally lengths, the combined dataset of all runs is in the cell structure CombinedTablePlus
* "pong data both.mat" - The datasets of all Pong game runs performance, showing hits, misses, and rally lengths, the combined dataset of all runs is in the cell structure CombinedTablePlus
* "simulation_data.mat" - The datasets of all Pong game runs performance when the inhibited sensing data simulation for control comparison, showing hits, misses, and rally lengths, the combined dataset of all runs is in the cell structure CombinedSimTable

* "ballDistMatGen.m" - Generates the datasets of ball distributions
* "ballDistPlotterRatio.m" - Generates the figure of ball distributions for simulated dataset of paddle hitting ball
* "combinedPongRallyTrend.m" - Generates the trend of rally lengths with standard deviation and error
* "combinedPongRallyTrendAces.m" - Generates the trend of rally ace lengths with standard deviation and error
* "extractAces.m" - Counts and returns the length of rallys aces from the provided dataset
* "extractHits.m" - Counts and returns the number of hits at a given region from the provided dataset
* "extractRallys.m" - Counts and returns the length of hit rallys from the provided dataset
* "GenPaddleData2.m" - Generates datasets of paddle positions over time and standard deviation of paddle positions
* "hitLocs.m" - Generates plot of how many times each region is hit over the course of the Pong game runs
* "hitPositions.m" - Generates pie chart of distributions of misses and hit within the experimental runs
* "mapCurrent.m" - Maps current values from a given range to between 0 and 1
* "paddleTracking.m" - Plots the paddle positions and standard deviation generated from GenPaddleData2
* "paddleTrend.m" - Generates a dataset of paddle positions from region current values using baseline current measurements
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

## Arduino
* "Array_Driver.ino" - The arduino code that communicates with the python script via serial, and coordinates the relays and sensor communication.

# Matlab Figure Commands list
This is a list of the figures present in the paper and the accompanying Matlab function/commands that render them.

## Memory Mechanics Through Ion Migration and Conductivity Measurement
* EAP Muscle Memory - Fig 2
    * `load('memory data.mat')`
    * `MemoryDataPlot`

## EAP Hydrogel Embodied in a Simulated Game-world
* Current Draw Learning - Fig 6.A
    * `load('current data 2.mat');`
    * `CurrentPlotFull`
* Current Draw Learning - Fig 6.B
    * `load('pong data both.mat')`
    * `combinedPongRallyTrend(CombinedTablePlus,1)`
* Paddle State Comparison Distribution - Fig 7.A
    * `load('current_data_mutual_info_3.mat')`
    * `stateHistogrames3D(paddleDataSep2, 0)`
* Paddle State Comparison Distribution - Fig 7.B.i
    * `ballDistMatGen`
    * `load('ballDist.mat')`
    * `paddleRandDistPlot(paddleRandomDist)`
* Paddle State Comparison Distribution - Fig 7.B.ii
    * `ballDistMatGen`
    * `load('ballDist.mat')`
    * `ballDistPlotterRatio(ballDist_Paddle_RatioComb,3)`
* Entropy and Variance - Fig 8
    * `load('current_data_mutual_info_3.mat')`
    * `stateHisVar2(paddleDataSep2, ballDataSep3, 0)`
* Baseline Learning - Fig 9.A
    * `load('simulation_data.mat')`
    * `combinedPongRallyTrend(CombinedSimTable,0)`
* Baseline Learning - Fig 9.B
    * `load('pong baseline data.mat')`
    * `combinedPongRallyTrend(CombinedBaseTable,0)`

## Supplementary Information
* Hit Distribution - Fig S4
    * `load('pong data both.mat')`
    * `hitLocs(CombinedTablePlus);`
* Live Hit Distribution - Fig S5
    * `load('pong data both.mat')`
    * `hitPositions(CombinedTablePlus)`
* Averaging Window Sizes - Fig S6
    * `load('pong data both.mat')`
    * `pongTrendWindowCom(CombinedTablePlus)`
* Standard Deviation Stability - Fig S7
    * `load('pong data both.mat')`
    * `pongTrendSampleSize(CombinedTable)`
* Distribution Histogram - Fig S9
    * `load('pong data both.mat');`
    * `rallyTrend1Ttest(CombinedTablePlus);`
* Aces Learning - Fig S10
    * `load('pong data both.mat');`
    * `combinedPongRallyTrendAces(CombinedTablePlus)`
* Paddle State Distribution - Fig S11
    * `load('current_data_mutual_info_3.mat')`
    * `stateHistogrames(paddleDataSep2, 0)`
* Position of Paddle - Fig S12
    * `load('current data 2.mat');`
    * `paddleData = GenPaddleData2(CombinedCurrentPlus,defults);`
    * `paddleTracking(paddleData);`
* Standard Deviation Stability Baseline Sensing Impaired - Fig S13
    * `load('simulation_data.mat')`
    * `pongTrendSampleSize(CombinedSimTable)`
* Standard Deviation Stability Baseline Stimulation Impaired - Fig S14
    * `load('pong baseline data.mat')`
    * `pongTrendSampleSize(CombinedBaseTable)`
* Simulated Hit and Miss - Fig S15.A
    * `ballDistMatGen`
    * `load('ballDist.mat')`
    * `ballDistPlotterRatio(ballDist_NoPaddle,2)`
* Simulated Hit and Miss - Fig S15.B
    * `ballDistMatGen`
    * `load('ballDist.mat')`
    * `ballDistPlotterRatio(ballDist_Paddle,1)`
* Aces Learning Control  - Fig S13.A
    * `load('simulation_data.mat')`
    * `combinedPongRallyTrendAces(CombinedSimTable)`
* Aces Learning Control  - Fig S13.B
    * `load('pong baseline data.mat')`
    * `combinedPongRallyTrendAces(CombinedBaseTable)`
