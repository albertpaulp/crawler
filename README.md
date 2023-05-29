# Crawler
A simple web crawler to crawl all links in the same domain.
## Problem statement
```
Write a simple web crawler in a programming language you're familiar with. Given a starting URL, the crawler should visit each URL it finds on the same domain. It should print each URL visited, and a list of links found on that page. The crawler should be limited to one subdomain - so when you start with *https://monzo.com/*, it would crawl all pages on the monzo.com website, but not follow external links, for example to facebook.com or community.monzo.com.

We would like to see your own implementation of a web crawler. Please do not use frameworks like scrapy or go-colly which handle all the crawling behind the scenes or someone else's code. You are welcome to use libraries to handle things like HTML parsing.

Ideally, write it as you would a production piece of code. This exercise is not meant to show us whether you can write code – we are more interested in how you design software. This means that we care less about a fancy UI or sitemap format, and more about how your program is structured: the trade-offs you've made, what behaviour the program exhibits, and your use of concurrency, test coverage, and so on.
```

## How to

- Install ruby 3.2.2 by `rbenv install 3.2.2`

- Install all libraries by `bundle install`

- Run the application by `ruby app.rb https://monzo.com/`

- Run test suite with `bundle exec rspec .`

- Run static type checking with `bundle exec srb tc`

## Sample response

```
thread 1400: Crawling https://monzo.com/blog/2019/08/22/strong-customer-authentication
thread 1400: Found 1 URLs
thread 1400: Found https://monzo.com/blog/2019/08/22/strong-customer-authentication
thread 1400: ===================================
.......
Completed crawling in 2.423 seconds, found 70 unique URLs
https://monzo.com
............
https://monzo.com/blog/2019/08/22/strong-customer-authentication
```

## Design decisions

### System design
There are different ways to design the application with the given requirement.
I've identified mainly 2 approaches and decide stick with #2 due to time/complexicity(YAGNI).
#### 1. Using multiple background/delayed jobs with an RDBMS to store visited URLs.
This would involve, creating n number of background jobs/processes that subscribe to a job queue waiting to execute it.
Each time a worker visit a page and collect URLs, it would push unique and unvisited URLs to a job queue to be picked
up by a worker from pool.

**Pros**:
1. Scales horizontally, we can add as much as background job executors/processes we want.
2. Best if we wanted to build a cloud hosted app that does need to crawl large swaths of internet/domains.
3. More reliable, crawling won't be stopped if single worker/node goes down.

**Cons**:
1. Needs a lot of boiler code/infrastructure to have RDBMS, background job, possibly networking setup in place.
2. Unneccessary complexicity for something like crawling a domain with limited number of URLs.

#### 2. Single App/Process with multithreading
We can use a single app/process to do the crawling. We could use OS threads for concurrency and parellelism(based on Ruby interpreter support).

**Pros**:
1. Simple to create and can be done in 4-5 hours max.
2. It can use in-memory and does not need any memory persistance systems like RDBMS.

**Cons**:
1. Does not scale horizontally but vertically. Throughput will depend on the number of cores in CPU.
2. Unreliable since the whole app is run on a single computing node.

### Caveats

- Even though we use concurrency, standard Ruby interpreter(YARV) comes with Global interpreter lock(GIL) which prevents parallel execution. That means threads won't run parallelly even if multiple CPU cores are available, we still can make use of concurrency for performance gain. We could run the code truly parallel using interpreters like JRuby/TruffleRuby which does not have GIL.
- I have added logging while each thread fetch web pages, this log won't be in order because of unordered thread execution pattern. We can verify producing thread of each log by thread id in the beginning of the log line. I have added a bit of code to print unique URLs once entire execution is completed.
- I am decided to add static and runtime type checking with Sorbet for easier code reading and reliability.
- I haven't added integration test due to lack of time but added unit testing for service classes.
- Current parsing recognise links by looking at <a href> tags, if a link is present in any other format, for example sitemap.xml, it's not crawled.
