---
title: Theron W. Genaux
---

# Theron W. Genaux

## Contents

[TOC]

## About Me

I'm a software engineer with experience in developing real-time, event-driven embedded systems, internationalized Microsoft Windows-based applications, and software for regulated medical devices. Acquired a broad range of skills in all software development life cycle phases, from requirements gathering and design to systems implementation and testing. Strong analytical, diagnostic, and problem-solving abilities.

I began my career as a Digital Systems Technician (DST) at Kodak, then transitioned into software engineering. A few years later, I returned to college to earn my Bachelor's degree in Computer Science.

My first job was at Kodak's instant print manufacturing in Kodak Park. The entire building was an embedded system, with minimal human interaction with the raw materials or products. There were approximately 75 DEC PDP-11 computers throughout the building, with many of them performing real-time control of the large Continuous Motion Assembly Machines (COMAMs). The COMAMs assembled the individual, unexposed picture units (PU) from a continuously moving layer of webs while adding some components. The PUs were then stacked into a pack, and a cover was sealed on top. The packs were then fed on an air conveyor to an accumulator for quality inspection. When released, they were sent on another air conveyor, where they were packaged for sale and boxed for shipping.

 Additionally, there were many microcontrollers and digital systems. I was impressed with the COMAM hardware simulator, which was driven by a variable oscillator feed to a counter that produced an address to a bank of PROMs, whose output simulated the inputs and interrupts to the software.  

This was an invaluable learning experience and introduction to real-time event-driven software for me, as I ended up writing assembly code, Intel’s PL/M, and updating various small real-time event-driven microcontrollers. I also worked with computer engineers, developing code for testing new microcontroller boards. This involved often suggesting improvements to make the boards fully testable and speeding up the performance of their target applications.

My first unofficial work as a software engineer was on a Kodak Venture project, where I wrote all the low-level device drivers for what was at the time a general-purpose tablet computer with a CD drive, targeting field service engineers. This project ended when, at one meeting, someone walked in with one of the first laptop computers. 

Because of my work on the venture project, I was hired as a software engineer by an internal group that outsourced engineers as needed for new projects. This led to a career of developing new real-time embedded systems, desktop applications, and supporting and maintaining legacy systems.



# Articles

## [Introduction to ASTM E1394 and LIS02-A2 Message Formats](https://twgenaux.github.io/MessageFormats/MessageFormats)

​	A basic introduction to the ASTM E1394 and LIS02 message formats for non-programmers.

**TAGS:** E1394, LIS2, LIS02

## [ASTM E1394 Message Parsing](https://twgenaux.github.io/ASTME1394MessagParsing/ASTME1394MessagParsing)  

This project demonstrates the generic parsing of ASTM E1394 (also known as LIS2) messages. It is a prototype that shows a method for parsing any ASTM E1394 (ASTM) message and returning key/value pairs containing all the information in the message. These key/value pairs can be used to recreate an equivalent ASTM message. I'm continuing to revise and expand my approach as time permits.

**TAGS:** E1394, LIS2, LIS02

# Projects

### [Tool for calculating and verifying LIS01 Low-Level Protocol Frame Checksums](https://github.com/twgenaux/LIS01-Checksum-Calculatpr-Verifier) 

The LIS1-A / ASTM E1381 Frame Checksum Calculator (LFCC) can be used to calculate or verify the checksum of an LIS01 frame.

![image-20250314201901833.png](https://github.com/twgenaux/LIS01-Checksum-Calculatpr-Verifier/blob/main/README.assets/image-20250314201901833.png?raw=true) 

**TAGS:** LIS01, LIS02

