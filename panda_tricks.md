# Python Pandas Tips and Tricks

<i>[source](https://www.dataschool.io/python-pandas-tips-and-tricks/)</i>

<div id="content" role="main">

---

## Categories

- [Python Pandas Tips and Tricks](#python-pandas-tips-and-tricks)
  - [Categories](#categories)
  - [Reading files](#reading-files)
  - [Reading from the web](#reading-from-the-web)
  - [Creating example DataFrames](#creating-example-dataframes)
  - [Creating columns](#creating-columns)
  - [Renaming columns](#renaming-columns)
  - [Selecting rows and columns](#selecting-rows-and-columns)
  - [Filtering rows by condition](#filtering-rows-by-condition)
  - [Manipulating strings](#manipulating-strings)
  - [Working with data types](#working-with-data-types)
  - [Encoding data](#encoding-data)
  - [Extracting data from lists](#extracting-data-from-lists)
  - [Working with time series data](#working-with-time-series-data)
  - [Handling missing values](#handling-missing-values)
  - [Using aggregation functions](#using-aggregation-functions)
  - [Using cumulative functions](#using-cumulative-functions)
  - [Random sampling](#random-sampling)
  - [Merging DataFrames](#merging-dataframes)
  - [Styling DataFrames](#styling-dataframes)
  - [Exploring a dataset](#exploring-a-dataset)
  - [Handling warnings](#handling-warnings)
  - [Other](#other)

## Reading files

> 🐼🤹‍♂️ pandas trick:
>
> 5 useful "read_csv" parameters that are often overlooked:
>
> ➡️ names: specify column names  
> ➡️ usecols: which columns to keep  
> ➡️ dtype: specify data types  
> ➡️ nrows: \# of rows to read  
> ➡️ na_values: strings to recognize as
> NaN[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw)
>
> — Kevin Markham (@justmarkham)
> [August 19, 2019](https://twitter.com/justmarkham/status/1163533800841928711?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> ⚠️ Got bad data (or empty rows) at the top of your CSV file? Use these
> read_csv parameters:
>
> ➡️ header = row number of header (start counting at 0)  
> ➡️ skiprows = list of row numbers to skip
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/t1M6XkkPYG](https://t.co/t1M6XkkPYG)
>
> — Kevin Markham (@justmarkham)
> [September 3, 2019](https://twitter.com/justmarkham/status/1168930165658914816?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Two easy ways to reduce DataFrame memory usage:  
> 1\. Only read in columns you need  
> 2\. Use 'category' data type with categorical data.
>
> Example:  
> df = <https://t.co/Ib52aQAdkA>\_csv('file.csv', usecols=\['A', 'C',
> 'D'\],
> dtype={'D':'category'})[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw)
>
> — Kevin Markham (@justmarkham)
> [June 21, 2019](https://twitter.com/justmarkham/status/1142059583835447296?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> You can read directly from a compressed file:  
> df = <https://t.co/Ib52aQAdkA>\_csv('https://t.co/3JAwA8h7FJ')
>
> Or write to a compressed
> file:<https://t.co/ySXYEf6MjY>\_csv('https://t.co/3JAwA8h7FJ')
>
> Also supported: .gz, .bz2,
> .xz[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw)
>
> — Kevin Markham (@justmarkham)
> [July 4, 2019](https://twitter.com/justmarkham/status/1146764820697505792?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Are your dataset rows spread across multiple files, but you need a
> single DataFrame?
>
> Solution:  
> 1\. Use glob() to list your files  
> 2\. Use a generator expression to read files and concat() to combine
> them  
> 3\. 🥳
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/qtKpzEoSC3](https://t.co/qtKpzEoSC3)
>
> — Kevin Markham (@justmarkham)
> [June 20, 2019](https://twitter.com/justmarkham/status/1141697969131065344?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Need to quickly get data from Excel or Google Sheets into pandas?
>
> 1\. Copy data to clipboard  
> 2\. df = <https://t.co/Ib52aQAdkA>\_clipboard()  
> 3\. 🥳
>
> See example 👇
>
> Learn 25 more tips & tricks:
> <https://t.co/6akbxXG6SI>[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/M2Yw0NAXRe](https://t.co/M2Yw0NAXRe)
>
> — Kevin Markham (@justmarkham)
> [July 15, 2019](https://twitter.com/justmarkham/status/1150752152811462656?ref_src=twsrc%5Etfw)

## Reading from the web

> 🐼🤹‍♂️ pandas trick:
>
> Want to read a JSON file from the web? Use read_json() to read it
> directly from a URL into a DataFrame\! 😎
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/gei6eeudiq](https://t.co/gei6eeudiq)
>
> — Kevin Markham (@justmarkham)
> [September 9, 2019](https://twitter.com/justmarkham/status/1171054819584462848?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick \#68:
>
> Want to scrape a web page? Try read_html()\!
>
> Definitely worth trying before bringing out a more complex tool
> (Beautiful Soup, Selenium, etc.)
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/sPKrea9wk1](https://t.co/sPKrea9wk1)
>
> — Kevin Markham (@justmarkham)
> [September 18, 2019](https://twitter.com/justmarkham/status/1174319137767575552?ref_src=twsrc%5Etfw)

## Creating example DataFrames

> 🐼🤹‍♂️ pandas trick:
>
> Need to create an example DataFrame? Here are 3 easy options:
>
> pd.DataFrame({'col_one':\[10, 20\], 'col_two':\[30, 40\]})  
> pd.DataFrame(np.random.rand(2, 3), columns=list('abc'))  
> pd.util.testing.makeMixedDataFrame()
>
> See output
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/SSlZsd6OEj](https://t.co/SSlZsd6OEj)
>
> — Kevin Markham (@justmarkham)
> [June 28, 2019](https://twitter.com/justmarkham/status/1144593270149959682?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Need to create a DataFrame for testing?
>
> pd.util.testing.makeDataFrame() ➡️ contains random values  
> .makeMissingDataframe() ➡️ some values missing  
> .makeTimeDataFrame() ➡️ has DateTimeIndex  
> .makeMixedDataFrame() ➡️ mixed data
> types[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw)
>
> — Kevin Markham (@justmarkham)
> [July 10, 2019](https://twitter.com/justmarkham/status/1148940650492170241?ref_src=twsrc%5Etfw)

## Creating columns

> 🐼🤹‍♂️ pandas trick:
>
> Want to create new columns (or overwrite existing columns) within a
> method chain? Use "assign"\!
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/y0wEfbz0VA](https://t.co/y0wEfbz0VA)
>
> — Kevin Markham (@justmarkham)
> [September 17, 2019](https://twitter.com/justmarkham/status/1173995596631478272?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Need to create a bunch of new columns based on existing columns? Use
> this pattern:
>
> for col in df.columns:  
> df\[f'{col}\_new'\] = df\[col\].apply(my_function)
>
> See example 👇
>
> Thanks to
> [@pmbaumgartner](https://twitter.com/pmbaumgartner?ref_src=twsrc%5Etfw)
> for this
> trick\![\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/7qvKn9UypE](https://t.co/7qvKn9UypE)
>
> — Kevin Markham (@justmarkham)
> [September 16, 2019](https://twitter.com/justmarkham/status/1173665673530269697?ref_src=twsrc%5Etfw)

## Renaming columns

> 🐼🤹‍♂️ pandas trick:
>
> 3 ways to rename columns:
>
> 1\. Most flexible option:  
> df = df.rename({'A':'a', 'B':'b'}, axis='columns')
>
> 2\. Overwrite all column names:  
> df.columns = \['a', 'b'\]
>
> 3\. Apply string method:  
> df.columns =
> df.columns.str.lower()[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw)
>
> — Kevin Markham (@justmarkham)
> [July 16, 2019](https://twitter.com/justmarkham/status/1151117787932364802?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Add a prefix to all of your column names:  
> df.add_prefix('X\_')
>
> Add a suffix to all of your column names:  
> df.add_suffix('\_Y')[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw)
>
> — Kevin Markham (@justmarkham)
> [June 11, 2019](https://twitter.com/justmarkham/status/1138427282412978176?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Need to rename all of your columns in the same way? Use a string
> method:
>
> Replace spaces with \_:  
> df.columns = df.columns.str.replace(' ', '\_')
>
> Make lowercase & remove trailing whitespace:  
> df.columns =
> df.columns.str.lower().str.rstrip()[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw)
>
> — Kevin Markham (@justmarkham)
> [June 25, 2019](https://twitter.com/justmarkham/status/1143504595630645248?ref_src=twsrc%5Etfw)

## Selecting rows and columns

> 🐼🤹‍♂️ pandas trick:
>
> You can use f-strings (Python 3.6+) when selecting a Series from a
> DataFrame\!
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [@python_tip](https://twitter.com/python_tip?ref_src=twsrc%5Etfw) > [pic.twitter.com/8qHEXiGBaB](https://t.co/8qHEXiGBaB)
>
> — Kevin Markham (@justmarkham)
> [September 13, 2019](https://twitter.com/justmarkham/status/1172579990296285185?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Need to select multiple rows/columns? "loc" is usually the solution:
>
> select a slice (inclusive):  
> df.loc\[0:4, 'col_A':'col_D'\]
>
> select a list:  
> df.loc\[\[0, 3\], \['col_A', 'col_C'\]\]
>
> select by condition:  
> df.loc\[df.col_A=='val',
> 'col_D'\][\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw)
>
> — Kevin Markham (@justmarkham)
> [July 3, 2019](https://twitter.com/justmarkham/status/1146408709087739904?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> "loc" selects by label, and "iloc" selects by position.
>
> But what if you need to select by label \*and\* position? You can
> still use loc or iloc\!
>
> See example 👇
>
> P.S. Don't use "ix", it has been deprecated since 2017.[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/SpFkjWYEE0](https://t.co/SpFkjWYEE0)
>
> — Kevin Markham (@justmarkham)
> [August 1, 2019](https://twitter.com/justmarkham/status/1156914155477241861?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Reverse column order in a DataFrame:  
> df.loc\[:, ::-1\]
>
> Reverse row order:  
> df.loc\[::-1\]
>
> Reverse row order and reset the index:  
> df.loc\[::-1\].reset_index(drop=True)
>
> Want more
> [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw)?
> Working on a video right now, stay tuned...
> 🎥[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw)
>
> — Kevin Markham (@justmarkham)
> [June 12, 2019](https://twitter.com/justmarkham/status/1138783488864395265?ref_src=twsrc%5Etfw)

## Filtering rows by condition

> 🐼🤹‍♂️ pandas trick:
>
> Filter DataFrame by multiple OR conditions:  
> df\[(df.color == 'red') | (df.color == 'green') | (df.color ==
> 'blue')\]
>
> Shorter way:  
> df\[df.color.isin(\['red', 'green', 'blue'\])\]
>
> Invert the filter:  
> df\[\~df.color.isin(\['red', 'green',
> 'blue'\])\][\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw)
>
> — Kevin Markham (@justmarkham)
> [June 13, 2019](https://twitter.com/justmarkham/status/1139158451169517568?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Are you trying to filter a DataFrame using lots of criteria? It can be
> hard to write ✏️ and to read\! 🔍
>
> Instead, save the criteria as objects and use them to filter. Or, use
> reduce() to combine the criteria\!
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/U9NV27RIjQ](https://t.co/U9NV27RIjQ)
>
> — Kevin Markham (@justmarkham)
> [August 28, 2019](https://twitter.com/justmarkham/status/1166702698869268480?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Want to filter a DataFrame that doesn't have a name?
>
> Use the query() method to avoid creating an intermediate variable\!
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/NyUOOSr7Sc](https://t.co/NyUOOSr7Sc)
>
> — Kevin Markham (@justmarkham)
> [July 25, 2019](https://twitter.com/justmarkham/status/1154391633674350593?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Need to refer to a local variable within a query() string? Just prefix
> it with the @ symbol\!
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/PfXcASWDdC](https://t.co/PfXcASWDdC)
>
> — Kevin Markham (@justmarkham)
> [August 13, 2019](https://twitter.com/justmarkham/status/1161290417960300544?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> If you want to use query() on a column name containing a space, just
> surround it with backticks\! (New in pandas 0.25)
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/M5ZSRVr3no](https://t.co/M5ZSRVr3no)
>
> — Kevin Markham (@justmarkham)
> [July 30, 2019](https://twitter.com/justmarkham/status/1156216721990180864?ref_src=twsrc%5Etfw)

## Manipulating strings

> 🐼🤹‍♂️ pandas trick:
>
> Want to concatenate two string columns?
>
> Option 1: Use a string method 🧶  
> Option 2: Use plus signs ➕
>
> See example 👇
>
> Which option do you prefer, and
> why?[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/SsjBAMqkxB](https://t.co/SsjBAMqkxB)
>
> — Kevin Markham (@justmarkham)
> [August 22, 2019](https://twitter.com/justmarkham/status/1164616017215201281?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Need to split a string into multiple columns? Use str.split() method,
> expand=True to return a DataFrame, and assign it to the original
> DataFrame.
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/wZ4okQZ9Dy](https://t.co/wZ4okQZ9Dy)
>
> — Kevin Markham (@justmarkham)
> [July 9, 2019](https://twitter.com/justmarkham/status/1148580936449175553?ref_src=twsrc%5Etfw)

## Working with data types

> 🐼🤹‍♂️ pandas trick:
>
> Numbers stored as strings? Try astype():  
> df.astype({'col1':'int', 'col2':'float'})
>
> But it will fail if you have any invalid input. Better way:  
> df.apply(<https://t.co/H90jtE9QMp>\_numeric, errors='coerce')
>
> Converts invalid input to NaN
> 🎉[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw)
>
> — Kevin Markham (@justmarkham)
> [June 17, 2019](https://twitter.com/justmarkham/status/1140603888791379968?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Select columns by data
> type:<https://t.co/8c3VWfaERD>\_dtypes(include='number')<https://t.co/8c3VWfaERD>\_dtypes(include=\['number',
> 'category',
> 'object'\])<https://t.co/8c3VWfaERD>\_dtypes(exclude=\['datetime',
> 'timedelta'\])[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw)
>
> — Kevin Markham (@justmarkham)
> [June 14, 2019](https://twitter.com/justmarkham/status/1139518333257158658?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Two useful properties of ordered categories:  
> 1️⃣ You can sort the values in logical (not alphabetical) order  
> 2️⃣ Comparison operators also work logically
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/HeYZ3P3gPP](https://t.co/HeYZ3P3gPP)
>
> — Kevin Markham (@justmarkham)
> [August 8, 2019](https://twitter.com/justmarkham/status/1159436190799605760?ref_src=twsrc%5Etfw)

## Encoding data

> 🐼🤹‍♂️ pandas trick:
>
> Need to convert a column from continuous to categorical? Use cut():
>
> df\['age_groups'\] = pd.cut(df.age, bins=\[0, 18, 65, 99\],
> labels=\['child', 'adult', 'elderly'\])
>
> 0 to 18 ➡️ 'child'  
> 18 to 65 ➡️ 'adult'  
> 65 to 99 ➡️
> 'elderly'[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw)
>
> — Kevin Markham (@justmarkham)
> [July 2, 2019](https://twitter.com/justmarkham/status/1146040449678925824?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Want to dummy encode (or "one hot encode") your DataFrame? Use
> pd.get_dummies(df) to encode all object & category columns.
>
> Want to drop the first level since it provides redundant info? Set
> drop_first=True.
>
> See example & read thread
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/g0XjJ44eg2](https://t.co/g0XjJ44eg2)
>
> — Kevin Markham (@justmarkham)
> [August 5, 2019](https://twitter.com/justmarkham/status/1158364160478109696?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Need to apply the same mapping to multiple columns at once? Use
> "applymap" (DataFrame method) with "get" (dictionary method).
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/WU4AmeHP4O](https://t.co/WU4AmeHP4O)
>
> — Kevin Markham (@justmarkham)
> [August 30, 2019](https://twitter.com/justmarkham/status/1167494070790434816?ref_src=twsrc%5Etfw)

## Extracting data from lists

> 🐼🤹‍♂️ pandas trick:
>
> Has your data ever been TRAPPED in a Series of Python lists? 🔒
>
> Expand the Series into a DataFrame by using apply() and passing it the
> Series constructor 🔓
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/ZvysqaRz6S](https://t.co/ZvysqaRz6S)
>
> — Kevin Markham (@justmarkham)
> [June 27, 2019](https://twitter.com/justmarkham/status/1144233944281419776?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Do you have a Series containing lists of items? Create one row for
> each item using the "explode" method 💥
>
> New in pandas 0.25\! See example 👇
>
> 🤯[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/ix5d8CLg57](https://t.co/ix5d8CLg57)
>
> — Kevin Markham (@justmarkham)
> [August 12, 2019](https://twitter.com/justmarkham/status/1161001631942684672?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Does your Series contain comma-separated items? Create one row for
> each item:
>
> ✂️ "str.split" creates a list of strings  
> ⬅️ "assign" overwrites the existing column  
> 💥 "explode" creates the rows (new in pandas 0.25)
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/OqZNWdarP0](https://t.co/OqZNWdarP0)
>
> — Kevin Markham (@justmarkham)
> [August 14, 2019](https://twitter.com/justmarkham/status/1161621998994374657?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> 💥 "explode" takes a list of items and creates one row for each item
> (new in pandas 0.25)
>
> You can also do the reverse\! See example 👇
>
> Thanks to
> [@EForEndeavour](https://twitter.com/EForEndeavour?ref_src=twsrc%5Etfw)
> for this tip
> 🙌[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/4UBxbzHS51](https://t.co/4UBxbzHS51)
>
> — Kevin Markham (@justmarkham)
> [August 16, 2019](https://twitter.com/justmarkham/status/1162353777267138560?ref_src=twsrc%5Etfw)

## Working with time series data

> 🐼🤹‍♂️ pandas trick:
>
> If you need to create a single datetime column from multiple columns,
> you can use to_datetime() 📆
>
> See example 👇
>
> You must include: month, day, year  
> You can also include: hour, minute,
> second[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/0bip6SRDdF](https://t.co/0bip6SRDdF)
>
> — Kevin Markham (@justmarkham)
> [July 8, 2019](https://twitter.com/justmarkham/status/1148217934298406912?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> One reason to use the datetime data type is that you can access many
> useful attributes via "dt", like:  
> df.column.dt.hour
>
> Other attributes include: year, month, day, dayofyear, week, weekday,
> quarter, days_in_month...
>
> See full list
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/z405STKqKY](https://t.co/z405STKqKY)
>
> — Kevin Markham (@justmarkham)
> [August 2, 2019](https://twitter.com/justmarkham/status/1157274570220613632?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Need to perform an aggregation (sum, mean, etc) with a given frequency
> (monthly, yearly, etc)?
>
> Use resample\! It's like a "groupby" for time series data. See example
> 👇
>
> "Y" means yearly. See list of frequencies:
> <https://t.co/oPDx85yqFT>[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/nweqbHXEtd](https://t.co/nweqbHXEtd)
>
> — Kevin Markham (@justmarkham)
> [July 18, 2019](https://twitter.com/justmarkham/status/1151846604216971264?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Want to calculate the difference between each row and the previous
> row? Use df.col_name.diff()
>
> Want to calculate the percentage change instead? Use
> df.col_name.pct_change()
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/5EGYqpNPC3](https://t.co/5EGYqpNPC3)
>
> — Kevin Markham (@justmarkham)
> [August 27, 2019](https://twitter.com/justmarkham/status/1166389736371576835?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Need to convert a datetime Series from UTC to another time zone?
>
> 1\. Set current time zone ➡️ tz_localize('UTC')  
> 2\. Convert ➡️ tz_convert('America/Chicago')
>
> Automatically handles Daylight Savings Time\!
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/ztzMXcgkFY](https://t.co/ztzMXcgkFY)
>
> — Kevin Markham (@justmarkham)
> [July 31, 2019](https://twitter.com/justmarkham/status/1156596371820072961?ref_src=twsrc%5Etfw)

## Handling missing values

> 🐼🤹‍♂️ pandas trick:
>
> Calculate % of missing values in each column:  
> df.isna().mean()
>
> Drop columns with any missing values:  
> df.dropna(axis='columns')
>
> Drop columns in which more than 10% of values are missing:  
> df.dropna(thresh=len(df)\*0.9,
> axis='columns')[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw)
>
> — Kevin Markham (@justmarkham)
> [June 19, 2019](https://twitter.com/justmarkham/status/1141328289186951168?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Need to fill missing values in your time series data? Use
> df.interpolate()
>
> Defaults to linear interpolation, but many other methods are
> supported\!
>
> Want more pandas tricks? Watch this:  
> 👉 <https://t.co/6akbxXXHKg>
> 👈[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/JjH08dvjMK](https://t.co/JjH08dvjMK)
>
> — Kevin Markham (@justmarkham)
> [July 12, 2019](https://twitter.com/justmarkham/status/1149668977741688832?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Do you need to store missing values ("NaN") in an integer Series? Use
> the "Int64" data type\!
>
> See example 👇
>
> (New in v0.24, API is experimental/subject to
> change)[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/mN7Ud53Rls](https://t.co/mN7Ud53Rls)
>
> — Kevin Markham (@justmarkham)
> [August 15, 2019](https://twitter.com/justmarkham/status/1162002963835039750?ref_src=twsrc%5Etfw)

## Using aggregation functions

> 🐼🤹‍♂️ pandas trick:
>
> Instead of aggregating by a single function (such as 'mean'), you can
> aggregate by multiple functions by using 'agg' (and passing it a list
> of functions) or by using 'describe' (for summary statistics 📊)
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/Emg3zLAocB](https://t.co/Emg3zLAocB)
>
> — Kevin Markham (@justmarkham)
> [July 19, 2019](https://twitter.com/justmarkham/status/1152204706292408320?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Did you know that "last" is an aggregation function, just like "sum"
> and "mean"?
>
> Can be used with a groupby to extract the last value in each group.
> See example 👇
>
> P.S. You can also use "first" and "nth"
> functions\![\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/WKJtNIUxwz](https://t.co/WKJtNIUxwz)
>
> — Kevin Markham (@justmarkham)
> [August 9, 2019](https://twitter.com/justmarkham/status/1159841685175537666?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Are you applying multiple aggregations after a groupby? Try "named
> aggregation":
>
> ✅ Allows you to name the output columns  
> ❌ Avoids a column MultiIndex
>
> New in pandas 0.25\! See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/VXJz6ShZbc](https://t.co/VXJz6ShZbc)
>
> — Kevin Markham (@justmarkham)
> [August 21, 2019](https://twitter.com/justmarkham/status/1164167735275921408?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Want to combine the output of an aggregation with the original
> DataFrame?
>
> Instead of: df.groupby('col1').col2.func()  
> Use: df.groupby('col1').col2.transform(func)
>
> "transform" changes the output shape
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/9dkcAGpTYK](https://t.co/9dkcAGpTYK)
>
> — Kevin Markham (@justmarkham)
> [September 4, 2019](https://twitter.com/justmarkham/status/1169235705933049856?ref_src=twsrc%5Etfw)

## Using cumulative functions

> 🐼🤹‍♂️ pandas trick:
>
> Need to calculate a running total (or "cumulative sum")? Use the
> cumsum() function\! Also works with groupby()
>
> See example 👇
>
> Other cumulative functions: cummax(), cummin(),
> cumprod()[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/H4whqlV2ky](https://t.co/H4whqlV2ky)
>
> — Kevin Markham (@justmarkham)
> [September 6, 2019](https://twitter.com/justmarkham/status/1169951245873897479?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Need to calculate a running count within groups? Do this:  
> df.groupby('col').cumcount() + 1
>
> See example 👇
>
> Thanks to
> [@kjbird15](https://twitter.com/kjbird15?ref_src=twsrc%5Etfw) and
> [@EForEndeavour](https://twitter.com/EForEndeavour?ref_src=twsrc%5Etfw)
> for this trick\!
> 🙌[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [@python_tip](https://twitter.com/python_tip?ref_src=twsrc%5Etfw) > [pic.twitter.com/jSz231QmmS](https://t.co/jSz231QmmS)
>
> — Kevin Markham (@justmarkham)
> [September 11, 2019](https://twitter.com/justmarkham/status/1171776545217814530?ref_src=twsrc%5Etfw)

## Random sampling

> 🐼🤹‍♂️ pandas trick:
>
> Randomly sample rows from a DataFrame:  
> df.sample(n=10)  
> df.sample(frac=0.25)
>
> Useful parameters:  
> ➡️ random_state: use any integer for reproducibility  
> ➡️ replace: sample with replacement  
> ➡️ weights: weight based on values in a column
> 😎[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/j2AyoTLRKb](https://t.co/j2AyoTLRKb)
>
> — Kevin Markham (@justmarkham)
> [August 20, 2019](https://twitter.com/justmarkham/status/1163809580213780486?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Want to shuffle your DataFrame rows?  
> df.sample(frac=1, random_state=0)
>
> Want to reset the index after shuffling?  
> df.sample(frac=1,
> random_state=0).reset_index(drop=True)[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw)
>
> — Kevin Markham (@justmarkham)
> [August 26, 2019](https://twitter.com/justmarkham/status/1165998474464235524?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Split a DataFrame into two random subsets:
>
> df_1 = df.sample(frac=0.75, random_state=42)  
> df_2 = df.drop(df_1.index)
>
> (Only works if df's index values are unique)
>
> P.S. Working on a video of my 25 best
> [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw),
> stay tuned\!
> 📺[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw)
>
> — Kevin Markham (@justmarkham)
> [June 18, 2019](https://twitter.com/justmarkham/status/1140967304517378048?ref_src=twsrc%5Etfw)

## Merging DataFrames

> 🐼🤹‍♂️ pandas trick:
>
> When you are merging DataFrames, you can identify the source of each
> row (left/right/both) by setting indicator=True.
>
> See example 👇
>
> P.S. Learn 25 more
> [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw)
> in 25 minutes:
> <https://t.co/6akbxXG6SI>[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/tkb2LiV4eh](https://t.co/tkb2LiV4eh)
>
> — Kevin Markham (@justmarkham)
> [July 23, 2019](https://twitter.com/justmarkham/status/1153653794829418496?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Merging datasets? Check that merge keys are unique in BOTH datasets:  
> pd.merge(left, right, validate='one_to_one')
>
> ✅ Use 'one_to_many' to only check uniqueness in LEFT  
> ✅ Use 'many_to_one' to only check uniqueness in
> RIGHT[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw)
>
> — Kevin Markham (@justmarkham)
> [June 26, 2019](https://twitter.com/justmarkham/status/1143868476609765376?ref_src=twsrc%5Etfw)

## Styling DataFrames

> 🐼🤹‍♂️ pandas trick:
>
> Two simple ways to style a DataFrame:
>
> 1️⃣ <https://t.co/HRqLVf3cWC>.hide_index()  
> 2️⃣ <https://t.co/HRqLVf3cWC>.set_caption('My caption')
>
> See example 👇
>
> For more style options, watch trick \#25: <https://t.co/6akbxXG6SI>
> 📺[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/8yzyQYz9vr](https://t.co/8yzyQYz9vr)
>
> — Kevin Markham (@justmarkham)
> [August 6, 2019](https://twitter.com/justmarkham/status/1158728502176337921?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Want to add formatting to your DataFrame? For example:  
> \- hide the index  
> \- add a caption  
> \- format numbers & dates  
> \- highlight min & max values
>
> Watch 👇 to learn how\!
>
> Code: <https://t.co/HKroWYVIEs>
>
> 25 more tricks:
> <https://t.co/6akbxXG6SI>[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/AKQr7zVR7S](https://t.co/AKQr7zVR7S)
>
> — Kevin Markham (@justmarkham)
> [July 17, 2019](https://twitter.com/justmarkham/status/1151477232713555972?ref_src=twsrc%5Etfw)

## Exploring a dataset

> 🐼🤹‍♂️ pandas trick:
>
> Want to explore a new dataset without too much work?
>
> 1\. Pick one:  
> ➡️ pip install pandas-profiling  
> ➡️ conda install -c conda-forge pandas-profiling
>
> 2\. import pandas_profiling  
> 3\. df.profile_report()  
> 4\. 🥳
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/srq5rptEUj](https://t.co/srq5rptEUj)
>
> — Kevin Markham (@justmarkham)
> [July 29, 2019](https://twitter.com/justmarkham/status/1155840938356432896?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Need to check if two Series contain the same elements?
>
> ❌ Don't do this:  
> df.A == df.B
>
> ✅ Do this:  
> df.A.equals(df.B)
>
> ✅ Also works for DataFrames:  
> df.equals(df2)
>
> equals() properly handles NaNs, whereas == does
> not[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw)
>
> — Kevin Markham (@justmarkham)
> [June 24, 2019](https://twitter.com/justmarkham/status/1143140214057111552?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick \#69:
>
> Need to check if two Series are "similar"? Use this:
>
> pd.testing.assert_series_equal(df.A, df.B, ...)
>
> Useful arguments include:  
> ➡️ check_names=False  
> ➡️ check_dtype=False  
> ➡️ check_exact=False
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/bdJBkiFxne](https://t.co/bdJBkiFxne)
>
> — Kevin Markham (@justmarkham)
> [September 19, 2019](https://twitter.com/justmarkham/status/1174679494470381568?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Want to examine the "head" of a wide DataFrame, but can't see all of
> the columns?
>
> Solution \#1: Change display options to show all columns  
> Solution \#2: Transpose the head (swaps rows and columns)
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/9sw7O7cPeh](https://t.co/9sw7O7cPeh)
>
> — Kevin Markham (@justmarkham)
> [July 24, 2019](https://twitter.com/justmarkham/status/1154036887834615812?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Want to plot a DataFrame? It's as easy as:  
> df.plot(kind='...')
>
> You can use:  
> line 📈  
> bar 📊  
> barh  
> hist  
> box 📦  
> kde  
> area  
> scatter  
> hexbin  
> pie 🥧
>
> Other plot types are available via pd.plotting\!
>
> Examples:
> <https://t.co/fXYtPeVpZX>[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#dataviz](https://twitter.com/hashtag/dataviz?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/kp82wA15S4](https://t.co/kp82wA15S4)
>
> — Kevin Markham (@justmarkham)
> [August 23, 2019](https://twitter.com/justmarkham/status/1164881213317926913?ref_src=twsrc%5Etfw)

## Handling warnings

> 🐼🤹‍♂️ pandas trick:
>
> Did you encounter the dreaded SettingWithCopyWarning? 👻
>
> The usual solution is to rewrite your assignment using "loc":
>
> ❌ df\[df.col == val1\].col = val2  
> ✅ df.loc\[df.col == val1, 'col'\] = val2
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [@python_tip](https://twitter.com/python_tip?ref_src=twsrc%5Etfw) > [pic.twitter.com/6L6IukTpBO](https://t.co/6L6IukTpBO)
>
> — Kevin Markham (@justmarkham)
> [September 10, 2019](https://twitter.com/justmarkham/status/1171400622022844418?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Did you get a "SettingWithCopyWarning" when creating a new column? You
> are probably assigning to a DataFrame that was created from another
> DataFrame.
>
> Solution: Use the "copy" method when copying a DataFrame\!
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/LrRNFyN6Qn](https://t.co/LrRNFyN6Qn)
>
> — Kevin Markham (@justmarkham)
> [September 12, 2019](https://twitter.com/justmarkham/status/1172139564141633536?ref_src=twsrc%5Etfw)

## Other

> 🐼🤹‍♂️ pandas trick:
>
> If you've created a groupby object, you can access any of the groups
> (as a DataFrame) using the get_group() method.
>
> See example
> 👇[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#DataScience](https://twitter.com/hashtag/DataScience?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/6Ya0kxMpgk](https://t.co/6Ya0kxMpgk)
>
> — Kevin Markham (@justmarkham)
> [September 2, 2019](https://twitter.com/justmarkham/status/1168503762484416512?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Do you have a Series with a MultiIndex?
>
> Reshape it into a DataFrame using the unstack() method. It's easier to
> read, plus you can interact with it using DataFrame methods\!
>
> See example 👇
>
> P.S. Want a video with my top 25
> [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw)?
> 📺[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/DKHwN03A7J](https://t.co/DKHwN03A7J)
>
> — Kevin Markham (@justmarkham)
> [July 1, 2019](https://twitter.com/justmarkham/status/1145682082112442369?ref_src=twsrc%5Etfw)

> 🐼🤹 pandas trick:
>
> There are many display options you can change:  
> max_rows  
> max_columns  
> max_colwidth  
> precision  
> date_dayfirst  
> date_yearfirst
>
> How to use:  
> pd.set_option('display.max_rows', 80)  
> pd.reset_option('display.max_rows')
>
> See all:  
> pd.describe_option()[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw)
>
> — Kevin Markham (@justmarkham)
> [July 26, 2019](https://twitter.com/justmarkham/status/1154736907974316032?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Show total memory usage of a
> DataFrame:<https://t.co/LkpMP7wWOi>(memory_usage='deep')
>
> Show memory used by each column:  
> df.memory_usage(deep=True)
>
> Need to reduce? Drop unused columns, or convert object columns to
> 'category'
> type.[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw)
>
> — Kevin Markham (@justmarkham)
> [July 5, 2019](https://twitter.com/justmarkham/status/1147126063350407170?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick \#70:
>
> Need to know which version of pandas you're using?
>
> ➡️ pd.\_\_version\_\_
>
> Need to know the versions of its dependencies (numpy, matplotlib,
> etc)?
>
> ➡️ <https://t.co/84gN00FdzJ>\_versions()
>
> Helpful when reading the documentation\!
> 📚[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw)
>
> — Kevin Markham (@justmarkham)
> [September 20, 2019](https://twitter.com/justmarkham/status/1175029249973075971?ref_src=twsrc%5Etfw)

> 🐼🤹‍♂️ pandas trick:
>
> Want to use NumPy without importing it? You can access ALL of its
> functionality from within pandas\! See example 👇
>
> This is probably \*not\* a good idea since it breaks with a
> long-standing convention. But it's a neat trick
> 😎[\#Python](https://twitter.com/hashtag/Python?src=hash&ref_src=twsrc%5Etfw) > [\#pandas](https://twitter.com/hashtag/pandas?src=hash&ref_src=twsrc%5Etfw) > [\#pandastricks](https://twitter.com/hashtag/pandastricks?src=hash&ref_src=twsrc%5Etfw) > [pic.twitter.com/pZbXwuj6Kz](https://t.co/pZbXwuj6Kz)
>
> — Kevin Markham (@justmarkham)
> [July 22, 2019](https://twitter.com/justmarkham/status/1153290079089172480?ref_src=twsrc%5Etfw)

<div id="footer-message" class="section">

© 2019 Data School. All rights reserved. Powered by
[Ghost](https://ghost.org).
[Crisp](https://github.com/kathyqian/crisp-ghost-theme) theme by [Kathy
Qian](https://kathyqian.com).

</div>
