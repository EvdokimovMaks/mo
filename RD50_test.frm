.linkform 'RD5000' prototype is 'NformRD50'
.nameinlist 'ДопСоглашение ЗарПлата (ТЕСТ)'
.create view v_cntd
as select *
from titledoc, partdoc, contdoc
where ((
    TitleDocNrec            == titledoc.nrec and
    50                      == partdoc.typeoper and
    titledoc.nrec           == partdoc.cdoc and
    PersNrec                == contdoc.person and
    partdoc.nrec            == contdoc.cpart
));
.Fields
Организация
ОКПО
TitleDocNrec
PersNrec
AppointNrec
номер_документа
дата_составления
FIO
FIO_VP
TabN
подразделение
должность
DateBeg
DateEnd
VidOpl
TaxRate
Koef
WorkStations
WorkRegime
Found
Reason
PassportsSer
PassportsNmb
PassportsGivenDate
PassportsGivenBy
ContractNmb
ContractDate
ДолжнРук
ФиоРук
.EndFields
============================
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
===========================
.endform
