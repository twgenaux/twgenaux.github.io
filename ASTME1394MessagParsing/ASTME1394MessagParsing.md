---
title: ASTM E1394 Message Parsing
category: ASTM E1394
author: [ Theron W. Genaux]
tags: [LIS,ASTM,E1394,LIS02]
---



<h1 id='astm-e1394-message-parsing'><span><center>ASTM E1394 Message Parsing</center></span></h1>
<p style="text-align:center">Theron W. Genaux</p>
<p style="text-align:center">21-February-2025</p>



This project demonstrates generically parsing ASTM  E1394 (a.k.a LIS2) messages. It is a prototype demonstrating a method to parse any ASTM  E1394 (ASTM) message and return key/value pairs containing all the information in the message. These key/value pairs can recreate an equivalent ASTM message.

In 2015, I started working with vendors and customers to help them interface with my company's new family of instruments, which used the ASTM E1394 message format. I wondered how LIS and middleware vendors could adapt and connect with so many instruments as each instrument manufacturer developed its message format based on the ASTM E1394 standard.

I had already seen some code that reads and writes ASTM messages on the web and proprietary. I always thought that they were error-prone and overly complex. I wondered how reading, writing, and processing ASTM messaging could be generalized to adapt to all the variations I've seen. I also wanted to make it less error-prone.

I played around mentally with different ideas for a while until I realized that an ASTM record is, in essence, a recursive data structure with one recursion per separator. ASTM records have three separators: field, Repeat-Field, and Components. Because they only have three delimiters, they are limited to only three levels of recursion. 

HL7  version 2 (pipe-delimited) messages use segment, field, component, and sub-component delimiters, which have four separators and four levels of recursion. This code can be used with version 2 (pipe-delimited) messages.

The following output is from a program developed to explore two ideas: generically reading and writing ASTM messages and using bidirectional maps (Translation Map). ASTM messages are parsed into position/value pairs, where the key identifies the position of a value in a record. These position/value pairs are then mapped to token key/value pairs, where the key determines the value type. The program supports round-tripping, so the extracted content from one message can recreate the equivalent original message. The original translation map can map the token pairs to position pairs that can be used to recreate an equivalent ASTM message. 


Input message:

```
H|\^&|||OCD^VISION^5.10.0.46252^JNumber|||||||P|LIS2-A|20240307151237
P|1|PID123456||NID123456^MID123456^OID123456|Brown^Bobby^B|White|19650102030400|U|||||||||||||||||||||||
O|1|SID101||ABO-D|N|20240307151207|||||||||CENTBLOOD|||||||20240307151237|||F|||||
O|1|SID101||ABScr|N|20240307151207|||||||||CENTBLOOD|||||||20240307151237|||F|||||
L||
```

Parse massage into record Position:Value pairs:

```
Delimiters:|\^&
H.1:H
H.5:OCD^VISION^5.10.0.46252^JNumber
H.5.1.1:OCD
H.5.1.2:VISION
H.5.1.3:5.10.0.46252
H.5.1.4:JNumber
H.12:P
H.13:LIS2-A
H.14:20240307151237
P.1:P
P.2:1
P.3:PID123456
P.5:NID123456^MID123456^OID123456
P.5.1.1:NID123456
P.5.1.2:MID123456
P.5.1.3:OID123456
P.6:Brown^Bobby^B
P.6.1.1:Brown
P.6.1.2:Bobby
P.6.1.3:B
P.7:White
P.8:19650102030400
P.9:U
O.1:O
O.2:1
O.3:SID101
O.5:ABO-D
O.6:N
O.7:20240307151207
O.16:CENTBLOOD
O.23:20240307151237
O.26:F
O.1:O
O.2:1
O.3:SID101
O.5:ABScr
O.6:N
O.7:20240307151207
O.16:CENTBLOOD
O.23:20240307151237
O.26:F
L.1:L
```



A bidirectional translation map is used to remap the Position:Value pairs into Key:Value pairs and to remap the Key:ValuePosition:Value pairs back into Position:Value pairs.

An Order record like this:

```
O|1|SID102\SID103||ABO FWD/RVS|||||||||||PACKEDCELLS\PLASMA
```

Is parsed into Position:Value pairs:

```
O.1:O
O.2:1
O.3:SID102\SID103
O.3.1:SID102
O.3.2:SID103
O.5:ABO FWD/RVS
O.16:PACKEDCELLS\PLASMA
O.16.1:PACKEDCELLS
O.16.2:PLASMA
```

It can be remapped into Key:Value pairs using a bi-directional translation map:

```
RecordType:O.1
SeqeNumber:O.2
OrderSampleIDs:O.3
OrderSampleID1:O.3.1
OrderSampleID2:O.3.2
OrderTestID:O.5    # Universal Test ID
OrderPriority:O.6
OrderReqDateTime:O.7
OrderActionCode:O.12
OrderSampleTypes:O.16
OrderSampleType1:O.16.1
OrderSampleType2:O.16.2
```

Remapping to Key:Value pairs:

```
RecordType:O
SeqeNumber:1
OrderSampleIDs:SID102\SID103
OrderSampleID1:SID102
OrderSampleID2:SID103
OrderTestID:ABO FWD/RVS
OrderSampleTypes:PACKEDCELLS\PLASMA
OrderSampleType1:PACKEDCELLS
OrderSampleType2:PLASMA
```



I used a bidirectional translation map to remap the message Position:Value pairs into Key:Value pairs. 

Here we list the extracted message Key:Value pairs:

```
Delimiters:|\^&
H-RecordType:H
H-SenderName:OCD^VISION^5.10.0.46252^JNumber
H-Company:OCD
H-InstrumentModel:VISION
H-Version:5.10.0.46252
H-InstrumentID:JNumber
H-ProcessingID:P
H-VeresionNumber:LIS2-A
H-TimeStamp:20240307151237
P-RecordType:P
P-SeqNumber:1
P-PatientID:PID123456
P-PatientID3:NID123456^MID123456^OID123456
P-PatientName:Brown^Bobby^B
P-PatientNameLast:Brown
P-PatientNameFirst:Bobby
P-PatientNameMiddle:B
P-MothersMaiden:White
P-BirthDate:19650102030400
P-Sex:U
O-RecordType:O
O-SeqNumber:1
O-SampleIDs:SID101
O-Profiles:ABO-D
O-Priority:N
O-RequestedTimeStamp:20240307151207
O-SampleTypes:CENTBLOOD
O-ReportedTime:20240307151237
O-ReportType:F
O-RecordType:O
O-SeqNumber:1
O-SampleIDs:SID101
O-Profiles:ABScr
O-Priority:N
O-RequestedTimeStamp:20240307151207
O-SampleTypes:CENTBLOOD
O-ReportedTime:20240307151237
O-ReportType:F
L-RecordType:L
```


Recreate the message by first converting Key:Value pairs into record Position:Value pairs:

```
Delimiters:|\^&
H.1:H
H.5:OCD^VISION^5.10.0.46252^JNumber
H.5.1.1:OCD
H.5.1.2:VISION
H.5.1.3:5.10.0.46252
H.5.1.4:JNumber
H.12:P
H.13:LIS2-A
H.14:20240307151237
P.1:P
P.2:1
P.3:PID123456
P.5:NID123456^MID123456^OID123456
P.6:Brown^Bobby^B
P.6.1.1:Brown
P.6.1.2:Bobby
P.6.1.3:B
P.7:White
P.8:19650102030400
P.9:U
O.1:O
O.2:1
O.3:SID101
O.5:ABO-D
O.6:N
O.7:20240307151207
O.16:CENTBLOOD
O.23:20240307151237
O.26:F
O.1:O
O.2:1
O.3:SID101
O.5:ABScr
O.6:N
O.7:20240307151207
O.16:CENTBLOOD
O.23:20240307151237
O.26:F
L.1:L
```



Export Position/Value pairs into an ASTM message:

```
H|\^&|||OCD^VISION^5.10.0.46252^JNumber|||||||P|LIS2-A|20240307151237
P|1|PID123456||NID123456^MID123456^OID123456|Brown^Bobby^B|White|19650102030400|U
O|1|SID101||ABO-D|N|20240307151207|||||||||CENTBLOOD|||||||20240307151237|||F
O|1|SID101||ABScr|N|20240307151207|||||||||CENTBLOOD|||||||20240307151237|||F
L
```

