.linkform 'RD5000' prototype is 'NformRD50'
.nameinlist '��������襭�� ������� (����)'
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
�࣠������
����
TitleDocNrec
PersNrec
AppointNrec
�����_���㬥��
���_��⠢�����
FIO
FIO_VP
TabN
���ࠧ�������
���������
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
�������
�����
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
