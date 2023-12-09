use classicmodels;
##1) Number of Orders and Total sales by Years
select sum(x.quantityOrdered * x.priceEach) as sales, count(x.status) as numberoforders,  year(x.orderDate) as salesyear from
	(select orders.orderNumber, customerNumber, status , orderDate, quantityOrdered, priceEach 
		from orders 
		join orderdetails 
		on orders.orderNumber = orderdetails.orderNumber) as x
	where x.status = 'shipped'
    group by year(x.orderDate) ;
    
    
##2) Total Sales by Category i year 2004 and 2005
select * , round(( y1.salesin2004 - y1.salesin2005)*100/ y1.salesin2004) as percentagedifference from 
(select y.productLine, 
	   sum(if (year(y.orderDate) = 2004 ,(y.quantityOrdered * y.priceEach),0)) as salesin2004 ,
       sum(if (year(y.orderDate) = 2005 ,(y.quantityOrdered * y.priceEach),0)) as salesin2005 from
			(select orders.orderNumber, customerNumber, status , orderDate, quantityOrdered, priceEach , orderdetails.productCode, products.productLine
			from orders 
			inner join orderdetails on orders.orderNumber = orderdetails.orderNumber
			inner join products on products.productCode = orderdetails.productCode) as y
		where y.status = 'Shipped'
        group by y.productLine ) as y1;
        
##3) Customer Transactions per year
select count(distinct customerNumber) as numberofcustomer, year(orderDate) from orders
		where status = 'Shipped'
        group by year(orderDate) ;
        
##4) New Customers over the Years
select count(distinct customerNumber) as numberofcustomer, year(first_order) from 
		(select distinct customerNumber, 
			min(orderDate) as first_order from orders
            where status = 'shipped'
            group by 1) as first
group by 2;
        

