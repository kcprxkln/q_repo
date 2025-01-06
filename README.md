The following repo is example of q code that we can split into two separate parts: 
- **e1** - simple example of code in q 
- **e2** - *mini-project* with mock data generation, asynchronous api, and tests for the code.
```
├── e1
│   └── e1.q
└── e2
    ├── config.q
    ├── data
    │   └── fxTable.csv
    ├── src
    │   ├── api.q
    │   └── generateMockFxData.q
    └── tests
        ├── test_api.q
        └── test_generateMockFxData.q
```

## Start 

First of all, please ensure that you have provided the absolute path to the e2 folder in the `/e2/config.q` file. 
```
/ Paths

.path.root: "" < absolute path to the e2 folder
.path.data: .path.root,"/data/";
.path.src: .path.root,"/src/";

```
It might be worth to use os environment instead (*getenv`envname*), but for my convenience, I used the following approach.
## Data generation

`fxTable.csv` file can be generated in two ways: 

1. By running `generateMockFxData.q` script
```
/e2/src> q generateMockFxData.q
```

2. Running `test_generateMockFxData.q` script
```
/e2/src> q test_generateMockFxData.q
```

#### Data Structure of `fxTable.csv`
| Column      | q Datatype | Description                    |
| ----------- | ---------- | ------------------------------ |
| `timeStamp` | -12h       | Timestamp in UTC               |
| `sym`       | 11h        | FX Pair Symbol (e.g., `USDJPY) |
| `price`     | -7h        | Price of the FX Pair           |
| `qty`       | -7h        | Trade Quantity                 |

## Tests

Tests can be run directly from the test directory.
```
/e2/tests> q test_generateMockFxData.q
```
A CSV file containing test results will be saved in the same directory. File should contain functions' names, and value `0` or `1` indicating if all of the test for that function passed. 

## How to use the API server?

Go to the `e2/src/` folder and run command:
```
/e2/src> q api.q
```
The server will run automatically on port provided in `config.q` file.


After that, you can connect to the port from different q process and run calls:

open new q process, write in console:
```
/your/path> q
```
Connect to the server using port (Replace `<port>` with the port number from `config.q`)
```
q) h: hopen `::<port>
```
 
Call *`calcVwapBySymAsync* method with the following arguments:
- `symbols` (-11h, 11h) - FX Pair symbol or List of FX Pair symbols. 
- `start time` (-12h) - Start timestamp for the query range. 
- `end time` (-12h) - End timestamp for the query range.
- `callback` (function) - Function to handle the async response.
```
(neg h) (`calcVwapBySymAsync; `USDJPY`EURUSD; 2023.01.01D12:00:00.000347123; 2023.01.01D12:01:22.000546493; {show x})
```
If the provided data was valid, in response you should get a table containing a fx pairs and their Volume Weighted Average Price. If any of arguments will have incorrect datatype, you will see that in response as well e.g.
```
 `type_error`invalid_x
```

**Please note that the API has implemented security mechanism to ensure that only allowed functions can be run, if you want to create your own methods, remember to add them to the code.**
```
.auth.allowedFunctions:`calcVwapBySymAsync
```

## Config

Config allows you to change params for paths, mock data generation and API settings. 
