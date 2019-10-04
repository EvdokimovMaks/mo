.linkform 'Nformt1_Rector' prototype is 'Nformt1_2004'
.nameinlist '�����祭�� �� ��������� ४��'

.var
  ddoc:     date;
  datefrom: date;
  dateto:   date;
  strf:     Z_STAFF::StringFunctions;
  ipad:     ipadeg;
  iCommission: F_COMMON::Commission;
  CommissIndex: integer;
  CommissCount: integer;
  dateto_frm: string;
  deparde: string;
.endvar

.create view v_post
as select *
from titledoc, partdoc, contdoc, appointments, catalogs
where ((
    TitleDocNrec      == titledoc.nrec and
    1                 == partdoc.typeoper and
    titledoc.nrec     == partdoc.cdoc and
    PersNrec          == contdoc.person and
    partdoc.nrec      == contdoc.cpart and
    AppointNrec       == appointments.nrec and
    appointments.post == catalogs.nrec
));

.create view v_dep
as select *
from titledoc, partdoc, contdoc, appointments, catalogs
where ((
    TitleDocNrec            == titledoc.nrec and
    1                       == partdoc.typeoper and
    titledoc.nrec           == partdoc.cdoc and
    PersNrec                == contdoc.person and
    partdoc.nrec            == contdoc.cpart and
    AppointNrec             == appointments.nrec and
    appointments.department == catalogs.nrec
));

.fields
  day(ddoc) datetostr(ddoc, 'Mon') year(ddoc)
  �����_���㬥��
  ipad.GetFullAppointmentPadeg(LoCase(v_post.catalogs.name), '', 2)
  GetSurnameWithInitials(FIO_VP)
  FIO_VP
  ipad.GetAppointmentPadeg(LoCase(v_post.catalogs.name), 2)
  deparde
  LoCase(datetostr(datefrom, 'DD Mon YYYY'))
  dateto_frm
  �᭮�����
  iCommission.GetComponentPost(CommissIndex)
  iCommission.GetComponentFIO(CommissIndex)
.endfields

.begin
  ddoc := strtodate(���_��⠢�����, 'DD/MM/YYYY');
  datefrom := strtodate(���_�, 'DD/MM/YYYY');
  dateto := strtodate(���_��, 'DD/MM/YYYY');
  if v_post.getfirst appointments = tsOk
    if v_post.getfirst catalogs = tsOk { }
  if v_dep.getfirst appointments = tsOk
    if v_dep.getfirst catalogs = tsOk { }
  if v_dep.catalogs.longname <> ''
       deparde := ipad.GetDepartmentPadeg(LoCase(v_dep.catalogs.longname), 2)
  else deparde := ipad.GetDepartmentPadeg(LoCase(v_dep.catalogs.name), 2)
  iCommission.InitCommission(COMMISSION_APPOINTMENT);
  iCommission.RunWindowSelection(1);
  CommissCount := iCommission.GetComponentsCount;
  if iCommission.GetCommissionChairMan
    CommissIndex := 0
  else
    CommissIndex := 1;
  if dateto <> 0 dateto_frm := ' �� ' + LoCase(datetostr(dateto, 'DD Mon YYYY')) + ' ����'
end.

                 ~ ������ ~
  "^" (^) ^ �.     �:  ^

        � �����祭�� �� ���������
        ^  ^

� � � � � � � � � � :
�������� ^ �� ��������� ^ ^ � ^ ����^.

.{t1_2004_Raise  CheckEnter
.}

�᭮�����: ^


.{while CommissIndex <= CommissCount
^  ^
.begin
  CommissIndex++;
end.
.}
.endform
