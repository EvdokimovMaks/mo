.linkform 'Nformt8_universal' prototype is 'Nformt8_2004'
.nameinlist 'Об освобождении (универсальная)'
.var
  ddoc:     date;
  firedate: date;
  decl:     Z_STAFF::declension;
  strf:     Z_STAFF::StringFunctions;
  ipad:     ipadeg;
  iCommission: F_COMMON::Commission;
  CommissIndex: integer;
  CommissCount: integer;
  Deparde, depardy: string;
  lastname_sign, name_sign, patron, signaturer: string;
  post, post_without_io, io_without_post: string;
  FIO_RP: string;
  ot_chego: string;
  reason_full, foundation_full, dep_full, second_text: string;
  part1, part2, part3: string;
  flag1, flag2, flag3, flag4: boolean;
.endvar
.create view v_post
as select *
from titledoc, partdoc, contdoc, appointments, catalogs
where ((
    TitleDocNrec      == titledoc.nrec and
    8                 == partdoc.typeoper and
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
    8                       == partdoc.typeoper and
    titledoc.nrec           == partdoc.cdoc and
    PersNrec                == contdoc.person and
    partdoc.nrec            == contdoc.cpart and
    AppointNrec             == appointments.nrec and
    appointments.department == catalogs.nrec
));

.fields
  day(ddoc) LoCase(datetostr(ddoc, 'Mon')) year(ddoc)
  номер_документа
  GetSurnameWithInitials(FIO_RP)
  day(firedate) LoCase(datetostr(firedate, 'Mon YYYY'))
  FIO_VP
  ot_chego
  post
  deparde
  reason_full
  dep_full
  second_text
  foundation_full
  iCommission.GetComponentPost(CommissIndex)
  signaturer
.endfields

.begin
  ddoc := strtodate(дата_составления, 'DD/MM/YYYY');
  firedate := strtodate(dDel, '"DD" Mon YYYY');
  if v_post.getfirst appointments = tsOk
    if v_post.getfirst catalogs = tsOk { }
  if v_dep.getfirst appointments = tsOk
    if v_dep.getfirst catalogs = tsOk { }
  if v_dep.catalogs.longname <> ''
{
       deparde := ipad.GetDepartmentPadeg(v_dep.catalogs.longname, 2);
       depardy := ipad.GetDepartmentPadeg(v_dep.catalogs.longname, 3);
}
  else
{
       deparde := ipad.GetDepartmentPadeg(v_dep.catalogs.name, 2);
       depardy := ipad.GetDepartmentPadeg(v_dep.catalogs.name, 3);
};

  iCommission.InitCommission(COMMISSION_APPOINTMENT);
  iCommission.RunWindowSelection(1);
  CommissCount := iCommission.GetComponentsCount;
  if iCommission.GetCommissionChairMan
    CommissIndex := 0
  else
    CommissIndex := 1;

  lastname_sign := strf.Get_LastName(iCommission.GetComponentFIO(CommissIndex));
  name_sign := strf.Get_FirstName(iCommission.GetComponentFIO(CommissIndex));
  patron := strf.GetPatronymic(iCommission.GetComponentFIO(CommissIndex));
  signaturer := SubStr(name_sign, 1, 1)+'.'+SubStr(patron, 1, 1)+'. '+lastname_sign;

  FIO_RP := decl.FIODeclension(PersNrec, FIO, 2);

  if  length(v_post.catalogs.name) > 23 then
  {
    ot_chego := 'исполнения обязанностей';
    post_without_io := substr(v_post.catalogs.name, 25, 255);
    post := post_without_io;
  }
  else
  {
    ot_chego := 'занимаемой должности';
    post := ipad.GetAppointmentPadeg(LoCase(v_post.catalogs.name), 2);
  }

  part1 := 'расчет в соответствии со статьей 140 Трудового кодекса Российской Федерации';
  part2 := ', выплатить компенсацию в размере трехкратного среднего месячного заработка';
  part3 := ' и выдать трудовую книжку.';

  flag1 := true;
  flag2 := false;
  flag3 := true;
  flag4 := false;

  if flag1
  {
    dep_full := depardy + ' произвести с ' + GetSurnameWithInitials(FIO_TP);
    if flag2
    {
      second_text := ' ' + part1 + part2 + part3;
    }
    else
    {
      second_text := ' ' + part1 + part3;
    }
  }
  else
  {
    dep_full := '';
    second_text := '';
  }

  if flag3 reason_full := reason2
  else reason_full := '';

  if flag4 foundation_full := 'Основание: ' + foundation
  else foundation_full := '';

var
  flags: word;
  flags := 2;
  runinterface(MINOBR::rep_fire, flags);
  message(flags);
end.



 ^ ^ ^ г.  № ^

 Об освобождении ^


П р и к а з ы в а ю :
Освободить ^ ^ года ^
от ^ ^
^ ^
^
^
^

.{while CommissIndex <= CommissCount
^      	^
.begin
  CommissIndex++;
  lastname_sign := strf.Get_LastName(iCommission.GetComponentFIO(CommissIndex));
  name_sign := strf.Get_FirstName(iCommission.GetComponentFIO(CommissIndex));
  patron := strf.GetPatronymic(iCommission.GetComponentFIO(CommissIndex));
  signaturer := SubStr(name_sign, 1, 1)+'.'+SubStr(patron, 1, 1)+'. '+lastname_sign;
end.
.}
.endform
