---
title: Theron W. Genaux
---

# Theron W. Genaux

## ASTM E1394 and LIS01-A Messages

## [Introduction to ASTM E1394 and LIS02-A2 Message Formats](https://twgenaux.github.io/MessageFormats/MessageFormats)

​	A basic introduction to the ASTM E1394 and LIS02 message formats.

## [ASTM E1394 LIS02-A Messages (Github)](https://github.com/twgenaux/tgenaux-ASTM-LIS) 

​	This repository contains code, projects, and programs related to ASTM E1394 and LIS1.

## [Parsing ASTM E1394 Messages](https://twgenaux.github.io/ASTME1394MessagParsing/ASTME1394MessagParsing)  

This project demonstrates generically reading and creating ASTM  E1394 messages. 

In 2015, I started working with vendors and customers to help them interface with my company's new instrument. The message format was ASTM E1394 (ASTM). I started to wonder how LIS and middleware vendors were able to adapt to connect with so many instruments, as each instrument manufacturer developed its own message format based on the ASTM E1394 standard.

I had already seen some code that reads and writes ASTM messages on the web and proprietary. I always thought that they were error-prone and overly complex. I started wondering how reading, writing, and processing ASTM messaging could be generalized so that one could adapt to all the variations that I've seen. I also wondered how to make it less error-prone.

I played around mentally with different ideas for a while until I realized that an ASTM record is, in essence, a recursive data structure with one recursion per separator. ASTM records have three separators: field, Repeat-Field, and Components. Because they have only three delimiters, they are limited to only three levels of recursion. [Continue reading...](https://twgenaux.github.io/ASTME1394MessagParsing/ASTME1394MessagParsing)    



