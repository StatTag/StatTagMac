clear


**>>>ST:Value(Label="checking to see if tag name saves", Frequency="On Demand", Type="Default")
local aaa 339
display `aaa'
**<<<



**>>>ST:Value(Label="macro test 2", Frequency="Always", Type="Numeric", Decimals=3, Thousands=True)
local x 339
display `x'
**<<<

**>>>ST:Value(Label="on demand macro", Frequency="On Demand", Type="Numeric", Decimals=2, Thousands=False)
local y 3
display `y'
**<<<

**>>>ST:Value(Label="macro test", Frequency="Always", Type="Numeric", Decimals=2, Thousands=True)
local z 6002
display `z'
**<<<

**>>>ST:Value(Label="macro test 3", Frequency="Always", Type="Numeric", Decimals=3, Thousands=True)
local d 6002.12345
display `d'
**<<<

**>>>ST:Value(Label="macro percent", Frequency="Always", Type="Percentage", Decimals=3)
local a 97
display `a'
**<<<

**>>>ST:Value(Label="my new first tag", Frequency="On Demand", Type="Numeric", Decimals=3, Thousands=True)
local b 97
display `b'
**<<<

matrix A = (3,4\4,8\6,16)
matrix list A
**>>>ST:Table(Label="tmp", Frequency="Always", ColumnNames=False, RowNames=False, Type="Numeric", AllowInvalid=True, Decimals=0, Thousands=True)
matrix list A
**<<<


**>>>ST:Table(Label="tmpShowRowsAndCols", Frequency="Always", ColumnNames=True, RowNames=True, Type="Numeric", AllowInvalid=True, Decimals=0, Thousands=True)
matrix list A
**<<<

**>>>ST:Value(Label="macro date", Frequency="Always", Type="DateTime", DateFormat="MMMM dd, yyyy", TimeFormat="HH:mm")
local c = mdy(11, 20, 2010)
display `c'
**<<<

**>>>ST:Figure(Label="sample figure", Frequency="On Demand", Type="Figure")
graph export "/Users/ewhitley/Desktop/chartoftheday_3171_Apples_Historic_Quarterly_Earnings_n.jpg", as(pdf), replace
**<<<

**>>>ST:Figure(Label="my new first test figure tag", Frequency="On Demand")
graph export "/Users/ewhitley/Desktop/chartoftheday_3171_Apples_Historic_Quarterly_Earnings_n.jpg", as(pdf), replace
**<<<

