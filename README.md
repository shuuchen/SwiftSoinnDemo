# SwiftSoinnDemo
A Soinn demo implemented in Swift.

## Introduction
Soinn is Self-organized Incremental Neural Network. It is 
 * An unsuperveised clustering algorithm
  * Learning the cluster and topology of input data
  * Output data is only a small portion of input data
 * Especially good at on-line learning with continuous data input
 * Perfectly suitable for smartphone apps that can learn from users' everyday data

<p>
  <img src="https://github.com/shuuchen/SwiftSoinnDemo/blob/master/result03.png" height="689" width="375"  />
</p>

## About the example
As shown above, in the upper half of the screen, 27027 signals are input one by one and learned incrementally. The output in the lower half of the screen shows that the clusters and topology of the input are learned correctly with only 298 signals. The example is implemented in the file SignalView.swift.

## How to use
Just copy the file Soinn.swift to your own project directory and use the APIs in it for your own learning task. 

## Requirements
* Xcode 7.3.1 +
* Swift 2 +
* iOS 9 +

## About the APIs
Member functions 
* inputSignal() is the main learning function. It accepts one input signal at one time to determine which cluster it belongs to.

Member variables 
* outSignals and edges are the output of learning. They contain the signals and edges of the learned clusters.

## About the parameters
It is well known that directly using a learning model without parameter tuning may not generate good results. Soinn is not an exception. It has two parameters for you to tune to optimize the result
* EDGE_AGE_MAX determines that after how many learning rounds the old edges should be removed.
* SIGNAL_DELETE_INTERVAL determines that after how many learning rounds the old signals should be removed.

## About the implementation
The current version is an implementation of the paper
* "An incremental network for on-line unsupervised classification and topology learning" by S Furao, O Hasegawa

## To do
The enhanced version
* "An enhanced self-organizing incremental neural network for online unsupervised learning" by S Furao, T Ogura, O Hasegawa

## License
MIT
