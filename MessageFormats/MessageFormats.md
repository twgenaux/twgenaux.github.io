---
title: Introduction to ASTM Message Formats
category: LIS
author: [ Theron W. Genaux, Draft, 2-February-2024]
theme: Pixyll
tags: [LIS, ASTM,E1394 ,LIS2, LIS02, HL7 V2.x ]
---

# Introduction to ASTM Message Formats - DRAFT

| Acronym             | Description                                                  |
| ------------------- | ------------------------------------------------------------ |
| LIS                 | Laboratory Information Systems                               |
| ASTM                | Refers to ASTM E1394 and LIS02 standards.                    |
| Record              | An ordered list of fields, i.e the fields in a Patient record containing a patient's name, date of birth, ... |
| Field               | An attribute (Data Type) of a record, i.e. a patient's  name |
| Repeat field        | A repeating field data type, i.e. a list of two or more of a patient's attending physicians |
| Component           | A single data element of a data type of a field, i.e. a patient's name can consist of a first, middle, and last name, where each name is a componet of the patient name field in a Patient record. |
| ASTM Message        | An ordered list of ASTM records, starting with a Header record and ending with a Terminator record. |
| ASTM Message Format | A specific implantation of the ASTM E1394 or LIS02 standards by a manufacturer. |
|                     |                                                              |

## TODO

- [ ] Add links to standards, LIS guides, and other resources.
- [x] Explain Field separator
- [ ] Explain Repeat field separator - multiple sample IDs in an order
- [ ] Explain Component separator - patient name
- [ ] Repeated fields with Components - multiple physicians
- [ ] How do I find out what each field is? The instrument interface guide. The standard.
- [ ] Add links to the standards
- [ ] Data Types
- [ ] A Record Sequence Number is used in record types that may occur multiple timeswithin a single message. The number used defines the nth occurrence of the associated record type at a particular hierarchical level and is reset to one whenever a record of a greater hierarchical significance (lower number). Add example message.


The ASTM E1394 standard was created over 30 years ago. However, messages based on the ASTM E1394 (now LIS02) standard are still being used by Laboratory Information Systems (LIS), middleware, and clinical laboratory instruments. Throughout this document, I will use ASTM to refer to ASTM E1394, LIS2, and LIS02 standards.

One example of an ASTM message is provided below. My goal is for you to be able to understand its construction and be able to identify each part. Don't worry, we won't jump into this all at once. We will start small and work our way up to more complex messages as we go along.

```ASTM
H|\^&|||OCD^VISION^5.13.1.46935^JNumber|||||||P|LIS2-A|20210309142633
P|1|PID123456||NID123456^MID123456^OID123456|Brown^Bobby^B|White|19650102030400|U|||||PHY1234^Kildare^James^P|Blaine
O|1|SID305||ABO|N|20210309142136|||||||||CENTBLOOD|||||||20210309142229|||R
R|1|ABO|B|||||R||Automatic||20210309142229|JNumber
R|2|Rh|POS|||||R||Automatic||20210309142229|JNumber
L|1|N
```

An ASTM message is an ordered list of lines, called records. A record is an ordered list of fields. Fields are separated by a Field Separator, in this case a pipe character is used (|). Each record starts with a Record Type ID, such as O, for the Order record. The Record Type ID identifies what data is contained in each record. 

Let's begin with an ASTM Order record with just the essential parts and nothing else.

```ASTM
O|1|SID101||ABORH|||||||||||CENTBLOOD
```

The table below shows the field in the above Order, along with their field position number, data type, and values. The position in the record identifies the data type of each field.  

![image-20240419223033977](.\Message Formats.assests\image-20240419223033977.png) 

ASTM messages are easy to implement. Using a field separator makes it easy for computers to create and parse these messages.

Let me show you how to manually take apart this Order record and identify each field and the type of information in it.

You can use any text editor that can number the lines and allows you to replace the field separator (|) with a Carriage Return (CR) and Line Feed (LF). I'll demonstrate with Notepad++.

![image-20240420191928705](.\Message Formats.assests\image-20240420191928705.png)  

The first step is to split the fields into separate lines:

1. In the Replace dialog, enter the field separator. 
2. Enter the <CR> and <LF>
3. Click Replace All

You now have a list of fields where each line number is also its field position.

![image-20240420183844463](.\Message Formats.assests\image-20240420183844463.png) 

Field names and their position are defined in the ASTM standard. The specification for the Order record is in section 8 of the ASTM E1394 standard. The field definitions start with section 8.4.1 (Record Type ID). The field position is the last number of the section number that defines it, 1 for the  Record Type ID. TheSpecimen ID (Sample ID) is in section 8.4.3 and is referred to as O.3, for Order record field 3.

You can use this same technique for listing the fields in reverse to create an Order record manually.

![image-20240420185330462](.\Message Formats.assests\image-20240420185330462.png) 

To hand code an Order record:

1. Enter each field attribute on the line number that corresponds to its field position as defined by the ASTM standard. For an Order record, the sample ID goes in field 3, so write it on line 3.
2. In the Replace dialog, enter the <CR> and <LF> 
3. Enter the field separator. 
4. Click *Replace all*

Now we have manually created an Order record. Computers are programed to do something similar.

![image-20240420185552555](.\Message Formats.assests\image-20240420185552555.png) 



## The other separators

### Repeat Fields

A Repeat field is a duplication of the same field where each value is unique. For example, an order record with multiple Specimen IDs; such as a pair of blood samples from the same draw, one containing packed red blood cells and the other plasma.

```ASTM
O|1|SID102\SID103||ABO FWD/RVS|||||||||||PACKEDCELLS\PLASMA
```

### Componets


```ASTM
P|1|PID123456|||Brown^Bobby^B||||||||PHY101^Forbin^Charles^A\PHY103^Morbius^Edward
```


## ASTM Record Notation

The ASTM record notation I use is very similar to IP notation and is used to identify the parts of a record. It consists of a record ID followed by indexes into the parts of the record.  

- RecordID.Field - The specimen ID in the Order record field 3, is denoted as O.3

- RecordID.Field.Repeat.Component P.14.2: HID714^Pierce^Hawkeye

## Record Separator



## ASTM Escape Sequences


The escape character is the last of the 4 defined characters in the header. The escape character is used to create a sequence of characters to replace the defined characters in the text values. This is similar to what is done in XML when \&lt; is used to replace the reserved character *left angle bracket* (<) in text data.

Take for example the name of a profile that contains the repeat field separator, as in "ABO\Rh\ABScr", named after the analyses returned by the profile. If this profile name was placed in an order profile field as is, it would not be parsed as one profile, but three. To prevent this, embedded repeat field separators are replaced with an escape sequence, which will be converted back to the embedded repeat field separator when it is parsed by the receiver of the message. 

When the sender writes "ABO\Rh\ABScr" into the order record, every repeat separator (\\) is replaced with "&R&",  resulting with a string of "ABO<u>&R&</u>Rh<u>&R&</u>ABScr". When the profile is read by the receiver of the message, every "&R&" is replaced with the repeat field separator (\\), restoring the data to it's original text.

```ASTM
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



