\l ../config.q

/ load /src/generateMockFxData.q
dir: .path.src, "api.q"
path: "l ", dir
system path

/ Test sync version 
testCalcVwapBySymSync:{
  syms:`EURUSD`USDJPY;
  start:2024.01.01D00:00:00.000000000;
  end:2024.01.02D00:00:00.000000000;
  testSymType:calcVwapBySymSync["EURUSD";start;end] ~ `type_error`invalid_x;
  testStartType:calcVwapBySymSync[syms;`start;end] ~ `type_error`invalid_y;
  testEndType:calcVwapBySymSync[syms;start;`end] ~ `type_error`invalid_z;
  testSymType & testStartType & testEndType}

apiTestResults:([] functionName:`symbol$(); output:`boolean$())
runTests:{`apiTestResults insert (`testCalcVwapBySymSync; testCalcVwapBySymSync[])}
runTests[]  

save `$"apiTestResults.csv"
select from apiTestResults