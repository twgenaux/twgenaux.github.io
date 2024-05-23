---
title: Introduction to ASTM Message Formats
category: LIS
author: [ Theron W. Genaux, Draft, 2-February-2024]
tags: [LIS,ASTM,E1394, ASTM E1394,LIS2, LIOS2, HL7 V2 ]
---


# TODO

Add links to standards, LIS guides, and other resources.

Start off with a bare-bones ASTM Order record.

# Style

Objects or parts start with a capital letter; Order record.

| Acronym             | Description                                                  |
| ------------------- | ------------------------------------------------------------ |
| LIS                 | Laboratory Information Systems                               |
| ASTM                | Refers to ASTM E1394 and LIS02 standards.                    |
| Record              | An ordered list of fields, i.e the fields in a Patient record containing a patient's name, date of birth, ... |
| Field               | An attribute of a record, i.e. a patient's  name             |
| Repeat field        | A repeating attribute of a field, i.e. a list of two or more of a patient's attending physicians |
| Component           | A single data element, i.e. a patient's name can consist of a first, middle, and last name, where each name is a componet of the patient name field in a Patient record. |
| ASTM Message        | to be treated as having equal priority or standing to associated repeat fields. of data elements which precede it, for example, parts of a field or repeat field entry; NOTES: a) As anthe basic attribute.An ordered list of ASTM records, starting with a Header record and ending with a Terminator record. |
| ASTM Message Format | example, the patient's name is recorded as last name, first name, and middle initial, each of which isA specific implantation of the ASTM E1394 standards by a manufacturer. |
|                     | separated by a component delimiter; b) Components cannot contain repeat fields. |



# Introduction to ASTM Message Formats

The ASTM E1394 standard was created over 30 years ago. However, messages based on the ASTM E1394 (now LIS02) standard are still being used by Laboratory Information Systems (LIS), middleware, and clinical laboratory instruments. Throughout this document, I will use ASTM to refer to ASTM E1394, LIS2, and LIS02 standards.

One example of an ASTM message is provided below. My goal is for you to be able to understand its construction and be able to identify each part. Don't worry; we won't jump into this all at once. We will start small and work our way up to more complex messages as we go along.

```ASTM
H|\^&|||OCD^VISION^5.13.1.46935^JNumber|||||||P|LIS2-A|20210309142633
P|1|PID123456||NID123456^MID123456^OID123456|Brown^Bobby^B|White|19650102030400|U|||||PHY1234^Kildare^James^P|Blaine
O|1|SID305||ABO|N|20210309142136|||||||||CENTBLOOD|||||||20210309142229|||R
R|1|ABO|B|||||R||Automatic||20210309142229|JNumber
R|2|Rh|POS|||||R||Automatic||20210309142229|JNumber
L|1|N
```

An ASTM message is an ordered list of lines, called records. A record is an ordered list of fields. Fields are separated by a Field Separator, in this case a pipe character is used (|). Each record starts with a record type ID, such as O, for the Order record.

Let's begin with an ASTM Order record with just the essential parts and nothing else.



```ASTM
O|1|SID101||ABORH|||||||||||CENTBLOOD
```





The table below shows the Order record fields with their field position number, field descriptions, and values. The position in the record identifies the contents of each field.  

![image-20240419223033977](.\Message Formats.assests\image-20240419223033977.png) 

ASTM messages are easy to implement. And using a separator in this way makes it easy for computers to create and parse these messages.

Let me show you how to take apart this Order record and identify each field and the type of information in it.

You can use any text editor that can number the lines and allows you to replace the field separator (|) with a Carriage Return (CR) and Line Feed (LF). I'll demonstrate with Notepad++.

![image-20240420191928705](.\Message Formats.assests\image-20240420191928705.png)  

The first step is to split the fields into separate lines:

1. Enter the field separator. 
2. Enter the <CR> and <LF>
3. Click Replace All

You now have a list of fields where each field position is the number of the line it is on.

![image-20240420183844463](.\Message Formats.assests\image-20240420183844463.png) 

Field names and their position come from the ASTM standard. The specification for the Order record is in section 8. The field definitions start with section 8.4.1 (Record Type ID). The field position is the last number of the section number that defines it (1). Therefore, the Specimen ID (Sample ID) is in section 8.4.3 and is referred to as O.3.

You can use this same technique in reverse to create an order record manually.

![image-20240420185330462](.\Message Formats.assests\image-20240420185330462.png) 

To hand code an Order record:

1. Enter each field attribute on the line number that corresponds to its field number as defined by the ASTM standard. For an Order record, the sample ID goes in field 3, so write it on line 3.
2. In the Replace dialog, enter the <CR> and <LF> 
3. Enter the field separator. 
4. Click *Replace all*

![image-20240420185552555](.\Message Formats.assests\image-20240420185552555.png) 



## The other separators

### Repeat Fields



```ASTM
O|1|SID102\SID103||Type + Ab Scn Pnl Bld|||||||||||PACKEDCELLS\PLASMA
```







![image-20240420190402026](.\Message Formats.assests\image-20240420190402026.png) 

## TODO

1. Repeated fields - multiple sample IDs in an order
2. Components - patient name
3. Repeated fields with Components - multiple referring physicians
4. Bring it back to the original message.
5. Where to find what each field is? The instrument interface guide. The standard. 
6. Links to the standards
7. No, you don't have to list each record and its field definitions.








```
H|\^&<CR>
P|1|PID123456<CR>
O|1|SID305||ABORH|||||||||||CENTBLOOD<CR>
L|1|N<CR>
```





An ASTM message is a list of lines, called records. The first character of every record is the record type. 

1. The type of line 1 is a Header (H) record. Following the Header record type are the definitions for the separators (|\^) and the escape (&) characters. The separators and the escape definitions are used throughout the rest of the message.
1. Line 2 is a Patient (P) record and, if provided, will contain patience demographics.
1. Line 3  is a Order (O) record and contains all the information to describe the order.
1. Line 4 is the message terminator (L) is is the last record of a message.




Delimiters:|\^&
H.1:H
P.1:P
P.2:1
O.1:O
O.2:1
O.3:SID101
O.5:ABO-D
O.16:CENTBLOOD
L.1:L

Delimiters:|\^&
H-RecordType:H
P-RecordType:P
P-SeqNumber:1
O-RecordType:O
O-SeqNumber:1
O-SampleIDs:SID101
O-Profiles:ABO-D
O-SampleTypes:CENTBLOOD
L-RecordType:L



Here we have an exemplary ASTM message.

```ASTM
H|\^&|||OCD^VISION^5.13.1.46935^JNumber|||||||P|LIS2-A|20210309142633
P|1|PID123456||NID123456^MID123456^OID123456|Brown^Bobby^B|White|19650102030400|U|||||PHY1234^Kildare^James^P|Blaine
O|1|SID305||ABO|N|20210309142136|||||||||CENTBLOOD|||||||20210309142229|||R
R|1|ABO|B|||||R||Automatic||20210309142229|JNumber
R|2|Rh|POS|||||R||Automatic||20210309142229|JNumber
L|1|N

```

In this message you can see names, date-times, addresses, and others things that you may or may not recognize base on your experience.

The first thing to note is that a message is a list of lines, called records. And each record ends in a carriage return (<CR>). The <CR> marks the end of a record, it separates one record from another.





```
H|\^&|||Mini LIS||||||||LIS2-A|20200210110913
P|1|PID02101110||NID02101110^MID02101110^OID02101110|Brown^Bobby^B|White|196501020304|U|||||PHY1234^Kildare^James^P|Blaine
O|1|02101110||ABO|N|20200210110913|||||N||||CENTBLOOD
L||
```

ORTHO Optix™ Reader for BioVue® Cassettes, Laboratory Information System Guide, Ortho-Clinical Diagnostics, Inc.



```
H|@^\|4e075416e50c470cba55ed3350c9bec5||ICU^GeneXpert^1.0|||||LIS||P|1394-97|20070521100245 
P|1|||
O|1|SID-123456||^^^|R|20070521101245|||||C||||ORH||||||||||Q@Y O|2|SID123456||^^^|R|20070521101246|||||C||||ORH||||||||||Q@Y
L|1|Q
```

GeneXpert System Software LIS Interface Protocol Specification





```
H||^&||| Harbour Hospital LIS^||||||||1|20010507144648
P|1||1234||Doe^John||19560607|M||||||||159^cm|67^kg||||||||
0|1|789
L|1|N
```

Communication Protocol Specifications for Radiometer products, 





# Introduction

The ASTM E1394 standard was first adopted in 1991 with the intent to be a flexible standard for LIS vendors and manufacturers to create compatible message formats.   

> This standard specifies the conventions for structuring the content of the message and for representing the data elements contained within those structures. It is applicable to all text-oriented clinical instrumentation. It has been specifically created to provide common conventions for interfacing computers and instruments in a clinical setting. [^ASTM E1394-97]

ASTM has since transferred the responsibility for maintaining this standard to the Clinical and Laboratory Standards Institute (CLSI). Which means that the latest version of the ASTM E1394 standard is actually an CLSI standard:

> LIS02-A2 Specification for Transferring Information Between Clinical Laboratory Instruments and Information Systems; Approved Standard- Second Edition

The ASTM E1394 standard has been around since 1991, different systems will reference the version that they target. Below is a list of revisions:

- ASTM E1394-91
- ASTM E1394-97
- LIS02-A
- LIS02-A2

Unless otherwise stated, throughout this paper, *ASTM*  refers to ASTM E1394 based message formats and their related standards.

## A Flexible Standard 

The ASTM standard is not a ridged standard. The phrase "agreed upon between the sender and the receiver" appears several times in the ASTM  standard. Additionally, the majority of fields are optional; the sender is not required to send the information and the receiver may ignore the information if it is not required for the processing of the message. This means there is significant variability between implementations. 

The ASTM standard "has sufficient flexibility to permit the addition of fields to existing record types or the creation of new record types to accommodate new test and reporting methodologies."

A system may transmit a null value (devoid of text) for a field because:

1. It does not know the value
2. It knows the value is irrelevant to the receiving system
3. The value has not changed since the last transmission or any combination thereof

The ASTM standard is designed to help systems to be **compatible**, but **not always interchangeable**. Compatible so that it should be relatively easy to connect an instrument to an LIS with minimal adjustments.


# Comma-Separated Values (CSV) Format

You may already be familiar with a simple text format that delimits fields with a separator, such as the comma-separated values (CSV) format. Although not limited to it, the CSV format is famous for storing tabular data using plain text, where each record has the same number and ordered set of fields.

The simplest CSV file is a list of records. A record is an ordered array of related text fields, and each field is separated by a comma. Fields within a record are identified by their position in the record. 

Let's define an LIS order message based on the CSV format. The minimum amount of information needed for an order is a sample ID (barcode), sample type, and a test ID or profile name a nane that identified a list of one or more test IDs). Below is an example order message based on the CSV format:

```
P,PID1234<CR>
O,SID304,CENTBLOOD,ABORh<CR>
```

The first record is the patient record and it contains a record identifier (P) and a patient identifier (PID1234). 
The second record is the order record and it contains a reocrd identifier (O), a sample ID (SID1234), a sample type (CENTBLOOD), and a name to identify one or more tests to run (ABORh).

The main advantages of such a format is that it is easy to create and parse, and therefore easy to implement.

Key points of our CSV message:

- The entire message is created from simple text
- Messages and records are easy to create and parse, either programmatically or manually with a text editor
- Any character can be used as the field separator as long as it does not appear in the text of a field

## ASTM Message Formats

Below is a valid ASTM order message which contains the same information as our CSV based example.

```
H,\^&<CR>
P,1,PID123456<CR>
O,1,SID305,,ABORH,,,,,,,,,,,CENTBLOOD<CR>
L,1,N<CR>
```

The ASTM order message contains additional records and fields and the fields are in a different order than in our CSV example.

There is no difference in the way CSV messages and this ASTM messages are parsed, other than the minor differences in the ASTM patient and order records, and of course the two new records.

And for those who have seen ATSM messages before, I assure you that this is a valid ASTM message. 


The first line is the Message Header record. The bare minimum header record is just these 5 characters. The first character is the record type ID (H). The next 3 characters are the separator definitions; field separator (,), repeat separator (\\), and component separator (^). The next character is escape character (&). These seperators and escape character definitions are not fixed by the standard, but can be defined by the sender of the message in the header record and then used throughout the message.  

The next record is the Patient record. This record consists only of the record type ID (P), record sequence number, and a patient id. These fields are separated by the field separator that was defined in the header record.

The third line is the Order record. The Order record contains multiple fields; the record type ID (O), record sequence number, sample ID, profile name, and the sample type. The other commas are empty fields and are referred to as *null fields* in the standard.

The last line is the Termination record. It consists of 3 fields; record type ID (L), sequence number, and termination code. 


The ASTM standard uses a pipe (|) for the field seperator in its example messages and not the comma (,) as was used in our examples. Below, is the same message , but with the pipe (|) for the field separator. Per the ASTM standard, both messages are the same. By convention, separators used in the standard are used as the default for most implementations. 


```
H|\^&<CR>
P|1|PID123456<CR>
O|1|SID305||ABORH|||||||||||CENTBLOOD<CR>
L|1|N<CR>
```


An ASTM message is structured text:

- An ASTM message is an ordered list of records
- All ASTM records start with a record type ID
- The first record is always a Header record (H)
- The last record is always a Message Terminator record (L)
- An ASTM record is an ordered list of fields delimited by the field separator (|)
- A field is an unordered list of homogeneous field values delimited by the repeat field separator (\\)
- A field value is an ordered list of values delimited by the component separator (^)



Record Type

Sequence Number

Name

Timestamps

Dates

Reserved Field

Special Fields

Comment Fields

Patient ID - a unique ID assigned to the patient.

- P.3 Practice-Assigned ID
- P.4 Laboratory-Assigned ID
- P.5 ID Number 3





P.3 Patient ID

P. 4 Laboratory Patient ID

P.5 Patient ID 3

P.6 Patient Name

P.7 Mother's maiden name

P.8 Birthdate 

P. 9 Sex

P.11 Address

P.12 Reserved for future expansion

P.13 Phone Number

P.14 Attending Physician 

P.15 Special Field 1

P.16 Special Field 2

P.17 Height

P.18 Weight

P.19 Diagnosis

P.20 Medications

P.21 Diet

P.22 Field Number 1

P.23 Field Number 2

P.24 Admission-Discharged Date

P.25 Admission States

P.26 Location

P.27 Alternative Diagnostic Code







H.5 Sender name or ID

H.10 Receive ID or ID

H.11 Comment or special instructions 

H.12 Processing ID

H.13 Version Number (LIS02-A2)

H.14 Timestamp 



## Header Record

This record contains information about the sender and receiver.

H.1 Record Type ID (H or h)?

H.2 Delimiter Definitions

H.3 Message Control ID. A unique ID that identifiesthe transmission for use in network systems that have protocols outside the scope of this standard.

H.4 Access Password

H.5 Sender name or ID

H.6 Sender street address. The parts of the address are separated by component separator.

H.7 Sender phone number

## ASTM Record Notation

The ASTM record notation is very similar to IP notation and is used to identify the parts of a record. It consists of a record ID followed by indexes into the parts of the record.  

- RecordID.Field

- RecordID.Field.Component

- RecordID.Field.Repeat.Component

  

Record - one or more Repeat-Fields.

Repeat-Field - zero or more Fields.

Field -  an instance of a field definition; such as a birth date or a patient name (last name, first name, and middle initial).

Component - one ore more data elements



Record - An aggregate of fields describing one aspect of the complete message.

Repeat field - A single data element which expresses a duplication of the field definition it is repeating; NOTE: It is used for demographics, requests, orders and the like, where each element of a repeat field is to be treated as having equal priority or standing to associated repeat fields.

Field - One specific attribute of a record which may contain aggregates of data elements further refining the basic attribute.

Component field - A single data element or data elements which express a finer aggregate or extension of data elements which precede it, for example, parts of a field or repeat field entry; NOTES: a) As an example, the patient’s name is recorded as last name, first name, and middle initial, each of which is partioned by a component separator; b) Components cannot contain repeat fields.



A record is an ordered list of fields delimited by the field separator (|). By convention, ASTM record notation numbers the fields in a record are numbered from 1 to N. This stems from the heading numbers found in the standard that describes each record and field. 

For example, the Patient record field headings are numbered from 7.1, 7.2, ... 7.35. The first field in a Patient record is denoted as P.1 and contains the record type ID (P). The second field is denoted as P.2 and is the record sequence number.

A field is an unordered list of homogeneous field values delimited by the repeat field separator (\\). In the order record below, field O.1 is the Specimen ID, and O.16 is the Specimen Type. Field O.5 holds one or more Test IDs (unordered repeated field values). 


```
O|1|SID101||ABO\ABScr|||||||||||CENTBLOOD

O.1 : O
O.2 : 1
O.3 : SID101
O.4 : 
O.5 : ABO\ABScr
O.6 : 
O.7 : 
O.8 : 
O.9 : 
O.10: 
O.11: 
O.12: 
O.13: 
O.14: 
O.15: 
O.16: CENTBLOOD
```

When the order record is parsed, "ABO\ABScr" is returned as the O.5 field value. The repeat separator delimits each repeated field values.

The O.5  field value is then parsed for repeated fields using the repeat field separator to extract each repeated field values. In this case, the repeat field separator plays the same role as the comma does in the CSV format.  The first repeated field in O.5, ABO is denoted as O.5.1 and the second, ABScr is denoted as O.5.2.


```
O.5 : ABO\ABScr

O.5.1: ABO
O.5.2: ABScr
```


A field value is an ordered list of values delimited by the component separator (^). In the order message below, the patient name is in P.6 and contains 3 components; last name, first name, and middle initial. By convention, the last name is denoted as P.6.1 and the middle initial is denoted as P.6.3. If you include the repeated field numbers, the last name is denoted as P.6.1.1, first name is denoted as P.6.1.2, and the middle initial is denoted as P.6.1.3.


```
H|\^&
P|1|PID123456|||Brown^Bobby^B|White|196501020304
O|1|SID101||ABO\ABScr|||||||||||CENTBLOOD
L|1|N
```

When field P.6 is parsed, "Brown^Bobby^B" is returned as the field value. This field value is then parsed for components using the component separator to extract the components. In this case, the component separator plays the same role as the comma does in the CSV format. 


```
P.6 : Brown^Bobby^B

P.6.1: Brown
P.6.2: Bobby
P.6.3: B
```


The escape character is the last of the 4 defined characters in the header. The escape character is used to create a sequence of characters to replace the defined characters in the text values. This is similar to what is done in XML when \&lt; is used to replace the reserved character *left angle bracket* (<) in text data.

Take for example the name of a profile that contains the repeat field separator, as in "ABO\Rh\ABScr", named after the analyses returned by the profile. If this profile name was placed in an order profile field as is, it would not be parsed as one profile, but three. To prevent this, embedded repeat field separators are replaced with an escape sequence, which will be converted back to the embedded repeat field separator when it is parsed by the receiver of the message. 

When the sender writes "ABO\Rh\ABScr" into the order record, every repeat separator (\\) is replaced with "&R&",  resulting with a string of "ABO<u>&R&</u>Rh<u>&R&</u>ABScr". When the profile is read by the receiver of the message, every "&R&" is replaced with the repeat field separator (\\), restoring the data to it's original text.

```
Profile name: ABO\Rh\ABScr
When written into the message, replace every field separator (\) with the escape sequence &R&: 
	ABO&R&Rh&R&ABScr
When read from the message, replace every escape sequence &R& with the field separator (\):
	ABO\Rh\ABScr

O|1|SID101||ABO&R&Rh&R&ABScr|||||||||||CENTBLOOD
```



Table 1: Recode Type IDs

| Type ID | Record Description                                           | Level |
| ------- | ------------------------------------------------------------ | ----- |
| H       | Message Header - contains information about the sender and defines separators and the escape character | 0     |
| P       | Patient - contains information about an individual patient   | 1     |
| O       | Order - when sent from an LIS, this record contains information about a test order. When sent by the instrument, it shall provide information about the test request. | 2     |
| R       | Result - contains the results ofzl a single analytic determination. | 3     |
| M       | Manufacture Information - the fields in this record are defined by the manufacturer. |       |
| Q       | Request for information - used to request information, e.g. request outstanding orders for a sample. | 1     |
| L       | Message Terminator - the last record in the message. A header record may be transmitted after this record signifying the start of a second message. | 0     |


```
P|1|PID123456|||Brown^Bobby^B|White|196501020304|U|||||PHYID937^House^Gregory\PHID714^Pierce^Hawkeye

P.1 : P
P.2 : 1
P.3 : PID123456
P.4 : 
P.5 : 
P.6 : Brown^Bobby^B
P.7 : White
P.8 : 196501020304
P.9 : U
P.10: 
P.11: 
P.12: 
P.13: 
P.14: PHYID937^House^Gregory\PHID714^Pierce^Hawkeye
```

```
P.6 : Brown^Bobby^B

P.6.1: Brown
P.6.2: Bobby
P.6.3: B
```


```
P.14.1: HYID937^House^Gregory
P.14.2: HID714^Pierce^Hawkeye

P.14.2.1: HID714
P.14.2.2: Pierce
P.14.2.3: Hawkeye
```




|      |      |
| ---- | ---- |
|      |      |
|      |      |
|      |      |




[^ASTM E1394-97]:ASTM E1394 Standard Specification for Transferring Information Between Clinical Instruments and Computer Systems


- *ASTM E1381-02 Standard Specification for Low-Level Protocol to Transfer Messages Between Clinical Laboratory Instruments and Computer* *Systems (Withdrawn 2002)*

[^LIS02-A2]:LIS02-A2 Specification for Transferring Information Between Clinical Instruments and Computer Systems; Approved Standard- Second Edition
[^Ortho Vision LIS Guide]:J66623ENX Ortho BioVue Cassettes Laboratory Information System (LIS) Guide



[^Accession Number ]:  An Accession Number is a unique alphanumeric identifier which is assigned to each entry in a database to unambiguously identify a particular record.

[Ortho Public Technical Documents](https://www.orthoclinicaldiagnostics.com/en-gb/home/technical-documents)

A Record Sequence Number is used in record types that may occur multiple tienes within a single message. The number used defines the z'th occurrence of the associated record type at a particular hierarchical level and is reset to one whenever a record of a greater hierarchical significance (lower number).