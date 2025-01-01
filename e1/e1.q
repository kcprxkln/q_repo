
/ Generate a vector of times with 2-second intervals
times: .z.t + 0D00:00:02 * til 10

/ Setting the seed for reproducible randomness.
\S 101

/ Function to drop all smaller values than a random selection from the vector.
/ Assumes input is sorted in ascending order for correct behavior
dropBeforeRandom:{
  idx: 1?count x; / Get random index 
  x: idx _ x;     / Drop earlier elements (ascending order of vector ensures the correctness of the filtering operation)
  x}

/ Apply filter 
times: dropBeforeRandom tim es
times
