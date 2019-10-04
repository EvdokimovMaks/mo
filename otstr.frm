.linkform 'Nformt5test' prototype is 'Nformt5_2004'
.nameinlist 'Временное отстранение от работы'
.group 'назначения'
.var
  ddoc:     date;
  datefrom: date;
  strf:     Z_STAFF::StringFunctions;
  ipad:     ipadeg;
  iCommission: F_COMMON::Commission;
  CommissIndex: integer;
  CommissCount: integer;
  deparde: string;
  ind: longint;
  note_array: array [0..100] of string;
  file_string: string;
  n, count: integer;
.endvar

.create view v_post
as select *
from titledoc, partdoc, contdoc, appointments, catalogs
where ((
    TitleDocNrec      == titledoc.nrec and
    5                 == partdoc.typeoper and
    titledoc.nrec     == partdoc.cdoc and
    partdoc.nrec      == contdoc.cpart and
    partdoc.typeoper  == contdoc.typeoper and
    PersNrec          == contdoc.person and
    1                 == contdoc.seqnmb and
    OldAppNrec        == appointments.nrec and
    appointments.post == catalogs.nrec
));

.create view v_dep
as select *
from titledoc, partdoc, contdoc, appointments, catalogs
where ((
    TitleDocNrec            == titledoc.nrec and
    5                       == partdoc.typeoper and
    titledoc.nrec           == partdoc.cdoc and
    partdoc.nrec            == contdoc.cpart and
    partdoc.typeoper        == contdoc.typeoper and
    PersNrec                == contdoc.person and
    1                       == contdoc.seqnmb and
    OldAppNrec              == appointments.nrec and
    appointments.department == catalogs.nrec
));

.create view v_memo
as select *
from titledoc, partdoc, contdoc, notes
where ((
      TitleDocNrec     == titledoc.nrec and
      5                == partdoc.typeoper and
      titledoc.nrec    == partdoc.cdoc and
      partdoc.nrec     == contdoc.cpart and
      partdoc.typeoper == contdoc.typeoper and
      PersNrec         == contdoc.person and
      1                == contdoc.seqnmb and
      CHOICE_VGVR      == notes.choice and
      contdoc.nrec     == notes.owner
));

.fields
  day(ddoc) LoCase(datetostr(ddoc, 'Mon')) year(ddoc)
  номер_документа
  GetSurnameWithInitials(FIO_VP)
  LoCase(datetostr(datefrom, 'DD Mon YYYY'))
  FIO_VP
  ipad.GetAppointmentPadeg(LoCase(v_post.catalogs.name), 2)
  deparde
  note_array[n]
  iCommission.GetComponentPost(CommissIndex)
  iCommission.GetComponentFIO(CommissIndex)
.endfields

.begin
  ddoc := strtodate(дата_составления, 'DD/MM/YYYY');
  datefrom := strtodate(дата_с, 'DD/MM/YYYY');

  iCommission.InitCommission(COMMISSION_APPOINTMENT);
  iCommission.RunWindowSelection(1);
  CommissCount := iCommission.GetComponentsCount;
  if iCommission.GetCommissionChairMan
    CommissIndex := 0
  else
    CommissIndex := 1;
  if v_post.getfirst appointments = tsOk
    if v_post.getfirst catalogs = tsOk { }

  if v_dep.getfirst appointments = tsOk
    if v_dep.getfirst catalogs = tsOk { }

  if v_memo.getfirst titledoc = tsOk
    if v_memo.getfirst partdoc = tsOk
      if v_memo.getfirst contdoc = tsOk
        if v_memo.getfirst notes = tsOk { }

  if v_dep.catalogs.longname <> ''
       deparde := ipad.GetDepartmentPadeg(LoCase(v_dep.catalogs.longname), 2)
  else deparde := ipad.GetDepartmentPadeg(LoCase(v_dep.catalogs.name), 2);

  ind := CreateFileHandle('memo');
  if File_OpenMemo(v_memo.notes.note, ind)
  {
    while not File_EOF(ind)
    {
      File_ReadLn(file_string, ind);
      note_array[count++] := file_string;
    }
    file_close(ind);
  }
end.


^ ^ ^   # ^

           Приказ
о временном отстранении ^


Отстранить с ^ года ^ от работы
в должности ^
^

.{t5_2004_Raise  CheckEnter
.}
Основание:
.{while n < count
        ^
.begin
  n++;
end.
.}

.{while CommissIndex <= CommissCount
^    ^
.begin
  CommissIndex++;
end.
.}


.endform
