/ seed used for reproducible result
\S 12 

/ Load variables from configuration file
\l config.q 


/ TIME VECTORS GENERATION 

// Generates a vector of timestamps sorted in ascending order.
/ x = start timestamp 
/ y = length of vector that we want to generate
genTimeSeriesVector:{
  tsv: (x + `timespan$1e9 * til y) + `timespan$y?1e6; 
  tsv}


/ PRICES VECTORS GENERATION

const.startingPrices: `EURUSD`USDJPY`GBPUSD!1.20 115.0 1.35
/ to avoid issues with floating point numbers, we are using INTs. For above pairs, 4-decimal precision is enough.
const.startingPrices: `int$(const.startingPrices * 1000000) 

/ Generates vector of prices with simulated randomness and a linear upward trend.
/ x = initial price
/ y = length of returned vector
/ z = maximum random component (simulated using a uniform distribution)
/ trend = linear trend added to the generated data
genPricesVec:{
  [x; y; z; trend]
  changesVec: y?z - til (z*2);  / Generate random changes vector, within a specified range
  prices: x + changesVec + `int$trend * til y}


/ TX SIZES VECTOR GENERATION

/ Generates vector of transaction sizes
/ x = length of returned lenth 
/ y = min qty 
/ z = max qty 
genTxQtyVec:{
  posQtys: y + til (z - y) + 1; / inclusive right bound
  qtyVec: x?posQtys}


/  TABLES GENERATION

/ values from config file  
const.startTimestamp: startTimestamp     / starting time series 
const.nrOfEntries: entriesPerFxPair      / number of entries for each fx pair
const.minTxQty: minTxQty
const.maxTxQty: maxTxQty

/ gen table for `EURUSD pair
eurusd: const.startingPrices`EURUSD
eurusdTable: ([]
  timeStamp:genTimeSeriesVector[const.startTimestamp; const.nrOfEntries];
  sym:const.nrOfEntries#(`EURUSD);
  price:genPricesVec[eurusd; const.nrOfEntries; 1000; 0.2];
  qty:genTxQtyVec[const.nrOfEntries; const.minTxQty; const.maxTxQty])

/ gen table for `USDJPY pair
usdjpy: const.startingPrices`USDJPY
usdjpyTable: ([]
  timeStamp:genTimeSeriesVector[const.startTimestamp; const.nrOfEntries];
  sym:const.nrOfEntries#(`USDJPY);
  price:genPricesVec[usdjpy; const.nrOfEntries; 1000; 0.2];
  qty:genTxQtyVec[const.nrOfEntries; const.minTxQty; const.maxTxQty])

/ gen table for `GBPUSD pair
gbpusd: const.startingPrices`GBPUSD
gbpusdTable: ([]
  timeStamp:genTimeSeriesVector[const.startTimestamp; const.nrOfEntries];
  sym:const.nrOfEntries#(`GBPUSD);
  price:genPricesVec[gbpusd; const.nrOfEntries; 1000; 0.15];
  qty:genTxQtyVec[const.nrOfEntries; const.minTxQty; const.maxTxQty])


/ merge tables and sort by timestamp in asc order
fxTable: `timeStamp xasc raze (usdjpyTable; eurusdTable; gbpusdTable)

save fxTableSaveDir
