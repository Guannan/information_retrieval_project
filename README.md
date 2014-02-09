information_retrieval_project
=============================

Information retrieval class final project
Spring 2013

Project Description: 
The MetaShopper application is used for the quick and informative search of a query product. Options to rank the retrieved results by price, relevance, and rating are available.

The vendor sites are listed here :
<li>
	Abebooks
	Amazon
	BestBuy
	BarnesAndNoble
	Ebay
	K-Mart
	pcRUSH
	Staples
	Sears
	WalMart
</li>

The list of product categories included are :
<li>
	Books
	Clothing
	Computer
	Electronics
	Grocery
	Office supplies
</li>

The configuration file named "configuration.txt" contains the URLs and the fields for the relevant webpage retrieval and extraction.

A hash->hash->hash data structure was used for reading the configuration file's data. 

A basic webpage interface (with Perl CGI) for our Perl application was planned but failed to be completed.

For the final display of resulting products, we show an unified format across all items within the same category. The information displayed varies by category.

To run the code in the command line, we would input:
perl metashopper.pl configuration.txt log.txt result.txt

The file result.txt returns the final ranked results; log.txt is only used for debugging.
