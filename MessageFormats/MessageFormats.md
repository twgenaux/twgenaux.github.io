---
title: Introduction to ASTM Message Formats
category: LIS
author: [ Theron W. Genaux]
theme: Pixyll
tags: [LIS, ASTM,E1394 ,LIS2, LIS02, HL7 V2.x ]
---

<h1 id='astm-e1394-message-parsing'><span><center>Introduction to ASTM Message Formats</center></span></h1>
<h3><span><center>DRAFT</center></span></h1>
<p style="text-align:center">Theron W. Genaux</p>
<p style="text-align:center">31-May-2024</p>


# Definitions 

| Term                | Description                                                  |
| ------------------- | ------------------------------------------------------------ |
| ASTM                | Refers to ASTM E1394 and LIS02 standards.                    |
| ASTM Message        | An ordered list of ASTM records, starting with a Header record and ending with a Terminator record. |
| ASTM Message Format | A specific implementation of the ASTM E1394 or LIS02 standards by a manufacturer. |
| Component           | A single data element of a field's data type, i.e., of the patient name field in a Patient record. |
| Data Type           | A defined format of one or more data values, such as a birthdate, patient's name, etc. |
| Field               | An attribute (Data Type) of a record, i.e. a patient's  name |
| LIS                 | Laboratory Information Systems                               |
| Record              | An ordered list of fields, i.e., the fields in a Patient record containing a patient's name, date of birth, etc. |
| Repeat field        | A repeating field (data type), i.e., a list of two or more of a patient's attending physicians |
|                     |                                                              |

## TODO

- [ ] Add links to standards, LIS guides, and other resources.
- [x] Explain Field separator
- [ ] Explain Repeat field separator - multiple sample IDs in an order.
- [ ] Explain Component separator - patient name
- [ ] Repeated fields with Components - multiple physicians
- [ ] How do I find out what each field is? The instrument interface guide. The standard.
- [ ] Add links to the standards
- [ ] Data Types
- [ ] A Record Sequence Number is used in record types that may occur multiple times within a single message. The number used defines the nth occurrence of the associated record type at a particular hierarchical level and is reset to one whenever a record of a greater hierarchical significance (lower number). Add an example message.



# Introduction

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

An ASTM message is an ordered list of lines called records. In the message above, each record starts with a Record Type ID, such as O, for the Order record. The Record Type ID identifies what data is contained in each record. 

A record is an ordered list of fields. A Field Separator separates each field; in this case, a pipe character is used (|). 

Let's begin with an ASTM Order record with only the essential parts and nothing else.

```ASTM
O|1|SID101||ABORH|||||||||||CENTBLOOD
```

The table below shows the fields in the above Order and their field position number, data type, and values. The position in the record identifies the data type of each field.  

![image-20240419223033977](.\Message Formats.assests\image-20240419223033977.png) 

Using a field separator makes it easy for computers to create and parse ASTM messages.

Using a text editor like Notepad++, you can manually take apart this Order record and identify each field and the type of information in it.

You can use any text editor as long as it can display then line numbers and allow you to replace the field separator (|) with a Carriage Return (CR) and Line Feed (LF). I'll demonstrate with Notepad++.

![image-20240420191928705](.\Message Formats.assests\image-20240420191928705.png)  

The first step is to split the fields into separate lines:

1. In the Replace dialog, enter the field separator. 
2. Enter the \<CR> and \<LF>
3. Click Replace All

You now have a list of fields where each line number is also its field position.

![image-20240420183844463](.\Message Formats.assests\image-20240420183844463.png) 

Field names and their position are defined in the ASTM standard. The specification for the Order record is in section 8 of the ASTM E1394 standard. The field definitions start with section 8.4.1 (Record Type ID). The field position is the last number of the section number that defines it, 1 for the  Record Type ID. TheSpecimen ID (Sample ID) is in section 8.4.3 and is referred to as O.3, for Order record field 3.

You can use this same technique for listing the fields in reverse to create an Order record manually.

![image-20240420185330462](.\Message Formats.assests\image-20240420185330462.png) 

To hand code an Order record:

1. Enter each field attribute on the line number that corresponds to its field position as defined by the ASTM standard. For an Order record, the sample ID goes in field 3, so write it on line 3.
2. In the Replace dialog, enter \<CR> and \<LF> 
3. Enter the field separator. 
4. Click *Replace all*

Now we have manually created an Order record. Computers are programmed to do something similar.

![image-20240420185552555](.\Message Formats.assests\image-20240420185552555.png) 





# Repeat Fields

A Repeat field is a duplication of the same field where each value is unique. For example, an order record with multiple Specimen IDs, such as a pair of blood samples from the same draw, one containing packed red blood cells and the other plasma.

```ASTM
O|1|SID102\SID103||ABO FWD/RVS|||||||||||PACKEDCELLS\PLASMA
```

If we break the above Order record into fields, we get the following fields and values:

| Position | Value              |
| -------- | ------------------ |
| O.1      | O                  |
| O.2      | 1                  |
| O.3      | SID102\SID103      |
| O.5      | ABO FWD/RVS        |
| O.16     | PACKEDCELLS\PLASMA |


Fields O.3, Specimen ID, and O.16, Specimen Type are Repeat fields. Now, we can break the O.3 field into components as we did by replacing the Field separators with \<CR>\<LF>. Only this time, we will use the Repeat field separator (^).


```ASTM
SID102\SID103
```

And we end up with the following:

![image-20240529214915431](.\assets\image-20240529214915431.png)  

Note that components are numbered from 1 to n. The ASTM position notation is the following:


| Position | Value              |
| -------- | ------------------ |
| O.3.1    | SID102             |
| O.3.2    | SID103             |



List of the complete Order record with the ASTM notation and their vaules:


| Position | Value              |
| -------- | ------------------ |
| O.1      | O                  |
| O.2      | 1                  |
| O.3.1    | SID102             |
| O.3.2    | SID103             |
| O.5      | ABO FWD/RVS        |
| O.16.1   | PACKEDCELLS        |
| O.16.2   | PLASMA             |





| Position | Value              |
| -------- | ------------------ |
| O.1      | O                  |
| O.2      | 1                  |
| O.3      | SID102\SID103      |
| O.3.1    | SID102             |
| O.3.2    | SID103             |
| O.5      | ABO FWD/RVS        |
| O.16     | PACKEDCELLS\PLASMA |
| O.16.1   | PACKEDCELLS        |
| O.16.2   | PLASMA             |





![image-20240529210743871](.\assets\image-20240529210743871.png)  



fgghjgfhjghjhg

![image-20240529210904860](.\assets\image-20240529210904860.png)  



# Components


```ASTM
P|1|PID123456|||Brown^Bobby^B||||||||PHY101^Forbin^Charles^A\PHY103^Morbius^Edward
```


# ASTM Record Notation

The ASTM record notation I use is very similar to IP notation and is used to identify the parts of a record. It consists of a record ID followed by indexes into the parts of the record.  

- RecordID.Field - The specimen ID in the Order record field 3, is denoted as O.3

- RecordID.Field.Repeat.Component P.14.2: HID714^Pierce^Hawkeye

# Record Separator



# ASTM Escape Sequences


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



