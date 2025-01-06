\l ../config.q

/ load /src/generateMockFxData.q
dir: .path.src, "generateMockFxData.q"
path: "l ", dir
system path

/ Test genTimeSeriesVec
testGenTimeSeriesVec:{
  start: 2024.01.01D00:00:00.000000000;
  len: 5;
  data: genTimeSeriesVector[start;len];
  dataType: type data[0];
  correctType: dataType~type 2024.01.01D00:00:00.000000000;
  correctOrder: data~asc data;  / checks if the data is sorted in ascending order
  correctLength: len~count data;
  result: correctType & correctLength & correctOrder;
  result}


/ Test genPricesVec
testGenPricesVec:{
  start: 1200000;  
  len: 5;
  maxChange: 1000;
  trend: 0.2;
  data: genPricesVec[start;len;maxChange;trend];
  dataType: type data[0];
  correctType: dataType~type `long$1;
  correctLength: len~count data;
  result: correctType & correctLength}


/ Test genTxQtyVec
testGenTxQtyVec:{
  len: 5;
  minQty: 100;
  maxQty: 1000;
  data: genTxQtyVec[len;minQty;maxQty];
  dataType: type data[0];
  correctType: dataType~type `long$1; 
  correctLength: len~count data;
  correctRange: ((max data)<=maxQty) & ((min data)>=minQty); / test if all quantities are within available range
  result: correctType & correctRange & correctLength}


/ test results table
genTestResults: ([] 
  functionName: `symbol$();
  output: `boolean$()) / 1 - success, 0 - fail

/ function to run the tests and store them in table
runTests:{ 
  `genTestResults insert (`testGenTimeSeriesVec; testGenTimeSeriesVec[]);
  `genTestResults insert (`testGenPricesVec; testGenPricesVec[]);
  `genTestResults insert (`testGenTxQtyVec; testGenTxQtyVec[])}

/ fun the tests and save them in csv file
runTests[]
save `$"genTestResults.csv"
select from genTestResults