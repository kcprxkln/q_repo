/ load configuration file
\l config.q 

/ List of functions that can be called from clients
.auth.allowedFunctions:`calcVwapBySymAsync

/ Handler for unauthorized calls on synchronous functions
.z.pg:{[x]
    if[not first[x] in .auth.allowedFunctions; 
      '`$"Access denied: Function not authorized"
    ];
    value x
 }

/ Handler for unauthorized calls on asynchronous functions
.z.ps:{[x]
  if[not first[x] in .auth.allowedFunctions; 
    (neg .z.w)({-1 "Access denied: Function not authorized"};());
    :() 
  ];
  value x
 }

/ Load FX data to memory for lower latency
fxTable: ("psjj";enlist",") 0: fxTableDir

/ Calculates the Volume Weighted Average Price (VWAP) for the given time range and symbols.
/ x = list of FX pairs (symbols) to calculate VWAP for
/ y = start timestamp of the time range
/ z = end timestamp of the time range
/ callback = callback function to return the result asynchronously
calcVwapBySymAsync:{[x; y; z; callback]
  res: select vwap: `long$qty wavg price by sym from fxTable where timeStamp within (y;z), sym in x; / calculate VWAP 
  (neg .z.w) (callback; res)} / send result asynchronously    


/ Use the port provided in the config file
defaults:enlist[`p]!enlist port
system "p ",string .Q.def[defaults;.Q.opt .z.X]`p
\p
