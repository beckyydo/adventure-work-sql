# Adventure Work T-SQL

Download Source: https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure

Data Source: Adventure Work R2008

### Concept
The Adventure Work contains various tables such as employees, customer, sales and purchasing. This explores the sales data of Adventure Work using various queries exploring the sales and orders and the geographic location of them.

### Summary
Intial queries help to identify the TOP 10 products based on sales and order quantity. Other queries identified number of orders and sales in each country, United States being the top. For my purposes, I decided to look further into Canadian orders. From Canadian orders, Ontario and British Columbia had the highest sales. An observation was that Ontario had significantly more sales than BC but with a smaller amount of order. After examining the distribution of QTYs being placed in each order, around 30% of orders had more than 50 total items in the order and over 30% with less than 10 total items where as in BC over 97% of orders had a QTY of less than 10 items. This could suggest that Ontario has a lot more business orders which would explain the large orders compared to BC. The smaller percentage in range '<10' is likely due to some customer placing their orders from Adventure Work or buying from the businesses who have purchases Adventure Works products whereas BC doesn't have any business who sell Adventure Work so they have to purchase directly from them.

