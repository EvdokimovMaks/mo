.linkform 'SprMesR_mo' PROTOTYPE IS 'SprMesR'
.nameinlist'Справка (МО)'
.group 'SprMesR1'
.var
  af: Z_STAFF::AppointmentsFunctions;
.endvar

.create view v_podr
as select *
from appointments app, catalogs catDep
where ((
      af.GetAppNrec_OnDate(Persons_Nrec, cur_date) == app.nrec and
      app.department                               == catDep.nrec
));
.fields
  Фамилия Имя Отчество
  v_podr.catDep.name
  ДатаРождение
  МестоРождения
  Образование
  ОкончилГод ОкончилЧто
  Специальность
  УченаяСтепень Звание
  ИностранныйЯзык

  ДатаСВПрошлом Тире ДатаПОВПрошлом
  ДолжностьВПрошлом НаименованиеПредприятияВПрошлом

  ДатаСВНастВремя Тире1 ДатаПОВНастВремя
  ДолжностьВНастВремя НаименованиеПредприятияНаДату

.endfields

.begin
  if v_podr.getfirst app = tsOk
    if v_podr.getfirst catDep = tsOk { }
end.

СПРАВКА
^ ^ ^
ИО ректора: ^
.{ CheckEnter CatalogsPost2
.}
Дата рождения: ^
Место рождения: ^
Образование(когда и что окончил): ^ ^ ^
Специальность по образованию: ^
Учёная степень, учёное звание: ^ ^

.{ CheckEnter ContDoc
.}
.{ CheckEnter LangLanguageCat
Какими иностранными языками владеет: ^
.}
.{ CheckEnter OsvoenDrugProf
.}
.{ CheckEnter PovischenieKvalif
.}
.{ CheckEnter Experience
.{ CheckEnter Experience_Old
.}
.{ CheckEnter Experience_Rename
.}
.}
.{ CheckEnter Appointments
.{ CheckEnter Appointments_Old
.}
.{ CheckEnter Appointments_Rename
.}
.}
.{ CheckEnter PsnLinks
.}
.endform

