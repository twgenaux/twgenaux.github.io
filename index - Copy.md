---
title: Theron W. Genaux
---

# Theron W. Genaux

## ASTM E1394 and LIS02-A Messages

## [Introduction to ASTM E1394 and LIS02-A2 Message Formats](https://twgenaux.github.io/MessageFormats/MessageFormats)

​	A basic introduction to the ASTM E1394 and LIS02 message formats.

## [ASTM E1394 LIS02-A Messages (Github)](https://github.com/twgenaux/tgenaux-ASTM-LIS) 

​	This repository contains code, projects, and programs related to ASTM E1394 and LIS1.

## [ASTM E1394 Message Parsing](https://twgenaux.github.io/ASTME1394MessagParsing/ASTME1394MessagParsing)  

This project demonstrates generically parsing ASTM  E1394 (a.k.a LIS2) messages. It is a prototype demonstrating a method to parse any ASTM  E1394 (ASTM) message and return key/value pairs containing all the information in the message. These key/value pairs can be used to recreate an equivalent ASTM message.

In 2015, I started working with vendors and customers to help them interface with my company's new family of instruments, which used the ASTM E1394 message format. I began to wonder how LIS and middleware vendors could adapt and connect with so many instruments, as each instrument manufacturer developed its message format based on the ASTM E1394 standard.

I had already seen some code that reads and writes ASTM messages on the web and proprietary. I always thought that they were error-prone and overly complex. I wondered how reading, writing, and processing ASTM messaging could be generalized to adapt to all the variations I've seen. I also wanted to make it less error-prone.

I played around mentally with different ideas for a while until I realized that an ASTM record is, in essence, a recursive data structure with one recursion per separator. ASTM records have three separators: field, Repeat-Field, and Components. Because they only have three delimiters, they are limited to only three levels of recursion. 

I played around mentally with different ideas for a while until I realized ... [Continue reading...](https://twgenaux.github.io/ASTME1394MessagParsing/ASTME1394MessagParsing)    



