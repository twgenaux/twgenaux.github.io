---
title: Theron W. Genaux
---

# Theron W. Genaux

## ASTM E1394 Messages

[Parsing ASTM E1394 Messages (Github)](https://github.com/twgenaux/tgenaux-ASTM-LIS) 

This repository contains code, projects, and programs related to ASTM E1394 and LIS1.

[Parsing ASTM E1394 Messages](https://twgenaux.github.io/ASTME1394MessagParsing) 

This project demonstrates generically reading and creating ASTM  E1394 messages. 

In 2015 I started working with vendors and customers to help them interface to my company's new instrument. The message format was ASTM E1394 (ASTM). I started to wonder how LIS and middleware vendors were able to adapt to connecting with so many instruments where each instrument manufacturer developed their own message format based on the ASTM E1394 standard.

I had already seen some code that reads and writes ASTM messages, both on the web and proprietary. And I always thought that they were error prone to use and and overly complex. I started  wondering how reading, writng, and processing ASTM messaging could be generalized so that one could adapt to all the variations that I've seen. I also wondered how to make it less error prone.

I played around mentally going through different ideas for a while until I realized that an ASTM record is in essence a recursive data structure, one recursion per separator. ASTM records have 3 separators; Field, Repeat-Field, and Components. Because it only has 3 delimiters, it is limited to only 3 levels of recursion. [Continue reading...](https://twgenaux.github.io/ASTME1394MessagParsing) 
