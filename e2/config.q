/#######################
/  Configuration  File
/#######################


/ Paths
.path.root: "" / absolute path to the e2 folder. getenv`E2_ROOT
.path.data: .path.root,"/data/";
.path.src: .path.root,"/src/";
fxTableSaveDir: `$.path.data,"fxTable.csv"            
fxTableDir:`$.path.data,"fxTable.csv"               / Relative path to the fxTable data file


/ Mock data params
entriesPerFxPair: 1000                       / Number of entries to generate per FX pair
minTxQty: 10                                   / Minimum quantity of transaction
maxTxQty: 1000                                 / Maximum quantity of transaction
startTimestamp: 2023.01.01T12:00:00.000000000  / Starting timestamp for mock data


/ API Settings
port: 5000                                     / Port for the API service
apiConnection: `::5000

