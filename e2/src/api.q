/ load configuration file
\l ../config.q 

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
/ x = list of FX pairs (symbols) to calculate VWAP for (11)
/ y = start timestamp of the time range (-12)
/ z = end timestamp of the time range (-12)
/ callback = callback function to return the result asynchronously
calcVwapBySymAsync:{[x; y; z; callback]
  / Validate input types
  if[(abs type[x])<>11; (neg .z.w) (callback; `type_error`invalid_x); :()];
  if[type[y]<>-12; (neg .z.w) (callback; `type_error`invalid_y); :()];
  if[type[z]<>-12; (neg .z.w) (callback; `type_error`invalid_z); :()];

  res: select vwap: `long$qty wavg price by sym from fxTable where timeStamp within (y;z), sym in x; / calculate VWAP 
  (neg .z.w) (callback; res)} / send result asynchronously

/ sync version for testing purposes 
calcVwapBySymSync:{[x;y;z]
  if[(abs type[x])<>11h; :`type_error`invalid_x];
  if[type[y]<>-12h; :`type_error`invalid_y];
  if[type[z]<>-12h; :`type_error`invalid_z];
  select vwap:`long$qty wavg price by sym from fxTable where timeStamp within (y;z),sym in x}

/ Use the port provided in the config file
defaults:enlist[`p]!enlist port
system "p ",string .Q.def[defaults;.Q.opt .z.X]`p
\p
