/ IPC communication, 
/ CSV stored in-memory 

/ VMAP (volume-weighted average price)
/ 1. group by symbol
/ 2. price * volume for each row
/ 3. divide by count

tStart: 2023.01.01D12:00:00.000000000 
tStop: 2023.01.10D12:00:00.000000000 

pairs: (`EURUSD)

/ something like that
select vwap: sum(price * qty) % sum qty by symbol from fxTable where time > tStart, time < tStop, symbol in pairs

