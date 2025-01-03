
\P 16   
\S 12

/ $$$$$$$$$$$$$$$$$$$$$$$$$ TIME VECTORS GENERATION $$$$$$$$$$$$$$$$$$$$$$$$$$$$$

TS_START: 2023.01.01D12:00:00.000000000 / starting time for generated data
DATA_LEN: 10                            / how many records should the data have?

// Generates a vector of timestamps sorted in ascending order.
/ x -> starting timestamp 
/ y -> length of vector that we want to generate
genTimeSeriesVector:{
  tsv: (x + `timespan$1e9 * til y) + `timespan$y?1e6; 
  tsv}

/ $$$$$$$$$$$$$$$$$$$$$$$$ PRICES VECTORS GENERATION $$$$$$$$$$$$$$$$$$$$$$$$$$$$$

DATA_LEN: 10
STARTING_PRICES: `EURUSD`USDJPY`GBPUSD`USDCHF!1.20 115.0 1.35 0.95 
/ to avoid issues with floating point numbers, we are using INTs. For above pairs, 4-decimal precision is enough.
STARTING_PRICES: `int$(STARTING_PRICES * 1000000) 


/ Generates vector of prices adding noise (randomness), and a fixed upward trend
/ x -> initial price
/ y -> length of returned vector
/ z -> max random component
genPricesVec:{
  [x; y; z; trend]
  changesVec: y?z - til (z*2);  / Generate random changes vector, within a specified range
  prices: x + changesVec + `int$trend * til y}


/ ################## TX SIZES VECTOR GENERATION  #####################


/ Generates vector of transaction sizes
/ x -> vector lenth 
/ y -> min qty 
/ z -> max qty 
genTxQtyVec:{
  posQtys: y + til (z - y) + 1; / inclusive right bound
  qtyVec: x?posQtys}


/ ################## TABLES GENERATION #####################

/ example table generation

/ gen table for `EURUSD pair
timeVec: genTimeSeriesVector[TS_START; DATA_LEN]
eurusd: STARTING_PRICES`EURUSD
pairName: DATA_LEN#(`EURUSD)
pricesVec: genPricesVec[eurusd; DATA_LEN; 1000; 0.1]
qtyVec: genTxQtyVec[DATA_LEN; 1; 100]

eurusdTable: ([]time:timeVec;symbol:pairName;price:pricesVec;qty:qtyVec)


/ gen table for `USDJPY pair
timeVec2: genTimeSeriesVector[TS_START; DATA_LEN]
usdjpy: STARTING_PRICES`USDJPY
pairName2: DATA_LEN#(`USDJPY)
pricesVec2: genPricesVec[usdjpy; DATA_LEN; 1000; 0.2]
qtyVec2: genTxQtyVec[DATA_LEN; 1; 100]

usdjpyTable: ([]time:timeVec2;symbol:pairName2;price:pricesVec2;qty:qtyVec2)


/ merge tables and sort by time in asc order
fxTable: `time xasc raze (usdjpyTable; eurusdTable)

save `$"../data/fxTable.csv"
