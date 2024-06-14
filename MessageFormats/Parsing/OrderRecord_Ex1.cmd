@cd /d %~dp0

@set LogFile=%~dp0OrderRecord_Ex1.log

@echo %~n0 > "%LogFile%"
@echo. >> "%LogFile%"

@set SRC=.\OrderRecord_Ex1.txt
@set MAP=.\OrderRecord_Ex1_Map.txt

@echo. >> "%LogFile%"
@echo Source: %SRC% >> "%LogFile%"
@type %SRC% >> "%LogFile%"

@echo. >> "%LogFile%"
@echo Map: %MAP% >> "%LogFile%"
@type %MAP% >> "%LogFile%"

@echo. >> "%LogFile%"
@echo. >> "%LogFile%"
@echo AstmMessageParsing.exe %SRC% /TransMap:%MAP% /onlyMapped  >> "%LogFile%"
@echo.>> "%LogFile%"

@AstmMessageParsing.exe %SRC% /TransMap:%MAP% /onlyMapped  >> "%LogFile%"

pause
