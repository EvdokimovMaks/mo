.linkform 'NFormVygovor' prototype is 'NFRMPUNIS_2004'
.nameinlist 'Выговор'

.var
  ddoc:     date;
  decl:     Z_STAFF::declension;
  strf:     Z_STAFF::StringFunctions;
  ipad:     ipadeg;
  iCommission: F_COMMON::Commission;
  CommissIndex: integer;
  CommissCount: integer;
  deparde: string;
  ind: longint;
  FIO_DP: string;
  file_string: string;
  n, count: integer;
  note_array: array [0..100] of string;
.endvar

.create view v_post
as select *
from titledoc, partdoc, contdoc, appointments, catalogs
where ((
    TitleDocNrec      == titledoc.nrec     and
    31                == partdoc.typeoper  and
    titledoc.nrec     == partdoc.cdoc      and
    PersNrec          == contdoc.person    and
    partdoc.nrec      == contdoc.cpart     and
    AppointNrec       == appointments.nrec and
    appointments.post == catalogs.nrec
));

.create view v_dep
as select *
from titledoc, partdoc, contdoc, appointments, catalogs
where ((
    TitleDocNrec            == titledoc.nrec     and
    31                      == partdoc.typeoper  and
    titledoc.nrec           == partdoc.cdoc      and
    PersNrec                == contdoc.person    and
    partdoc.nrec            == contdoc.cpart     and
    AppointNrec             == appointments.nrec and
    appointments.department == catalogs.nrec
));

.create view v_punish
as select *
from titledoc, partdoc, contdoc, punishments, catalogs
where ((
      TitleDocNrec      == titledoc.nrec     and
      31                == partdoc.typeoper  and
      titledoc.nrec     == partdoc.cdoc      and
      PersNrec          == contdoc.person    and
      partdoc.nrec      == contdoc.cpart     and
      contdoc.nrec      == punishments.ccont and
      punishments.cref2 == catalogs.nrec
));

.create view v_memo
as select *
from titledoc, partdoc, contdoc, notes
where ((
      TitleDocNrec  == titledoc.nrec    and
      31            == partdoc.typeoper and
      titledoc.nrec == partdoc.cdoc     and
      PersNrec      == contdoc.person   and
      partdoc.nrec  == contdoc.cpart    and
      CHOICE_VGVR   == notes.choice     and
      contdoc.nrec  == notes.owner
));

.fields
  day(ddoc) LoCase(datetostr(ddoc, 'Mon')) year(ddoc)
  номер_документа
  GetSurnameWithInitials(FIO_DP)
  FIO_DP
  ipad.GetAppointmentPadeg(LoCase(v_post.catalogs.name), 3)
  deparde
  v_punish.catalogs.name
  основание
  note_array[n]
  iCommission.GetComponentPost(CommissIndex)
  iCommission.GetComponentFIO(CommissIndex)
.endfields

.begin
  ddoc := strtodate(дата_составления, 'DD/MM/YYYY');

  if v_post.getfirst appointments = tsOk
    if v_post.getfirst catalogs = tsOk { }

  if v_dep.getfirst appointments = tsOk
    if v_dep.getfirst catalogs = tsOk { }

  if v_punish.getfirst titledoc = tsOk
    if v_punish.getfirst partdoc = tsOk
      if v_punish.getfirst contdoc = tsOk
        if v_punish.getfirst punishments = tsOk
          if v_punish.getfirst catalogs = tsOk { }

  if v_memo.getfirst titledoc = tsOk
    if v_memo.getfirst partdoc = tsOk
      if v_memo.getfirst contdoc = tsOk
        if v_memo.getfirst notes = tsOk { }

  iCommission.InitCommission(COMMISSION_APPOINTMENT);
  iCommission.RunWindowSelection(1);
  CommissCount := iCommission.GetComponentsCount;
  if iCommission.GetCommissionChairMan
    CommissIndex := 0
  else
    CommissIndex := 1;
  if v_dep.catalogs.longname <> ''
       deparde := ipad.GetDepartmentPadeg(LoCase(v_dep.catalogs.longname), 2)
  else deparde := ipad.GetDepartmentPadeg(LoCase(v_dep.catalogs.name), 2);

  FIO_DP := decl.FIODeclension(PersNrec, FIO, 3);


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


   ^ ^ ^ г.      № ^
   Об объявлении выговора ^

   Приказываю:
   Объявить выговор ^, ^
   ^,
   ^, ^
   Основание:
.{while n < count
        ^
.begin
  n++;
end.
.}

.{while CommissIndex <= CommissCount
^           ^
.begin
  CommissIndex++;
end.
.}

.endform
