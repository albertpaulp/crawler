# Crawler

## Problem statement
```
Write a simple web crawler in a programming language you're familiar with. Given a starting URL, the crawler should visit each URL it finds on the same domain. It should print each URL visited, and a list of links found on that page. The crawler should be limited to one subdomain - so when you start with *https://monzo.com/*, it would crawl all pages on the monzo.com website, but not follow external links, for example to facebook.com or community.monzo.com.

We would like to see your own implementation of a web crawler. Please do not use frameworks like scrapy or go-colly which handle all the crawling behind the scenes or someone else's code. You are welcome to use libraries to handle things like HTML parsing.
```

## How to run the application ?

- Install ruby 3.2.2 by `rbenv install 3.2.2`

- Install all libraries by `bundle install`

- Run the application by `ruby app.rb https://monzo.com/`

- Run test suite with `bundle exec rspec .`

## Design decisions

### System design
There are different ways to design the application with the given requirement.
I've identified mainly 2 different approaches and decide stick with #2 due to time/complexicity(YAGNI).
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
2. Unneccessary complexicity for something like crawling a small domain.

#### 2. Single App/Process with multithreading
We can use a single app/process to do the crawling. We could use OS threads for concurrency and parellelism(based on Ruby interpreter support).

**Pros**:
1. Simple to create and can be done in 4-5 hours max.
2. It can use in-memory and does not need any memory persistance systems like RDBMS.

**Cons**:
1. Does not scale horizontally but vertically. Throughput will depend on type of hardware it's run.
2. Unreliable since the whole app is run on a single computing node.

### Caveats

- Even though we use concurrency, standard Ruby interpreter(YARV) comes with Global interpreter lock which prevents parallel execution. Even though threads won't run parallelly even with multiple cores, we still can make use of concurrency for performance improvement.
